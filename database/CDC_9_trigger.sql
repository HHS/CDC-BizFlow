--------------------------------------------------------
--  File created - Tuesday-September-11-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Trigger ERROR_LOG_BIR
--------------------------------------------------------
/*
  CREATE OR REPLACE TRIGGER "HHS_CDC_HR"."ERROR_LOG_BIR" 
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
--  DDL for Trigger TBL_FORM_DTL_AIUDR
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "HHS_CDC_HR"."TBL_FORM_DTL_AIUDR" 
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

  CREATE OR REPLACE TRIGGER "HHS_CDC_HR"."TBL_FORM_DTL_AUDIT_BIR" 
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
--  DDL for Trigger TBL_FORM_DTL_BIR
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "HHS_CDC_HR"."TBL_FORM_DTL_BIR" 
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
*/
