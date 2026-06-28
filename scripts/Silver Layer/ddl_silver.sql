if object_id('silver.crm_cust_info', 'U') is not null
    drop table silver.crm_cust_info;

create table silver.crm_cust_info (
    cst_id int,
    cst_key nvarchar(50),
    cst_firstname nvarchar(50),
    cst_lastname nvarchar(50),
    cst_material_status nvarchar(50),
    cst_gndr nvarchar(50),
    cst_create_date date,
    dwh_create_date datetime2 default getdate()
);

if object_id('silver.crm_prd_info', 'U') is not null
    drop table silver.crm_prd_info;

create table silver.crm_prd_info (
    prd_id int,
    cat_id nvarchar(50),
    prd_key nvarchar(50),
    prd_nm nvarchar(50),
    prd_cost int,
    prd_line nvarchar(50),
    prd_start_dt datetime,
    prd_end_dt datetime,
    dwh_create_date datetime2 default getdate()
);

if object_id('silver.crm_sales_details', 'U') is not null
    drop table silver.crm_sales_details;

create table silver.crm_sales_details (
    sls_ord_num nvarchar(50),
    sls_prd_key nvarchar(50),
    sls_cust_id int,
    sls_order_dt date,
    sls_ship_dt date,
    sls_due_dt date,
    sls_sales int,
    sls_quantity int,
    sls_price int,
    dwh_create_date datetime2 default getdate()
);

if object_id('silver.erp_loc_a101', 'U') is not null
    drop table silver.erp_loc_a101;

create table silver.erp_loc_a101 (
    cid nvarchar(50),
    cntry nvarchar(50),
    dwh_create_date datetime2 default getdate()
);

if object_id('silver.erp_cust_az12', 'U') is not null
    drop table silver.erp_cust_az12;

create table silver.erp_cust_az12 (
    cid nvarchar(50),
    bdate date,
    gen nvarchar(50),
    dwh_create_date datetime2 default getdate()
);

if object_id('silver.erp_px_cat_g1v2', 'U') is not null
    drop table silver.erp_px_cat_g1v2;

create table silver.erp_px_cat_g1v2 (
    id nvarchar(50),
    cat nvarchar(50),
    subcat nvarchar(50),
    maintenance nvarchar(50),
    dwh_create_date datetime2 default getdate()
);

select  cst_id, count(*)
from bronze.crm_cust_info
group by cst_id
having count(*) >1 or cst_id is null

-- sorted by latest date and avoided duplicates
select *
from (
    select *,
           row_number() over (
               partition by cst_id
               order by cst_create_date desc
           ) as flag_last
    from bronze.crm_cust_info
    where cst_id is not null
) t
where flag_last = 1;

-- unwantd spaces
--first name
select cst_firstname
from silver.crm_cust_info
where cst_firstname != trim (cst_firstname)
--last anme
select cst_lastname
from bronze.crm_cust_info
where cst_lastname != trim (cst_lastname)
--gender is good
select cst_gndr
from bronze.crm_cust_info
where cst_gndr != trim (cst_gndr)

-- clean first add last name
select
    cst_id,
    cst_key,
    trim(cst_firstname) as cst_firstname,
    trim(cst_lastname) as cst_lastname,
    --maritial correction from m-> married and s-> single and null-> n/a

    case when upper(trim (cst_material_status)) = 'S' then 'Single'
     when upper(trim (cst_material_status)) = 'M' then 'Married'
     else 'n/a'
    end cst_material_status,
    
    --gender correction from m-> male and f-> female and null-> n/a

    case when upper(trim (cst_gndr)) = 'F' then 'Female'
     when upper(trim (cst_gndr)) = 'M' then 'Male'
     else 'n/a'
     end cst_gndr,

    cst_create_date
from (
    select
        *,
        row_number() over (
            partition by cst_id
            order by cst_create_date desc
        ) as flag_last
    from bronze.crm_cust_info
    where cst_id is not null
) t
where flag_last = 1;

