------------------------------------------------------------------------------------------
--  Name	            : 	2_grant_bizflow.sql
--	Author				:	Taeho Lee <thee@bizflow.com>
--	Copyright			:	BizFlow Corp.	
--	
--	Project				:	HHS CDC HR Workflow Solution - EWITS 2.0
--	Purpose				:	Grant permission to access workflow database tables. 
--	
--  Example
--  To use in SQL statements:
--
-- 	WHEN		WHO			WHAT		
-- 	-----------	--------	-------------------------------------------------------
-- 	04/13/2018	THLEE		Created
------------------------------------------------------------------------------------------


-- grant workflow table access to role
BEGIN
	FOR ATAB IN (SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER = 'BIZFLOW') LOOP
		EXECUTE IMMEDIATE 'GRANT ALL ON BIZFLOW.'||ATAB.TABLE_NAME||' TO BF_DEV_ROLE';
	END LOOP;
END;

-- privilege on BIZFLOW tables to be used in stored procedure of HHS_CDC_HR schema
-- NOTE: This cannot be granted through role and should be granted individually and directly to user
GRANT SELECT, INSERT, UPDATE, DELETE ON BIZFLOW.RLVNTDATA TO HHS_CDC_HR;
GRANT SELECT, INSERT, UPDATE, DELETE ON BIZFLOW.PROCDEF TO HHS_CDC_HR;
GRANT SELECT, INSERT, UPDATE, DELETE ON BIZFLOW.PROCS TO HHS_CDC_HR;
GRANT SELECT, INSERT, UPDATE, DELETE ON BIZFLOW.MEMBER TO HHS_CDC_HR WITH GRANT OPTION;

