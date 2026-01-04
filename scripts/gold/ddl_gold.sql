/*
===============================================================================
DDL Script: Create Gold Layer Views
===============================================================================
Simple Explanation:
    This script creates views for the Gold layer of the data warehouse.

What the Gold layer is:
    - The Gold layer is the FINAL layer used for reporting and analytics.
    - It follows a Star Schema design:
        • Dimension tables (customers, products)
        • Fact table (sales)

What these views do:
    - Combine data from multiple Silver tables
    - Apply final business rules
    - Create clean, easy-to-use datasets for BI tools and reports

How to use:
    - Query these views directly for dashboards, reports, and analysis
===============================================================================
*/


-- =============================================================================
-- Dimension View: gold.dim_customers
-- =============================================================================
-- This view creates a clean Customer dimension by combining:
--   - CRM customer data
--   - ERP customer demographics
--   - ERP location data
-- Each customer gets a new surrogate key for analytics

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,   -- Surrogate key (used in fact table)
    ci.cst_id                          AS customer_id,    -- Original customer ID
    ci.cst_key                         AS customer_number,-- Business customer key
    ci.cst_firstname                   AS first_name,     -- Customer first name
    ci.cst_lastname                    AS last_name,      -- Customer last name
    la.cntry                           AS country,        -- Customer country
    ci.cst_marital_status              AS marital_status, -- Marital status
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr         -- Prefer CRM gender
        ELSE COALESCE(ca.gen, 'n/a')                       -- Use ERP gender if CRM is missing
    END                                AS gender,
    ca.bdate                           AS birthdate,      -- Customer birth date
    ci.cst_create_date                 AS create_date     -- Customer record creation date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;
GO


-- =============================================================================
-- Dimension View: gold.dim_products
-- =============================================================================
-- This view creates a Product dimension by combining:
--   - CRM product data
--   - ERP product category data
-- Only current (active) products are included

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, -- Surrogate key
    pn.prd_id       AS product_id,        -- Original product ID
    pn.prd_key      AS product_number,    -- Business product key
    pn.prd_nm       AS product_name,      -- Product name
    pn.cat_id       AS category_id,        -- Category ID
    pc.cat          AS category,           -- Category name
    pc.subcat       AS subcategory,        -- Sub-category name
    pc.maintenance  AS maintenance,        -- Maintenance flag
    pn.prd_cost     AS cost,               -- Product cost
    pn.prd_line     AS product_line,       -- Product line
    pn.prd_start_dt AS start_date          -- Product start date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;               -- Only active products
GO


-- =============================================================================
-- Fact View: gold.fact_sales
-- =============================================================================
-- This view creates the Sales fact table.
-- It links sales transactions to:
--   - Product dimension
--   - Customer dimension
-- This is the main table used for sales analysis

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num  AS order_number,   -- Sales order number
    pr.product_key  AS product_key,    -- Link to product dimension
    cu.customer_key AS customer_key,   -- Link to customer dimension
    sd.sls_order_dt AS order_date,     -- Order date
    sd.sls_ship_dt  AS shipping_date,  -- Shipping date
    sd.sls_due_dt   AS due_date,       -- Due date
    sd.sls_sales    AS sales_amount,   -- Total sales amount
    sd.sls_quantity AS quantity,       -- Quantity sold
    sd.sls_price    AS price           -- Unit price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
GO
