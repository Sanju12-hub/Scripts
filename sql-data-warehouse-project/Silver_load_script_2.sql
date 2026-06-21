--- correcting the table DDL as we added derived columns
if OBJECT_ID('silver.crm_prod_info', 'U') is not null
drop table silver.crm_prod_info
go
create table silver.crm_prod_info (
prd_id int,
cat_id nvarchar(50),
prd_key nvarchar(50),
prd_nm nvarchar(50),
prd_cost int,
prd_line nvarchar(50),
prd_start_dt date,
prd_end_dt date
)

--- insert the corrected data into table
insert into silver.crm_prod_info (
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)

select
prd_id,
replace(substring(prd_key,1,5),'-','_') as cat_id,
replace(substring(prd_key,7,len(prd_key)),'-','_') as prd_key,
prd_nm,
ISNULL(prd_cost,0) as prd_cost,
case when upper(trim(prd_line)) = 'M' then 'Mountain'
when upper(trim(prd_line)) = 'R' then 'Road'
when upper(trim(prd_line)) = 'S' then 'Other Sales'
when upper(trim(prd_line)) = 'T' then 'Touring'
else 'n/a'
end prd_line,
prd_start_dt,
cast(lead(prd_start_dt) over (partition by prd_key order by prd_start_dt) -1 as date)as prd_end_dt
from Bronze.crm_prod_info
where substring(prd_key,7,len(prd_key)) in (select sls_prd_key from Bronze.crm_sales_details)