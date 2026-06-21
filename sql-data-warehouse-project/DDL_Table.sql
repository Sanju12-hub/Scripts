--- Creating Tables DDL----
/*
Creating DDL for source tables
*/

if OBJECT_ID('Bronze.crm_cust_info','U') is not null
	drop table Bronze.crm_cust_info;
go
create table Bronze.crm_cust_info (
cst_id int,
cst_key varchar(50), 
cst_firstname varchar(50),
cst_lastname varchar(50),
cst_marital_status varchar(50),
cst_gndr varchar(50),
cst_create_date date
);


if OBJECT_ID('Bronze.crm_prod_info','U') is not null
	drop table Bronze.crm_prod_info;
go
create table Bronze.crm_prod_info (
prd_id int,
prd_key nvarchar(50),
prd_nm nvarchar(50),
prd_cost int,
prd_line nvarchar(50),
prd_start_dt datetime,
prd_end_dt datetime
);


if OBJECT_ID('Bronze.crm_sales_details','U') is not null
	drop table Bronze.crm_sales_details;
go
create table Bronze.crm_sales_details (
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


if OBJECT_ID('Bronze.erp_cust_az12','U') is not null
	drop table Bronze.erp_cust_az12;
go
create table Bronze.erp_cust_az12 (
cid nvarchar(50),
bdate date,
gen nvarchar(50)	
);


if OBJECT_ID('Bronze.erp_loc_a101','U') is not null
	drop table Bronze.erp_loc_a101;
go
create table Bronze.erp_loc_a101 (
cid nvarchar(50),
cntry nvarchar(50)	
);


if OBJECT_ID('Bronze.erp_px_cat_g1v2','U') is not null
	drop table Bronze.erp_px_cat_g1v2;
go
create table Bronze.erp_px_cat_g1v2(
id nvarchar(50),
cat nvarchar(50),
sub_cat nvarchar(50),
maintenance nvarchar(50)
);

select * from bronze.crm_prod_info;