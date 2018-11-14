
CREATE TABLE TRIAGE
(
    CASE_ID              NUMBER(10) NOT NULL ,
    STAFFING_NEED_TP     VARCHAR2(200) NULL ,
    HR_ACTION_TP         VARCHAR2(200) NULL ,
    JOB_REQ_NO           VARCHAR2(200) NULL ,
    EMP_ID               VARCHAR2(200) NULL ,
    EMP_NM               VARCHAR2(200) NULL ,
    PAR_ACTION           VARCHAR2(200) NULL ,
    HIRING_METHOD        VARCHAR2(20) NULL ,
    PAR_ACTION_TP        VARCHAR2(200) NULL ,
    PROPOSED_EFF_DT      VARCHAR2(20) NULL ,
    ADMIN_CD             VARCHAR2(20) NULL ,
    ORG_NM               VARCHAR2(200) NULL ,
    CAN                  VARCHAR2(200) NULL ,
    SO_NM                VARCHAR2(100) NULL ,
    SO_EMAIL             VARCHAR2(100) NULL ,
    CIO_ADMN_NM          VARCHAR2(100) NULL ,
    CIO_ADMN_EMAIL       VARCHAR2(100) NULL ,
    HRO_SPC_NM           VARCHAR2(100) NULL ,
    HRO_SPC_EMAIL        VARCHAR2(100) NULL ,
    CLA_SPC_NM           VARCHAR2(100) NULL ,
    CLA_SPC_EMAIL        VARCHAR2(100) NULL ,
    NOAC                 VARCHAR2(200) NULL ,
    FIRST_AUTH           VARCHAR2(100) NULL ,
    SECOND_AUTH          VARCHAR2(100) NULL ,
    IS_PRECONSULT_RQRD   VARCHAR2(100) NULL ,
    MEETING_DT           VARCHAR2(20) NULL ,
    REMAKRS              VARCHAR2(4000) NULL 
);



CREATE UNIQUE INDEX XPKTriage ON TRIAGE
    (CASE_ID   ASC);


ALTER TABLE TRIAGE
    ADD CONSTRAINT  XPKTriage PRIMARY KEY (CASE_ID);
    

GRANT SELECT, INSERT, UPDATE, DELETE ON HHS_CDC_HR.TRIAGE TO HHS_CDC_HR_DEV_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON HHS_CDC_HR.TRIAGE TO HHS_CDC_HR_RW_ROLE;
/

create or replace PROCEDURE "SP_UPDATE_TRIAGE_TBLS" 
(
  I_PROCID IN NUMBER 
) 
    ------------------------------------------------------------------------------------------
    --  Procedure name	    : 	SP_UPDATE_TRIAGE_TBLS
    --	Author				:	Taeho Lee <thee@bizflow.com>
    --	Copyright			:	BizFlow Corp.	
    --	
    --	Project				:	HHS CDC HR Workflow Solution - EWITS 2.0
    --	Purpose				:	Insert/Update Triage tables with XML document in TBL_FORM_DTL.FIELD_DATA
    --	
    --  Example
    --  To use in SQL statements:
    --
    -- 	WHEN		WHO			WHAT		
    -- 	-----------	--------	-------------------------------------------------------
    -- 	11/13/2018	THLEE		Created
    -- 	-----------	--------	-------------------------------------------------------
IS
-------- COMMON
    V_RECCNT                            INTEGER;

-------- FORM DATA
    V_FD_ID                             NUMBER(20);
    V_FD_PROCID	                        NUMBER(10);
    V_FD_ACTSEQ                         NUMBER(10);
    V_FD_WITEMSEQ                       NUMBER(10);
    V_FD_FORM_TYPE                      VARCHAR2(50);
    V_FD_FIELD_DATA	                    XMLTYPE;
    V_FD_CRT_DT	                        TIMESTAMP;
    V_FD_CRT_USR                        VARCHAR2(50);
    V_FD_MOD_DT	                        TIMESTAMP;
    V_FD_MOD_USR	                    VARCHAR2(50);
-------- HR_CASE
    V_CASE_ID                           NUMBER(10);
    V_CASE_CREATOR_NM                   VARCHAR(100);
    V_CASE_CREATION_DT                  TIMESTAMP;
BEGIN

    --DBMS_OUTPUT.PUT_LINE('I_PROCID=' || I_PROCID); 
    SELECT "ID",
           PROCID,
           ACTSEQ,
           WITEMSEQ,
           FORM_TYPE,
           FIELD_DATA,
           CRT_DT,
           CRT_USR,
           MOD_DT,
           MOD_USR
      INTO V_FD_ID,
           V_FD_PROCID,
           V_FD_ACTSEQ,
           V_FD_WITEMSEQ,
           V_FD_FORM_TYPE,
           V_FD_FIELD_DATA,
           V_FD_CRT_DT,
           V_FD_CRT_USR,
           V_FD_MOD_DT,
           V_FD_MOD_USR    
      FROM HHS_CDC_HR.TBL_FORM_DTL
     WHERE PROCID = I_PROCID;

    ---------- HR_CASE TABLE
    V_RECCNT := 0;
    SELECT COUNT(1)
      INTO V_RECCNT
      FROM HHS_CDC_HR.HR_CASE
     WHERE CASE_ID = I_PROCID;

    IF V_RECCNT = 0 THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT INTO HHS_CDC_HR.HR_CASE');
        INSERT INTO HHS_CDC_HR.HR_CASE 
        (
            CASE_ID
            ,CASE_TP
            ,CREATOR_NM
            ,CREATION_DT
        )
        VALUES 
        (
            I_PROCID
            ,'CLASSIFICATION'
            ,V_FD_CRT_USR
            ,V_FD_CRT_DT
        );

    ELSE
        UPDATE HHS_CDC_HR.HR_CASE
           SET CASE_TP = 'CLASSIFICATION'
               ,MODIFIER_NM = V_FD_MOD_USR
               ,MODIFICATION_DT = V_FD_MOD_DT
         WHERE CASE_ID = I_PROCID;
    END IF;

END SP_UPDATE_TRIAGE_TBLS;

GRANT EXECUTE ON HHS_CDC_HR.SP_UPDATE_TRIAGE_TBLS TO HHS_CDC_HR_RW_ROLE;
GRANT EXECUTE ON HHS_CDC_HR.SP_UPDATE_TRIAGE_TBLS TO HHS_CDC_HR_DEV_ROLE;
/

create or replace PROCEDURE  HHS_CDC_HR.SP_UPDATE_FORM_DATA
(
	IO_ID               IN OUT  NUMBER
	, I_FORM_TYPE       IN      VARCHAR2
	, I_FIELD_DATA      IN      CLOB
	, I_USER            IN      VARCHAR2
	, I_PROCID          IN      NUMBER
	, I_ACTSEQ          IN      NUMBER
	, I_WITEMSEQ        IN      NUMBER
)
IS
	V_ID NUMBER(20);
	V_FORM_TYPE VARCHAR2(50);
	V_USER VARCHAR2(50);
	V_PROCID NUMBER(10);
	V_ACTSEQ NUMBER(10);
	V_WITEMSEQ NUMBER(10);
	V_REC_CNT NUMBER(10);
	V_MAX_ID NUMBER(20);
	V_XMLDOC XMLTYPE;
BEGIN

    --dbms_output.enable(null);

	V_XMLDOC := XMLTYPE(I_FIELD_DATA);

	IF IO_ID IS NOT NULL AND IO_ID > 0 THEN
		V_ID := IO_ID;
	ELSE

		--DBMS_OUTPUT.PUT_LINE('Attempt to find record using PROCID: ' || TO_CHAR(I_PROCID));
		-- if existing record is found using procid, use that id
		IF I_PROCID IS NOT NULL AND I_PROCID > 0 THEN
			BEGIN
				SELECT ID INTO V_ID FROM TBL_FORM_DTL WHERE PROCID = I_PROCID;
			EXCEPTION
				WHEN NO_DATA_FOUND THEN
					V_ID := -1;
			END;
		END IF;

		--DBMS_OUTPUT.PUT_LINE('No record found for PROCID: ' || TO_CHAR(I_PROCID));

		IO_ID := V_ID;
	END IF;

	--DBMS_OUTPUT.PUT_LINE('ID to be used is determined: ' || TO_CHAR(V_ID));

	IF I_PROCID IS NOT NULL AND I_PROCID > 0 THEN
		V_PROCID := I_PROCID;
	ELSE
		V_PROCID := 0;
	END IF;

	IF I_ACTSEQ IS NOT NULL AND I_ACTSEQ > 0 THEN
		V_ACTSEQ := I_ACTSEQ;
	ELSE
		V_ACTSEQ := 0;
	END IF;

	IF I_WITEMSEQ IS NOT NULL AND I_WITEMSEQ > 0 THEN
		V_WITEMSEQ := I_WITEMSEQ;
	ELSE
		V_WITEMSEQ := 0;
	END IF;

	BEGIN
		SELECT COUNT(*) INTO V_REC_CNT FROM TBL_FORM_DTL WHERE ID = V_ID;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			V_REC_CNT := -1;
	END;

	V_FORM_TYPE := I_FORM_TYPE;
	V_USER := I_USER;

	--DBMS_OUTPUT.PUT_LINE('Inspected existence of same record.');
	--DBMS_OUTPUT.PUT_LINE('    V_ID       = ' || TO_CHAR(V_ID));
	--DBMS_OUTPUT.PUT_LINE('    V_PROCID   = ' || TO_CHAR(V_PROCID));
	--DBMS_OUTPUT.PUT_LINE('    V_ACTSEQ   = ' || TO_CHAR(V_ACTSEQ));
	--DBMS_OUTPUT.PUT_LINE('    V_WITEMSEQ = ' || TO_CHAR(V_WITEMSEQ));
	--DBMS_OUTPUT.PUT_LINE('    V_REC_CNT  = ' || TO_CHAR(V_REC_CNT));

/*
	-- Strategic Consultation specific xml data manipulation before insert/update
	IF V_FORM_TYPE = 'CMSSTRATCON' THEN
		SP_UPDATE_STRATCON_DATA( V_XMLDOC );
	END IF;
*/
	IF V_REC_CNT > 0 THEN
		--DBMS_OUTPUT.PUT_LINE('Record found so that field data will be updated on the same record.');

		UPDATE TBL_FORM_DTL
		SET
			PROCID = V_PROCID
			, ACTSEQ = V_ACTSEQ
			, WITEMSEQ = V_WITEMSEQ
            , FORM_TYPE = V_FORM_TYPE
			, FIELD_DATA = V_XMLDOC
			, MOD_DT = SYSDATE
			, MOD_USR = V_USER
		WHERE ID = V_ID
		;

	ELSE
		--DBMS_OUTPUT.PUT_LINE('No record found so that new record will be inserted.');

		INSERT INTO TBL_FORM_DTL
		(
--			ID
--			, PROCID
			PROCID
			, ACTSEQ
			, WITEMSEQ
			, FORM_TYPE
			, FIELD_DATA
			, CRT_DT
			, CRT_USR
		)
		VALUES
		(
--			V_ID
--			, V_PROCID
			V_PROCID
			, V_ACTSEQ
			, V_WITEMSEQ
			, V_FORM_TYPE
			, V_XMLDOC
			, SYSDATE
			, V_USER
		)
		;
	END IF;

	-- Update process variable and transition xml into individual tables
	-- for respective process definition
	IF UPPER(V_FORM_TYPE) = 'TRIAGE' THEN
        --DBMS_OUTPUT.PUT_LINE('SP_UPDATE_TRIAGE_TBLS V_PROCID=' || V_PROCID);
        HHS_CDC_HR.SP_UPDATE_TRIAGE_TBLS(V_PROCID);       
    ELSIF UPPER(V_FORM_TYPE) = 'RECRUITMENT' THEN
        --DBMS_OUTPUT.PUT_LINE('SP_UPDATE_RECRUITMENT_TBLS V_PROCID=' || V_PROCID);
        HHS_CDC_HR.SP_UPDATE_RECRUITMENT_TBLS(V_PROCID);    
    -- HHS_MAIN is a temporary name of Classification, it will need to be changed to Classification once the CLA_Main WebMaker's broken application map is fixed.
	ELSIF UPPER(V_FORM_TYPE) = 'CLASSIFICATION' or UPPER(V_FORM_TYPE) = 'HHS_MAIN' THEN
        --DBMS_OUTPUT.PUT_LINE('SP_UPDATE_CLASSIFICATION_TBLS V_PROCID=' || V_PROCID);
        HHS_CDC_HR.SP_UPDATE_CLASSIFICATION_TBLS(V_PROCID);        
	ELSIF UPPER(V_FORM_TYPE) = 'APPOINTMENT' THEN
		--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_APPOINTMENT_TBLS V_PROCID=' || V_PROCID);
        HHS_CDC_HR.SP_UPDATE_APPOINTMENT_TBLS(V_PROCID);
 	ELSIF UPPER(V_FORM_TYPE) = 'NAMEDACTION' THEN
		--DBMS_OUTPUT.PUT_LINE('SP_UPDATE_NAMEDACTION_TBLS V_PROCID=' || V_PROCID);
        HHS_CDC_HR.SP_UPDATE_NAMEDACTION_TBLS(V_PROCID);       
    ELSE
        DBMS_OUTPUT.PUT_LINE('SP_UPDATE_###_TBLS V_PROCID=' || V_PROCID);
	END IF;

	COMMIT;

EXCEPTION
	WHEN OTHERS THEN
		SP_ERROR_LOG();
		--DBMS_OUTPUT.PUT_LINE('Error occurred while executing SP_UPDATE_FORM_DATA -------------------');
END;

/

