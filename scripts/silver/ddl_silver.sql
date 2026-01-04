/*
===============================================================================
DDL Script: Create Silver Layer Tables
===============================================================================
What this script does:
    This script builds all tables in the 'silver' schema.
    Before creating each table, it checks whether the table already exists.
    If the table exists, it is deleted and then recreated.

Why this is needed:
    The Silver layer stores cleaned, standardized, and transformed data.
    Running this script ensures that all Silver tables have a fresh
    and correct structure before loading data from the Bronze layer.

Important Note:
    Running this script will delete all existing data in the Silver tables.
    Only run it when you want to reset or rebuild the Silver layer.
===============================================================================
*/

-- ==========================================================
-- Customer information table (cleaned CRM customer data)
-- ==========================================================
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info (
    cst_id             INT,              -- Unique customer ID
    cst_key            NVARCHAR(50),      -- Business customer key
    cst_firstname      NVARCHAR(50),      -- Customer first name (trimmed & cleaned)
    cst_lastname       NVARCHAR(50),      -- Customer last name (trimmed & cleaned)
    cst_marital_status NVARCHAR(50),      -- Standardized marital status
    cst_gndr           NVARCHAR(50),      -- Standardized gender
    cst_create_date    DATE,              -- Customer record creation date
    dwh_create_date    DATETIME2 DEFAULT GETDATE() -- Load timestamp
);
GO

-- ==========================================================
-- Product information table (cleaned CRM product data)
-- ==========================================================
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
    prd_id          INT,              -- Product ID
    cat_id          NVARCHAR(50),      -- Derived category ID
    prd_key         NVARCHAR(50),      -- Clean product key
    prd_nm          NVARCHAR(50),      -- Product name
    prd_cost        INT,               -- Product cost (NULLs replaced with 0)
    prd_line        NVARCHAR(50),      -- Product line (mapped to readable values)
    prd_start_dt    DATE,              -- Product validity start date
    prd_end_dt      DATE,              -- Product validity end date
    dwh_create_date DATETIME2 DEFAULT GETDATE() -- Load timestamp
);
GO

-- ==========================================================
-- Sales transaction table (cleaned CRM sales data)
-- ==========================================================
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
    sls_ord_num     NVARCHAR(50),      -- Sales order number
    sls_prd_key     NVARCHAR(50),      -- Product key
    sls_cust_id     INT,               -- Customer_id
    sls_order_dt    DATE,              -- Order date (converted from integer)
    sls_ship_dt     DATE,              -- Shipping date
    sls_due_dt      DATE,              -- Due date
    sls_sales       INT,               -- Corrected sales amount
    sls_quantity    INT,               -- Quantity sold
    sls_price       INT,               -- Unit price
    dwh_create_date DATETIME2 DEFAULT GETDATE() -- Load timestamp
);
GO

-- ==========================================================
-- ERP customer location table
-- ==========================================================
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO

CREATE TABLE silver.erp_loc_a101 (
    cid             NVARCHAR(50),      -- Cleaned customer ID
    cntry           NVARCHAR(50),      -- Normalized country name
    dwh_create_date DATETIME2 DEFAULT GETDATE() -- Load timestamp
);
GO

-- ==========================================================
-- ERP customer demographic table
-- ==========================================================
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
GO

CREATE TABLE silver.erp_cust_az12 (
    cid             NVARCHAR(50),      -- Cleaned customer ID
    bdate           DATE,              -- Birth date (future dates removed)
    gen             NVARCHAR(50),      -- Normalized gender
    dwh_create_date DATETIME2 DEFAULT GETDATE() -- Load timestamp
);
GO

-- ==========================================================
-- ERP product category reference table
-- ==========================================================
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
GO

CREATE TABLE silver.erp_px_cat_g1v2 (
    id              NVARCHAR(50),      -- Category ID
    cat             NVARCHAR(50),      -- Category name
    subcat          NVARCHAR(50),      -- Sub-category name
    maintenance     NVARCHAR(50),      -- Maintenance indicator
    dwh_create_date DATETIME2 DEFAULT GETDATE() -- Load timestamp
);
GO
