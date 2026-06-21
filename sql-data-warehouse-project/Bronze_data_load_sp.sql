--- exec bronze.load_bronze; --- execute sp using this line

create or alter procedure bronze.load_bronze as
begin
    --- adding timestamp helps in analysing exec time, ETL, and try catch handles any error message
    declare @start_time Datetime, @end_time datetime, @start_batch_time datetime, @end_batch_time datetime;
	begin try
		print '=========================================='
		print 'Loading Bronze layer'
		print '=========================================='
		set @start_batch_time = getdate()
		print 'Loading CRM Tables'

		set @start_time = getdate();
		print '>> Truncating Table: Bronze.crm_cust_info'

		truncate table Bronze.crm_cust_info --- removes if any rows exists
		print '>> Loading data into: Bronze.crm_cust_info'

		bulk insert Bronze.crm_cust_info
		from 'C:\Users\sandh\OneDrive\Documents\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time = GETDATE();
		print '>>load duration' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		--- if executed above scripts twice it will load data twice. check using count function as below.
		--- so truncate (removes all rows withot condition) the table and load again
		print '-------------------------------------------------'
		--- now load csv file for all tables

		print '>> Truncating Table: Bronze.crm_prod_info'
		set @start_time = getdate();
		truncate table Bronze.crm_prod_info
		print '>> Loading data into: Bronze.crm_prod_info'
		bulk insert Bronze.crm_prod_info
		from 'C:\Users\sandh\OneDrive\Documents\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time = GETDATE();
		print '>>load duration' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
		print '-------------------------------------------------'
		print '>> Truncating Table: Bronze.crm_sales_details'

		set @start_time = getdate();
		truncate table Bronze.crm_sales_details
		print '>> Loading data into: Bronze.crm_sales_details'
		bulk insert Bronze.crm_sales_details
		from 'C:\Users\sandh\OneDrive\Documents\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time = GETDATE();
		print '>> load duration' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';


		print '==========================================='
		print 'Loading ERP Tables'
		print '-------------------------------------------------'
		print '>> Truncating Table: Bronze.erp_cust_az12'

		set @start_time = getdate();
		truncate table Bronze.erp_cust_az12
		print '>> Loading data into: Bronze.erp_cust_az12'
		bulk insert Bronze.erp_cust_az12
		from 'C:\Users\sandh\OneDrive\Documents\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time = GETDATE();
		print '>> load duration' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';


		print '-------------------------------------------------'
		print '>> Truncating Table: Bronze.erp_loc_a101'

		set @start_time = getdate();
		truncate table Bronze.erp_loc_a101
		print '>> Loading data into: Bronze.erp_loc_a101'
		bulk insert Bronze.erp_loc_a101
		from 'C:\Users\sandh\OneDrive\Documents\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time = GETDATE();
		print '>> load duration' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';


		print '-------------------------------------------------'
		print '>> Truncating Table: Bronze.erp_loc_a101'

		set @start_time = getdate();
		truncate table Bronze.erp_px_cat_g1v2
		print '>> Loading data into: Bronze.erp_px_cat_g1v2'
		bulk insert Bronze.erp_px_cat_g1v2
		from 'C:\Users\sandh\OneDrive\Documents\SQL\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with (
		firstrow = 2,
		fieldterminator = ',',
		tablock
		);
		set @end_time = GETDATE();
		print '>> load duration' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'seconds';
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