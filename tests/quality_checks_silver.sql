/*
===============================================================================
Data Quality Checks – Silver Layer
===============================================================================
Simple Explanation:
    This script checks whether the data in the Silver layer is clean,
    correct, and consistent after loading from the Bronze layer.

What this script checks:
    - Missing or duplicate IDs (primary keys)
    - Extra spaces in text columns
    - Correct and consistent values (example: gender, product line)
    - Valid dates and correct date order
    - Logical consistency between numeric fields (sales = quantity × price)

When to run:
    - Always run this script AFTER the Silver layer load is complete.
    - If any query returns rows, it means there is a data issue
      that should be investigated and fixed.
===============================================================================
*/

-- ==========================================================
-- 1) Quality checks for silver.crm_cust_info (Customer Data)
-- ==========================================================

-- Check for missing or duplicate customer IDs
-- Expected result: NO rows returned
SELECT 
    cst_id,
    COUNT(*) AS record_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted spaces in customer key
-- Expected result: NO rows returned
SELECT 
    cst_key
FROM silver.crm_cust_info
WHERE cst_key <> TRIM(cst_key);

-- Check that marital status values are standardized
-- Expected values: Single, Married, n/a
SELECT DISTINCT 
    cst_marital_status
FROM silver.crm_cust_info;


-- ==========================================================
-- 2) Quality checks for silver.crm_prd_info (Product Data)
-- ==========================================================

-- Check for missing or duplicate product IDs
-- Expected result: NO rows returned
SELECT 
    prd_id,
    COUNT(*) AS record_count
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for unwanted spaces in product name
-- Expected result: NO rows returned
SELECT 
    prd_nm
FROM silver.crm_prd_info
WHERE prd_nm <> TRIM(prd_nm);

-- Check for invalid product cost values
-- Expected result: No NULL or negative values
SELECT 
    prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;

-- Check product line values are consistent
-- Expected values: Mountain, Road, Touring, Other Sales, n/a
SELECT DISTINCT 
    prd_line
FROM silver.crm_prd_info;

-- Check that product end date is not before start date
-- Expected result: NO rows returned
SELECT 
    *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


-- ==========================================================
-- 3) Quality checks for silver.crm_sales_details (Sales Data)
-- ==========================================================

-- Check for invalid date values in the original Bronze data
-- Expected result: NO rows returned
SELECT 
    NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
   OR LEN(sls_due_dt) <> 8
   OR sls_due_dt > 20500101
   OR sls_due_dt < 19000101;

-- Check that order date is not after ship date or due date
-- Expected result: NO rows returned
SELECT 
    *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- Check sales calculation consistency
-- Sales must equal quantity × price
-- Expected result: NO rows returned
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales <> sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;


-- ==========================================================
-- 4) Quality checks for silver.erp_cust_az12 (ERP Customer Data)
-- ==========================================================

-- Check for invalid birth dates
-- Expected range: 1924-01-01 up to today
SELECT DISTINCT 
    bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > GETDATE();

-- Check gender values are standardized
-- Expected values: Male, Female, n/a
SELECT DISTINCT 
    gen
FROM silver.erp_cust_az12;


-- ==========================================================
-- 5) Quality checks for silver.erp_loc_a101 (Location Data)
-- ==========================================================

-- Check country values are clean and standardized
SELECT DISTINCT 
    cntry
FROM silver.erp_loc_a101
ORDER BY cntry;


-- ==========================================================
-- 6) Quality checks for silver.erp_px_cat_g1v2 (Category Data)
-- ==========================================================

-- Check for extra spaces in text fields
-- Expected result: NO rows returned
SELECT 
    *
FROM silver.erp_px_cat_g1v2
WHERE cat <> TRIM(cat)
   OR subcat <> TRIM(subcat)
   OR maintenance <> TRIM(maintenance);

-- Check maintenance values are consistent
SELECT DISTINCT 
    maintenance
FROM silver.erp_px_cat_g1v2;
