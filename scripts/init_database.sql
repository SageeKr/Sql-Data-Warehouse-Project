/*
=============================================================
Database Creation and Schema Setup
=============================================================

Purpose:
    - Creates a new database named 'DataWarehouse'.
    - Drops the database first if it already exists.
    - Defines three schemas: 'bronze', 'silver', and 'gold'.

Caution:
    - This script **permanently deletes** the existing 'DataWarehouse' database.
    - Ensure you have a **backup** before running this script.
*/
USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO