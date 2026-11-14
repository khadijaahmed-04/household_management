# NyumbaSmart (Rahisi) — Shared Household Financial Management & Consumption Prediction App

A production-quality **Flutter** mobile application powered by **Firebase** (Authentication, Cloud Firestore, Cloud Messaging) and **Supabase** (PostgreSQL ledger, Row-Level Security, atomic RPCs), designed for families, roommates, and shared households.

Initial target market: **Tanzania** — TZS / `TSh 100,000`, `Africa/Dar_es_Salaam` timezone, `DD MMM YYYY` formatting, and local utilities (TANESCO LUKU electricity, LPG cooking gas cylinders, DAWASA/water, local groceries).

---

## 1. Key Features

### 🏡 Multi-Household Management & Role-Based Access Control
- **Multi-Household Isolation**: One administrator can manage multiple completely separated households (e.g., *My Family*, *Mikocheni Apartment*, *Parents' Home*).
- **Independent Scopes**: Each household maintains its own wallet, members, expense categories, consumption history, replenishment predictions, monthly budgets, and audit trails.
- **Role Permissions**: Strict distinction between household **Administrators** (full ledger, budget, threshold, and member management) and **Members** (read-only insight into wallet balances, predictions, and reports).

### 💰 Shared Household Wallet & Immutable Ledger
- **Shared Pool with Unequal Contributions**: Members pool funds without computing individual interpersonal debts.
- **Strict Ledger Equation**:
  $$\text{Available Balance} = \text{Total Contributions} - \text{Total Expenses} + \text{Adjustments}$$
- **Negative Balance Guard**: System-level rejection (`InsufficientBalanceException`) blocks any expense that would drive the household balance below zero.
- **Streamlined Expense Logging**: Quick, frictionless expense entry with direct category tagging and instant balance updates (no mandatory receipt upload required).
- **Audit Trail & Corrections**: Reversals and corrections require a logged reason and write immutable before/after records into `audit_logs`.

### 🔔 Configurable Low-Balance Alerts & Deduplication
- **Customizable Warning Threshold**: Administrators can configure a specific low-balance trigger per household (e.g., `TSh 10,000`, `TSh 25,000`, etc.).
- **Smart Shorthand Parsing**: Inputs accept compact notations like `10k`, `10K`, `15k`, `10,000`, or `10 000` via `AppFormatters.tryParseAmount`.
- **Informative, Accurate Notifications**: Low-balance alerts clearly state the current balance relative to the user's chosen threshold amount (e.g., *"Wallet balance (TSh 8,500) has fallen below your household warning threshold of TSh 10,000"*), avoiding misleading "completely finished" messages.
- **Settings Quick Edit**: Update or tune alert thresholds at any time from Settings or Household Edit dialogs with real-time UI synchronization.
- **Smart Auto-Clearing**: Topping up the wallet with contributions above the threshold automatically resolves and clears stale low-balance alerts.

### 🔮 Consumption Tracking & Statistical Prediction Engine
- **Electricity (TANESCO LUKU)**:
  - Tracks monetary purchases, optional `kWh` units, and prior cycle depletion status (*Yes, completely finished* / *No, some remained* / *I don't know*).
- **Cooking Gas (LPG)**:
  - Tracks cylinder weights (e.g., 6 kg, 15 kg, 38 kg), replacement dates, and usage velocity.
- **Water & Household Essentials**:
  - Monitors municipal water/bowser refills and high-frequency staples (*Rice, Sugar, Cooking Oil, Flour, Milk, Soap*).
- **Statistical Forecasting**:
  - Calculates arithmetic mean, median, recency-weighted intervals, standard deviation, and coefficient of variation.
  - Dynamically assigns confidence levels: `Insufficient data`, `Low confidence`, `Medium confidence`, and `High confidence`.

### 🎨 Nyumba Organic Wave Design System
- Modern fintech aesthetic built around an emerald/forest green identity palette (`#1F9562`, `#178255`, `#126843`).
- Custom organic SVG/Canvas wave layouts (`NyumbaAuthWaveLayout` and `NyumbaAppWaveBackground`).
- Fully responsive across phone form factors with zero keyboard bottom-overflows.
- Generous 64px rounded action pills with centered typography for seamless login and registration flows.
- Full support for Light and Dark themes.

---

## 2. Architecture & Technology Stack

- **Frontend**: Flutter 3.x (Dart 3.3+)
- **State Management**: Riverpod (`flutter_riverpod`)
- **Routing**: `go_router`
- **Charts & Data Visuals**: `fl_chart`
- **Primary Cloud Backend**:
  - **Firebase Authentication**: Email/Password and Google Sign-In (`firebase_auth`, `google_sign_in`).
  - **Cloud Firestore**: Real-time synchronized ledger with offline disk persistence (`cloud_firestore`).
  - **Firestore Security Rules**: Comprehensive role-based access validation ([firestore.rules](firestore.rules)).
  - **Cloud Messaging**: Push notifications for low-balance and supply alerts (`firebase_messaging`).
- **Relational Cloud Backend (Alternative / Enterprise)**:
  - **Supabase**: PostgreSQL 15+ with Row-Level Security and atomic ledger RPC stored procedures.
- **Local Fallback**: In-memory and secure local storage with Tanzanian seed data for instant offline testing and preview.

---

## 3. Project Structure

```text
household_management/
├── android/                        # Android project configuration & google-services.json
├── lib/
│   ├── core/
│   │   ├── config/                 # App configuration & currency defaults
│   │   ├── constants/              # Brand tokens (AppColors, Nyumba greens, text styles)
│   │   ├── errors/                 # Domain exceptions (InsufficientBalance, Unauthorized)
│   │   ├── network/                # Supabase & network connectivity providers
│   │   ├── router/                 # GoRouter declarations & auth guards
│   │   ├── theme/                  # Light & Dark Material 3 theme data
│   │   ├── utils/                  # Currency (TSh), date, and compact amount formatters
│   │   └── widgets/                # Nyumba wave backgrounds, pill inputs, metric cards
│   ├── features/
│   │   ├── auth/                   # Splash, Welcome, Login, Register, Password Reset
│   │   ├── households/             # Multi-household state, Firestore ledger sync, ledger repo
│   │   ├── categories/             # Default & custom household expense categories
│   │   ├── wallet/                 # Contributions, Expenses, Ledger history & Audit corrections
│   │   ├── consumption/            # LUKU, Gas, Water, Grocery item loggers & history
│   │   ├── predictions/            # Statistical prediction engine & replenishment forecasts
│   │   ├── budgets/                # Monthly category budget limits & usage tracking
│   │   ├── notifications/          # Smart alert evaluator, deduplication, & Notifications UI
│   │   ├── dashboard/              # Home dashboard, quick actions, & bottom nav shell
│   │   ├── reports/                # Financial spending & consumption trends (fl_chart)
│   │   └── settings/               # Household settings, threshold editor, currency & sync
│   └── main.dart                   # Application entrypoint & Firebase initialization
├── supabase/
│   ├── migrations/                 # PostgreSQL schemas, RLS policies, atomic ledger RPCs
│   └── functions/                  # Supabase Edge Functions for alert evaluation
├── test/
│   ├── balance_alerts_test.dart    # Low-balance threshold, shorthand formatters & alert logic
│   ├── financial_ledger_test.dart  # Exact TZS ledger math, negative-balance guards, audit trails
│   ├── prediction_engine_test.dart # LUKU, gas, water interval prediction & confidence scoring
│   ├── security_access_test.dart   # RBAC & cross-household isolation enforcement
│   └── ui_flows_test.dart          # Widget tests for auth waves, dashboards, & contribution forms
├── firestore.rules                 # Cloud Firestore security rules
├── firestore.indexes.json          # Firestore composite query index definitions
└── firebase.json                   # Firebase CLI project configuration
```

---

## 4. Setup & Installation

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (v3.19 or higher)
- Android Studio / Xcode with platform simulators or connected physical devices
- (Optional) [Firebase CLI](https://firebase.google.com/docs/cli) and [Supabase CLI](https://supabase.com/docs/guides/cli)

### 1. Clone & Install Dependencies
```bash
git clone https://github.com/your-username/household_management.git
cd household_management
flutter pub get
```

### 2. Environment Configuration
Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```
Update `.env` with your backend credentials:
```env
SUPABASE_URL=https://your-project-ref.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key
```
*(Note: If `.env` is omitted or empty, the app runs gracefully with its built-in local ledger and realistic Tanzanian seed scenarios).*

### 3. Firebase Configuration
- For Android: Place your `google-services.json` in `android/app/`.
- Deploy Firestore Security Rules:
  ```bash
  firebase deploy --only firestore:rules
  ```

---

## 5. Verification & Testing

The project maintains a rigorous automated test suite covering financial equations, predictions, security boundaries, and user interface workflows:

```bash
# Run code analysis (must have 0 errors)
flutter analyze --no-fatal-infos

# Run the complete test suite (22 unit & widget tests)
flutter test
```

### Test Suite Overview:
- `test/financial_ledger_test.dart`: Validates $\text{Balance} = \text{Contributions} - \text{Expenses}$, negative balance guards, multi-household isolation, and audit log generation.
- `test/balance_alerts_test.dart`: Verifies threshold parsing (`10k`, `15k`, `10,000`), dynamic alert formatting, and automatic alert clearance when balances recover.
- `test/prediction_engine_test.dart`: Tests LUKU and gas replenishment interval calculations, recency weighting, and confidence determination.
- `test/security_access_test.dart`: Verifies role enforcement (Admins vs Read-only Members) and prevents cross-household data leakage.
- `test/ui_flows_test.dart`: Tests responsive wave layouts, screen transitions, and input validation without rendering overflows.

---

## 6. Running the App

```bash
# Launch on connected device or simulator
flutter run
```

---

## 7. License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
