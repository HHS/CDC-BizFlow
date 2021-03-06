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

BEGIN
	FOR ATAB IN (SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER = 'HHS_HR') LOOP
		EXECUTE IMMEDIATE 'GRANT SELECT ON HHS_HR.'||ATAB.TABLE_NAME||' TO HHS_CDC_HR_RW_ROLE';
	END LOOP;
END;
/

BEGIN
	FOR ATAB IN (SELECT TABLE_NAME FROM ALL_TABLES WHERE OWNER = 'HHS_HR') LOOP
		EXECUTE IMMEDIATE 'GRANT SELECT ON HHS_HR.'||ATAB.TABLE_NAME||' TO HHS_CDC_HR_DEV_ROLE';
	END LOOP;
END;
/

GRANT SELECT ON HHS_HR.PAY_PLAN TO HHS_CDC_HR_RW_ROLE;
GRANT SELECT ON HHS_HR.PAY_PLAN TO HHS_CDC_HR_DEV_ROLE;

GRANT SELECT ON HHS_HR.OCCUPATIONAL_SERIES TO HHS_CDC_HR_RW_ROLE;
GRANT SELECT ON HHS_HR.OCCUPATIONAL_SERIES TO HHS_CDC_HR_DEV_ROLE;

GRANT SELECT ON HHS_HR.NATURE_OF_ACTION TO HHS_CDC_HR_RW_ROLE;
GRANT SELECT ON HHS_HR.NATURE_OF_ACTION TO HHS_CDC_HR_DEV_ROLE;

GRANT SELECT ON HHS_HR.LEGAL_AUTHORITY TO HHS_CDC_HR_RW_ROLE;
GRANT SELECT ON HHS_HR.LEGAL_AUTHORITY TO HHS_CDC_HR_DEV_ROLE;

GRANT SELECT ON HHS_HR.DUTY_STATION TO HHS_CDC_HR_RW_ROLE;
GRANT SELECT ON HHS_HR.DUTY_STATION TO HHS_CDC_HR_DEV_ROLE;

GRANT SELECT ON HHS_HR.CYBERSECURITY_CODE TO HHS_CDC_HR_RW_ROLE;
GRANT SELECT ON HHS_HR.CYBERSECURITY_CODE TO HHS_CDC_HR_DEV_ROLE;

GRANT SELECT ON HHS_HR.APPOINTMENT_TYPE TO HHS_CDC_HR_RW_ROLE;
GRANT SELECT ON HHS_HR.APPOINTMENT_TYPE TO HHS_CDC_HR_DEV_ROLE;

GRANT SELECT ON HHS_HR.ADMINISTRATIVE_CODE TO HHS_CDC_HR_RW_ROLE;
GRANT SELECT ON HHS_HR.ADMINISTRATIVE_CODE TO HHS_CDC_HR_DEV_ROLE;

GRANT SELECT ON HHS_HR.VW_EHRP_15_MIN TO HHS_CDC_HR_RW_ROLE;
GRANT SELECT ON HHS_HR.VW_EHRP_15_MIN TO HHS_CDC_HR_DEV_ROLE;

GRANT SELECT ON HHS_HR.PS_GVT_JOB TO HHS_CDC_HR_RW_ROLE;
GRANT SELECT ON HHS_HR.PS_GVT_JOB TO HHS_CDC_HR_DEV_ROLE;

GRANT SELECT ON HHS_HR.PS_GVT_PAR_REMARKS TO HHS_CDC_HR_RW_ROLE;
GRANT SELECT ON HHS_HR.PS_GVT_PAR_REMARKS TO HHS_CDC_HR_DEV_ROLE;

GRANT SELECT ON HHS_HR.EMPLOYEE_LOOKUP TO HHS_CDC_HR_RW_ROLE;
GRANT SELECT ON HHS_HR.EMPLOYEE_LOOKUP TO HHS_CDC_HR_DEV_ROLE;

/
