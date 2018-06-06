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
-- 	04/13/2018	THLEE		Created
------------------------------------------------------------------------------------------

----------------------------------------------------
-- DBA statment to inspect deadlock and resolve
----------------------------------------------------
--SELECT s.sid, s.serial#, s.status, p.spid
--FROM v$session s, v$process p
--WHERE s.username = 'CDC'
--	AND p.addr(+) = s.paddr
--;
--ALTER SYSTEM KILL SESSION '22, 7157';


-------------------------------------------------------------------------------
-- DBA statement to change default profile to lift password expiration
-------------------------------------------------------------------------------
--SELECT * FROM DBA_USERS;
--SELECT * FROM DBA_PROFILES WHERE PROFILE='DEFAULT';
--ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;


----------------------------------------------------
-- DBA statement to reset password 
----------------------------------------------------
-- ALTER USER CDCADMIN IDENTIFIED BY <replace_with_password>;
-- ALTER USER HHS_CDC_HR IDENTIFIED BY <replace_with_password>;


----------------------------------------------------
-- backout statement
----------------------------------------------------
--DROP USER CDCADMIN CASCADE;
--DROP TABLESPACE HHS_CDC_HR_TS;
--DROP USER HHS_CDC_HR CASCADE;
--DROP USER CDCDEV CASCADE;
--DROP ROLE HHS_CDC_HR_RW_ROLE;
--DROP ROLE HHS_CDC_HR_DEV_ROLE;
--DROP ROLE BF_DEV_ROLE;


----------------------------------------------------
-- Create CDCADMIN user for DBA for CDC project
----------------------------------------------------

-- admin user
CREATE USER CDCADMIN IDENTIFIED BY <replace_with_password>;
GRANT CONNECT, RESOURCE, DBA TO CDCADMIN;


----------------------------------------------------
-- Create TABLESPACE, USER for CDC project
----------------------------------------------------

-- Make sure the directory to store the datafile actually exists on the server where DBMS is installed.
CREATE TABLESPACE HHS_CDC_HR_TS DATAFILE 'C:\bizflowdb\HHS_CDC_HR.DBF' SIZE 30M AUTOEXTEND ON NEXT 3M MAXSIZE UNLIMITED
;


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
CREATE ROLE BF_DEV_ROLE;

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


----------------------------------------------------
-- CROSS schema access
----------------------------------------------------

-- grant the CDC database access role to bizflow database user
GRANT HHS_CDC_HR_RW_ROLE TO BIZFLOW;


-- grant WORKFLOW database access role to HHS_CDC_HR database user
GRANT BF_DEV_ROLE TO HHS_CDC_HR;


-- grant WORKFLOW database access role to CDCDEV database user
GRANT BF_DEV_ROLE TO CDCDEV;
