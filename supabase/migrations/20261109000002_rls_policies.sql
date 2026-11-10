-- =============================================================================
-- MIGRATION 002: ROW LEVEL SECURITY (RLS) POLICIES & ACCESS CONTROL FUNCTIONS
-- Enforces strict cross-household isolation, administrator write access, and
-- future read-only household member access at the PostgreSQL database layer.
-- =============================================================================

-- Helper 1: Check whether the authenticated user is the Administrator of the household
CREATE OR REPLACE FUNCTION public.user_is_household_admin(target_household_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
    SELECT EXISTS (
        SELECT 1
        FROM public.households h
        WHERE h.id = target_household_id
          AND h.owner_id = auth.uid()
          AND h.deleted_at IS NULL
    );
$$;

-- Helper 2: Check whether the authenticated user has Read Access to the household
-- (Either the Administrator OR a linked active household member for future read-only access)
CREATE OR REPLACE FUNCTION public.user_has_household_read_access(target_household_id UUID)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
STABLE
AS $$
    SELECT EXISTS (
        SELECT 1
        FROM public.households h
        WHERE h.id = target_household_id
          AND h.deleted_at IS NULL
          AND (
              h.owner_id = auth.uid()
              OR EXISTS (
                  SELECT 1
                  FROM public.household_members hm
                  WHERE hm.household_id = h.id
                    AND hm.linked_user_id = auth.uid()
                    AND hm.is_active = TRUE
                    AND hm.deleted_at IS NULL
              )
          )
    );
$$;

-- Enable RLS on all 15 tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.households ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.household_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expense_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.household_wallets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contributions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.wallet_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.household_budgets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tracked_supplies ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.consumption_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.predictions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.recurring_bills ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;

-- 1. PROFILES POLICIES
CREATE POLICY "Users can view their own profile"
    ON public.profiles FOR SELECT
    USING (id = auth.uid());

CREATE POLICY "Users can insert their own profile"
    ON public.profiles FOR INSERT
    WITH CHECK (id = auth.uid());

CREATE POLICY "Users can update their own profile"
    ON public.profiles FOR UPDATE
    USING (id = auth.uid())
    WITH CHECK (id = auth.uid());

-- 2. HOUSEHOLDS POLICIES
CREATE POLICY "Admins and linked members can view households"
    ON public.households FOR SELECT
    USING (public.user_has_household_read_access(id));

CREATE POLICY "Authenticated users can create households they own"
    ON public.households FOR INSERT
    WITH CHECK (owner_id = auth.uid());

CREATE POLICY "Only household admin can update household"
    ON public.households FOR UPDATE
    USING (owner_id = auth.uid())
    WITH CHECK (owner_id = auth.uid());

-- 3. HOUSEHOLD MEMBERS POLICIES
CREATE POLICY "Household members readable by household participants"
    ON public.household_members FOR SELECT
    USING (public.user_has_household_read_access(household_id));

CREATE POLICY "Only household admin can add members"
    ON public.household_members FOR INSERT
    WITH CHECK (public.user_is_household_admin(household_id));

CREATE POLICY "Only household admin can update members"
    ON public.household_members FOR UPDATE
    USING (public.user_is_household_admin(household_id))
    WITH CHECK (public.user_is_household_admin(household_id));

-- 4. EXPENSE CATEGORIES POLICIES
CREATE POLICY "Expense categories readable by household participants"
    ON public.expense_categories FOR SELECT
    USING (public.user_has_household_read_access(household_id));

CREATE POLICY "Only household admin can create categories"
    ON public.expense_categories FOR INSERT
    WITH CHECK (public.user_is_household_admin(household_id));

CREATE POLICY "Only household admin can update categories"
    ON public.expense_categories FOR UPDATE
    USING (public.user_is_household_admin(household_id))
    WITH CHECK (public.user_is_household_admin(household_id));

-- 5. HOUSEHOLD WALLETS POLICIES
CREATE POLICY "Wallets readable by household participants"
    ON public.household_wallets FOR SELECT
    USING (public.user_has_household_read_access(household_id));

-- Direct client INSERT/UPDATE/DELETE on household_wallets is restricted;
-- all mutations occur via SECURITY DEFINER atomic RPC functions that verify admin status.
CREATE POLICY "Only household admin can initialize wallet"
    ON public.household_wallets FOR INSERT
    WITH CHECK (public.user_is_household_admin(household_id));

CREATE POLICY "Only household admin can update wallet"
    ON public.household_wallets FOR UPDATE
    USING (public.user_is_household_admin(household_id))
    WITH CHECK (public.user_is_household_admin(household_id));

-- 6. CONTRIBUTIONS POLICIES
CREATE POLICY "Contributions readable by household participants"
    ON public.contributions FOR SELECT
    USING (public.user_has_household_read_access(household_id));

CREATE POLICY "Only household admin can record contributions"
    ON public.contributions FOR INSERT
    WITH CHECK (public.user_is_household_admin(household_id) AND recorded_by = auth.uid());

CREATE POLICY "Only household admin can update contribution status"
    ON public.contributions FOR UPDATE
    USING (public.user_is_household_admin(household_id))
    WITH CHECK (public.user_is_household_admin(household_id));

-- 7. EXPENSES POLICIES
CREATE POLICY "Expenses readable by household participants"
    ON public.expenses FOR SELECT
    USING (public.user_has_household_read_access(household_id));

CREATE POLICY "Only household admin can record expenses"
    ON public.expenses FOR INSERT
    WITH CHECK (public.user_is_household_admin(household_id) AND recorded_by = auth.uid());

CREATE POLICY "Only household admin can update expense status"
    ON public.expenses FOR UPDATE
    USING (public.user_is_household_admin(household_id))
    WITH CHECK (public.user_is_household_admin(household_id));

-- 8. WALLET TRANSACTIONS POLICIES (IMMUTABLE LEDGER)
CREATE POLICY "Wallet transactions readable by household participants"
    ON public.wallet_transactions FOR SELECT
    USING (public.user_has_household_read_access(household_id));

CREATE POLICY "Only household admin can insert wallet transactions"
    ON public.wallet_transactions FOR INSERT
    WITH CHECK (public.user_is_household_admin(household_id) AND recorded_by = auth.uid());

-- Notice: No UPDATE or DELETE policy on wallet_transactions! Ledger entries are immutable.

-- 9. HOUSEHOLD BUDGETS POLICIES
CREATE POLICY "Budgets readable by household participants"
    ON public.household_budgets FOR SELECT
    USING (public.user_has_household_read_access(household_id));

CREATE POLICY "Only household admin can manage budgets"
    ON public.household_budgets FOR ALL
    USING (public.user_is_household_admin(household_id))
    WITH CHECK (public.user_is_household_admin(household_id));

-- 10. TRACKED SUPPLIES POLICIES
CREATE POLICY "Tracked supplies readable by household participants"
    ON public.tracked_supplies FOR SELECT
    USING (public.user_has_household_read_access(household_id));

CREATE POLICY "Only household admin can manage tracked supplies"
    ON public.tracked_supplies FOR ALL
    USING (public.user_is_household_admin(household_id))
    WITH CHECK (public.user_is_household_admin(household_id));

-- 11. CONSUMPTION RECORDS POLICIES
CREATE POLICY "Consumption records readable by household participants"
    ON public.consumption_records FOR SELECT
    USING (public.user_has_household_read_access(household_id));

CREATE POLICY "Only household admin can manage consumption records"
    ON public.consumption_records FOR ALL
    USING (public.user_is_household_admin(household_id))
    WITH CHECK (public.user_is_household_admin(household_id));

-- 12. PREDICTIONS POLICIES
CREATE POLICY "Predictions readable by household participants"
    ON public.predictions FOR SELECT
    USING (public.user_has_household_read_access(household_id));

CREATE POLICY "Only household admin can update predictions"
    ON public.predictions FOR ALL
    USING (public.user_is_household_admin(household_id))
    WITH CHECK (public.user_is_household_admin(household_id));

-- 13. RECURRING BILLS POLICIES
CREATE POLICY "Recurring bills readable by household participants"
    ON public.recurring_bills FOR SELECT
    USING (public.user_has_household_read_access(household_id));

CREATE POLICY "Only household admin can manage recurring bills"
    ON public.recurring_bills FOR ALL
    USING (public.user_is_household_admin(household_id))
    WITH CHECK (public.user_is_household_admin(household_id));

-- 14. NOTIFICATIONS POLICIES
CREATE POLICY "Notifications readable by household participants"
    ON public.notifications FOR SELECT
    USING (public.user_has_household_read_access(household_id));

CREATE POLICY "Household admin can insert and update notifications"
    ON public.notifications FOR ALL
    USING (public.user_is_household_admin(household_id))
    WITH CHECK (public.user_is_household_admin(household_id));

-- 15. AUDIT LOGS POLICIES (APPEND-ONLY)
CREATE POLICY "Audit logs readable by household participants"
    ON public.audit_logs FOR SELECT
    USING (public.user_has_household_read_access(household_id));

CREATE POLICY "Only household admin can append audit logs"
    ON public.audit_logs FOR INSERT
    WITH CHECK (public.user_is_household_admin(household_id) AND actor_user_id = auth.uid());

