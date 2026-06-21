--- this table is clearly showing the data about the customer so it is a dimensional table. not fact
--- creating a view object for gold layer. dimension table

create view gold.dim_customers as
select 
row_number() over (order by cst_id) as customer_key,
ci.cst_id as customer_id,
ci.cst_key as customer_number,
ci.cst_firstname as first_name,
ci.cst_lastname as last_name,
la.cntry as country,
ci.cst_marital_status as marital_status,
case when ci.cst_gndr != 'n/a' then ci.cst_gndr
else coalesce(ca.gen,'n/a')
end gender,
ca.bdate as birtdate,
ci.cst_create_date as create_date
from silver.crm_cust_info ci
left join silver.erp_cust_az12 ca
on ci.cst_key =  ca.cid
left join silver.erp_loc_a101 la
on ca.cid = la.cid



--- below table is showing lot of informtaion about product and no much evens or transaction data is shown.
--- so this is dimension table - product
--- creating a separate view obj for this table
create view gold.dim_products as
select
row_number() over (order by prd_start_dt, prd_key) as product_key,
cp.prd_id as product_id,
cp.prd_key as product_number,
cp.prd_nm as product_name,
cp.cat_id as category_id,
ep.cat as category,
ep.sub_cat as sub_category,
ep.maintenance,
cp.prd_cost as cost,
cp.prd_line as product_line,
cp.prd_start_dt as start_date
from silver.crm_prod_info cp
left join silver.erp_px_cat_g1v2 ep
on cp.cat_id = ep.id
where cp.prd_end_dt is null -- filter all historical data

-- fact table
create or alter view gold.fact_sales as

select 
sd.sls_ord_num as order_num,
pr.product_key,
cu.customer_key,
sd.sls_order_dt as order_date,
sd.sls_ship_dt as ship_date,
sd.sls_due_dt as due_date,
sd.sls_sales as sales,
sd.sls_quantity as quantity,
sd.sls_price as price
from Silver.crm_sales_details sd
left join Gold.dim_products pr
on sd.sls_prd_key = pr.product_number
left join Gold.dim_customers cu
on sd.sls_cust_id = cu.customer_id



