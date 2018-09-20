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
-- 	09/20/2018	THLEE		Created
------------------------------------------------------------------------------------------


-- grant workflow table access to role

GRANT SELECT, INSERT, UPDATE, DELETE ON BIZFLOW.RLVNTDATA TO HHS_CDC_HR;
GRANT SELECT, INSERT, UPDATE, DELETE ON BIZFLOW.PROCDEF TO HHS_CDC_HR;
GRANT SELECT, INSERT, UPDATE, DELETE ON BIZFLOW.PROCS TO HHS_CDC_HR;
GRANT SELECT, INSERT, UPDATE, DELETE ON BIZFLOW.ACT TO HHS_CDC_HR;
GRANT SELECT, INSERT, UPDATE, DELETE ON BIZFLOW.WITEM TO HHS_CDC_HR;
GRANT SELECT, INSERT, UPDATE, DELETE ON BIZFLOW.MEMBER TO HHS_CDC_HR WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON BIZFLOW.USRGRPPRTCP TO HHS_CDC_HR WITH GRANT OPTION;

