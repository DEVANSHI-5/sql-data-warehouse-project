/*
=============================================================
Database and Schema Initialization
=============================================================
Overview:
    This script initializes a database called 'DataWarehouse'. 
    It first checks whether the database already exists. If found, 
    the existing database is removed and then recreated from scratch. 
    Afterward, three schemas—'bronze', 'silver', and 'gold'—are created 
    to support layered data organization.

CAUTION:
    Executing this script will completely remove the 'DataWarehouse' 
    database if it already exists. All stored data will be irreversibly 
    lost. Make sure appropriate backups are in place before proceeding.
*/

USE master;
GO

-- Remove existing 'DataWarehouse' database and recreate it
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create a fresh 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Define database schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
