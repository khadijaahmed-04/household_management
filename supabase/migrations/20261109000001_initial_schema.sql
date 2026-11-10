-- =============================================================================
-- MIGRATION 001: INITIAL NORMALIZED SCHEMA FOR SHARED HOUSEHOLD MANAGEMENT APP
-- Target Market: Tanzania (TZS / TSh, Africa/Dar_es_Salaam), Multi-Currency Ready
-- =============================================================================

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- -----------------------------------------------------------------------------
-- 1. PROFILES
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    full_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone_number TEXT,
    preferred_currency TEXT NOT NULL DEFAULT 'TZS',
    preferred_currency_symbol TEXT NOT NULL DEFAULT 'TSh',
    timezone TEXT NOT NULL DEFAULT 'Africa/Dar_es_Salaam',
    notify_push_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    notify_in_app_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    notify_low_balance_threshold NUMERIC(14, 2) NOT NULL DEFAULT 25000.00,
    notify_days_before_replenishment INTEGER NOT NULL DEFAULT 3,
    fcm_token TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- -----------------------------------------------------------------------------
-- 2. HOUSEHOLDS
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.households (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE RESTRICT,
    name TEXT NOT NULL CHECK (char_length(trim(name)) >= 2),
    description TEXT,
    address TEXT,
    currency_code TEXT NOT NULL DEFAULT 'TZS',
    currency_symbol TEXT NOT NULL DEFAULT 'TSh',
    timezone TEXT NOT NULL DEFAULT 'Africa/Dar_es_Salaam',
    allow_overdraft BOOLEAN NOT NULL DEFAULT FALSE,
    low_balance_threshold NUMERIC(14, 2) NOT NULL DEFAULT 25000.00 CHECK (low_balance_threshold >= 0),
    is_archived BOOLEAN NOT NULL DEFAULT FALSE,
    deleted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_households_owner_id ON public.households(owner_id);

-- -----------------------------------------------------------------------------
-- 3. HOUSEHOLD MEMBERS
-- Supports MVP Admin-managed records (linked_user_id IS NULL) and future
-- read-only member accounts (linked_user_id = auth.uid(), role = 'member').
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.household_members (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id UUID NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    linked_user_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
    display_name TEXT NOT NULL CHECK (char_length(trim(display_name)) >= 1),
    email TEXT,
    phone_number TEXT,
    role TEXT NOT NULL DEFAULT 'member' CHECK (role IN ('admin', 'member')),
    avatar_color TEXT NOT NULL DEFAULT '#3B82F6',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (household_id, display_name)
);

CREATE INDEX IF NOT EXISTS idx_household_members_household_id ON public.household_members(household_id);
CREATE INDEX IF NOT EXISTS idx_household_members_linked_user_id ON public.household_members(linked_user_id);

-- -----------------------------------------------------------------------------
-- 4. EXPENSE CATEGORIES
-- Customizable per household, seeded with 10 default categories on creation.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.expense_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id UUID NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    name TEXT NOT NULL CHECK (char_length(trim(name)) >= 2),
    slug TEXT NOT NULL,
    icon_name TEXT NOT NULL DEFAULT 'category',
    color_hex TEXT NOT NULL DEFAULT '#3B82F6',
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    tracks_consumption BOOLEAN NOT NULL DEFAULT FALSE,
    supply_type TEXT CHECK (supply_type IN ('electricity', 'gas', 'water', 'grocery', 'recurring_bill', 'none')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (household_id, slug)
);

CREATE INDEX IF NOT EXISTS idx_expense_categories_household_id ON public.expense_categories(household_id);

-- -----------------------------------------------------------------------------
-- 5. HOUSEHOLD WALLETS
-- 1-to-1 ledger summary per household, strictly synchronized with wallet_transactions.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.household_wallets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id UUID NOT NULL UNIQUE REFERENCES public.households(id) ON DELETE CASCADE,
    total_contributions NUMERIC(14, 2) NOT NULL DEFAULT 0.00 CHECK (total_contributions >= 0),
    total_expenses NUMERIC(14, 2) NOT NULL DEFAULT 0.00 CHECK (total_expenses >= 0),
    total_adjustments NUMERIC(14, 2) NOT NULL DEFAULT 0.00,
    available_balance NUMERIC(14, 2) NOT NULL DEFAULT 0.00,
    version INTEGER NOT NULL DEFAULT 1,
    last_transaction_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_wallet_balance_equation CHECK (
        available_balance = (total_contributions - total_expenses + total_adjustments)
    )
);

CREATE INDEX IF NOT EXISTS idx_household_wallets_household_id ON public.household_wallets(household_id);

-- -----------------------------------------------------------------------------
-- 6. CONTRIBUTIONS
-- Unequal member contributions into the shared household pool.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.contributions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id UUID NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    member_id UUID NOT NULL REFERENCES public.household_members(id) ON DELETE RESTRICT,
    recorded_by UUID NOT NULL REFERENCES public.profiles(id) ON DELETE RESTRICT,
    amount NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
    contribution_date DATE NOT NULL,
    description TEXT,
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'corrected', 'reversed')),
    idempotency_key UUID NOT NULL DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (household_id, idempotency_key)
);

CREATE INDEX IF NOT EXISTS idx_contributions_household_date ON public.contributions(household_id, contribution_date DESC);
CREATE INDEX IF NOT EXISTS idx_contributions_member_id ON public.contributions(member_id);

-- -----------------------------------------------------------------------------
-- 7. EXPENSES
-- Purchases made from the shared household pool.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.expenses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id UUID NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES public.expense_categories(id) ON DELETE RESTRICT,
    paid_by_member_id UUID NOT NULL REFERENCES public.household_members(id) ON DELETE RESTRICT,
    recorded_by UUID NOT NULL REFERENCES public.profiles(id) ON DELETE RESTRICT,
    title TEXT NOT NULL CHECK (char_length(trim(title)) >= 2),
    amount NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
    expense_date DATE NOT NULL,
    notes TEXT,
    receipt_url TEXT,
    status TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'corrected', 'reversed')),
    idempotency_key UUID NOT NULL DEFAULT gen_random_uuid(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (household_id, idempotency_key)
);

CREATE INDEX IF NOT EXISTS idx_expenses_household_date ON public.expenses(household_id, expense_date DESC);
CREATE INDEX IF NOT EXISTS idx_expenses_category_id ON public.expenses(category_id);
CREATE INDEX IF NOT EXISTS idx_expenses_member_id ON public.expenses(paid_by_member_id);

-- -----------------------------------------------------------------------------
-- 8. WALLET TRANSACTIONS (IMMUTABLE LEDGER SOURCE OF TRUTH)
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.wallet_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id UUID NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    wallet_id UUID NOT NULL REFERENCES public.household_wallets(id) ON DELETE CASCADE,
    transaction_type TEXT NOT NULL CHECK (
        transaction_type IN ('contribution', 'expense', 'adjustment_credit', 'adjustment_debit', 'reversal')
    ),
    reference_contribution_id UUID REFERENCES public.contributions(id) ON DELETE RESTRICT,
    reference_expense_id UUID REFERENCES public.expenses(id) ON DELETE RESTRICT,
    parent_transaction_id UUID REFERENCES public.wallet_transactions(id) ON DELETE RESTRICT,
    member_id UUID REFERENCES public.household_members(id) ON DELETE RESTRICT,
    category_id UUID REFERENCES public.expense_categories(id) ON DELETE RESTRICT,
    amount NUMERIC(14, 2) NOT NULL CHECK (amount > 0),
    signed_amount NUMERIC(14, 2) NOT NULL,
    balance_before NUMERIC(14, 2) NOT NULL,
    balance_after NUMERIC(14, 2) NOT NULL,
    transaction_date DATE NOT NULL,
    description TEXT NOT NULL,
    recorded_by UUID NOT NULL REFERENCES public.profiles(id) ON DELETE RESTRICT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_wallet_tx_household_date ON public.wallet_transactions(household_id, transaction_date DESC, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_wallet_tx_member ON public.wallet_transactions(member_id);
CREATE INDEX IF NOT EXISTS idx_wallet_tx_category ON public.wallet_transactions(category_id);

-- -----------------------------------------------------------------------------
-- 9. HOUSEHOLD BUDGETS
-- Optional per-category monthly budgets (format YYYY-MM-01).
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.household_budgets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id UUID NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES public.expense_categories(id) ON DELETE CASCADE,
    budget_month DATE NOT NULL, -- Normalized to first day of month (e.g. 2026-11-01)
    budget_amount NUMERIC(14, 2) NOT NULL CHECK (budget_amount > 0),
    alert_threshold_percent NUMERIC(5, 2) NOT NULL DEFAULT 80.00 CHECK (alert_threshold_percent BETWEEN 10 AND 100),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (household_id, category_id, budget_month)
);

CREATE INDEX IF NOT EXISTS idx_household_budgets_household_month ON public.household_budgets(household_id, budget_month);

-- -----------------------------------------------------------------------------
-- 10. TRACKED SUPPLIES
-- Catalog of household utilities and essential grocery items tracked for prediction.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.tracked_supplies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id UUID NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    category_id UUID REFERENCES public.expense_categories(id) ON DELETE SET NULL,
    name TEXT NOT NULL CHECK (char_length(trim(name)) >= 2),
    supply_type TEXT NOT NULL CHECK (supply_type IN ('electricity', 'gas', 'water', 'grocery')),
    default_unit TEXT NOT NULL DEFAULT 'units', -- kWh, kg, liters, pieces, etc.
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (household_id, supply_type, name)
);

CREATE INDEX IF NOT EXISTS idx_tracked_supplies_household ON public.tracked_supplies(household_id, supply_type);

-- -----------------------------------------------------------------------------
-- 11. CONSUMPTION RECORDS
-- Historical purchases & replenishment observations for Electricity, Gas, Water, Groceries.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.consumption_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id UUID NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    supply_id UUID NOT NULL REFERENCES public.tracked_supplies(id) ON DELETE CASCADE,
    expense_id UUID REFERENCES public.expenses(id) ON DELETE SET NULL,
    purchase_date DATE NOT NULL,
    amount_paid NUMERIC(14, 2) NOT NULL CHECK (amount_paid > 0),
    quantity NUMERIC(12, 3) CHECK (quantity IS NULL OR quantity > 0),
    unit TEXT NOT NULL DEFAULT 'units',
    -- Electricity & Utility specific fields:
    previous_exhausted_state TEXT NOT NULL DEFAULT 'unknown'
        CHECK (previous_exhausted_state IN ('yes_completely_finished', 'no_some_remained', 'unknown')),
    remaining_units NUMERIC(12, 3) CHECK (remaining_units IS NULL OR remaining_units >= 0),
    remaining_percentage NUMERIC(5, 2) CHECK (remaining_percentage IS NULL OR (remaining_percentage >= 0 AND remaining_percentage <= 100)),
    -- Gas & Grocery specific fields:
    cylinder_weight_kg NUMERIC(8, 2) CHECK (cylinder_weight_kg IS NULL OR cylinder_weight_kg > 0),
    user_estimated_duration_days INTEGER CHECK (user_estimated_duration_days IS NULL OR user_estimated_duration_days > 0),
    actual_depletion_date DATE,
    notes TEXT,
    recorded_by UUID NOT NULL REFERENCES public.profiles(id) ON DELETE RESTRICT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_consumption_records_supply_date
    ON public.consumption_records(household_id, supply_id, purchase_date ASC);

-- -----------------------------------------------------------------------------
-- 12. PREDICTIONS
-- Computed statistical replenishment predictions per tracked supply.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.predictions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id UUID NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    supply_id UUID NOT NULL UNIQUE REFERENCES public.tracked_supplies(id) ON DELETE CASCADE,
    sample_count INTEGER NOT NULL DEFAULT 0,
    confirmed_cycle_count INTEGER NOT NULL DEFAULT 0,
    average_interval_days NUMERIC(10, 2),
    median_interval_days NUMERIC(10, 2),
    weighted_interval_days NUMERIC(10, 2),
    interval_std_dev_days NUMERIC(10, 2),
    average_purchase_amount NUMERIC(14, 2),
    average_daily_consumption_units NUMERIC(12, 4),
    average_daily_cost NUMERIC(14, 2),
    last_purchase_date DATE,
    estimated_next_replenishment_date DATE,
    manual_override_date DATE,
    actual_confirmed_depletion_date DATE,
    confidence_level TEXT NOT NULL DEFAULT 'insufficient_data'
        CHECK (confidence_level IN ('insufficient_data', 'low', 'medium', 'high')),
    confidence_score NUMERIC(5, 2) NOT NULL DEFAULT 0.00 CHECK (confidence_score BETWEEN 0 AND 100),
    is_monetary_estimate_only BOOLEAN NOT NULL DEFAULT TRUE,
    explanation TEXT NOT NULL,
    trend_direction TEXT NOT NULL DEFAULT 'stable' CHECK (trend_direction IN ('increasing', 'stable', 'decreasing')),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_predictions_household_next_date
    ON public.predictions(household_id, estimated_next_replenishment_date);

-- -----------------------------------------------------------------------------
-- 13. RECURRING BILLS
-- Scheduled fixed-cycle bills (Internet, Rent, TV, etc.) distinct from consumption predictions.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.recurring_bills (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id UUID NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES public.expense_categories(id) ON DELETE RESTRICT,
    title TEXT NOT NULL CHECK (char_length(trim(title)) >= 2),
    provider_name TEXT,
    expected_amount NUMERIC(14, 2) NOT NULL CHECK (expected_amount > 0),
    frequency TEXT NOT NULL CHECK (frequency IN ('weekly', 'monthly', 'quarterly', 'yearly')),
    next_due_date DATE NOT NULL,
    last_paid_date DATE,
    remind_days_before INTEGER NOT NULL DEFAULT 3 CHECK (remind_days_before BETWEEN 0 AND 30),
    auto_record_reminder BOOLEAN NOT NULL DEFAULT TRUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_recurring_bills_household_due
    ON public.recurring_bills(household_id, next_due_date);

-- -----------------------------------------------------------------------------
-- 14. NOTIFICATIONS
-- Smart alerts with deduplication keys to prevent duplicate notification spam.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id UUID NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    recipient_user_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE,
    notification_type TEXT NOT NULL CHECK (
        notification_type IN (
            'electricity_replenishment',
            'gas_replenishment',
            'water_replenishment',
            'grocery_replenishment',
            'recurring_bill_due',
            'low_wallet_balance',
            'budget_warning',
            'budget_exceeded',
            'transaction_corrected'
        )
    ),
    severity TEXT NOT NULL DEFAULT 'info' CHECK (severity IN ('info', 'warning', 'critical')),
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    related_entity_type TEXT,
    related_entity_id UUID,
    dedup_key TEXT NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    is_dismissed BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    read_at TIMESTAMPTZ,
    UNIQUE (household_id, dedup_key)
);

CREATE INDEX IF NOT EXISTS idx_notifications_household_unread
    ON public.notifications(household_id, is_dismissed, is_read, created_at DESC);

-- -----------------------------------------------------------------------------
-- 15. AUDIT LOGS
-- Immutable audit trail for transaction edits, reversals, prediction corrections, and settings.
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    household_id UUID NOT NULL REFERENCES public.households(id) ON DELETE CASCADE,
    actor_user_id UUID NOT NULL REFERENCES public.profiles(id) ON DELETE RESTRICT,
    entity_type TEXT NOT NULL CHECK (
        entity_type IN ('contribution', 'expense', 'wallet_transaction', 'prediction', 'household', 'member', 'budget')
    ),
    entity_id UUID NOT NULL,
    action TEXT NOT NULL CHECK (
        action IN ('create', 'correct', 'reverse', 'manual_prediction_override', 'deactivate', 'settings_change')
    ),
    reason TEXT NOT NULL,
    previous_state JSONB,
    new_state JSONB,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_audit_logs_household_created
    ON public.audit_logs(household_id, created_at DESC);

