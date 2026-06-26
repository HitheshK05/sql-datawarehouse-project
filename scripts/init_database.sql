/*==============================================================================
  Script: Create Database and Schemas
==============================================================================

Description:
This script initializes the DataWarehouse database by creating it if it does
not already exist. If an existing database is found, it is safely dropped and
recreated to ensure a clean deployment.

After the database is created, the following schemas are generated to support
the Medallion Architecture:

    - bronze : Raw source data
    - silver : Cleansed and transformed data
    - gold   : Business-ready analytical data

Note:
Executing this script will remove the existing DataWarehouse database and all
associated objects. Ensure that any required data has been backed up before
running this script.
*/

USE master;
GO

-- Drop existing database (if available)
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE DataWarehouse;
END;
GO

-- Create database
CREATE DATABASE DataWarehouse;
GO
USE DataWarehouse;
GO

-- Create schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
