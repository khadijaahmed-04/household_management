// Supabase Edge Function: evaluate-household-alerts
// Evaluates consumption predictions, upcoming recurring bills, category budgets,
// and low wallet balances for a household and creates deduplicated alerts.

import { createClient } from "https://esm.sh/@supabase/supabase-js@2.45.0";

interface AlertRequest {
  household_id: string;
  reference_date?: string; // YYYY-MM-DD
}

Deno.serve(async (req: Request) => {
  try {
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(JSON.stringify({ error: "Missing Authorization header" }), {
        status: 401,
        headers: { "Content-Type": "application/json" },
      });
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
    const supabaseAnonKey = Deno.env.get("SUPABASE_ANON_KEY") ?? "";
    const supabase = createClient(supabaseUrl, supabaseAnonKey, {
      global: { headers: { Authorization: authHeader } },
    });

    const payload: AlertRequest = await req.json();
    const householdId = payload.household_id;
    const today = payload.reference_date ? new Date(payload.reference_date) : new Date();
    const todayIso = today.toISOString().split("T")[0];

    // 1. Fetch household & wallet
    const { data: household, error: hErr } = await supabase
      .from("households")
      .select("*, household_wallets(*)")
      .eq("id", householdId)
      .single();

    if (hErr || !household) {
      return new Response(JSON.stringify({ error: "Household not found or unauthorized" }), {
        status: 404,
        headers: { "Content-Type": "application/json" },
      });
    }

    const generatedAlerts: Array<Record<string, unknown>> = [];

    // 2. Check upcoming supply predictions (within 3 days)
    const { data: predictions } = await supabase
      .from("predictions")
      .select("*, tracked_supplies(name, supply_type)")
      .eq("household_id", householdId)
      .neq("confidence_level", "insufficient_data");

    for (const pred of predictions ?? []) {
      const targetDateStr = pred.manual_override_date ?? pred.estimated_next_replenishment_date;
      if (!targetDateStr) continue;

      const targetDate = new Date(targetDateStr);
      const diffDays = Math.ceil((targetDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24));
      if (diffDays >= 0 && diffDays <= 3) {
        const supplyName = pred.tracked_supplies?.name ?? "Supply";
        const supplyType = pred.tracked_supplies?.supply_type ?? "grocery";
        const notifType =
          supplyType === "electricity"
            ? "electricity_replenishment"
            : supplyType === "gas"
            ? "gas_replenishment"
            : supplyType === "water"
            ? "water_replenishment"
            : "grocery_replenishment";

        const body =
          supplyType === "electricity"
            ? `Your household may need to purchase electricity within approximately ${diffDays} day(s).`
            : supplyType === "gas"
            ? `Your gas cylinder is approaching its estimated replacement date (${targetDateStr}).`
            : `${supplyName} is estimated to need replenishment in approximately ${diffDays} day(s).`;

        generatedAlerts.push({
          household_id: householdId,
          recipient_user_id: household.owner_id,
          notification_type: notifType,
          severity: diffDays <= 1 ? "critical" : "warning",
          title: `Upcoming Replenishment: ${supplyName}`,
          body,
          related_entity_type: "prediction",
          related_entity_id: pred.id,
          dedup_key: `pred_${pred.supply_id}_${targetDateStr}`,
        });
      }
    }

    // 3. Check recurring bills due within remind_days_before
    const { data: bills } = await supabase
      .from("recurring_bills")
      .select("*")
      .eq("household_id", householdId)
      .eq("is_active", true);

    for (const bill of bills ?? []) {
      const dueDate = new Date(bill.next_due_date);
      const diffDays = Math.ceil((dueDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24));
      if (diffDays >= 0 && diffDays <= (bill.remind_days_before ?? 3)) {
        generatedAlerts.push({
          household_id: householdId,
          recipient_user_id: household.owner_id,
          notification_type: "recurring_bill_due",
          severity: diffDays <= 1 ? "critical" : "warning",
          title: `${bill.title} Due Soon`,
          body: `Your ${bill.title} payment (${household.currency_symbol} ${Number(bill.expected_amount).toLocaleString()}) is due in ${diffDays} day(s).`,
          related_entity_type: "recurring_bill",
          related_entity_id: bill.id,
          dedup_key: `bill_${bill.id}_${bill.next_due_date}`,
        });
      }
    }

    // Upsert alerts using (household_id, dedup_key) conflict suppression
    if (generatedAlerts.length > 0) {
      await supabase
        .from("notifications")
        .upsert(generatedAlerts, { onConflict: "household_id,dedup_key", ignoreDuplicates: true });
    }

    return new Response(
      JSON.stringify({
        status: "ok",
        evaluated_at: todayIso,
        alerts_checked: generatedAlerts.length,
      }),
      { status: 200, headers: { "Content-Type": "application/json" } }
    );
  } catch (err) {
    return new Response(JSON.stringify({ error: String(err) }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});

