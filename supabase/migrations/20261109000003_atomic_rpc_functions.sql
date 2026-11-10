-- =============================================================================
-- MIGRATION 003: ATOMIC FINANCIAL & HOUSEHOLD PROVISIONING RPC FUNCTIONS
-- Ensures financial calculations, insufficient-balance guards, duplicate
-- submission protection, and audit trails cannot be bypassed by the client.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. CREATE HOUSEHOLD WITH DEFAULT CATEGORIES, WALLET & TRACKED SUPPLIES
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.create_household_with_defaults(
    p_name TEXT,
    p_description TEXT DEFAULT NULL,
    p_address TEXT DEFAULT NULL,
    p_currency_code TEXT DEFAULT 'TZS',
    p_currency_symbol TEXT DEFAULT 'TSh',
    p_admin_display_name TEXT DEFAULT 'Administrator'
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_user_id UUID := auth.uid();
    v_household_id UUID;
    v_cat_electricity UUID;
    v_cat_gas UUID;
    v_cat_water UUID;
    v_cat_groceries UUID;
BEGIN
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'Authentication required to create a household.';
    END IF;

    INSERT INTO public.households (
        owner_id, name, description, address, currency_code, currency_symbol
    ) VALUES (
        v_user_id, trim(p_name), p_description, p_address, p_currency_code, p_currency_symbol
    )
    RETURNING id INTO v_household_id;

    -- Initialize 1-to-1 Household Wallet
    INSERT INTO public.household_wallets (
        household_id, total_contributions, total_expenses, total_adjustments, available_balance
    ) VALUES (
        v_household_id, 0.00, 0.00, 0.00, 0.00
    );

    -- Add Administrator as initial Household Member
    INSERT INTO public.household_members (
        household_id, linked_user_id, display_name, role, avatar_color
    ) VALUES (
        v_household_id, v_user_id, trim(p_admin_display_name), 'admin', '#3B82F6'
    );

    -- Seed the 10 Default Expense Categories
    INSERT INTO public.expense_categories (household_id, name, slug, icon_name, color_hex, is_default, tracks_consumption, supply_type)
    VALUES (v_household_id, 'Groceries', 'groceries', 'shopping_basket', '#10B981', TRUE, TRUE, 'grocery')
    RETURNING id INTO v_cat_groceries;

    INSERT INTO public.expense_categories (household_id, name, slug, icon_name, color_hex, is_default, tracks_consumption, supply_type)
    VALUES (v_household_id, 'Electricity', 'electricity', 'bolt', '#F59E0B', TRUE, TRUE, 'electricity')
    RETURNING id INTO v_cat_electricity;

    INSERT INTO public.expense_categories (household_id, name, slug, icon_name, color_hex, is_default, tracks_consumption, supply_type)
    VALUES (v_household_id, 'Gas', 'gas', 'local_fire_department', '#F97316', TRUE, TRUE, 'gas')
    RETURNING id INTO v_cat_gas;

    INSERT INTO public.expense_categories (household_id, name, slug, icon_name, color_hex, is_default, tracks_consumption, supply_type)
    VALUES (v_household_id, 'Water', 'water', 'water_drop', '#06B6D4', TRUE, TRUE, 'water')
    RETURNING id INTO v_cat_water;

    INSERT INTO public.expense_categories (household_id, name, slug, icon_name, color_hex, is_default, tracks_consumption, supply_type)
    VALUES
        (v_household_id, 'Internet', 'internet', 'wifi', '#6366F1', TRUE, FALSE, 'recurring_bill'),
        (v_household_id, 'Rent', 'rent', 'home', '#8B5CF6', TRUE, FALSE, 'recurring_bill'),
        (v_household_id, 'Cleaning supplies', 'cleaning_supplies', 'cleaning_services', '#14B8A6', TRUE, FALSE, 'none'),
        (v_household_id, 'Household maintenance', 'household_maintenance', 'build', '#EC4899', TRUE, FALSE, 'none'),
        (v_household_id, 'Transportation', 'transportation', 'directions_bus', '#3B82F6', TRUE, FALSE, 'none'),
        (v_household_id, 'Other', 'other', 'more_horiz', '#6B7280', TRUE, FALSE, 'none');

    -- Seed Default Tracked Supplies for Consumption Prediction
    INSERT INTO public.tracked_supplies (household_id, category_id, name, supply_type, default_unit)
    VALUES
        (v_household_id, v_cat_electricity, 'Electricity (LUKU)', 'electricity', 'kWh'),
        (v_household_id, v_cat_gas, 'Cooking Gas', 'gas', 'kg'),
        (v_household_id, v_cat_water, 'Water Supply', 'water', 'liters'),
        (v_household_id, v_cat_groceries, 'Unga (Flour)', 'grocery', 'kg'),
        (v_household_id, v_cat_groceries, 'Sukari (Sugar)', 'grocery', 'kg'),
        (v_household_id, v_cat_groceries, 'Mafuta (Cooking Oil)', 'grocery', 'liters'),
        (v_household_id, v_cat_groceries, 'Spices', 'grocery', 'packs'),
        (v_household_id, v_cat_groceries, 'Viungo', 'grocery', 'kg'),
        (v_household_id, v_cat_groceries, 'Mchele (Rice)', 'grocery', 'kg'),
        (v_household_id, v_cat_groceries, 'Maziwa (Milk)', 'grocery', 'liters'),
        (v_household_id, v_cat_groceries, 'Mayai (Eggs)', 'grocery', 'trays'),
        (v_household_id, v_cat_groceries, 'Sabuni (Soap)', 'grocery', 'bars');

    RETURN v_household_id;
END;
$$;

-- -----------------------------------------------------------------------------
-- 2. RECORD HOUSEHOLD CONTRIBUTION (ATOMIC)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.record_household_contribution(
    p_household_id UUID,
    p_member_id UUID,
    p_amount NUMERIC(14, 2),
    p_contribution_date DATE,
    p_description TEXT DEFAULT NULL,
    p_idempotency_key UUID DEFAULT gen_random_uuid()
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_user_id UUID := auth.uid();
    v_wallet RECORD;
    v_contribution_id UUID;
    v_tx_id UUID;
    v_new_balance NUMERIC(14, 2);
BEGIN
    IF NOT public.user_is_household_admin(p_household_id) THEN
        RAISE EXCEPTION 'Unauthorized: Only the household administrator can record contributions.';
    END IF;

    IF p_amount IS NULL OR p_amount <= 0 THEN
        RAISE EXCEPTION 'Validation Error: Contribution amount must be greater than zero.';
    END IF;

    -- Verify member belongs to this household
    IF NOT EXISTS (
        SELECT 1 FROM public.household_members
        WHERE id = p_member_id AND household_id = p_household_id AND deleted_at IS NULL
    ) THEN
        RAISE EXCEPTION 'Validation Error: Selected member does not belong to this household.';
    END IF;

    -- Lock household wallet row for atomic update
    SELECT * INTO v_wallet
    FROM public.household_wallets
    WHERE household_id = p_household_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Household wallet not found for household %.', p_household_id;
    END IF;

    -- Insert contribution (unique constraint on household_id + idempotency_key protects against duplicates)
    INSERT INTO public.contributions (
        household_id, member_id, recorded_by, amount, contribution_date, description, idempotency_key
    ) VALUES (
        p_household_id, p_member_id, v_user_id, p_amount, p_contribution_date, p_description, p_idempotency_key
    )
    RETURNING id INTO v_contribution_id;

    v_new_balance := v_wallet.available_balance + p_amount;

    -- Update wallet totals
    UPDATE public.household_wallets
    SET total_contributions = total_contributions + p_amount,
        available_balance = v_new_balance,
        version = version + 1,
        last_transaction_at = NOW(),
        updated_at = NOW()
    WHERE id = v_wallet.id;

    -- Append immutable ledger entry
    INSERT INTO public.wallet_transactions (
        household_id, wallet_id, transaction_type, reference_contribution_id,
        member_id, amount, signed_amount, balance_before, balance_after,
        transaction_date, description, recorded_by
    ) VALUES (
        p_household_id, v_wallet.id, 'contribution', v_contribution_id,
        p_member_id, p_amount, p_amount, v_wallet.available_balance, v_new_balance,
        p_contribution_date, COALESCE(NULLIF(trim(p_description), ''), 'Member contribution'), v_user_id
    )
    RETURNING id INTO v_tx_id;

    -- Append audit log
    INSERT INTO public.audit_logs (
        household_id, actor_user_id, entity_type, entity_id, action, reason, new_state
    ) VALUES (
        p_household_id, v_user_id, 'contribution', v_contribution_id, 'create',
        'Recorded member contribution',
        jsonb_build_object(
            'contribution_id', v_contribution_id,
            'wallet_transaction_id', v_tx_id,
            'member_id', p_member_id,
            'amount', p_amount,
            'balance_before', v_wallet.available_balance,
            'balance_after', v_new_balance
        )
    );

    RETURN jsonb_build_object(
        'contribution_id', v_contribution_id,
        'wallet_transaction_id', v_tx_id,
        'balance_before', v_wallet.available_balance,
        'balance_after', v_new_balance
    );
END;
$$;

-- -----------------------------------------------------------------------------
-- 3. RECORD HOUSEHOLD EXPENSE (ATOMIC WITH INSUFFICIENT BALANCE PROTECTION)
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.record_household_expense(
    p_household_id UUID,
    p_category_id UUID,
    p_paid_by_member_id UUID,
    p_title TEXT,
    p_amount NUMERIC(14, 2),
    p_expense_date DATE,
    p_notes TEXT DEFAULT NULL,
    p_receipt_url TEXT DEFAULT NULL,
    p_idempotency_key UUID DEFAULT gen_random_uuid()
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_user_id UUID := auth.uid();
    v_household RECORD;
    v_wallet RECORD;
    v_expense_id UUID;
    v_tx_id UUID;
    v_new_balance NUMERIC(14, 2);
BEGIN
    IF NOT public.user_is_household_admin(p_household_id) THEN
        RAISE EXCEPTION 'Unauthorized: Only the household administrator can record expenses.';
    END IF;

    IF p_amount IS NULL OR p_amount <= 0 THEN
        RAISE EXCEPTION 'Validation Error: Expense amount must be greater than zero.';
    END IF;

    SELECT * INTO v_household
    FROM public.households
    WHERE id = p_household_id AND deleted_at IS NULL;

    -- Verify member and category belong to this household
    IF NOT EXISTS (
        SELECT 1 FROM public.household_members
        WHERE id = p_paid_by_member_id AND household_id = p_household_id AND deleted_at IS NULL
    ) THEN
        RAISE EXCEPTION 'Validation Error: Selected member does not belong to this household.';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM public.expense_categories
        WHERE id = p_category_id AND household_id = p_household_id
    ) THEN
        RAISE EXCEPTION 'Validation Error: Selected category does not belong to this household.';
    END IF;

    -- Lock household wallet row for atomic balance check and deduction
    SELECT * INTO v_wallet
    FROM public.household_wallets
    WHERE household_id = p_household_id
    FOR UPDATE;

    -- Enforce Non-Negative Balance Invariant
    IF (v_wallet.available_balance < p_amount) AND (NOT v_household.allow_overdraft) THEN
        RAISE EXCEPTION 'Insufficient household wallet balance. Available: % %, Required: % %.',
            v_household.currency_symbol, v_wallet.available_balance,
            v_household.currency_symbol, p_amount
            USING ERRCODE = 'P0001';
    END IF;

    INSERT INTO public.expenses (
        household_id, category_id, paid_by_member_id, recorded_by,
        title, amount, expense_date, notes, receipt_url, idempotency_key
    ) VALUES (
        p_household_id, p_category_id, p_paid_by_member_id, v_user_id,
        trim(p_title), p_amount, p_expense_date, p_notes, p_receipt_url, p_idempotency_key
    )
    RETURNING id INTO v_expense_id;

    v_new_balance := v_wallet.available_balance - p_amount;

    UPDATE public.household_wallets
    SET total_expenses = total_expenses + p_amount,
        available_balance = v_new_balance,
        version = version + 1,
        last_transaction_at = NOW(),
        updated_at = NOW()
    WHERE id = v_wallet.id;

    INSERT INTO public.wallet_transactions (
        household_id, wallet_id, transaction_type, reference_expense_id,
        member_id, category_id, amount, signed_amount,
        balance_before, balance_after, transaction_date, description, recorded_by
    ) VALUES (
        p_household_id, v_wallet.id, 'expense', v_expense_id,
        p_paid_by_member_id, p_category_id, p_amount, -p_amount,
        v_wallet.available_balance, v_new_balance, p_expense_date, trim(p_title), v_user_id
    )
    RETURNING id INTO v_tx_id;

    -- Append audit log
    INSERT INTO public.audit_logs (
        household_id, actor_user_id, entity_type, entity_id, action, reason, new_state
    ) VALUES (
        p_household_id, v_user_id, 'expense', v_expense_id, 'create',
        'Recorded household expense',
        jsonb_build_object(
            'expense_id', v_expense_id,
            'wallet_transaction_id', v_tx_id,
            'title', trim(p_title),
            'category_id', p_category_id,
            'paid_by_member_id', p_paid_by_member_id,
            'amount', p_amount,
            'balance_before', v_wallet.available_balance,
            'balance_after', v_new_balance
        )
    );

    -- Generate Low Wallet Balance Notification if threshold reached
    IF v_new_balance <= v_household.low_balance_threshold THEN
        INSERT INTO public.notifications (
            household_id, recipient_user_id, notification_type, severity,
            title, body, related_entity_type, related_entity_id, dedup_key
        ) VALUES (
            p_household_id, v_user_id, 'low_wallet_balance', 'warning',
            'Low Household Wallet Balance',
            format('Your household balance is running low (%s %s remaining).', v_household.currency_symbol, v_new_balance),
            'household_wallet', v_wallet.id,
            format('low_balance_%s_%s', p_household_id, to_char(CURRENT_DATE, 'YYYY_MM_DD'))
        )
        ON CONFLICT (household_id, dedup_key) DO NOTHING;
    END IF;

    RETURN jsonb_build_object(
        'expense_id', v_expense_id,
        'wallet_transaction_id', v_tx_id,
        'balance_before', v_wallet.available_balance,
        'balance_after', v_new_balance
    );
END;
$$;

-- -----------------------------------------------------------------------------
-- 4. SAFE TRANSACTION CORRECTION / REVERSAL WITH AUDIT LOGGING
-- Never silently overwrites historical records; creates compensating adjustment
-- entries and logs before/after state in audit_logs.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.correct_or_reverse_transaction(
    p_household_id UUID,
    p_wallet_transaction_id UUID,
    p_new_amount NUMERIC(14, 2), -- Pass 0 to completely reverse the transaction
    p_new_description TEXT,
    p_reason TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_user_id UUID := auth.uid();
    v_household RECORD;
    v_wallet RECORD;
    v_orig_tx RECORD;
    v_delta_signed NUMERIC(14, 2);
    v_new_balance NUMERIC(14, 2);
    v_adj_type TEXT;
    v_adj_tx_id UUID;
BEGIN
    IF NOT public.user_is_household_admin(p_household_id) THEN
        RAISE EXCEPTION 'Unauthorized: Only the household administrator can correct transactions.';
    END IF;

    IF p_reason IS NULL OR char_length(trim(p_reason)) < 3 THEN
        RAISE EXCEPTION 'Validation Error: An audit reason is required to correct or reverse a transaction.';
    END IF;

    IF p_new_amount IS NULL OR p_new_amount < 0 THEN
        RAISE EXCEPTION 'Validation Error: Corrected amount cannot be negative.';
    END IF;

    SELECT * INTO v_household FROM public.households WHERE id = p_household_id;

    SELECT * INTO v_wallet
    FROM public.household_wallets
    WHERE household_id = p_household_id
    FOR UPDATE;

    SELECT * INTO v_orig_tx
    FROM public.wallet_transactions
    WHERE id = p_wallet_transaction_id AND household_id = p_household_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Original wallet transaction not found.';
    END IF;

    IF v_orig_tx.transaction_type = 'contribution' THEN
        -- Original contribution added v_orig_tx.amount; new contribution should add p_new_amount
        v_delta_signed := p_new_amount - v_orig_tx.amount;
    ELSIF v_orig_tx.transaction_type = 'expense' THEN
        -- Original expense subtracted v_orig_tx.amount; new expense should subtract p_new_amount
        v_delta_signed := v_orig_tx.amount - p_new_amount;
    ELSE
        RAISE EXCEPTION 'Only primary contribution or expense transactions can be corrected.';
    END IF;

    IF v_delta_signed = 0 AND trim(p_new_description) = v_orig_tx.description THEN
        RAISE EXCEPTION 'No changes detected for transaction correction.';
    END IF;

    v_new_balance := v_wallet.available_balance + v_delta_signed;

    IF v_new_balance < 0 AND (NOT v_household.allow_overdraft) THEN
        RAISE EXCEPTION 'Cannot apply correction: resulting household wallet balance would be negative (% %).',
            v_household.currency_symbol, v_new_balance;
    END IF;

    -- Determine ledger adjustment type
    IF p_new_amount = 0 THEN
        v_adj_type := 'reversal';
    ELSIF v_delta_signed > 0 THEN
        v_adj_type := 'adjustment_credit';
    ELSE
        v_adj_type := 'adjustment_debit';
    END IF;

    -- Update wallet totals using total_adjustments so historical contribution/expense ledgers remain auditable
    UPDATE public.household_wallets
    SET total_adjustments = total_adjustments + v_delta_signed,
        available_balance = v_new_balance,
        version = version + 1,
        last_transaction_at = NOW(),
        updated_at = NOW()
    WHERE id = v_wallet.id;

    -- Update status on underlying contribution or expense record without deleting history
    IF v_orig_tx.reference_contribution_id IS NOT NULL THEN
        UPDATE public.contributions
        SET status = CASE WHEN p_new_amount = 0 THEN 'reversed' ELSE 'corrected' END,
            updated_at = NOW()
        WHERE id = v_orig_tx.reference_contribution_id;
    ELSIF v_orig_tx.reference_expense_id IS NOT NULL THEN
        UPDATE public.expenses
        SET status = CASE WHEN p_new_amount = 0 THEN 'reversed' ELSE 'corrected' END,
            updated_at = NOW()
        WHERE id = v_orig_tx.reference_expense_id;
    END IF;

    -- Insert compensating immutable wallet_transaction
    INSERT INTO public.wallet_transactions (
        household_id, wallet_id, transaction_type,
        reference_contribution_id, reference_expense_id, parent_transaction_id,
        member_id, category_id, amount, signed_amount,
        balance_before, balance_after, transaction_date, description, recorded_by
    ) VALUES (
        p_household_id, v_wallet.id, v_adj_type,
        v_orig_tx.reference_contribution_id, v_orig_tx.reference_expense_id, v_orig_tx.id,
        v_orig_tx.member_id, v_orig_tx.category_id, ABS(v_delta_signed), v_delta_signed,
        v_wallet.available_balance, v_new_balance, CURRENT_DATE,
        format('[%s] %s (Reason: %s)', UPPER(v_adj_type), COALESCE(p_new_description, v_orig_tx.description), trim(p_reason)),
        v_user_id
    )
    RETURNING id INTO v_adj_tx_id;

    -- Record full immutable audit trail
    INSERT INTO public.audit_logs (
        household_id, actor_user_id, entity_type, entity_id,
        action, reason, previous_state, new_state
    ) VALUES (
        p_household_id, v_user_id, 'wallet_transaction', v_orig_tx.id,
        CASE WHEN p_new_amount = 0 THEN 'reverse' ELSE 'correct' END,
        trim(p_reason),
        jsonb_build_object(
            'original_amount', v_orig_tx.amount,
            'original_signed_amount', v_orig_tx.signed_amount,
            'original_description', v_orig_tx.description,
            'balance_before_adjustment', v_wallet.available_balance
        ),
        jsonb_build_object(
            'adjustment_transaction_id', v_adj_tx_id,
            'corrected_amount', p_new_amount,
            'delta_signed', v_delta_signed,
            'new_description', COALESCE(p_new_description, v_orig_tx.description),
            'balance_after_adjustment', v_new_balance
        )
    );

    RETURN jsonb_build_object(
        'original_transaction_id', v_orig_tx.id,
        'adjustment_transaction_id', v_adj_tx_id,
        'delta_signed', v_delta_signed,
        'balance_before', v_wallet.available_balance,
        'balance_after', v_new_balance
    );
END;
$$;

