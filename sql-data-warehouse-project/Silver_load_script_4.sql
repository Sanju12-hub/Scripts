print '>> truncating table silver.erp_cust_az12'
truncate table silver.erp_cust_az12
print '>> inserting data into silver.erp_cust_az12 '
insert into silver.erp_cust_az12 (
cid,
bdate,
gen)
select
case when cid like 'NAS%' then substring(cid, 4, len(cid))
else cid
end cid,
case when bdate > getdate() then null
else bdate
end bdate,
case when upper(trim(gen)) in ('M', 'Male') then 'Male'
when upper(trim(gen)) in ('F','Female') then 'Female'
else 'n/a'
end gen
from Bronze.erp_cust_az12

print '>> truncating table Silver.erp_loc_a101'
truncate table Silver.erp_loc_a101
print '>> inserting data into Silver.erp_loc_a101 '

insert into Silver.erp_loc_a101(
cid,
cntry)

select replace(cid,'-','') as cid,
case when trim(cntry) in ('US', 'USA') then 'United States'
when trim(cntry) = 'DE' then 'Germany'
when trim(cntry) is null or trim(cntry) = '' then 'n/a'
else trim(cntry)
end cntry
from Bronze.erp_loc_a101

print '>> truncating table silver.erp_px_cat_g1v2'
truncate table silver.erp_px_cat_g1v2
print '>> inserting data into silver.erp_px_cat_g1v2'

insert into silver.erp_px_cat_g1v2(
id,
cat,
sub_cat,
maintenance)
select id, cat, sub_cat, maintenance 
from Bronze.erp_px_cat_g1v2

