create schema gold

select * from INFORMATION_SCHEMA.TABLES

select * from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME = 'dim_customers'

select * from gold.dim_customers

select * from gold.dim_products

select * from gold.fact_sales

-- total cust by gender
select gender, count(customer_id) from gold.dim_customers
group by gender

-- total prod by cat
select category, count(product_id), avg(cost),  from gold.dim_products
group by category

-- tot revenue of each cat
select
dp.category, 
sum(fs.sales_amount)
from gold.fact_sales fs
left join gold.dim_products dp
on fs.product_key = dp.product_id
group by dp.category

-- tot rev genrated for each cust
select
dc.customer_id, 
sum(fs.sales_amount)
from gold.fact_sales fs
left join gold.dim_customers dc
on fs.customer_key = dc.customer_id
group by dc.customer_id

-- distribution of sold items accross countries
select
dc.country, 
sum(fs.quantity)
from gold.fact_sales fs
left join gold.dim_customers dc
on fs.customer_key = dc.customer_id
group by dc.country

-- which 5 products generate the high revenue

select top 5
dp.product_name, 
sum(fs.sales_amount) as tot_rev
from gold.fact_sales fs
left join gold.dim_products dp
on fs.product_key = dp.product_id
group by dp.product_name
order by tot_rev desc

-- worst performing prod
select top 5
dp.product_name, 
sum(fs.sales_amount) as tot_rev
from gold.fact_sales fs
left join gold.dim_products dp
on fs.product_key = dp.product_id
group by dp.product_name
order by tot_rev asc

-- top ten cust rev
select * from ( select
dc.customer_id, 
sum(fs.sales_amount) as tot_rev,
ROW_NUMBER() over ( order by sum(fs.sales_amount) desc) as rn

from gold.fact_sales fs
left join gold.dim_customers dc
on fs.customer_key = dc.customer_id
group by dc.customer_id )t
where rn <=10

-- 3 cust with fewer ordersplace
select * from ( select
dc.customer_id, 
count(fs.order_number) as tot_rev,
ROW_NUMBER() over ( order by count(fs.order_number) asc) as rn

from gold.fact_sales fs
left join gold.dim_customers dc
on fs.customer_key = dc.customer_id
group by dc.customer_id )t
where rn <=3