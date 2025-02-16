/*
===============================================================================
Data Quality Verification
===============================================================================
Script Objective:
    This script conducts quality assurance checks to uphold the accuracy, 
    consistency, and integrity of the Gold Layer. These validations ensure:
    - Surrogate keys in dimension tables remain unique.
    - Referential integrity is maintained between fact and dimension tables.
    - Relationships within the data model are correctly structured for analysis.

Guidelines:
    - Investigate and address any inconsistencies identified during validation.
===============================================================================
*/

-- ====================================================================
-- Validation of 'gold.dim_customers'
-- ====================================================================
-- Ensuring Customer Key Uniqueness in gold.dim_customers
-- Expected Outcome: No results (indicating no duplicates)
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Validation of 'gold.dim_products'
-- ====================================================================
-- Ensuring Product Key Uniqueness in gold.dim_products
-- Expected Outcome: No results (indicating no duplicates)
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Validation of 'gold.fact_sales'
-- ====================================================================
-- Verifying Referential Integrity Between Fact and Dimension Tables
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL;
