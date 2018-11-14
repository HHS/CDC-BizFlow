------------------------------------------------------------------------------------------
--  Name	            : 	2_grant_bizflow.sql
--	Author				:	Taeho Lee <thee@bizflow.com>
--	
--	Project				:	HHS CDC HR Workflow Solution - EWITS 2.0
--	Purpose				:	Grant permission to access workflow database tables. 
--	
-- 	WHEN		WHO			WHAT		
-- 	-----------	--------	-------------------------------------------------------
-- 	11/14/2018	THLEE		Created
------------------------------------------------------------------------------------------

-- grant workflow table access to role
GRANT SELECT, INSERT, UPDATE, DELETE ON BIZFLOW.RLVNTDATA TO HHS_CDC_HR WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON BIZFLOW.PROCDEF TO HHS_CDC_HR WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON BIZFLOW.PROCS TO HHS_CDC_HR WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON BIZFLOW.ACT TO HHS_CDC_HR WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON BIZFLOW.WITEM TO HHS_CDC_HR WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON BIZFLOW.MEMBER TO HHS_CDC_HR WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON BIZFLOW.MEMBERINFO TO HHS_CDC_HR WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON BIZFLOW.USRGRPPRTCP TO HHS_CDC_HR WITH GRANT OPTION;
/

