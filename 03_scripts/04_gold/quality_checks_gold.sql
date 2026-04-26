/*
================================================================================
Script      : quality_checks_gold.sql
Purpose     : Performs quality checks on the gold schema for data integrity,
              consistency, and accuracy.
--------------------------------------------------------------------------------
Checks      : - Uniqueness of surrogate keys in dimension tables.
              - Referential integrity between fact and dimension tables.
              - Relationship validation across the data model.
Notes       : Run to verify data quality and resolve any discrepancies
              during the gold layer loading process.
================================================================================
*/

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- check for uniqueness of surrogate key
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.dim_products'
-- ====================================================================
-- check for uniqueness of surrogate key
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- check for referential integrity between fact and dimension tables
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL;
