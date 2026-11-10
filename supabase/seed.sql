-- =============================================================================
-- SEPARATE DEMO / SEED ENVIRONMENT SCRIPT (supabase/seed.sql)
-- For local development & testing only. Models the exact Tanzanian household
-- scenario described in the Product Overview (Dida, Member B, Member C).
-- =============================================================================

-- Note: Run in local Supabase development after creating a seed user in auth.users
-- or via the Local Seed Repository during offline/demo development.
-- Scenario modeled:
--   Household 1: "My Family (Mikocheni, Dar es Salaam)"
--     - Dida contributes TSh 100,000
--     - Asha (Member B) contributes TSh 50,000
--     - Juma (Member C) contributes TSh 150,000
--     - Total contributions = TSh 300,000
--     - Groceries expense by Dida = TSh 50,000 -> Available balance = TSh 250,000
--     - LUKU Electricity purchases on 05 Oct, 15 Oct, 25 Oct, 04 Nov (~10 day interval)
--     - Cooking Gas 15kg purchases (~25 day interval)
--   Household 2: "Parents' Home (Arusha)"
--   Household 3: "My Apartment (Masaki)"

