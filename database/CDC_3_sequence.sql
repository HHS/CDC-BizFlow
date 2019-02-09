------------------------------------------------------------------------------------------
--  Name	            : 	CDC_3_sequence.sql
--	Author				:	Taeho Lee <thee@bizflow.com>
--	
--	Project				:	HHS CDC HR Workflow Solution - EWITS 2.0
--	Purpose				:	Creating database sequences in HHS_CDC_HR database schema
--	
--  Notes               :   
--
-- 	WHEN		WHO			WHAT		
-- 	-----------	--------	-------------------------------------------------------
-- 	11/14/2018	THLEE		Created
------------------------------------------------------------------------------------------

CREATE SEQUENCE  "HHS_CDC_HR"."CDC_FORM_DATA_SEQ"  MINVALUE 1 NOMAXVALUE NOCYCLE NOCACHE INCREMENT BY 1 START WITH 1 NOORDER;
CREATE SEQUENCE  "HHS_CDC_HR"."TBL_FORM_DTL_AUDIT_SEQ"  MINVALUE 1 NOMAXVALUE NOCYCLE NOCACHE INCREMENT BY 1 START WITH 1 NOORDER;
CREATE SEQUENCE  "HHS_CDC_HR"."ERROR_LOG_SEQ"  MINVALUE 1 NOMAXVALUE NOCYCLE NOCACHE INCREMENT BY 1 START WITH 1 NOORDER;

CREATE SEQUENCE  "HHS_CDC_HR"."ERA_LOG_CAPHR_JR_SEQ"  MINVALUE 1 NOMAXVALUE NOCYCLE NOCACHE INCREMENT BY 1 START WITH 1 NOORDER;
CREATE SEQUENCE  "HHS_CDC_HR"."ERA_LOG_CAPHR_PAR_SEQ"  MINVALUE 1 NOMAXVALUE NOCYCLE NOCACHE INCREMENT BY 1 START WITH 1 NOORDER;

/  


