------------------------------------------------------------------------------------------
--  Name	            : 	CDC_4_core_tables.sql
--	Author				:	Taeho Lee <thee@bizflow.com>
--	
--	Project				:	HHS CDC HR Workflow Solution - EWITS 2.0
--	Purpose				:	Creating core tables in HHS_CDC_HR database schema
--	
--  Notes               :   Run on HHS_CDC_HR schema
--
-- 	WHEN		WHO			WHAT		
-- 	-----------	--------	-------------------------------------------------------
-- 	11/14/2018	THLEE		Created
------------------------------------------------------------------------------------------

--------------------------------------------------------
--  DDL for Table ERA_LOG_CAPHR_JR
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."ERA_LOG_CAPHR_JR" 
   (	"ID" NUMBER(*,0) NOT NULL, 
	"JOB_OPENING_ID" VARCHAR2(200 BYTE), 
	"PROCID" NUMBER(*,0), 
	"ERA_STATUS" VARCHAR2(100 BYTE), 
	"DSCRPTN" VARCHAR2(4000 BYTE), 
	"CREATIONDTIME" TIMESTAMP (6)
   );
   
--------------------------------------------------------
--  DDL for Table ERA_LOG_CAPHR_LAST_RUN
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."ERA_LOG_CAPHR_LAST_RUN" 
   (	"ERA_SVC_TYPE" VARCHAR2(100 BYTE)  NOT NULL, 
	"LAST_RUN_DTIME" TIMESTAMP (6)
   );
   
--------------------------------------------------------
--  DDL for Table ERA_LOG_CAPHR_PAR
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."ERA_LOG_CAPHR_PAR" 
   (	"ID" NUMBER(*,0)  NOT NULL, 
	"EMPLID" VARCHAR2(100 BYTE), 
	"ADMIN_CODE" VARCHAR2(100 BYTE), 
	"PAR_ACTION" VARCHAR2(100 BYTE), 
	"PAR_ACTION_REASON" VARCHAR2(100 BYTE), 
	"PAR_STATUS" VARCHAR2(100 BYTE), 
	"GVT_EFFDT" DATE, 
	"GVT_EFFDT_PROPOSED_DT" DATE, 
	"PROCID" NUMBER(*,0), 
	"ERA_STATUS" VARCHAR2(100 BYTE), 
	"DSCRPTN" VARCHAR2(4000 BYTE), 
	"CREATIONDTIME" TIMESTAMP (6)
   );
   
--------------------------------------------------------
--  DDL for Table ERROR_LOG
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."ERROR_LOG" 
   (	"ID" NUMBER(*,0) NOT NULL, 
	"ERROR_CD" NUMBER(*,0), 
	"ERROR_MSG" VARCHAR2(4000 BYTE), 
	"BACKTRACE" CLOB, 
	"CALLSTACK" CLOB, 
	"CRT_DT" DATE, 
	"CRT_USR" VARCHAR2(50 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table TBL_FORM_DTL
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."TBL_FORM_DTL" 
   (	"ID" NUMBER(20,0) NOT NULL, 
	"PROCID" NUMBER(10,0), 
	"ACTSEQ" NUMBER(10,0), 
	"WITEMSEQ" NUMBER(10,0), 
	"FORM_TYPE" VARCHAR2(50 BYTE), 
	"FIELD_DATA" "XMLTYPE", 
	"CRT_DT" TIMESTAMP (6), 
	"CRT_USR" VARCHAR2(50 BYTE), 
	"MOD_DT" TIMESTAMP (6), 
	"MOD_USR" VARCHAR2(50 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table TBL_FORM_DTL_AUDIT
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."TBL_FORM_DTL_AUDIT" 
   (	"ID" NUMBER(20,0) NOT NULL, 
	"AUDITID" NUMBER(20,0) NOT NULL, 
	"PROCID" NUMBER(10,0), 
	"ACTSEQ" NUMBER(10,0), 
	"WITEMSEQ" NUMBER(10,0), 
	"FORM_TYPE" VARCHAR2(50 BYTE), 
	"FIELD_DATA" "XMLTYPE", 
	"CRT_DT" TIMESTAMP (6), 
	"CRT_USR" VARCHAR2(50 BYTE), 
	"MOD_DT" TIMESTAMP (6), 
	"MOD_USR" VARCHAR2(50 BYTE), 
	"AUDIT_ACTION" VARCHAR2(50 BYTE), 
	"AUDIT_TS" TIMESTAMP (6)
   );
   
--------------------------------------------------------
--  DDL for Table TBL_LOOKUP
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."TBL_LOOKUP" 
   (	"TBL_ID" NUMBER(*,0) NOT NULL, 
	"TBL_PARENT_ID" NUMBER(*,0), 
	"TBL_LTYPE" NVARCHAR2(50), 
	"TBL_NAME" NVARCHAR2(100), 
	"TBL_LABEL" NVARCHAR2(1000), 
	"TBL_ACTIVE" CHAR(1 BYTE), 
	"TBL_DISP_ORDER" NUMBER(*,0), 
	"TBL_MANDATORY" NVARCHAR2(10), 
	"TBL_REGION" NVARCHAR2(50), 
	"TBL_CATEGORY" NVARCHAR2(50), 
	"TBL_EFFECTIVE_DT" DATE, 
	"TBL_EXPIRATION_DT" DATE
   );
   
--------------------------------------------------------
--  DDL for Index ERA_LOG_CAPHR_JR_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."ERA_LOG_CAPHR_JR_PK" ON "HHS_CDC_HR"."ERA_LOG_CAPHR_JR" ("ID");
  
--------------------------------------------------------
--  DDL for Index ERA_LOG_CAPHR_JR_NK1
--------------------------------------------------------

  CREATE INDEX "HHS_CDC_HR"."ERA_LOG_CAPHR_JR_NK1" ON "HHS_CDC_HR"."ERA_LOG_CAPHR_JR" ("JOB_OPENING_ID");
  
--------------------------------------------------------
--  DDL for Index ERA_LOG_CAPHR_JR_NK2
--------------------------------------------------------

  CREATE INDEX "HHS_CDC_HR"."ERA_LOG_CAPHR_JR_NK2" ON "HHS_CDC_HR"."ERA_LOG_CAPHR_JR" ("PROCID");
  
--------------------------------------------------------
--  DDL for Index ERA_LOG_CAPHR_LAST_RUN_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."ERA_LOG_CAPHR_LAST_RUN_PK" ON "HHS_CDC_HR"."ERA_LOG_CAPHR_LAST_RUN" ("ERA_SVC_TYPE");
  
--------------------------------------------------------
--  DDL for Index ERA_LOG_CAPHR_PAR_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."ERA_LOG_CAPHR_PAR_PK" ON "HHS_CDC_HR"."ERA_LOG_CAPHR_PAR" ("ID");
  
--------------------------------------------------------
--  DDL for Index ERA_LOG_CAPHR_PAR_NK1
--------------------------------------------------------

  CREATE INDEX "HHS_CDC_HR"."ERA_LOG_CAPHR_PAR_NK1" ON "HHS_CDC_HR"."ERA_LOG_CAPHR_PAR" ("EMPLID", "ADMIN_CODE", "PAR_ACTION", "PAR_ACTION_REASON", "PAR_STATUS", "GVT_EFFDT", "GVT_EFFDT_PROPOSED_DT");
  
--------------------------------------------------------
--  DDL for Index XPKERROR_LOG
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKERROR_LOG" ON "HHS_CDC_HR"."ERROR_LOG" ("ID");
  
--------------------------------------------------------
--  DDL for Index XPKTBL_FORM_DTL
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKTBL_FORM_DTL" ON "HHS_CDC_HR"."TBL_FORM_DTL" ("ID");
  
--------------------------------------------------------
--  DDL for Index XPKTBL_FORM_DTL_AUDIT
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKTBL_FORM_DTL_AUDIT" ON "HHS_CDC_HR"."TBL_FORM_DTL_AUDIT" ("ID", "AUDITID");
  
--------------------------------------------------------
--  DDL for Index XPKLOOKUP_TABLE
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKLOOKUP_TABLE" ON "HHS_CDC_HR"."TBL_LOOKUP" ("TBL_ID") ;
  
--------------------------------------------------------
--  DDL for stored procedure used one of triger below
--------------------------------------------------------  
  create or replace PROCEDURE "HHS_CDC_HR"."SP_ERROR_LOG" 
IS
	PRAGMA AUTONOMOUS_TRANSACTION;
	V_CODE      PLS_INTEGER := SQLCODE;
	V_MSG       VARCHAR2(32767) := SQLERRM;
BEGIN
	INSERT INTO ERROR_LOG
	(
		ERROR_CD
		, ERROR_MSG
		, BACKTRACE
		, CALLSTACK
		, CRT_DT
		, CRT_USR
	)
	VALUES (
		V_CODE
		, V_MSG
		, SYS.DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
		, SYS.DBMS_UTILITY.FORMAT_CALL_STACK
		, SYSDATE
		, USER
	);

	COMMIT;
END;


--------------------------------------------------------
--  DDL for Trigger ERA_LOG_CAPHR_JR_BIR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HHS_CDC_HR"."ERA_LOG_CAPHR_JR_BIR" 
BEFORE INSERT ON HHS_CDC_HR.ERA_LOG_CAPHR_JR
FOR EACH ROW
BEGIN
	SELECT ERA_LOG_CAPHR_JR_SEQ.NEXTVAL
	INTO :NEW.ID
	FROM DUAL;
END;

/
ALTER TRIGGER "HHS_CDC_HR"."ERA_LOG_CAPHR_JR_BIR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger ERA_LOG_CAPHR_PAR_BIR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HHS_CDC_HR"."ERA_LOG_CAPHR_PAR_BIR" 
BEFORE INSERT ON HHS_CDC_HR.ERA_LOG_CAPHR_PAR
FOR EACH ROW
BEGIN
	SELECT ERA_LOG_CAPHR_PAR_SEQ.NEXTVAL
	INTO :NEW.ID
	FROM DUAL;
END;

/
ALTER TRIGGER "HHS_CDC_HR"."ERA_LOG_CAPHR_PAR_BIR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger ERROR_LOG_BIR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HHS_CDC_HR"."ERROR_LOG_BIR" 
BEFORE INSERT ON ERROR_LOG
FOR EACH ROW
BEGIN
	SELECT ERROR_LOG_SEQ.NEXTVAL
	INTO :NEW.ID
	FROM DUAL;
END;

/
ALTER TRIGGER "HHS_CDC_HR"."ERROR_LOG_BIR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TBL_FORM_DTL_BIR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HHS_CDC_HR"."TBL_FORM_DTL_BIR" 
BEFORE INSERT ON TBL_FORM_DTL
FOR EACH ROW
BEGIN
	SELECT CDC_FORM_DATA_SEQ.NEXTVAL
	INTO :NEW.ID
	FROM DUAL
	;
END
;

/
ALTER TRIGGER "HHS_CDC_HR"."TBL_FORM_DTL_BIR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TBL_FORM_DTL_AIUDR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HHS_CDC_HR"."TBL_FORM_DTL_AIUDR" 
AFTER INSERT OR UPDATE OR DELETE ON TBL_FORM_DTL
FOR EACH ROW
DECLARE
	V_TRG_ACTION VARCHAR2(50);
BEGIN
	CASE
		WHEN INSERTING THEN
			V_TRG_ACTION := 'INSERTING';
			INSERT INTO TBL_FORM_DTL_AUDIT
			(
				ID
				, PROCID
				, ACTSEQ
				, WITEMSEQ
				, FORM_TYPE
				, FIELD_DATA
				, CRT_DT
				, CRT_USR
				, MOD_DT
				, MOD_USR
				, AUDIT_ACTION
				, AUDIT_TS
			)
			VALUES
			(
				:NEW.ID
				, :NEW.PROCID
				, :NEW.ACTSEQ
				, :NEW.WITEMSEQ
				, :NEW.FORM_TYPE
				, :NEW.FIELD_DATA
				, :NEW.CRT_DT
				, :NEW.CRT_USR
				, :NEW.MOD_DT
				, :NEW.MOD_USR
				, V_TRG_ACTION
				, SYSTIMESTAMP
			);
		WHEN UPDATING THEN
			V_TRG_ACTION := 'UPDATING';
			INSERT INTO TBL_FORM_DTL_AUDIT
			(
				ID
				, PROCID
				, ACTSEQ
				, WITEMSEQ
				, FORM_TYPE
				, FIELD_DATA
				, CRT_DT
				, CRT_USR
				, MOD_DT
				, MOD_USR
				, AUDIT_ACTION
				, AUDIT_TS
			)
			VALUES
			(
				:NEW.ID
				, :NEW.PROCID
				, :NEW.ACTSEQ
				, :NEW.WITEMSEQ
				, :NEW.FORM_TYPE
				, :NEW.FIELD_DATA
				, :NEW.CRT_DT
				, :NEW.CRT_USR
				, :NEW.MOD_DT
				, :NEW.MOD_USR
				, V_TRG_ACTION
				, SYSTIMESTAMP
			);
		WHEN DELETING THEN
			V_TRG_ACTION := 'DELETING';
			INSERT INTO TBL_FORM_DTL_AUDIT
			(
				ID
				, PROCID
				, ACTSEQ
				, WITEMSEQ
				, FORM_TYPE
				, FIELD_DATA
				, CRT_DT
				, CRT_USR
				, MOD_DT
				, MOD_USR
				, AUDIT_ACTION
				, AUDIT_TS
			)
			VALUES
			(
				:OLD.ID
				, :OLD.PROCID
				, :OLD.ACTSEQ
				, :OLD.WITEMSEQ
				, :OLD.FORM_TYPE
				, :OLD.FIELD_DATA
				, :OLD.CRT_DT
				, :OLD.CRT_USR
				, :OLD.MOD_DT
				, :OLD.MOD_USR
				, V_TRG_ACTION
				, SYSTIMESTAMP
			);
		ELSE V_TRG_ACTION := NULL;
	END CASE;

EXCEPTION
	WHEN OTHERS THEN
		SP_ERROR_LOG();

END;

/
ALTER TRIGGER "HHS_CDC_HR"."TBL_FORM_DTL_AIUDR" ENABLE;
--------------------------------------------------------
--  DDL for Trigger TBL_FORM_DTL_AUDIT_BIR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "HHS_CDC_HR"."TBL_FORM_DTL_AUDIT_BIR" 
BEFORE INSERT ON TBL_FORM_DTL_AUDIT
FOR EACH ROW
BEGIN
	SELECT TBL_FORM_DTL_AUDIT_SEQ.NEXTVAL
	INTO :NEW.AUDITID
	FROM DUAL;
END;

/
ALTER TRIGGER "HHS_CDC_HR"."TBL_FORM_DTL_AUDIT_BIR" ENABLE;

--------------------------------------------------------
--  Constraints for Table ERA_LOG_CAPHR_JR
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."ERA_LOG_CAPHR_JR" ADD CONSTRAINT "ERA_LOG_CAPHR_JR_PK" PRIMARY KEY ("ID");

--------------------------------------------------------
--  Constraints for Table ERA_LOG_CAPHR_LAST_RUN
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."ERA_LOG_CAPHR_LAST_RUN" ADD CONSTRAINT "ERA_LOG_CAPHR_LAST_RUN_PK" PRIMARY KEY ("ERA_SVC_TYPE");
  
--------------------------------------------------------
--  Constraints for Table ERA_LOG_CAPHR_PAR
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."ERA_LOG_CAPHR_PAR" ADD CONSTRAINT "ERA_LOG_CAPHR_PAR_PK" PRIMARY KEY ("ID");
  
--------------------------------------------------------
--  Constraints for Table ERROR_LOG
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."ERROR_LOG" ADD CONSTRAINT "XPKERROR_LOG" PRIMARY KEY ("ID");

--------------------------------------------------------
--  Constraints for Table TBL_FORM_DTL
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."TBL_FORM_DTL" ADD CONSTRAINT "XPKTBL_FORM_DTL" PRIMARY KEY ("ID");
  
--------------------------------------------------------
--  Constraints for Table TBL_FORM_DTL_AUDIT
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."TBL_FORM_DTL_AUDIT" ADD CONSTRAINT "XPKTBL_FORM_DTL_AUDIT" PRIMARY KEY ("ID", "AUDITID");

--------------------------------------------------------
--  Constraints for Table TBL_LOOKUP
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."TBL_LOOKUP" ADD CONSTRAINT "XPKLOOKUP_TABLE" PRIMARY KEY ("TBL_ID");

