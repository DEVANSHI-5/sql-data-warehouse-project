/*
===============================================================================
Gold Layer Quality Checks
===============================================================================
Simple Explanation:
    This script checks if the Gold layer is correct and reliable for reporting.

What we are checking:
    1) Customer dimension: customer_key must be unique (no duplicates)
    2) Product dimension: product_key must be unique (no duplicates)
    3) Fact table links: every sale must match a valid customer and product

Why this matters:
    If these checks fail, reports can show wrong totals, missing data,
    or broken relationships in the star schema.

Important:
    If any query returns rows, it means there is a problem that should be fixed.
===============================================================================
*/


-- ==========================================================
-- 1) Check gold.dim_customers
-- ==========================================================
-- Goal: Make sure customer_key is unique
-- Expected result: NO rows returned
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- ==========================================================
-- 2) Check gold.dim_products
-- ==========================================================
-- Goal: Make sure product_key is unique
-- Expected result: NO rows returned
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- ==========================================================
-- 3) Check gold.fact_sales relationships (links)
-- ==========================================================
-- Goal: Every row in fact_sales must connect to:
--       - a valid customer in dim_customers
--       - a valid product in dim_products
--
-- How it works:
--   - If a sale has a customer_key that does not exist in dim_customers,
--     then c.customer_key will be NULL.
--   - If a sale has a product_key that does not exist in dim_products,
--     then p.product_key will be NULL.
--
-- Expected result: NO rows returned
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
WHERE p.product_key IS NULL 
   OR c.customer_key IS NULL;
