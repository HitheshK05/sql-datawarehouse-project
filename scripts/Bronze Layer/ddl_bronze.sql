create table bronze.crm_cust_info (
    cst_id int,
    cst_key nvarchar(50),
    cst_firstname nvarchar(50),
    cst_lastname nvarchar(50),
    cst_material_status nvarchar(50),
    cst_gndr nvarchar(50),
    cst_create_date date
);

create table bronze.crm_prd_info (
    prd_id int,
    prd_key nvarchar(50),
    prd_nm nvarchar(50),
    prd_cost int,
    prd_line nvarchar(50),
    prd_start_dt datetime,
    prd_end_dt datetime
);

create table bronze.crm_sales_details (
    sls_ord_num nvarchar(50),
    sls_prd_key nvarchar(50),
    sls_cust_id int,
    sls_order_dt int,
    sls_ship_dt int,
    sls_due_dt int,
    sls_sales int,
    sls_quantity int,
    sls_price int
);

create table bronze.erp_loc_a101 (
    cid nvarchar(50),
    cntry nvarchar(50)
);

create table bronze.erp_cust_az12 (
    cid nvarchar(50),
    bdate date,
    gen nvarchar(50)
);

create table bronze.erp_px_cat_g1v2 (
    id nvarchar(50),
    cat nvarchar(50),
    subcat nvarchar(50),
    maintenance nvarchar(50)
);
exec bronze.load_bronze
-- stored procedure for bronze layer
create or alter procedure bronze.load_bronze
as
begin

    declare @start_time datetime,
            @end_time datetime,
            @batch_start_time datetime,
            @batch_end_time datetime;

    begin try

        set @batch_start_time = getdate();

        print '=============================================';
        print 'Loading Bronze Layer';
        print '=============================================';

        print '';
        print '---------------------------------------------';
        print 'Loading CRM Tables';
        print '---------------------------------------------';

        -- CRM Customer
        set @start_time = getdate();

        print '>> Truncating Table: bronze.crm_cust_info';
        truncate table bronze.crm_cust_info;

        print '>> Inserting Data Into: bronze.crm_cust_info';

        bulk insert bronze.crm_cust_info
        from 'C:\Users\Dell\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        with (
            firstrow = 2,
            fieldterminator = ',',
            tablock
        );

        set @end_time = getdate();

        print '>> Load Duration: '
              + cast(datediff(second,@start_time,@end_time) as nvarchar)
              + ' seconds';
        print '';

        -- CRM Product
        set @start_time = getdate();

        print '>> Truncating Table: bronze.crm_prd_info';
        truncate table bronze.crm_prd_info;

        print '>> Inserting Data Into: bronze.crm_prd_info';

        bulk insert bronze.crm_prd_info
        from 'C:\Users\Dell\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        with (
            firstrow = 2,
            fieldterminator = ',',
            tablock
        );

        set @end_time = getdate();

        print '>> Load Duration: '
              + cast(datediff(second,@start_time,@end_time) as nvarchar)
              + ' seconds';
        print '';

        -- CRM Sales
        set @start_time = getdate();

        print '>> Truncating Table: bronze.crm_sales_details';
        truncate table bronze.crm_sales_details;

        print '>> Inserting Data Into: bronze.crm_sales_details';

        bulk insert bronze.crm_sales_details
        from 'C:\Users\Dell\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        with (
            firstrow = 2,
            fieldterminator = ',',
            tablock
        );

        set @end_time = getdate();

        print '>> Load Duration: '
              + cast(datediff(second,@start_time,@end_time) as nvarchar)
              + ' seconds';
        print '';

        print '---------------------------------------------';
        print 'Loading ERP Tables';
        print '---------------------------------------------';

        -- ERP Location
        set @start_time = getdate();

        print '>> Truncating Table: bronze.erp_loc_a101';
        truncate table bronze.erp_loc_a101;

        print '>> Inserting Data Into: bronze.erp_loc_a101';

        bulk insert bronze.erp_loc_a101
        from 'C:\Users\Dell\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
        with (
            firstrow = 2,
            fieldterminator = ',',
            tablock
        );

        set @end_time = getdate();

        print '>> Load Duration: '
              + cast(datediff(second,@start_time,@end_time) as nvarchar)
              + ' seconds';
        print '';

        -- ERP Customer
        set @start_time = getdate();

        print '>> Truncating Table: bronze.erp_cust_az12';
        truncate table bronze.erp_cust_az12;

        print '>> Inserting Data Into: bronze.erp_cust_az12';

        bulk insert bronze.erp_cust_az12
        from 'C:\Users\Dell\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
        with (
            firstrow = 2,
            fieldterminator = ',',
            tablock
        );

        set @end_time = getdate();

        print '>> Load Duration: '
              + cast(datediff(second,@start_time,@end_time) as nvarchar)
              + ' seconds';
        print '';

        -- ERP Product Category
        set @start_time = getdate();

        print '>> Truncating Table: bronze.erp_px_cat_g1v2';
        truncate table bronze.erp_px_cat_g1v2;

        print '>> Inserting Data Into: bronze.erp_px_cat_g1v2';

        bulk insert bronze.erp_px_cat_g1v2
        from 'C:\Users\Dell\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
        with (
            firstrow = 2,
            fieldterminator = ',',
            tablock
        );

        set @end_time = getdate();

        print '>> Load Duration: '
              + cast(datediff(second,@start_time,@end_time) as nvarchar)
              + ' seconds';

        set @batch_end_time = getdate();

        print '';
        print '=============================================';
        print 'Bronze Layer ETL Completed Successfully';
        print 'All source files have been loaded into the Bronze layer.';
        print 'Total Execution Time: '
              + cast(datediff(second,@batch_start_time,@batch_end_time) as nvarchar)
              + ' seconds';
        print '=============================================';

    end try

    begin catch

        print '';
        print '=============================================';
        print 'Bronze Layer ETL Failed';
        print error_message();
        print '=============================================';

    end catch

end;
