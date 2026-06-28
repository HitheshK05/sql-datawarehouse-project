
-- ====================================================================
-- Customer Table Checks
-- ====================================================================

-- Check for NULL or Duplicate Customer IDs
-- Expected: No rows
SELECT 
    cst_id,
    COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for Extra Spaces
-- Expected: No rows
SELECT 
    cst_key 
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Check Marital Status Values
SELECT DISTINCT 
    cst_marital_status 
FROM silver.crm_cust_info;

-- ====================================================================
-- Product Table Checks
-- ====================================================================

-- Check for NULL or Duplicate Product IDs
-- Expected: No rows
SELECT 
    prd_id,
    COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for Extra Spaces
-- Expected: No rows
SELECT 
    prd_nm 
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check Product Cost
-- Expected: No NULL or Negative Values
SELECT 
    prd_cost 
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Check Product Line Values
SELECT DISTINCT 
    prd_line 
FROM silver.crm_prd_info;

-- Check Product Dates
-- Expected: Start Date should be before End Date
SELECT 
    * 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ====================================================================
-- Sales Table Checks
-- ====================================================================

-- Check Invalid Due Dates
-- Expected: No Invalid Dates
SELECT 
    NULLIF(sls_due_dt, 0) AS sls_due_dt 
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
   OR LEN(sls_due_dt) != 8
   OR sls_due_dt > 20500101
   OR sls_due_dt < 19000101;

-- Check Order, Ship and Due Dates
-- Expected: Order Date should not be after Ship or Due Date
SELECT 
    * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- Check Sales Calculation
-- Expected: Sales = Quantity × Price
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
-- ERP Customer Table Checks
-- ====================================================================

-- Check Birth Dates
-- Expected: Between 1924-01-01 and Today
SELECT DISTINCT 
    bdate 
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > GETDATE();

-- Check Gender Values
SELECT DISTINCT 
    gen 
FROM silver.erp_cust_az12;

-- ====================================================================
-- ERP Location Table Checks
-- ====================================================================

-- Check Country Values
SELECT DISTINCT 
    cntry 
FROM silver.erp_loc_a101
ORDER BY cntry;

-- ====================================================================
-- ERP Product Category Table Checks
-- ====================================================================

-- Check for Extra Spaces
-- Expected: No rows
SELECT 
    * 
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
   OR subcat != TRIM(subcat)
   OR maintenance != TRIM(maintenance);

-- Check Maintenance Values
SELECT DISTINCT 
    maintenance 
FROM silver.erp_px_cat_g1v2;
```
