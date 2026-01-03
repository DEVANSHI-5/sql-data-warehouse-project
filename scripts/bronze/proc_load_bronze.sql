/*
===============================================================================
Stored Procedure: Bronze Layer Data Load (Source to Bronze)
===============================================================================
Overview:
    This stored procedure populates tables in the 'bronze' schema using data
    sourced from external CSV files. The process includes:
      - Clearing/truncate existing data from bronze tables
      - Loading fresh records via the BULK INSERT operation

Inputs:
    None.
    This procedure does not require parameters and does not return results.

Execution:
    EXEC bronze.load_bronze;
===============================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE 
        @start_time DATETIME, 
        @end_time DATETIME, 
        @batch_start_time DATETIME, 
        @batch_end_time DATETIME; 

    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Starting Bronze Layer Data Load';
        PRINT '================================================';

        PRINT '------------------------------------------------';
        PRINT 'Processing CRM Source Tables';
        PRINT '------------------------------------------------';

        SET @start_time = GETDATE();
        PRINT '>> Clearing Table: bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
        PRINT '>> Loading Data Into: bronze.crm_cust_info';
        BULK INSERT bronze.crm_cust_info
        FROM 'C:\sql\dwh_project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Execution Time: ' 
              + CAST(DATEDIFF(SEC
