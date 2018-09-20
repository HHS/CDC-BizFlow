------------------------------------------------------------------------------------------
--  Name	            : 	1_create_schema.sql
--	Author				:	Taeho Lee <thee@bizflow.com>
--	Copyright			:	BizFlow Corp.	
--	
--	Project				:	HHS CDC HR Workflow Solution - EWITS 2.0
--	Purpose				:	Create database account, tablespace, 
--	
--  Example
--  To use in SQL statements:
--
-- 	WHEN		WHO			WHAT		
-- 	-----------	--------	-------------------------------------------------------
-- 	09/19/2018	THLEE		Created
------------------------------------------------------------------------------------------

--=============================================================================
-- Create CMSADMIN user for DBA for CDC project
-------------------------------------------------------------------------------

-- admin user
CREATE USER CDCADMIN IDENTIFIED BY <replace_with_password>;
GRANT CONNECT, RESOURCE, DBA TO CDCADMIN;

--=============================================================================
-- Create TABLESPACE, USER for CDC project
-------------------------------------------------------------------------------

-- Make sure the directory to store the datafile actually exists on the server where DBMS is installed.
CREATE TABLESPACE HHS_CDC_HR_TS DATAFILE '<replace_with_directory_path>/HHS_CDC_HR.DBF' SIZE 30M AUTOEXTEND ON NEXT 3M MAXSIZE UNLIMITED
;

-- application
CREATE USER HHS_CDC_HR IDENTIFIED BY <replace_with_password>
	DEFAULT TABLESPACE HHS_CDC_HR_TS
	QUOTA UNLIMITED ON HHS_CDC_HR_TS
;

-- developer user
CREATE USER CDCDEV IDENTIFIED BY <replace_with_password>
	DEFAULT TABLESPACE HHS_CDC_HR_TS
	QUOTA UNLIMITED ON HHS_CDC_HR_TS
;


----------------------------------------------------
-- Create role and grant privilege
----------------------------------------------------
CREATE ROLE HHS_CDC_HR_RW_ROLE;
CREATE ROLE HHS_CDC_HR_DEV_ROLE;
--CREATE ROLE BF_DEV_ROLE;

-- grant CDC role to CDC user
GRANT CONNECT, RESOURCE, HHS_CDC_HR_RW_ROLE TO HHS_CDC_HR;
GRANT CONNECT, RESOURCE, HHS_CDC_HR_DEV_ROLE TO CDCDEV;

-- grant CDC database privileges to CDC role
GRANT ALTER SESSION, CREATE CLUSTER, CREATE DATABASE LINK
	, CREATE SEQUENCE, CREATE SESSION, CREATE SYNONYM, CREATE TABLE, CREATE VIEW
	, CREATE PROCEDURE
	TO HHS_CDC_HR_RW_ROLE
;

-- grant CDC database privileges to CDC DEV role
GRANT ALTER SESSION, CREATE CLUSTER, CREATE DATABASE LINK
	, CREATE SEQUENCE, CREATE SESSION, CREATE SYNONYM, CREATE TABLE, CREATE VIEW
	, CREATE PROCEDURE
	TO HHS_CDC_HR_DEV_ROLE
;

-- grant workflow table access to role
/*
BEGIN
	FOR ATAB IN (SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER = 'BIZFLOW') LOOP
		EXECUTE IMMEDIATE 'GRANT ALL ON BIZFLOW.'||ATAB.TABLE_NAME||' TO BF_DEV_ROLE';
	END LOOP;
END;
*/

----------------------------------------------------
-- CROSS schema access
----------------------------------------------------

-- grant the CDC database access role to bizflow database user
GRANT HHS_CDC_HR_RW_ROLE TO BIZFLOW;


-- grant WORKFLOW database access role to HHS_CDC_HR database user
--GRANT BF_DEV_ROLE TO HHS_CDC_HR;


-- grant WORKFLOW database access role to CDCDEV database user
--GRANT BF_DEV_ROLE TO CDCDEV;
