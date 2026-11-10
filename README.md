# NyumbaSmart (Rahisi) — Shared Household Financial Management & Consumption Prediction App

A production-quality **Flutter + Supabase** mobile application designed for families, roommates, and shared households (initial target market: **Tanzania — TZS / `TSh 100,000`, `Africa/Dar_es_Salaam`, `DD MMM YYYY`**) to manage shared household finances, record unequal member contributions, track common expenses, and statistically predict when essential supplies (**LUKU Electricity, Cooking Gas, Water, Groceries**) will need replenishment.

---

## 1. Key Features

- **Multi-Household Management**:
  - One administrator can manage multiple completely isolated households (e.g., *My Family*, *My Apartment*, *Parents' Home*), each with its own wallet, members, categories, consumption records, predictions, budgets, and reports.
- **Shared Household Wallet & Immutable Ledger**:
  - Supports unequal member contributions into a shared household pool without calculating interpersonal debts.
  - Strictly enforces $\text{Available Balance} = \text{Total Contributions} - \text{Total Expenses} + \text{Adjustments}$.
  - Blocks any expense that would drive the household wallet balance negative (`InsufficientBalanceException` + PostgreSQL row-locked `FOR UPDATE` check).
  - Supports safe transaction corrections and reversals with a mandatory reason and an immutable before/after **Audit Trail** (`audit_logs`).
- **Consumption Tracking & Statistical Prediction Engine**:
  - Tracks **Electricity (LUKU)** (monetary amount, optional `kWh` units, *"Was the previous electricity finished?"* $\rightarrow$ *Yes, completely finished* / *No, some remained* / *I don't know*, plus remaining units or percentage).
  - Tracks **Cooking Gas** (cylinder weight in `kg`, duration, replacement dates), **Water**, **Individual Grocery Items** (*Rice, Sugar, Cooking Oil, Flour, Milk, Eggs, Soap*), and **Scheduled Recurring Bills** (*Internet, Rent, TV*).
  - Computes arithmetic mean interval, outlier-resistant median interval, recency-weighted interval, standard deviation / coefficient of variation, confidence levels (`Insufficient data`, `Low confidence`, `Medium confidence`, `High confidence`), and learns from manual depletion date corrections.
- **Smart Alerts & Monthly Category Budgeting**:
  - Generates deduplicated alerts for upcoming supply replenishments, recurring bills due, low wallet balances, and category budgets approaching or exceeding their monthly limits.

---

## 2. Project Structure

```text
household_management/
├── lib/
│   ├── core/
│   │   ├── config/             # Environment & multi-currency configuration (TZS default)
│   │   ├── constants/          # Color tokens (#3B82F6, #F97316, #10B981, #F9FAFB, #111827)
│   │   ├── errors/             # Domain exceptions (InsufficientBalance, Unauthorized, ReadOnly)
│   │   ├── network/            # Supabase provider & offline connectivity sync tracker
│   │   ├── router/             # GoRouter navigation routes
│   │   ├── theme/              # Fintech Material 3 theme
│   │   ├── utils/              # TSh currency & DD MMM YYYY date formatters
│   │   └── widgets/            # Reusable cards, empty states, confirmation dialogs
│   ├── features/
│   │   ├── auth/               # Splash, Welcome, Login, Register, Forgot & Reset Password
│   │   ├── households/         # Multi-household CRUD, member management, ledger repository
│   │   ├── categories/         # 10 default categories + custom per-household categories
│   │   ├── wallet/             # Contributions, Expenses, Transaction Filters, Audit Corrections
│   │   ├── consumption/        # LUKU Electricity, Gas, Water, Groceries, Recurring Bills
│   │   ├── predictions/        # Statistical PredictionEngine & manual outcome learning
│   │   ├── budgets/            # Optional monthly per-category budgets
│   │   ├── notifications/      # Smart deduplicated alert evaluator & Notifications UI
│   │   ├── dashboard/          # Main Dashboard & bottom navigation shell
│   │   ├── reports/            # Monthly financial & consumption charts (fl_chart)
│   │   └── settings/           # Profile, Currency, Budgets, Offline Sync, Security
│   └── main.dart
├── supabase/
│   ├── config.toml
│   ├── migrations/
│   │   ├── 20261109000001_initial_schema.sql        # 15 normalized PostgreSQL tables
│   │   ├── 20261109000002_rls_policies.sql          # Row Level Security & read-only member policies
│   │   └── 20261109000003_atomic_rpc_functions.sql  # Atomic ledger RPCs & audit logging
│   ├── functions/
│   │   └── evaluate-household-alerts/index.ts       # Supabase Edge Function for smart alerts
│   └── seed.sql
├── test/
│   ├── financial_ledger_test.dart
│   ├── prediction_engine_test.dart
│   ├── security_access_test.dart
│   └── ui_flows_test.dart
└── integration_test/
    └── app_test.dart
```

---

## 3. Backend Setup Instructions (Supabase)

1. Create a new project at [https://supabase.com](https://supabase.com) or start local Supabase via `supabase start`.
2. Apply the SQL migrations in order:
   - [20261109000001_initial_schema.sql](file:///Users/abdirahmanhassan/AndroidStudioProjects/household_management/supabase/migrations/20261109000001_initial_schema.sql)
   - [20261109000002_rls_policies.sql](file:///Users/abdirahmanhassan/AndroidStudioProjects/household_management/supabase/migrations/20261109000002_rls_policies.sql)
   - [20261109000003_atomic_rpc_functions.sql](file:///Users/abdirahmanhassan/AndroidStudioProjects/household_management/supabase/migrations/20261109000003_atomic_rpc_functions.sql)
3. Create a private storage bucket named `household-receipts` in Supabase Storage for expense receipt images.
4. Copy `.env.example` to `.env` and fill in your credentials:
   ```bash
   cp .env.example .env
   ```
   ```env
   SUPABASE_URL=https://your-project-ref.supabase.co
   SUPABASE_ANON_KEY=your-supabase-anon-key
   ```
   *(Note: When `.env` is not yet configured with live credentials, the app automatically runs with the local hybrid ledger and Tanzanian seed scenario so all features can be tested immediately).*

---

## 4. Running & Testing the Application

```bash
# 1. Fetch dependencies
flutter pub get

# 2. Run static analysis
flutter analyze

# 3. Run the complete unit, security, prediction, and widget test suite
flutter test

# 4. Run the application on an Android device/emulator or iOS simulator
flutter run
```
