------------------------------------------------------------------------------------------
--  Name	            : 	CDC_2_grant_hhs_hr.sql
--	Author				:	Taeho Lee <thee@bizflow.com>
--	
--	Project				:	HHS CDC HR Workflow Solution - EWITS 2.0
--	Purpose				:	Grant permission to access hhs_hr database tables. 
--	
--  Notes               :   Run this query as DBA who having access permission to BIZFLOW, HHS_HR, and HHS_CDC_HR schema or Run this query on HHR_HR schema.
--
-- 	WHEN		WHO			WHAT		
-- 	-----------	--------	-------------------------------------------------------
-- 	11/14/2018	THLEE		Created
------------------------------------------------------------------------------------------

--set serveroutput on;

BEGIN
	FOR ATAB IN (SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER = 'HHS_HR' ORDER BY TABLE_NAME ) LOOP
        --DBMS_OUTPUT.PUT_LINE('GRANT SELECT ON HHS_HR.'||ATAB.TABLE_NAME||' TO HHS_CDC_HR_RW_ROLE');
		EXECUTE IMMEDIATE 'GRANT SELECT ON HHS_HR.'||ATAB.TABLE_NAME||' TO HHS_CDC_HR_RW_ROLE';
	END LOOP;
END;
/

BEGIN
	FOR ATAB IN (SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER = 'HHS_HR') LOOP
        --DBMS_OUTPUT.PUT_LINE('GRANT SELECT ON HHS_HR.'||ATAB.TABLE_NAME||' TO HHS_CDC_HR_DEV_ROLE');
		EXECUTE IMMEDIATE 'GRANT SELECT ON HHS_HR.'||ATAB.TABLE_NAME||' TO HHS_CDC_HR_DEV_ROLE';
	END LOOP;
END;
/
