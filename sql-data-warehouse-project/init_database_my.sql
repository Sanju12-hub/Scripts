--- Creating data bases and schemas ---
/* 
purpose - Creating DB after checking if it already exists, if exists, drops and recreates and set up thre schemas within the database

Warning - Running this script will drop the entire database 'DataWarehouse'. all the data in the DB will be permanently deleted. procede with caution and ensure you have proper backups.
*/

use master;
---
if exists (select 1 from sys.databases where name = 'DataWarehouse')
begin
alter database DataWarehouse set SINGLE_USER with rollback immediate;
drop database DataWarehouse;
end;
go
--- Creating the database ---
create database DataWarehouse;
use DataWarehouse;
go

--- Create Schema ---

create schema Bronze;
go

create schema Silver;
go

create schema Gold;
alter schema Gold transfer Gols;
go

drop Schema Gols
