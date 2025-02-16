/*
===============================================================================
Data Quality Checks
===============================================================================
Script Objective:
    This script performs comprehensive quality checks to ensure data accuracy, 
    consistency, and standardization within the 'silver' layer. The checks include:
    - Detecting null or duplicate primary keys.
    - Identifying unwanted spaces in text fields.
    - Verifying data standardization and consistency.
    - Validating date ranges and chronological order.
    - Ensuring logical consistency across related fields.

Usage Guidelines:
    - Execute these checks after loading data into the Silver Layer.
    - Investigate and correct any discrepancies identified during validation.
===============================================================================
*/

-- ====================================================================
-- Validating 'silver.crm_cust_info'
-- ====================================================================
-- Checking for NULLs or Duplicates in Primary Key
-- Expected Result: No rows returned
SELECT 
    cst_id,
    COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Identifying Unwanted Spaces in Key Fields
-- Expected Result: No rows returned
SELECT 
    cst_key 
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Verifying Data Standardization & Consistency
SELECT DISTINCT 
    cst_marital_status 
FROM silver.crm_cust_info;

-- ====================================================================
-- Validating 'silver.crm_prd_info'
-- ====================================================================
-- Checking for NULLs or Duplicates in Primary Key
-- Expected Result: No rows returned
SELECT 
    prd_id,
    COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Identifying Unwanted Spaces in Product Names
-- Expected Result: No rows returned
SELECT 
    prd_nm 
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Checking for NULLs or Negative Values in Product Cost
-- Expected Result: No rows returned
SELECT 
    prd_cost 
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Verifying Data Standardization & Consistency
SELECT DISTINCT 
    prd_line 
FROM silver.crm_prd_info;

-- Validating Chronological Order (Start Date ≤ End Date)
-- Expected Result: No rows returned
SELECT 
    * 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ====================================================================
-- Validating 'silver.crm_sales_details'
-- ====================================================================
-- Checking for Invalid Dates
-- Expected Result: No invalid dates found
SELECT 
    NULLIF(sls_due_dt, 0) AS sls_due_dt 
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
    OR LEN(sls_due_dt) != 8 
    OR sls_due_dt > 20500101 
    OR sls_due_dt < 19000101;

-- Ensuring Order Date Precedes Shipping/Due Dates
-- Expected Result: No rows returned
SELECT 
    * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- Validating Sales Calculation: Sales = Quantity * Price
-- Expected Result: No discrepancies found
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price 
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- ====================================================================
-- Validating 'silver.erp_cust_az12'
-- ====================================================================
-- Identifying Out-of-Range Birthdates
-- Expected Result: Birthdates within 1924-01-01 to today
SELECT DISTINCT 
    bdate 
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' 
   OR bdate > GETDATE();

-- Verifying Data Standardization & Consistency
SELECT DISTINCT 
    gen 
FROM silver.erp_cust_az12;

-- ====================================================================
-- Validating 'silver.erp_loc_a101'
-- ====================================================================
-- Checking for Standardized Country Names
SELECT DISTINCT 
    cntry 
FROM silver.erp_loc_a101
ORDER BY cntry;

-- ====================================================================
-- Validating 'silver.erp_px_cat_g1v2'
-- ====================================================================
-- Identifying Unwanted Spaces in Key Fields
-- Expected Result: No rows returned
SELECT 
    * 
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- Verifying Data Standardization & Consistency
SELECT DISTINCT 
    maintenance 
FROM silver.erp_px_cat_g1v2;
