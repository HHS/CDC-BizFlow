------------------------------------------------------------------------------------------
--  Name	            : 	4_view.sql
--	Author				:	Taeho Lee <thee@bizflow.com>
--	Copyright			:	BizFlow Corp.	
--	
--	Project				:	HHS CDC HR Workflow Solution - EWITS 2.0
--	Purpose				:	Create HHS_CDC_HR database views
--	
--  Example
--  To use in SQL statements:
--
-- 	WHEN		WHO			WHAT		
-- 	-----------	--------	-------------------------------------------------------
-- 	04/13/2018	THLEE		Created
------------------------------------------------------------------------------------------

--------------------------------------------------------
--  File created - Thursday-March-09-2017
--------------------------------------------------------
--DROP TABLE ADMIN_CODES;


--DROP SEQUENCE ADMIN_CODES_SEQ;


--------------------------------------------------------
--  DDL for Table TABLEA
--------------------------------------------------------
/*
CREATE TABLE APPROVALS
(
	SCA_REQ_ID NUMBER(20,0)
	, SCA_SO_SIG NVARCHAR2(100)
	, SCA_SO_SIG_DT DATE
	, SCA_CLASS_SPEC_SIG NVARCHAR2(100)
	, SCA_CLASS_SPEC_SIG_DT DATE
	, SCA_STAFF_SIG NVARCHAR2(100)
	, SCA_STAFF_SIG_DT DATE
)
;

COMMENT ON COLUMN APPROVALS.SCA_REQ_ID IS 'Primary key as well as foreign key to REQUEST table';
*/


--------------------------------------------------------
--  DDL for Sequence ADMIN_CODES_SEQ
--------------------------------------------------------
--
--CREATE SEQUENCE ADMIN_CODES_SEQ
--	INCREMENT BY 1
--	START WITH 1
--	NOMAXVALUE
--	NOCACHE
--	NOCYCLE ;
--/


--------------------------------------------------------
--  File created - Thursday-March-09-2017
--------------------------------------------------------
--DROP TABLE ADMIN_CODES;


--DROP SEQUENCE ADMIN_CODES_SEQ;


--------------------------------------------------------
--  DDL for Table TABLEA
--------------------------------------------------------
/*
CREATE TABLE APPROVALS
(
	SCA_REQ_ID NUMBER(20,0)
	, SCA_SO_SIG NVARCHAR2(100)
	, SCA_SO_SIG_DT DATE
	, SCA_CLASS_SPEC_SIG NVARCHAR2(100)
	, SCA_CLASS_SPEC_SIG_DT DATE
	, SCA_STAFF_SIG NVARCHAR2(100)
	, SCA_STAFF_SIG_DT DATE
)
;

COMMENT ON COLUMN APPROVALS.SCA_REQ_ID IS 'Primary key as well as foreign key to REQUEST table';
*/


--------------------------------------------------------
--  DDL for Sequence ADMIN_CODES_SEQ
--------------------------------------------------------
--
--CREATE SEQUENCE ADMIN_CODES_SEQ
--	INCREMENT BY 1
--	START WITH 1
--	NOMAXVALUE
--	NOCACHE
--	NOCYCLE ;
--/



--------------------------------------------------------
--  DDL for Trigger ADMIN_CODES_TRG
--------------------------------------------------------
--
--CREATE OR REPLACE TRIGGER ADMIN_CODES_TRG
--BEFORE INSERT ON ADMIN_CODES
--FOR EACH ROW
--BEGIN
--	IF INSERTING AND :NEW.AC_ID IS NULL THEN
--		SELECT ADMIN_CODES_SEQ.NEXTVAL INTO :NEW.AC_ID FROM DUAL;
--	END IF;
--END;
--
--/



--------------------------------------------------------
--  DDL for Trigger ADMIN_CODES_TRG
--------------------------------------------------------
--
--CREATE OR REPLACE TRIGGER ADMIN_CODES_TRG
--BEFORE INSERT ON ADMIN_CODES
--FOR EACH ROW
--BEGIN
--	IF INSERTING AND :NEW.AC_ID IS NULL THEN
--		SELECT ADMIN_CODES_SEQ.NEXTVAL INTO :NEW.AC_ID FROM DUAL;
--	END IF;
--END;
--
--/

--------------------------------------------------------
--  DDL for View ADMIN_CODES
--------------------------------------------------------

CREATE OR REPLACE FORCE VIEW HHS_CDC_HR.ADMIN_CODES
AS
SELECT
	ADMINISTRATIVE_CODE            AS AC_ADMIN_CD
	, DESCRIPTION                  AS AC_ADMIN_CD_DESCR
	, SUBSTR(ADMINISTRATIVE_CODE, 1, LENGTH(ADMINISTRATIVE_CODE) -1) AS AC_PARENT_CD
FROM
	HHS_CDC_HR.ADMINISTRATIVE_CODE
WHERE
	ADMINISTRATIVE_CODE = 'F' OR ADMINISTRATIVE_CODE LIKE 'FC%';

/

------------------------------------
--Backout Script
------------------------------------
/*
DROP VIEW HHS_CDC_HR.ADMIN_CODES;
*/


/
