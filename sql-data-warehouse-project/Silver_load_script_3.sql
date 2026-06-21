-- 1. check for table existence and create table. run below script first
if object_id('silver.crm_sales_details','U') is not null
drop table silver.crm_sales_details
go 
create table silver.crm_sales_details (
sls_ord_num nvarchar(50),
sls_prd_key nvarchar(50),
sls_cust_id int,
sls_order_dt date,
sls_ship_dt date,
sls_due_dt date,
sls_sales int,
sls_quantity int,
sls_price int
)

-- 2. then insert clean data into table and run below
insert into silver.crm_sales_details(
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
)

select sls_ord_num,
sls_prd_key,
sls_cust_id,
case when len(sls_order_dt) !=8 or sls_order_dt = 0  then null
else cast(cast((sls_order_dt) as varchar)as date) 
end sls_order_dt,
case when len(sls_ship_dt) !=8 or sls_ship_dt = 0  then null
else cast(cast((sls_ship_dt) as varchar)as date) 
end sls_ship_dt,
case when len(sls_due_dt) !=8 or sls_due_dt = 0  then null
else cast(cast((sls_due_dt) as varchar)as date) 
end sls_due_dt,
case when sls_sales is null or  sls_sales <0 or sls_Sales != abs(sls_price)* sls_quantity then abs(sls_price)* sls_quantity
else sls_sales
end sls_Sales,
sls_quantity,
case when sls_price <0 or sls_price is null then sls_sales / nullif(sls_quantity,0)
else sls_price
end sls_price
from bronze.crm_sales_details;