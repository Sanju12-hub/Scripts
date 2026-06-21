--- exec silver.load_silver

Create or alter procedure silver.load_silver as
begin
	declare @start_time Datetime, @end_time datetime, @start_batch_time datetime, @end_batch_time datetime;
	begin try
		print '=========================================='
		print 'Loading Silver layer'
		print '=========================================='
		set @start_batch_time = getdate()
		print 'Loading CRM Tables'
		set @start_time = getdate();
		print '>> truncating table Silver.crm_cust_info'
		truncate table Silver.crm_cust_info
		print '>> inserting data into Silver.crm_cust_info'
		insert into Silver.crm_cust_info (
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_marital_status,
		cst_gndr,
		cst_create_date
		)

		select cst_id,
		cst_key,
		trim(cst_firstname),
		trim(cst_lastname),
		case 
		when upper(trim(cst_marital_status)) = 'S' then 'Single'
		when upper(trim(cst_marital_status)) = 'M' then 'Married'
		else 'n/a'
		end cst_marital_status,
		case 
		when upper(trim(cst_gndr)) = 'F' then 'Female'
		when upper(trim(cst_gndr)) = 'M' then 'Male'
		else 'n/a'
		end cst_gndr,
		cst_create_date
		from (select *, ROW_NUMBER() over (partition by cst_id order by cst_create_date desc) as rn
		from Bronze.crm_cust_info)t
		where rn = 1 and cst_id is not null;

		set @end_time = GETDATE();
		print '>>load duration' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';


		print '>> truncating table silver.crm_prod_info'
		set @start_time = getdate();
		truncate table silver.crm_prod_info
		print '>> inserting data into silver.crm_prod_info'

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
		set @end_time = GETDATE();
		print '>>load duration' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';



		print '>> truncating table silver.crm_sales_details'
		set @start_time = getdate();
		truncate table silver.crm_sales_details
		print '>> inserting data into silver.crm_sales_details'

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
		set @end_time = GETDATE();
		print '>>load duration' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';


		print '>> truncating table silver.erp_cust_az12'
		set @start_time = getdate();
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
		set @end_time = GETDATE();
		print '>>load duration' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';


		print '>> truncating table Silver.erp_loc_a101'
		set @start_time = getdate();
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
		set @end_time = GETDATE();
		print '>>load duration' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';



		print '>> truncating table silver.erp_px_cat_g1v2'
		set @start_time = getdate();
		truncate table silver.erp_px_cat_g1v2
		print '>> inserting data into silver.erp_px_cat_g1v2'

		insert into silver.erp_px_cat_g1v2(
		id,
		cat,
		sub_cat,
		maintenance)
		select id, cat, sub_cat, maintenance 
		from Bronze.erp_px_cat_g1v2
		set @end_time = GETDATE();
		print '>>load duration' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';

		set @start_batch_time = getdate()
		print '>> load duration' + cast(datediff(second, @start_batch_time, @end_batch_time) as nvarchar) + 'seconds';


	end try
	begin catch
	print '============================='
	print 'error occured during bronze load'
	print 'error message' + error_message();
	print 'error number' + cast(error_number() as nvarchar)
	print 'error number' + cast(error_state() as nvarchar)
	print '============================='
	end catch

end