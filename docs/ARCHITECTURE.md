# System Architecture: Shared Household Financial Management & Consumption Prediction App

## 1. Architectural Overview

The application follows **Clean Architecture** combined with a **Feature-First** directory layout using **Flutter + Riverpod + GoRouter** on the frontend and **Supabase (PostgreSQL + Auth + Storage + Edge Functions + Row Level Security)** on the backend.

```
lib/
├── core/
│   ├── config/           # Environment configuration, currency, timezone (Africa/Dar_es_Salaam)
│   ├── constants/        # Default categories, color palette, design tokens
│   ├── errors/           # Domain & data exceptions (InsufficientBalanceException, etc.)
│   ├── network/          # Supabase client provider, connectivity & sync status tracker
│   ├── router/           # GoRouter declarative routing & auth guards
│   ├── theme/            # Fintech UI theme (#3B82F6 primary, #F97316 secondary, #10B981 green)
│   ├── utils/            # TZS currency formatter (TSh 100,000), DD MMM YYYY date formatter
│   └── widgets/          # Reusable fintech cards, empty states, confirmation dialogs
└── features/
    ├── auth/             # Splash, Welcome, Login, Register, Forgot/Reset Password, Profile
    ├── households/       # Multi-household CRUD, member management, active household switcher
    ├── wallet/           # Wallet ledger, Contributions, Expenses, Audit-logged corrections
    ├── categories/       # Default & custom per-household expense categories
    ├── consumption/      # Electricity (LUKU), Gas, Water, Grocery items, Recurring bills
    ├── predictions/      # Statistical replenishment prediction engine & manual correction
    ├── budgets/          # Optional monthly per-category budgets & threshold warnings
    ├── notifications/    # In-app + Local + FCM alert engine with deduplication
    ├── dashboard/        # Unified household dashboard
    ├── reports/          # Monthly financial & consumption analytics with fl_chart
    └── settings/         # Profile, Household, Currency, Notification, Budget & Security settings
```

## 2. Core Financial Invariants

1. **Shared Pool Ledger (No Interpersonal Debt Calculation)**:
   - Household members contribute unequal or equal amounts into a single household wallet.
   - Available balance is strictly derived from the immutable ledger:
     $$\text{Available Balance} = \sum \text{Contributions} - \sum \text{Expenses} + \sum \text{Adjustments}$$
2. **Non-Negative Wallet Constraint**:
   - No expense may reduce a household's wallet balance below `0` unless overdraft is explicitly enabled in a future release.
   - Both the client domain validator and the PostgreSQL `record_household_expense` RPC enforce `available_balance >= expense_amount` inside a serializable/row-locked transaction (`SELECT ... FOR UPDATE`).
3. **Immutable History & Audit Trail**:
   - Financial records are never silently overwritten or hard-deleted.
   - Editing or reversing a transaction creates a compensating adjustment entry in `wallet_transactions` and records the before/after payload, reason, actor, and timestamp in `audit_logs`.
4. **Duplicate Submission Protection**:
   - Every contribution and expense carries a client-generated `idempotency_key` (`UUID`), enforced by a `UNIQUE (household_id, idempotency_key)` constraint in PostgreSQL.

## 3. Multi-Household Isolation & Role-Based Access Control (RBAC)

- **Administrator (`owner_id = auth.uid()`)**:
  - Can create and switch between multiple independent households (`My Family`, `My Apartment`, `Parents' Home`).
  - Has full read/write permissions on their households.
- **Household Members (`role = 'member'`, `linked_user_id`)**:
  - In the MVP, members are managed by the administrator without requiring login accounts (`linked_user_id IS NULL`).
  - The database schema and Row Level Security (`user_has_household_read_access` vs `user_is_household_admin`) already enforce **read-only** access when `linked_user_id = auth.uid()`.

## 4. Statistical Consumption Prediction Engine

Instead of opaque black-box ML or naive averages, the prediction engine uses transparent statistical methods over historical replenishment records:

- **Effective Replenishment Intervals**:
  - Filters confirmed replenishment events and accounts for remaining supply (`was_previous_finished`, `remaining_percentage`, `remaining_units`, or `kwh_units` for LUKU electricity).
- **Central Tendency & Recency Weighting**:
  - Computes arithmetic mean interval ($\mu$), median interval ($M$) to suppress outlier distortion, and a **recency-weighted interval** ($W$) giving higher weight to recent consumption cycles.
  - Final estimated interval blends the recency-weighted interval ($0.6 \times W$) and median interval ($0.4 \times M$) when $\ge 3$ intervals exist.
- **Variability & Confidence Scoring**:
  - Computes sample standard deviation ($\sigma$) and coefficient of variation ($\text{CV} = \sigma / \mu$).
  - Assigns confidence level (`insufficientData`, `low`, `medium`, `high`) based on sample count, confirmation ratio, and $\text{CV}$.
- **Feedback Loop (Learning from Actual Outcomes)**:
  - When an administrator records the actual date a supply ran out (`actual_depletion_date`), the cycle's observed duration is updated and predictions are immediately recomputed.

