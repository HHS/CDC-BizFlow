--------------------------------------------------------
--  File created - Friday-August-31-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure SP_CLEAN_FORM_RECORDS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HHS_CDC_HR"."SP_CLEAN_FORM_RECORDS" 
(
  I_PROCID IN NUMBER 
) 
    ------------------------------------------------------------------------------------------
    --  Procedure name	    : 	SP_CLEAN_FORM_RECORDS
    --	Author				:	Taeho Lee <thee@bizflow.com>
    --	Copyright			:	BizFlow Corp.	
    --	
    --	Project				:	HHS CDC HR Workflow Solution - EWITS 2.0
    --	Purpose				:	Delete records of a process id.
    --	
    --  Example
    --  To use in SQL statements:
    --
    -- 	WHEN		WHO			WHAT		
    -- 	-----------	--------	-------------------------------------------------------
    -- 	04/23/2018	THLEE		Created
    ------------------------------------------------------------------------------------------
As

BEGIN
    DBMS_OUTPUT.PUT_LINE('I_PROCID=' || I_PROCID); 

    DELETE FROM FINANCIAL_STATEMENT
    WHERE CASE_ID = I_PROCID;

    DELETE FROM CLA_STANDARD
    WHERE CASE_ID = I_PROCID;

    DELETE FROM CLA_CONDITION
    WHERE CASE_ID = I_PROCID;

    DELETE FROM CONCURRENCE
    WHERE CASE_ID = I_PROCID;

    DELETE FROM GRADE
    WHERE CASE_ID = I_PROCID;

    DELETE FROM CONSIDERATION_AREA
    WHERE CASE_ID = I_PROCID;

    DELETE FROM DUTY_STATION
    WHERE CASE_ID = I_PROCID;

    DELETE FROM POSITION
    WHERE CASE_ID = I_PROCID;

    DELETE FROM LANGUAGE
    WHERE CASE_ID = I_PROCID;

    DELETE FROM EMP_CONDITION
    WHERE CASE_ID = I_PROCID;

    DELETE FROM AUTHORIZED_INCENTIVE
    WHERE CASE_ID = I_PROCID;

    DELETE FROM REC_SME
    WHERE CASE_ID = I_PROCID;

    DELETE FROM VALIDATION
    WHERE CASE_ID = I_PROCID;

    DELETE FROM RECRUITMENT
    WHERE CASE_ID = I_PROCID;

    DELETE FROM CLASSIFICATION
    WHERE CASE_ID = I_PROCID;

    DELETE FROM HR_CASE
    WHERE CASE_ID = I_PROCID;

END SP_CLEAN_FORM_RECORDS;

/
--------------------------------------------------------
--  DDL for Procedure SP_DATACOPY_FORM_DATA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HHS_CDC_HR"."SP_DATACOPY_FORM_DATA" 
(
	I_SRC_PROCID      IN NUMBER
    , I_SRC_FORM_TYPE   IN VARCHAR2
    , I_TGT_PROCID      IN NUMBER
	, I_TGT_FORM_TYPE   IN VARCHAR2
)
    ------------------------------------------------------------------------------------------
    --  Procedure name	    : 	SP_DATACOPY_FORM_DATA
    --	Author				:	Taeho Lee <thee@bizflow.com>
    --	Copyright			:	BizFlow Corp.	
    --	
    --	Project				:	HHS CDC HR Workflow Solution - EWITS 2.0
    --	Purpose				:	Data Copy between BizFlow processes
    --	
    --  Example
    --  To use in SQL statements:
    --
    -- 	WHEN		WHO			WHAT		
    -- 	-----------	--------	-------------------------------------------------------
    -- 	03/29/2018	THLEE		Created
    -- 	04/20/2018	SGURUNG		Added code to UPDATE FIELD_DATA by replacing node value 'POS_ORG_TITLE' with 'POS_FUNCTIONAL_TITLE'
    -- 	05/03/2018	SGURUNG		Added code to UPDATE FIELD_DATA by replacing node value 'JOB_REC_POS_NUM' with 'POS_JOB_REQ_NUM'
    -- 	05/03/2018	SGURUNG		Added code to UPDATE FIELD_DATA by replacing node value 'PRE_EMPLOYMENT_PHYSICAL_REQUIRED' with 'PRE_EMP_PHYSICAL_REQUIRED'    
    -- 	06/19/2018	SGURUNG		Added code to have the Appointment WF use PROCID from its parent WF as its Parent Process ID
    ------------------------------------------------------------------------------------------

IS

	V_ID NUMBER(20);

	V_USER VARCHAR2(50);
	V_PROCID NUMBER(10);
	V_ACTSEQ NUMBER(10);
    V_WITEMSEQ NUMBER(10);
    V_FORM_TYPE VARCHAR2(50);
    V_FIELD_DATA XMLTYPE;

    V_CRT_DT TIMESTAMP(6);
    V_CRT_USR VARCHAR2(50);
    V_MOD_DT TIMESTAMP(6);
    V_MOD_USR VARCHAR2(50);

    V_NEW_FIELD_DATA XMLTYPE;
    V_REC_CNT number(10);
    V_P_PRCID_CNT number(10);

BEGIN

    --DBMS_OUTPUT.PUT_LINE('[DEBUG] ' || 'SP_DATACOPY_FORM_DATA IS CALLED');
    --GET Form Data XML document from the source process
    BEGIN
        --DBMS_OUTPUT.PUT_LINE('[DEBUG] ' || 'Getting FIELD_DATA');
        SELECT PROCID, ACTSEQ, WITEMSEQ, FORM_TYPE, FIELD_DATA, CRT_DT, CRT_USR, MOD_DT, MOD_USR
          INTO V_PROCID, V_ACTSEQ, V_WITEMSEQ, V_FORM_TYPE, V_FIELD_DATA, V_CRT_DT, V_CRT_USR, V_MOD_DT, V_MOD_USR 
          FROM HHS_CDC_HR.TBL_FORM_DTL
        WHERE PROCID = I_SRC_PROCID;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            --DBMS_OUTPUT.PUT_LINE('[DEBUG] ' || 'NO FIELD_DATA FOUND');
            V_NEW_FIELD_DATA := NULL; -- Nothing but place holder
        WHEN OTHERS THEN
            --DBMS_OUTPUT.PUT_LINE('[DEBUG] ' || 'ERROR ' || SUBSTR(SQLERRM, 1, 200));
            V_NEW_FIELD_DATA := NULL; -- Nothing but place holder
    END;

    BEGIN
        SELECT COUNT(*) INTO V_P_PRCID_CNT FROM TBL_FORM_DTL WHERE PROCID = I_SRC_PROCID
          AND EXISTSNODE(field_data, '/formData/items/item[id="PARENT_PROCESS_ID"]') = 1 ;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_P_PRCID_CNT := -1;
    END;

    IF V_FIELD_DATA IS NOT NULL THEN

        V_NEW_FIELD_DATA := NULL;

        --Common Seciton
        --DBMS_OUTPUT.PUT_LINE('[DEBUG] ' || 'Removing history node from FIELD_DATA');
        SELECT DELETEXML(V_FIELD_DATA, '/formData/history')
          INTO V_NEW_FIELD_DATA
          FROM DUAL;

        IF V_NEW_FIELD_DATA IS NULL THEN
            V_NEW_FIELD_DATA := NULL; -- Nothing but place holder
            --DBMS_OUTPUT.PUT_LINE('[DEBUG] V_NEW_FIELD_DATA IS NULL');
        ELSE
            --DBMS_OUTPUT.PUT_LINE('[DEBUG] V_NEW_FIELD_DATA=' || V_NEW_FIELD_DATA.getStringVal());

            --Pre-processing: add, delete, move elements from source xml before copying it to target process.
            IF ((UPPER(I_SRC_FORM_TYPE) = 'CLASSIFICATION' and UPPER(I_TGT_FORM_TYPE) = 'RECRUITMENT')
               OR (UPPER(I_SRC_FORM_TYPE) = 'CLASSIFICATION' and UPPER(I_TGT_FORM_TYPE) = 'APPOINTMENT')
               OR (UPPER(I_SRC_FORM_TYPE) = 'RECRUITMENT' and UPPER(I_TGT_FORM_TYPE) = 'APPOINTMENT')) THEN

                SELECT DELETEXML(V_NEW_FIELD_DATA, '/formData/items/item[id=''genInitComplete'']')
                  INTO V_NEW_FIELD_DATA
                  FROM DUAL;

                SELECT DELETEXML(V_NEW_FIELD_DATA, '/formData/items/item[id=''posInitComplete'']')
                  INTO V_NEW_FIELD_DATA
                  FROM DUAL;

                SELECT DELETEXML(V_NEW_FIELD_DATA, '/formData/items/item[id=''claInitComplete'']')
                  INTO V_NEW_FIELD_DATA
                  FROM DUAL;

                SELECT DELETEXML(V_NEW_FIELD_DATA, '/formData/items/item[id=''concInitComplete'']')
                  INTO V_NEW_FIELD_DATA
                  FROM DUAL;

/*
                SELECT INSERTCHILDXML(V_NEW_FIELD_DATA
                        , '/formData/items'
                        , 'item'
                        , XMLTYPE('<item><id>PARENT_PROCESS_ID</id><etype>textbox</etype><value>' || TO_CHAR(I_SRC_PROCID) || '</value></item>'))
                  INTO V_NEW_FIELD_DATA
                  FROM DUAL;
                --DBMS_OUTPUT.PUT_LINE('[DEBUG] V_NEW_FIELD_DATA3=' || V_NEW_FIELD_DATA.getStringVal());
*/                
                -- Special handling for different name in between Classification and Recruitment.
                IF ((UPPER(I_SRC_FORM_TYPE) = 'CLASSIFICATION' and UPPER(I_TGT_FORM_TYPE) = 'RECRUITMENT')
                    or (UPPER(I_SRC_FORM_TYPE) = 'CLASSIFICATION' and UPPER(I_TGT_FORM_TYPE) = 'APPOINTMENT')) THEN
                    SELECT UPDATEXML(V_NEW_FIELD_DATA, '/formData/items/item[id="POS_ORG_TITLE"]/id/text()', 'POS_FUNCTIONAL_TITLE')                    
                      INTO V_NEW_FIELD_DATA
                      FROM DUAL; 
    
                    SELECT UPDATEXML(V_NEW_FIELD_DATA, '/formData/items/item[id="JOB_REC_POS_NUM"]/id/text()', 'POS_JOB_REQ_NUM')                    
                      INTO V_NEW_FIELD_DATA
                      FROM DUAL;
                      
                    SELECT UPDATEXML(V_NEW_FIELD_DATA, '/formData/items/item[id="PRE_EMPLOYMENT_PHYSICAL_REQUIRED"]/id/text()', 'PRE_EMP_PHYSICAL_REQUIRED')                    
                      INTO V_NEW_FIELD_DATA
                      FROM DUAL; 
                    
                    --parent's parent will become GRAND_PARENT
                    SELECT UPDATEXML(V_NEW_FIELD_DATA, '/formData/items/item[id="PARENT_PROCESS_ID"]/id/text()', 'GRAND_PARENT_PROCESS_ID')                    
                      INTO V_NEW_FIELD_DATA
                      FROM DUAL;                       
                END IF;
                
            END IF;
 
            --Set parent process id
            IF V_P_PRCID_CNT < 1 THEN
                SELECT INSERTCHILDXML(V_NEW_FIELD_DATA
                        , '/formData/items'
                        , 'item'
                        , XMLTYPE('<item><id>PARENT_PROCESS_ID</id><etype>textbox</etype><value>' || TO_CHAR(I_SRC_PROCID) || '</value></item>'))
                  INTO V_NEW_FIELD_DATA
                  FROM DUAL;
                --DBMS_OUTPUT.PUT_LINE('PARENT PROC ID DID NOT EXIST - INSERTED IT INTO TARGET - FLAG VAL : ' || V_P_PRCID_CNT);                
            ELSE
                SELECT UPDATEXML(V_NEW_FIELD_DATA, '/formData/items/item[id="PARENT_PROCESS_ID"]/value/text()', TO_CHAR(I_SRC_PROCID))                    
                  INTO V_NEW_FIELD_DATA
                  FROM DUAL;                     
                --DBMS_OUTPUT.PUT_LINE('PARENT PROC ID EXISTED -UPDATED FOR TARGET - FLAG VAL : ' || V_P_PRCID_CNT);
            END IF;                

            BEGIN
                SELECT COUNT(*) INTO V_REC_CNT FROM TBL_FORM_DTL WHERE PROCID = I_TGT_PROCID;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_REC_CNT := -1;
            END;


            --Copy xml from the source to the target.
            IF V_REC_CNT > 0 THEN
            
                --This is extremly rare case, becuase this process will be called at the beginning of a process.
                --Update FIELD_DATA with new FIELD_DATA without /formData/history node
                ----DBMS_OUTPUT.PUT_LINE('[DEBUG] ' || 'UPDATE FIELD_DATA TO NEW PROCESS');
                UPDATE HHS_CDC_HR.TBL_FORM_DTL
                   SET FIELD_DATA = V_NEW_FIELD_DATA
                       ,MOD_USR = 'update'
                 WHERE PROCID = I_TGT_PROCID;

            ELSE

                --INSERT Form Data to the target process
                ----DBMS_OUTPUT.PUT_LINE('[DEBUG] ' || 'INSERT FIELD_DATA TO NEW PROCESS');
                INSERT INTO HHS_CDC_HR.TBL_FORM_DTL
                (
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
                    I_TGT_PROCID
                    , NULL
                    , NULL
                    , I_TGT_FORM_TYPE
                    , V_NEW_FIELD_DATA
                    , SYSDATE
                    , V_MOD_USR --The last user who had updated the form data before this Data Copying action
                );

            END IF;

        END IF;

        -- for respective process definition
        IF UPPER(I_TGT_FORM_TYPE) = 'RECRUITMENT' THEN
            SP_UPDATE_RECRUITMENT_TBLS(I_TGT_PROCID);    
            DBMS_OUTPUT.PUT_LINE('SP_UPDATE_RECRUITMENT_TBLS V_PROCID=' || I_TGT_PROCID);
        -- HHS_MAIN is a temporary name of Classification, it will need to be changed to Classification once the CLA_Main WebMaker's broken application map is fixed.
        ELSIF UPPER(I_TGT_FORM_TYPE) = 'CLASSIFICATION' or UPPER(V_FORM_TYPE) = 'HHS_MAIN' THEN
            SP_UPDATE_CLASSIFICATION_TBLS(I_TGT_PROCID);
            DBMS_OUTPUT.PUT_LINE('SP_UPDATE_CLASSIFICATION_TBLS V_PROCID=' || I_TGT_PROCID);
        ELSIF UPPER(I_TGT_FORM_TYPE) = 'APPOINTMENT' THEN
            --TODO: implement appointment update stored procedure SP_UPDATE_APPOINTMENT_TBLS(V_PROCID);
            DBMS_OUTPUT.PUT_LINE('SP_UPDATE_APPOINTMENT_TBLS V_PROCID=' || I_TGT_PROCID);
        END IF;

    ELSE
        --DBMS_OUTPUT.PUT_LINE('[DEBUG] ' || 'V_FIELD_DATA IS NULL');
        V_NEW_FIELD_DATA := NULL; -- Nothing but place holder
    END IF;

	COMMIT;


EXCEPTION
	WHEN OTHERS THEN
        --DBMS_OUTPUT.PUT_LINE('[DEBUG] ' || 'ERROR ' || SUBSTR(SQLERRM, 1, 200));
        ROLLBACK;
        SP_ERROR_LOG();
        COMMIT;
END;

/
--------------------------------------------------------
--  DDL for Procedure SP_ERROR_LOG
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HHS_CDC_HR"."SP_ERROR_LOG" 
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

/
--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_CLASSIFICATION_TBLS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HHS_CDC_HR"."SP_UPDATE_CLASSIFICATION_TBLS" 
(
  I_PROCID IN NUMBER 
) 
    ------------------------------------------------------------------------------------------
    --  Procedure name	    : 	SP_UPDATE_CLASSIFICATION_TBLS
    --	Author				:	Taeho Lee <thee@bizflow.com>
    --	Copyright			:	BizFlow Corp.	
    --	
    --	Project				:	HHS CDC HR Workflow Solution - EWITS 2.0
    --	Purpose				:	Insert/Update Classification tables with XML document in TBL_FORM_DTL.FIELD_DATA
    --	
    --  Example
    --  To use in SQL statements:
    --
    -- 	WHEN		WHO			WHAT		
    -- 	-----------	--------	-------------------------------------------------------
    -- 	04/19/2018	THLEE		Created
    -- 	05/16/2018	SGURUNG		Added code to INSERT or UPDATE value for DB column CLASSIFICATION.POS_BSD_MGMT_SYS_NO
    -- 	05/29/2018	SGURUNG   Changed item <id> to 'POS_DUTY_STATIONS' from 'POS_DUTY_STATION'
    -- 	06/06/2018	SGURUNG   Added code to INSERT or UPDATE value for DB column CLASSIFICATION.RQST_TP
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
-------- CLASSIFICATION
	V_CLA_CASE_ID                       NUMBER(10);
	V_CLA_ADMN_CD                       VARCHAR2(20);
	V_CLA_ORG_NM                        VARCHAR2(200);
	V_CLA_HIRING_METHOD                 VARCHAR2(20);
	V_CLA_FIRST_SUBDVSN                 VARCHAR2(200);
	V_CLA_SECOND_SUBDVSN                VARCHAR2(200);
	V_CLA_THIRD_SUBDVSN                 VARCHAR2(200);
	V_CLA_FOURTH_SUBDVSN                VARCHAR2(200);
	V_CLA_FIFTH_SUBDVSN                 VARCHAR2(200);
	V_CLA_PROPOSED_ACTION               VARCHAR2(100);
	V_CLA_PA_OTHER_DESC                 VARCHAR2(400);
	V_CLA_POS_STATUS                    VARCHAR2(20);
	V_CLA_EXSTING_PD_NO                 VARCHAR2(200);
	V_CLA_JOB_REQ_NO                    VARCHAR2(200);
	V_CLA_POS_BSD_MGMT_SYS_NO           VARCHAR2(100);	
	V_CLA_SO_NM                         VARCHAR2(100);
	V_CLA_SO_EMAIL                      VARCHAR2(100);
	V_CLA_CIO_ADMN_NM                   VARCHAR2(100);
	V_CLA_CIO_ADMN_EMAIL                VARCHAR2(100);
	V_CLA_HRO_SPC_NM                    VARCHAR2(100);
	V_CLA_HRO_SPC_EMAIL                 VARCHAR2(100);
	V_CLA_CLA_SPC_NM                    VARCHAR2(100);
	V_CLA_CLA_SPC_EMAIL                 VARCHAR2(100);
    V_CLA_EXPLANATION                   VARCHAR2(4000);    
    V_CLA_OFFICIAL_REASON_SUB           VARCHAR2(400);
    V_CLA_REQUEST_TYPE                  VARCHAR2(400);  
---------- CONCURRENCE
	V_CONC_SUPERVISOR_CERT_1            VARCHAR2(20);
	V_CONC_SUPERVISOR_NM_1              VARCHAR2(100);
	V_CONC_SUPERVISOR_APPRVL_DT_1       VARCHAR2(20);
	V_CONC_SUPERVISOR_TP_1              VARCHAR2(20);
	V_CONC_SUPERVISOR_CERT_2            VARCHAR2(20);
	V_CONC_SUPERVISOR_NM_2              VARCHAR2(100);
	V_CONC_SUPERVISOR_APPRVL_DT_2       VARCHAR2(20);
	V_CONC_SUPERVISOR_TP_2              VARCHAR2(20);
	V_CONC_SUPERVISOR_CERT_3            VARCHAR2(20);
	V_CONC_SUPERVISOR_NM_3              VARCHAR2(100);
	V_CONC_SUPERVISOR_APPRVL_DT_3       VARCHAR2(20);
	V_CONC_SUPERVISOR_TP_3              VARCHAR2(20);           
---------- CLA_CONDITION
	V_COND_PHYSICIAN_COMP_ALLWNC        VARCHAR2(20);
	V_COND_DRUG_TEST_RQRD               VARCHAR2(20);
	V_COND_PRE_EMP_PHYSCL_RQRD          VARCHAR2(20);
	V_COND_SEL_AGNT_ACCSS_RQRD          VARCHAR2(20);
	V_COND_SUBJ_TO_ADDTNL_IDENT         VARCHAR2(20);
	V_COND_INCUMBENT_ONLY               VARCHAR2(20);
	V_COND_COMM_CORP_ELIGIBLE           VARCHAR2(20);
	V_COND_FINANCIAL_DSCLSR_RQRD        VARCHAR2(20);
	V_COND_FAIR_LABOR_STND_ACT          VARCHAR2(4000);
	V_COND_CYBER_SEC_CD                 VARCHAR2(4000);
	V_COND_BUS_CD                       VARCHAR2(4000);
	V_COND_ACQUISITION_CD               VARCHAR2(4000);
	V_COND_COMP_LVL_CD                  VARCHAR2(4000);
    V_COND_OPM_CERTIFICATION_NO         VARCHAR2(400);
    V_COND_LMTD_TRM                     VARCHAR2(100);
    V_COND_LMTD_EMRGNCY                 VARCHAR2(100);
    V_COND_LMTD_TRM_NTE                 VARCHAR2(100);
---------- POSITION
	V_POS_JOB_REQ_NO                    VARCHAR2(100);
	V_POS_OFFICIAL_POS_TTL              VARCHAR2(4000);
	V_POS_ORG_POS_TTL                   VARCHAR2(4000);
	V_POS_CLSSFD_POS_TTL                VARCHAR2(4000);
	V_POS_FNCTNL_POS_TTL                VARCHAR2(4000);
	V_POS_PAY_PLAN                      VARCHAR2(4000);
	V_POS_SERIES                        VARCHAR2(4000);
	V_POS_PROMO_POTENTIAL               VARCHAR2(400);
	V_POS_POS_SENSITIVITY               VARCHAR2(4000);
	V_POS_FULL_PERF_LVL                 VARCHAR2(400);
	V_POS_POS_TP                        VARCHAR2(400);
	V_POS_COMMON_ACCT_NO                VARCHAR2(400);
	V_POS_BACKFILL_VC                   VARCHAR2(400);
	V_POS_BACKFILL_VC_NM                VARCHAR2(400);
	V_POS_BACKFILL_VC_RSN               VARCHAR2(1000);
	V_POS_NUM_OF_VACANCY                VARCHAR2(400);
	V_POS_APPOINTMENT_TP                VARCHAR2(400);
	V_POS_NOT_TO_EXCEED                 VARCHAR2(400);
	V_POS_NAME_REQUEST                  VARCHAR2(400);
	V_POS_POS_OPEN_CONT                 VARCHAR2(400);
	V_POS_NUM_OF_DAYS_AD                VARCHAR2(400);
	V_POS_WORK_SCH_TP                   VARCHAR2(400);
	V_POS_HRS_PER_WEEK                  VARCHAR2(400);
	V_POS_REMARKS                       VARCHAR2(4000);
	V_POS_SERVICE                       VARCHAR2(400);
	V_POS_EMPLOYING_OFF_LOC             VARCHAR2(400); 
---------- POS_TITLES_SERIES
    V_POS_TITLES_SERIES                 VARCHAR2(10000);
    V_POS_TITLES_SERIES_TTL             VARCHAR2(4000);
    V_POS_TITLES_SERIES_SERIES          VARCHAR2(4000);
---------- DUTY_STATION
    V_DS_STATION                        VARCHAR2(400); 
---------- GRADES
    V_POS_GRADE_IDS                     VARCHAR2(10000);
---------- GRADE_INFO
    V_POS_GRADE_RELATED                 VARCHAR2(10000);
---------- CLA_STANDARD
    V_CLA_STANDARDS                     VARCHAR2(10000); 
---------- FINANCIAL_STATEMENT
    V_CLA_FINANCIAL_STATEMENTS          VARCHAR2(10000);



BEGIN

    --DBMS_OUTPUT.enable(null);
    
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

    ---------- CLASSIFICATION TABLE
    SELECT FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'ADMIN_CD')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'ORG_NAME')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'HM_ID')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'ORG_NAME_LVL1')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'ORG_NAME_LVL2')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'ORG_NAME_LVL3')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'ORG_NAME_LVL4')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'ORG_NAME_LVL5')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'PROPOSED_ACTION')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'PA_OTHER_DESC')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_STATUS')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'PD_NUMBER')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'JOB_REC_POS_NUM')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'PBMS_ID')		   
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SO_AutoComplete')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SO_EMAIL')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CIO_AutoComplete')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CIO_EMAIL')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'HROS_AutoComplete')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'HROS_EMAIL')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CLASS_SPEC_AutoComplete')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CLASS_SPEC_EMAIL')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CLA_EXP')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'OFFICIAL_REASON_SUB')
           ,FN_GET_XML_NODE_VALUE(V_FD_FIELD_DATA, 'REQUEST_TYPE')           
      INTO 
           V_CLA_ADMN_CD
           ,V_CLA_ORG_NM
           ,V_CLA_HIRING_METHOD
           ,V_CLA_FIRST_SUBDVSN
           ,V_CLA_SECOND_SUBDVSN
           ,V_CLA_THIRD_SUBDVSN
           ,V_CLA_FOURTH_SUBDVSN
           ,V_CLA_FIFTH_SUBDVSN
           ,V_CLA_PROPOSED_ACTION
           ,V_CLA_PA_OTHER_DESC
           ,V_CLA_POS_STATUS
           ,V_CLA_EXSTING_PD_NO
           ,V_CLA_JOB_REQ_NO
           ,V_CLA_POS_BSD_MGMT_SYS_NO		   
           ,V_CLA_SO_NM          
           ,V_CLA_SO_EMAIL
           ,V_CLA_CIO_ADMN_NM
           ,V_CLA_CIO_ADMN_EMAIL
           ,V_CLA_HRO_SPC_NM
           ,V_CLA_HRO_SPC_EMAIL
           ,V_CLA_CLA_SPC_NM
           ,V_CLA_CLA_SPC_EMAIL
           ,V_CLA_EXPLANATION
           ,V_CLA_OFFICIAL_REASON_SUB
           ,V_CLA_REQUEST_TYPE 
       FROM DUAL;

    V_RECCNT := 0;
    SELECT COUNT(1)
      INTO V_RECCNT
      FROM HHS_CDC_HR.CLASSIFICATION
     WHERE CASE_ID = I_PROCID;

    IF V_RECCNT = 0 THEN
    BEGIN
        --DBMS_OUTPUT.PUT_LINE('INSERT INTO HHS_CDC_HR.CLASSIFICATION');
        INSERT INTO HHS_CDC_HR.CLASSIFICATION 
        (                        
                    CASE_ID
                    ,ADMN_CD
                    ,ORG_NM
                    ,HIRING_METHOD
                    ,FIRST_SUBDVSN
                    ,SECOND_SUBDVSN
                    ,THIRD_SUBDVSN
                    ,FOURTH_SUBDVSN
                    ,FIFTH_SUBDVSN
                    ,PROPOSED_ACTION
                    ,PA_OTHER_DESC
                    ,POS_STATUS
                    ,EXSTING_PD_NO
                    ,JOB_REQ_NO
                    ,POS_BSD_MGMT_SYS_NO					
                    ,SO_NM
                    ,SO_EMAIL
                    ,CIO_ADMN_NM
                    ,CIO_ADMN_EMAIL
                    ,HRO_SPC_NM
                    ,HRO_SPC_EMAIL
                    ,CLA_SPC_NM
                    ,CLA_SPC_EMAIL
                    ,EXPLANATION
                    ,OFFCL_RSN_SBMSSN
                    ,RQST_TP
        )
        VALUES 
        (
                   I_PROCID
                   ,V_CLA_ADMN_CD
                   ,V_CLA_ORG_NM
                   ,V_CLA_HIRING_METHOD
                   ,V_CLA_FIRST_SUBDVSN
                   ,V_CLA_SECOND_SUBDVSN
                   ,V_CLA_THIRD_SUBDVSN
                   ,V_CLA_FOURTH_SUBDVSN
                   ,V_CLA_FIFTH_SUBDVSN
                   ,V_CLA_PROPOSED_ACTION
                   ,V_CLA_PA_OTHER_DESC
                   ,V_CLA_POS_STATUS
                   ,V_CLA_EXSTING_PD_NO
                   ,V_CLA_JOB_REQ_NO
                   ,V_CLA_POS_BSD_MGMT_SYS_NO				   
                   ,V_CLA_SO_NM          
                   ,V_CLA_SO_EMAIL
                   ,V_CLA_CIO_ADMN_NM
                   ,V_CLA_CIO_ADMN_EMAIL
                   ,V_CLA_HRO_SPC_NM
                   ,V_CLA_HRO_SPC_EMAIL
                   ,V_CLA_CLA_SPC_NM
                   ,V_CLA_CLA_SPC_EMAIL
                   ,V_CLA_EXPLANATION
                   ,V_CLA_OFFICIAL_REASON_SUB
                   ,FN_GET_LOOKUP_LABEL_BY_NAME('ReqType', V_CLA_REQUEST_TYPE)                       
        );
		
    END;    
    ELSE
    BEGIN
        --DBMS_OUTPUT.PUT_LINE('UPDATE HHS_CDC_HR.CLASSIFICATION');
        UPDATE HHS_CDC_HR.CLASSIFICATION
           SET 
                ADMN_CD = V_CLA_ADMN_CD
                ,ORG_NM = V_CLA_ORG_NM
                ,HIRING_METHOD = V_CLA_HIRING_METHOD
                ,FIRST_SUBDVSN = V_CLA_FIRST_SUBDVSN
                ,SECOND_SUBDVSN = V_CLA_SECOND_SUBDVSN
                ,THIRD_SUBDVSN = V_CLA_THIRD_SUBDVSN
                ,FOURTH_SUBDVSN = V_CLA_FOURTH_SUBDVSN
                ,FIFTH_SUBDVSN = V_CLA_FIFTH_SUBDVSN
                ,PROPOSED_ACTION = V_CLA_PROPOSED_ACTION
                ,PA_OTHER_DESC = V_CLA_PA_OTHER_DESC
                ,POS_STATUS = V_CLA_POS_STATUS
                ,EXSTING_PD_NO = V_CLA_EXSTING_PD_NO
                ,JOB_REQ_NO = V_CLA_JOB_REQ_NO
                ,POS_BSD_MGMT_SYS_NO = V_CLA_POS_BSD_MGMT_SYS_NO				
                ,SO_NM = V_CLA_SO_NM
                ,SO_EMAIL = V_CLA_SO_EMAIL
                ,CIO_ADMN_NM = V_CLA_CIO_ADMN_NM
                ,CIO_ADMN_EMAIL = V_CLA_CIO_ADMN_EMAIL
                ,HRO_SPC_NM = V_CLA_HRO_SPC_NM
                ,HRO_SPC_EMAIL = V_CLA_HRO_SPC_EMAIL
                ,CLA_SPC_NM = V_CLA_CLA_SPC_NM
                ,CLA_SPC_EMAIL = V_CLA_CLA_SPC_EMAIL
                ,EXPLANATION = V_CLA_EXPLANATION
                ,OFFCL_RSN_SBMSSN = V_CLA_OFFICIAL_REASON_SUB
                ,RQST_TP = FN_GET_LOOKUP_LABEL_BY_NAME('ReqType', V_CLA_REQUEST_TYPE)
         WHERE CASE_ID = I_PROCID;

    END;
    END IF;    



    ---------- POSITION TABLE
    SELECT FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'JOB_REC_POS_NUM') 
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_TITLE') --V_POS_OFFICIAL_POS_TTL
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_ORG_TITLE') --V_POS_ORG_POS_TTL
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_TITLE')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_FUNCTIONAL_TITLE') --???
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_PAY_PLAN_CODE')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_SERIES')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_IS_PROMOTIONAL')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_SENSITIVITY_ID')
           ,FN_GET_XML_NODE_VALUE(V_FD_FIELD_DATA, 'POS_FULL_PERF_LEVEL') --this field sometime has both value and text, and sometimes value only. It would be safer to use value, and find a maaping label.
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_SUPERVISORY_OR_NOT')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_CAN')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_IS_BF_OR_VICE')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_BF_VICE_NAME')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_NO_BF_VICE_RSN')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_NUM_VACANCIES')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_APPT_TYPE_ID')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_NTE')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_NAME_REQUEST')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_IS_OPEN_CONTINUOUS')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_DAYS_TO_ADVERTISE')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_WORK_SCHED')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_HOURS_PER_WEEK')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_REMARKS')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_SERVICE') --V_POS_SERVICE
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_EMPL_OFFICE') --V_POS_EMPLOYING_OFF_LOC
      INTO 
           V_POS_JOB_REQ_NO       
           ,V_POS_OFFICIAL_POS_TTL 
           ,V_POS_ORG_POS_TTL      
           ,V_POS_CLSSFD_POS_TTL   
           ,V_POS_FNCTNL_POS_TTL   
           ,V_POS_PAY_PLAN         
           ,V_POS_SERIES           
           ,V_POS_PROMO_POTENTIAL  
           ,V_POS_POS_SENSITIVITY  
           ,V_POS_FULL_PERF_LVL    
           ,V_POS_POS_TP           
           ,V_POS_COMMON_ACCT_NO   
           ,V_POS_BACKFILL_VC      
           ,V_POS_BACKFILL_VC_NM
           ,V_POS_BACKFILL_VC_RSN  
           ,V_POS_NUM_OF_VACANCY   
           ,V_POS_APPOINTMENT_TP   
           ,V_POS_NOT_TO_EXCEED    
           ,V_POS_NAME_REQUEST     
           ,V_POS_POS_OPEN_CONT    
           ,V_POS_NUM_OF_DAYS_AD   
           ,V_POS_WORK_SCH_TP      
           ,V_POS_HRS_PER_WEEK     
           ,V_POS_REMARKS          
           ,V_POS_SERVICE          
           ,V_POS_EMPLOYING_OFF_LOC
      FROM DUAL; 


    V_RECCNT := 0;
    SELECT COUNT(1)
      INTO V_RECCNT
      FROM HHS_CDC_HR.POSITION
     WHERE CASE_ID = I_PROCID;    

    IF V_RECCNT = 0 THEN
    BEGIN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.POSITION');    
        INSERT INTO HHS_CDC_HR.POSITION
        (
            CASE_ID          
            ,JOB_REQ_NO       
            ,ORG_POS_TTL      
            ,CLSSFD_POS_TTL   
            ,FNCTNL_POS_TTL   
            ,PAY_PLAN         
            ,PROMO_POTENTIAL  
            ,POS_SENSITIVITY  
            ,FULL_PERF_LVL    
            ,POS_TP           
            ,COMMON_ACCT_NO   
            ,BACKFILL_VC      
            ,BACKFILL_VC_NM   
            ,BACKFILL_VC_RSN  
            ,NUM_OF_VACANCY   
            ,APPOINTMENT_TP   
            ,NOT_TO_EXCEED    
            ,NAME_REQUEST     
            ,POS_OPEN_CONT    
            ,NUM_OF_DAYS_AD   
            ,WORK_SCH_TP      
            ,HRS_PER_WEEK     
            ,REMARKS          
            ,SERVICE          
            ,EMPLOYING_OFF_LOC
        )
        VALUES
        (
            I_PROCID 
            ,V_POS_JOB_REQ_NO       
            ,V_POS_ORG_POS_TTL      
            ,V_POS_CLSSFD_POS_TTL   
            ,V_POS_FNCTNL_POS_TTL   
            ,V_POS_PAY_PLAN         
            ,V_POS_PROMO_POTENTIAL  
            ,V_POS_POS_SENSITIVITY  
            ,FN_GET_LOOKUP_LABEL('Grade', V_POS_FULL_PERF_LVL)    
            ,V_POS_POS_TP           
            ,V_POS_COMMON_ACCT_NO   
            ,V_POS_BACKFILL_VC      
            ,V_POS_BACKFILL_VC_NM   
            ,V_POS_BACKFILL_VC_RSN  
            ,V_POS_NUM_OF_VACANCY   
            ,V_POS_APPOINTMENT_TP   
            ,V_POS_NOT_TO_EXCEED    
            ,V_POS_NAME_REQUEST     
            ,V_POS_POS_OPEN_CONT    
            ,FN_GET_LOOKUP_LABEL('CalendarDaysToAdvertise', V_POS_NUM_OF_DAYS_AD)
            ,V_POS_WORK_SCH_TP      
            ,V_POS_HRS_PER_WEEK     
            ,V_POS_REMARKS          
            ,V_POS_SERVICE          
            ,V_POS_EMPLOYING_OFF_LOC        
        );

    END;
    ELSE
    BEGIN
        --DBMS_OUTPUT.PUT_LINE('UPDATE HHS_CDC_HR.POSITION');
        UPDATE HHS_CDC_HR.POSITION
           SET JOB_REQ_NO = V_POS_JOB_REQ_NO
               ,ORG_POS_TTL = V_POS_ORG_POS_TTL
               ,CLSSFD_POS_TTL = V_POS_CLSSFD_POS_TTL
               ,FNCTNL_POS_TTL = V_POS_FNCTNL_POS_TTL  
               ,PAY_PLAN = V_POS_PAY_PLAN
               ,PROMO_POTENTIAL = V_POS_PROMO_POTENTIAL
               ,POS_SENSITIVITY = V_POS_POS_SENSITIVITY
               ,FULL_PERF_LVL = FN_GET_LOOKUP_LABEL('Grade', V_POS_FULL_PERF_LVL) 
               ,POS_TP = V_POS_POS_TP
               ,COMMON_ACCT_NO = V_POS_COMMON_ACCT_NO
               ,BACKFILL_VC = V_POS_BACKFILL_VC    
               ,BACKFILL_VC_NM = V_POS_BACKFILL_VC_NM
               ,BACKFILL_VC_RSN = V_POS_BACKFILL_VC_RSN
               ,NUM_OF_VACANCY = V_POS_NUM_OF_VACANCY
               ,APPOINTMENT_TP = V_POS_APPOINTMENT_TP
               ,NOT_TO_EXCEED = V_POS_NOT_TO_EXCEED 
               ,NAME_REQUEST = V_POS_NAME_REQUEST  
               ,POS_OPEN_CONT = V_POS_POS_OPEN_CONT
               ,NUM_OF_DAYS_AD = FN_GET_LOOKUP_LABEL('CalendarDaysToAdvertise', V_POS_NUM_OF_DAYS_AD) 
               ,WORK_SCH_TP = V_POS_WORK_SCH_TP
               ,HRS_PER_WEEK = V_POS_HRS_PER_WEEK 
               ,REMARKS = V_POS_REMARKS
               ,SERVICE = V_POS_SERVICE          
               ,EMPLOYING_OFF_LOC = V_POS_EMPLOYING_OFF_LOC
         WHERE CASE_ID = I_PROCID;

    END;
    END IF;


    ---------- DUTY_STATION TABLE
    --DBMS_OUTPUT.PUT_LINE('DELETE HHS_CDC_HR.DUTY_STATION');
    DELETE 
      FROM HHS_CDC_HR.DUTY_STATION
     WHERE CASE_ID = I_PROCID;

    SELECT FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_DUTY_STATIONS') 
      INTO V_DS_STATION
      FROM DUAL;

    IF V_DS_STATION IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.DUTY_STATION');
        INSERT INTO HHS_CDC_HR.DUTY_STATION 
        (
            CASE_ID
            ,SEQ
            ,STATION
        )        
        VALUES
        (
            I_PROCID
            ,1
            ,V_DS_STATION
        );

    END IF;

    ---------- CONCURRENCE
    --DBMS_OUTPUT.PUT_LINE('DELETE HHS_CDC_HR.CONCURRENCE');
    DELETE 
      FROM HHS_CDC_HR.CONCURRENCE
     WHERE CASE_ID = I_PROCID;

    SELECT FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CERT_IMMEDIATE_SUP')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CERT_IMMEDIATE_SUP_NAME')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CERT_IMMEDIATE_SUP_DATE')
           ,'1'
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CERT_HIGHER_SUP') 
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CERT_HIGHER_SUP_NAME') 
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CERT_HIGHER_SUP_DATE') 
           ,'2'
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CERT_CLASS') 
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CERT_CLASS_NAME') 
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CERT_CLASS_DATE') 
           ,'3'
      INTO 
            V_CONC_SUPERVISOR_CERT_1
            ,V_CONC_SUPERVISOR_NM_1
            ,V_CONC_SUPERVISOR_APPRVL_DT_1
            ,V_CONC_SUPERVISOR_TP_1
            ,V_CONC_SUPERVISOR_CERT_2
            ,V_CONC_SUPERVISOR_NM_2
            ,V_CONC_SUPERVISOR_APPRVL_DT_2
            ,V_CONC_SUPERVISOR_TP_2
            ,V_CONC_SUPERVISOR_CERT_3
            ,V_CONC_SUPERVISOR_NM_3
            ,V_CONC_SUPERVISOR_APPRVL_DT_3
            ,V_CONC_SUPERVISOR_TP_3          
      FROM DUAL; 

    IF V_CONC_SUPERVISOR_NM_1 IS NOT NULL AND V_CONC_SUPERVISOR_APPRVL_DT_1 IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.CONCURRENCE 1');
        INSERT INTO HHS_CDC_HR.CONCURRENCE
        (
            CASE_ID
            ,SEQ
            ,SUPERVISOR_CERT
            ,SUPERVISOR_NM
            ,SUPERVISOR_APPRVL_DT
            ,SUPERVISOR_TP
        )
        VALUES
        (
            I_PROCID
            ,1
            ,V_CONC_SUPERVISOR_CERT_1
            ,V_CONC_SUPERVISOR_NM_1      
            ,V_CONC_SUPERVISOR_APPRVL_DT_1   
            ,V_CONC_SUPERVISOR_TP_1   
        );
    END IF;

    IF V_CONC_SUPERVISOR_NM_2 IS NOT NULL AND V_CONC_SUPERVISOR_APPRVL_DT_2 IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.CONCURRENCE 2');
        INSERT INTO HHS_CDC_HR.CONCURRENCE
        (
            CASE_ID
            ,SEQ
            ,SUPERVISOR_CERT
            ,SUPERVISOR_NM
            ,SUPERVISOR_APPRVL_DT
            ,SUPERVISOR_TP
        )
        VALUES
        (
            I_PROCID
            ,2
            ,V_CONC_SUPERVISOR_CERT_2
            ,V_CONC_SUPERVISOR_NM_2
            ,V_CONC_SUPERVISOR_APPRVL_DT_2
            ,V_CONC_SUPERVISOR_TP_2
        );
    END IF;

    IF V_CONC_SUPERVISOR_NM_3 IS NOT NULL AND V_CONC_SUPERVISOR_APPRVL_DT_3 IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.CONCURRENCE 3');
        INSERT INTO HHS_CDC_HR.CONCURRENCE
        (
            CASE_ID
            ,SEQ
            ,SUPERVISOR_CERT
            ,SUPERVISOR_NM
            ,SUPERVISOR_APPRVL_DT
            ,SUPERVISOR_TP
        )
        VALUES
        (
            I_PROCID
            ,3
            ,V_CONC_SUPERVISOR_CERT_3
            ,V_CONC_SUPERVISOR_NM_3    
            ,V_CONC_SUPERVISOR_APPRVL_DT_3
            ,V_CONC_SUPERVISOR_TP_3
        );
    END IF;

    ---------- CLA_CONDITION
    SELECT FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'PHYSICIANS_COMPARABILITY_ALLOWANCE')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'DRUG_TEST_REQUIRED')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'PRE_EMPLOYMENT_PHYSICAL_REQUIRED')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SELECT_AGENT_ACCESS_REQUIRED')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SUBJECT_TO_ADDITIONAL_IDENTICAL')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'INCUMBENT_ONLY')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'COMMISSIONED_CORPS_ELIGIBLE')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'FINANCIAL_DISCLOSURE_REQUIRED')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CYBER_SECURITY_CODE')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'BARGAINING_UNIT_STATUS_CODE')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'ACQUISITION_CODE')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'OPM_CERTIFICATION_NO')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'LIMITED_TERM')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'LIMITED_EMERGENCY')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CLA_NTE')
      INTO 
            V_COND_PHYSICIAN_COMP_ALLWNC
            ,V_COND_DRUG_TEST_RQRD
            ,V_COND_PRE_EMP_PHYSCL_RQRD
            ,V_COND_SEL_AGNT_ACCSS_RQRD
            ,V_COND_SUBJ_TO_ADDTNL_IDENT
            ,V_COND_INCUMBENT_ONLY
            ,V_COND_COMM_CORP_ELIGIBLE
            ,V_COND_FINANCIAL_DSCLSR_RQRD
            ,V_COND_CYBER_SEC_CD
            ,V_COND_BUS_CD
            ,V_COND_ACQUISITION_CD
            ,V_COND_OPM_CERTIFICATION_NO
            ,V_COND_LMTD_TRM
            ,V_COND_LMTD_EMRGNCY
            ,V_COND_LMTD_TRM_NTE
       FROM DUAL;

    V_RECCNT := 0;
    SELECT COUNT(1)
      INTO V_RECCNT
      FROM HHS_CDC_HR.CLA_CONDITION
     WHERE CASE_ID = I_PROCID;

    IF V_RECCNT = 0 THEN
    BEGIN
        --DBMS_OUTPUT.PUT_LINE('INSERT INTO HHS_CDC_HR.CLA_CONDITION');
        INSERT INTO HHS_CDC_HR.CLA_CONDITION 
        (                        
            CASE_ID
            ,PHYSICIAN_COMP_ALLWNC
            ,DRUG_TEST_RQRD
            ,PRE_EMP_PHYSCL_RQRD
            ,SEL_AGNT_ACCSS_RQRD
            ,SUBJ_TO_ADDTNL_IDENTICAL
            ,INCUMBENT_ONLY
            ,COMM_CORP_ELIGIBLE
            ,FINANCIAL_DSCLSR_RQRD
            ,CYBER_SEC_CD
            ,BUS_CD
            ,ACQUISITION_CD
            ,OPM_CERT_NO
            ,LMTD_TRM
            ,LMTD_EMRGNCY
            ,LMTD_TRM_NTE
        )
        VALUES 
        (
            I_PROCID
            ,V_COND_PHYSICIAN_COMP_ALLWNC
            ,V_COND_DRUG_TEST_RQRD
            ,V_COND_PRE_EMP_PHYSCL_RQRD
            ,V_COND_SEL_AGNT_ACCSS_RQRD
            ,V_COND_SUBJ_TO_ADDTNL_IDENT
            ,V_COND_INCUMBENT_ONLY
            ,V_COND_COMM_CORP_ELIGIBLE
            ,V_COND_FINANCIAL_DSCLSR_RQRD
            ,V_COND_CYBER_SEC_CD
            ,V_COND_BUS_CD
            ,V_COND_ACQUISITION_CD
            ,V_COND_OPM_CERTIFICATION_NO
            ,V_COND_LMTD_TRM
            ,V_COND_LMTD_EMRGNCY
            ,V_COND_LMTD_TRM_NTE            
        );

    END;    
    ELSE
    BEGIN
        --DBMS_OUTPUT.PUT_LINE('UPDATE HHS_CDC_HR.CLA_CONDITION');
        UPDATE HHS_CDC_HR.CLA_CONDITION
           SET 
            PHYSICIAN_COMP_ALLWNC = V_COND_PHYSICIAN_COMP_ALLWNC
            ,DRUG_TEST_RQRD = V_COND_DRUG_TEST_RQRD
            ,PRE_EMP_PHYSCL_RQRD = V_COND_PRE_EMP_PHYSCL_RQRD
            ,SEL_AGNT_ACCSS_RQRD = V_COND_SEL_AGNT_ACCSS_RQRD
            ,SUBJ_TO_ADDTNL_IDENTICAL = V_COND_SUBJ_TO_ADDTNL_IDENT
            ,INCUMBENT_ONLY = V_COND_INCUMBENT_ONLY
            ,COMM_CORP_ELIGIBLE = V_COND_COMM_CORP_ELIGIBLE
            ,FINANCIAL_DSCLSR_RQRD = V_COND_FINANCIAL_DSCLSR_RQRD
            ,CYBER_SEC_CD = V_COND_CYBER_SEC_CD
            ,BUS_CD = V_COND_BUS_CD
            ,ACQUISITION_CD = V_COND_ACQUISITION_CD
            ,OPM_CERT_NO = V_COND_OPM_CERTIFICATION_NO
            ,LMTD_TRM = V_COND_LMTD_TRM
            ,LMTD_EMRGNCY = V_COND_LMTD_EMRGNCY
            ,LMTD_TRM_NTE = V_COND_LMTD_TRM_NTE            
         WHERE CASE_ID = I_PROCID;

    END;
    END IF;    


    ---------- CLA_STANDARD
    DELETE 
      FROM HHS_CDC_HR.CLA_STANDARD
     WHERE CASE_ID = I_PROCID;

    SELECT FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CLASSIFICATIONS') 
      INTO V_CLA_STANDARDS
      FROM DUAL;

    IF V_CLA_STANDARDS IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.CLA_STATION');
        INSERT INTO HHS_CDC_HR.CLA_STANDARD 
        (
            CASE_ID
            ,SEQ
            ,STANDARD
        )        
        SELECT I_PROCID
               ,ROWNUM
               ,regexp_substr(V_CLA_STANDARDS,'[^::]+', 1, level) from dual
               --,FN_GET_LOOKUP_LABEL('PositionClassificationStandard', regexp_substr(V_CLA_STANDARDS,'[^::]+', 1, level)) from dual
                     connect by regexp_substr(V_CLA_STANDARDS, '[^::]+', 1, level) is not null;

    END IF;      


    ---------- FINANCIAL_STATEMENT
    DELETE 
      FROM HHS_CDC_HR.FINANCIAL_STATEMENT
     WHERE CASE_ID = I_PROCID;

    SELECT FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'FINANCIAL_STATEMENTS') 
      INTO V_CLA_FINANCIAL_STATEMENTS
      FROM DUAL;

    IF V_CLA_FINANCIAL_STATEMENTS IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.FINANCIAL_STATEMENT');
        INSERT INTO HHS_CDC_HR.FINANCIAL_STATEMENT 
        (
            CASE_ID
            ,SEQ
            ,STATEMENT
        )        
        SELECT I_PROCID
               ,ROWNUM
               ,regexp_substr(V_CLA_FINANCIAL_STATEMENTS,'[^::]+', 1, level) from dual
                     connect by regexp_substr(V_CLA_FINANCIAL_STATEMENTS, '[^::]+', 1, level) is not null;

    END IF;      


    ---------- GRADE TABLE
    --DBMS_OUTPUT.PUT_LINE('DELETE HHS_CDC_HR.GRADE');
    DELETE 
      FROM HHS_CDC_HR.GRADE
     WHERE CASE_ID = I_PROCID;

    SELECT FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_GRADE_IDS') 
      INTO V_POS_GRADE_IDS
      FROM DUAL;

    IF V_POS_GRADE_IDS IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.GRADE');
        INSERT INTO HHS_CDC_HR.GRADE 
        (
            CASE_ID
            ,SEQ
            ,GRADE
        )        
        SELECT I_PROCID
               ,ROWNUM
               --,regexp_substr(V_POS_GRADE_IDS,'[^::]+', 1, level) from dual
               ,FN_GET_LOOKUP_LABEL('Grade', regexp_substr(V_POS_GRADE_IDS,'[^::]+', 1, level)) from dual
                     connect by regexp_substr(V_POS_GRADE_IDS, '[^::]+', 1, level) is not null;

    END IF;  
    
    ---------- GRADE_INFO TABLE
    --DBMS_OUTPUT.PUT_LINE('DELETE HHS_CDC_HR.GRADE_INFO');
    DELETE 
      FROM HHS_CDC_HR.GRADE_INFO
     WHERE CASE_ID = I_PROCID;

    SELECT FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_GRADE_RELATED') 
      INTO V_POS_GRADE_RELATED
      FROM DUAL;

    IF V_POS_GRADE_RELATED IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.GRADE');
        INSERT INTO HHS_CDC_HR.GRADE_INFO 
        (
            CASE_ID
            ,GRADE_SEQ
            ,FAIR_LABOR_STND_ACT
            ,COMP_LVL_CD
            ,PD_NO
            ,JOB_CD
        )        
        WITH GRADE_DETAIL AS
        (
            SELECT I_PROCID AS CASE_ID
                    ,substr(grade_info, 1, instr(grade_info, '%%', 1, 1)-1) GRADE
                    ,substr(grade_info, instr(grade_info, '%%', 1, 1)+2 , instr(grade_info, '%%', 1, 2) - instr(grade_info, '%%', 1, 1) - 2) FLSA
                    ,substr(grade_info, instr(grade_info, '%%', 1, 2)+2 , instr(grade_info, '%%', 1, 3) - instr(grade_info, '%%', 1, 2) - 2) JOB_CODE
                    ,substr(grade_info, instr(grade_info, '%%', 1, 3)+2 , instr(grade_info, '%%', 1, 4) - instr(grade_info, '%%', 1, 3) - 2) PD_NUM
                    ,substr(grade_info, instr(grade_info, '%%', 1, 4)+2) COMP_LEVEL
            FROM (
                SELECT 
                        regexp_substr(V_POS_GRADE_RELATED,'[^::]+', 1, level) AS grade_info from dual
                         connect by regexp_substr(V_POS_GRADE_RELATED, '[^::]+', 1, level) is not null
                ) MYTBL
        )
        SELECT G.CASE_ID, G.SEQ, GD.FLSA, GD.COMP_LEVEL, GD.PD_NUM, GD.JOB_CODE
          FROM GRADE G 
          JOIN GRADE_DETAIL GD ON G.CASE_ID = GD.CASE_ID AND G.GRADE = GD.GRADE
         WHERE G.CASE_ID = I_PROCID;
         
    END IF;  

    ---------- POS_TITLE_SERIES
    DELETE 
      FROM HHS_CDC_HR.POS_TITLE_SERIES
     WHERE CASE_ID = I_PROCID;
    
    /*
      <item>
         <id>POS_TITLES_SERIESES</id>
         <etype>textbox</etype>
         <value>tae%%1001::MINA%%1051</value>
      </item>
    */
    SELECT FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_TITLES_SERIESES') 
      INTO V_POS_TITLES_SERIES
      FROM DUAL;
    
    IF V_POS_TITLES_SERIES IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.POS_TITLE_SERIES');
        --DBMS_OUTPUT.PUT_LINE('V_POS_TITLES_SERIES=' || V_POS_TITLES_SERIES);
        INSERT INTO HHS_CDC_HR.POS_TITLE_SERIES 
        (
            CASE_ID
            ,SEQ
            ,OFFICIAL_POS_TTL
        )        
        SELECT I_PROCID
               ,ROWNUM
               ,regexp_substr(V_POS_TITLES_SERIES,'[^::]+', 1, level) from dual
                     connect by regexp_substr(V_POS_TITLES_SERIES, '[^::]+', 1, level) is not null;
    
        UPDATE HHS_CDC_HR.POS_TITLE_SERIES
           SET OFFICIAL_POS_TTL = SUBSTR(OFFICIAL_POS_TTL, 1, INSTR(OFFICIAL_POS_TTL, '%%')-1)
               , SERIES = SUBSTR(OFFICIAL_POS_TTL, INSTR(OFFICIAL_POS_TTL, '%%')+2)
         WHERE CASE_ID = I_PROCID;
    
    END IF;        
    
END SP_UPDATE_CLASSIFICATION_TBLS;

/
--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_FORM_DATA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HHS_CDC_HR"."SP_UPDATE_FORM_DATA" 
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
	IF UPPER(V_FORM_TYPE) = 'RECRUITMENT' THEN
        SP_UPDATE_RECRUITMENT_TBLS(V_PROCID);    
        DBMS_OUTPUT.PUT_LINE('SP_UPDATE_RECRUITMENT_TBLS V_PROCID=' || V_PROCID);
    -- HHS_MAIN is a temporary name of Classification, it will need to be changed to Classification once the CLA_Main WebMaker's broken application map is fixed.
	ELSIF UPPER(V_FORM_TYPE) = 'CLASSIFICATION' or UPPER(V_FORM_TYPE) = 'HHS_MAIN' THEN
        SP_UPDATE_CLASSIFICATION_TBLS(V_PROCID);
        DBMS_OUTPUT.PUT_LINE('SP_UPDATE_CLASSIFICATION_TBLS V_PROCID=' || V_PROCID);
	ELSIF UPPER(V_FORM_TYPE) = 'APPOINTMENT' THEN
		--TODO: implement appointment update stored procedure SP_UPDATE_APPOINTMENT_TBLS(V_PROCID);
        DBMS_OUTPUT.PUT_LINE('SP_UPDATE_APPOINTMENT_TBLS V_PROCID=' || V_PROCID);
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
--------------------------------------------------------
--  DDL for Procedure SP_UPDATE_RECRUITMENT_TBLS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "HHS_CDC_HR"."SP_UPDATE_RECRUITMENT_TBLS" 
(
  I_PROCID IN NUMBER 
) 
    ------------------------------------------------------------------------------------------
    --  Procedure name	    : 	SP_UPDATE_RECRUITMENT_TBLS
    --	Author				:	Taeho Lee <thee@bizflow.com>
    --	Copyright			:	BizFlow Corp.	
    --	
    --	Project				:	HHS CDC HR Workflow Solution - EWITS 2.0
    --	Purpose				:	Insert/Update Recruitment tables with XML document in TBL_FORM_DTL.FIELD_DATA
    --	
    --  Example
    --  To use in SQL statements:
    --
    -- 	WHEN		WHO			WHAT		
    -- 	-----------	--------	-------------------------------------------------------
    -- 	04/17/2018	THLEE		Created
    ------------------------------------------------------------------------------------------
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
-------- RECRUITMENT
	V_REC_RQST_TP                       VARCHAR2(100);
    V_REC_ADMN_CD                       VARCHAR2(20);
	V_REC_ORG_NM                        VARCHAR2(200);
	V_REC_HIRING_MTHD                   VARCHAR2(20);
	V_REC_SO_NM                         VARCHAR2(100);
	V_REC_SO_EML                        VARCHAR2(100);
	V_REC_CIO_ADMN_NM                   VARCHAR2(100);
	V_REC_CIO_ADMN_EML                  VARCHAR2(100);
	V_REC_HRO_SPC_NM                    VARCHAR2(100);
	V_REC_HRO_SPC_EML                   VARCHAR2(100);
	V_REC_CLA_SPC_NM                    VARCHAR2(100);
	V_REC_CLA_SPC_EML                   VARCHAR2(100);
	V_REC_COM_CHR_NM                    VARCHAR2(100);
	V_REC_COM_CHR_EML                   VARCHAR2(100);
	V_REC_COM_CHR_ORG_NM                VARCHAR2(200);
	V_REC_SME_RQRD                      VARCHAR2(10);
	V_REC_STFFNG_NEED_VLDTD             VARCHAR2(10);
	V_REC_JSTFCTN_NOT_VLD_STAFF_ND      VARCHAR2(4000);
	V_REC_HIRING_OPT_GUIDE_RVWD         VARCHAR2(10);
	V_REC_JSTFCTN_NOT_RVWNG             VARCHAR2(4000);    
    V_REC_REQ_APPRVD_BY_HHS             VARCHAR2(10);
    V_REC_JSTFCTN_NOT_RCVNG_HHS         VARCHAR2(4000);    
	V_REC_POS_BSD_MGMT_SYS_NO           VARCHAR2(100); 
---------- POSITION
	V_POS_JOB_REQ_NO                    VARCHAR2(100);
	V_POS_OFFICIAL_POS_TTL              VARCHAR2(4000);
	V_POS_ORG_POS_TTL                   VARCHAR2(4000);
	V_POS_CLSSFD_POS_TTL                VARCHAR2(4000);
	V_POS_FNCTNL_POS_TTL                VARCHAR2(4000);
	V_POS_PAY_PLAN                      VARCHAR2(4000);
	V_POS_SERIES                        VARCHAR2(4000);
	V_POS_PROMO_POTENTIAL               VARCHAR2(400);
	V_POS_POS_SENSITIVITY               VARCHAR2(4000);
	V_POS_FULL_PERF_LVL                 VARCHAR2(400);
	V_POS_POS_TP                        VARCHAR2(400);
	V_POS_COMMON_ACCT_NO                VARCHAR2(400);
	V_POS_BACKFILL_VC                   VARCHAR2(400);
	V_POS_BACKFILL_VC_NM                VARCHAR2(400);
	V_POS_BACKFILL_VC_RSN               VARCHAR2(1000);
	V_POS_NUM_OF_VACANCY                VARCHAR2(400);
	V_POS_APPOINTMENT_TP                VARCHAR2(400);
	V_POS_NOT_TO_EXCEED                 VARCHAR2(400);
	V_POS_NAME_REQUEST                  VARCHAR2(400);
	V_POS_POS_OPEN_CONT                 VARCHAR2(400);
	V_POS_NUM_OF_DAYS_AD                VARCHAR2(400);
	V_POS_WORK_SCH_TP                   VARCHAR2(400);
	V_POS_HRS_PER_WEEK                  VARCHAR2(400);
	V_POS_REMARKS                       VARCHAR2(4000);
	V_POS_SERVICE                       VARCHAR2(400);
	V_POS_EMPLOYING_OFF_LOC             VARCHAR2(400); 
---------- CONSIDERATION AREA
	V_CAREA_SEQ                         INTEGER;
	V_CAREA_CONS_PRIMARY               VARCHAR2(400);
    V_CAREA_CONS_PRIMARY_ID            VARCHAR2(400);
    V_CAREA_CONS_ADDL                  VARCHAR2(400);
    V_CAREA_CONS_ADDL_ID               VARCHAR2(400);
    V_CAREA_CONS_DE_TP                 VARCHAR2(400);
    V_CAREA_CONS_DE_TP_1               VARCHAR2(400);
    V_CAREA_CONS_MP_TP                 VARCHAR2(400);    
    V_CAREA_CONS_MP_TP_1               VARCHAR2(400);    
    V_CAREA_CONS_PATHWAY_TP            VARCHAR2(400);    
    V_CAREA_CONS_PATHWAY_TP_1          VARCHAR2(400);    

    V_CAREA_CONS_TP                    VARCHAR2(400);
    V_CAREA_CONS_TP_1                  VARCHAR2(400);
---------- DUTY_STATION
	V_DS_SEQ                            INTEGER;
	V_DS_STATIONS                       VARCHAR2(4000); 
---------- EMP_CONDITION
	V_EMPC_FINANCIAL_DSCLSR_RQRD        VARCHAR2(10);
	V_EMPC_PRE_EMP_PHYSCL_RQRD          VARCHAR2(10);
	V_EMPC_DRG_TST_RQRD                 VARCHAR2(10);
	V_EMPC_IMMUNZTN_RQRD                VARCHAR2(10);
	V_EMPC_MOBILITY_AGRMNT_RQRD         VARCHAR2(10);
	V_EMPC_LIC_RQRD                     VARCHAR2(10);
	V_EMPC_LIC_INFO                     VARCHAR2(1000);
	V_EMPC_TRVL_RQRD                    VARCHAR2(10);
	V_EMPC_DMSTC_TRVL_PRCNTG            VARCHAR2(100);
	V_EMPC_INTRNTNL_TRVL_PRCNTG         VARCHAR2(100);
	V_EMPC_FOREIGN_LANG_RQRD            VARCHAR2(10);
	V_EMPC_OTHER_CON                    VARCHAR2(4000); 
---------- LANGUAGE
    V_LANG_SEQ                          INTEGER;
    V_LANGS                             VARCHAR2(4000);
---------- REC_SME
	V_RSME_SEQ                          INTEGER;
	V_RSME_NAME                         VARCHAR2(200);
    V_RSME_EMAIL                        VARCHAR2(100);
	V_RSME_SME_TP                       VARCHAR2(10);
	V_RSME_IS_PRIMARY                   VARCHAR2(10);
	V_RSME_ORG_NM                       VARCHAR2(200);  
---------- AUTHORIZED_INCENTIVE
	V_RINC_ANN_LEAVE_NON_FED_SVC        VARCHAR2(10);
	V_RINC_MOVING_EXP_ATHRZD            VARCHAR2(10);
	V_RINC_RELOCATION_INC_ATHRZD        VARCHAR2(10);
	V_RINC_RECRUITMENT_INC_ATHRZD       VARCHAR2(10);
	V_RINC_STU_LOAN_REPAY_ATHRZD        VARCHAR2(10);
	V_RINC_OTHER_INC                    VARCHAR2(4000);
---------- VALIDATION
	V_RVAL_PRE_RECRUITMENT_MTNG_DT      VARCHAR2(20);
	V_RVAL_PPP_PCP_CLRD                 VARCHAR2(10);
	V_RVAL_PPP_PCP_CLRD_DT              VARCHAR2(20);
	V_RVAL_PPP_PCP_JUSTFCTN             VARCHAR2(4000); 
---------- FINANCIAL_STATEMENT
    V_CLA_FINANCIAL_STATEMENTS          VARCHAR2(10000);
---------- CLASSIFIED_POSITION_TITLE
    V_POS_TITLES                        VARCHAR2(10000);
---------- GRADES
    V_POS_GRADE_IDS                     VARCHAR2(10000);
---------- POS_TITLES_SERIES
    V_POS_TITLES_SERIES                 VARCHAR2(10000);
    V_POS_TITLES_SERIES_TTL             VARCHAR2(4000);
    V_POS_TITLES_SERIES_SERIES          VARCHAR2(4000);


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
            ,'RECRUITMENT'
            ,V_FD_CRT_USR
            ,V_FD_CRT_DT
        );

    ELSE
        UPDATE HHS_CDC_HR.HR_CASE
           SET CASE_TP = 'RECRUITMENT'
               ,MODIFIER_NM = V_FD_MOD_USR
               ,MODIFICATION_DT = V_FD_MOD_DT
         WHERE CASE_ID = I_PROCID;
    END IF;

    ---------- RECRUITMENT TABLE
    SELECT 
            FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'REQUEST_TYPE')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'ADMIN_CD')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'ORG_NAME')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'HM_ID')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SO_AutoComplete')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SO_EMAIL')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CIO_AutoComplete')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CIO_EMAIL')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'HROS_AutoComplete')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'HROS_EMAIL')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CLASS_SPEC_AutoComplete')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'CLASS_SPEC_EMAIL')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SCC_NAME')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SCC_EMAIL')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SCC_ORG')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_REQ')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'STF_VAL')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'STF_VAL_JUST')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'HIRE_GUIDE_REV')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'HIRE_GUIDE_REV_JUST')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'HHS_APPROVE')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'HHS_APPROVE_JUST')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'PBMS_ID')
      INTO 
            V_REC_RQST_TP
            ,V_REC_ADMN_CD
            ,V_REC_ORG_NM
            ,V_REC_HIRING_MTHD
            ,V_REC_SO_NM
            ,V_REC_SO_EML
            ,V_REC_CIO_ADMN_NM
            ,V_REC_CIO_ADMN_EML
            ,V_REC_HRO_SPC_NM
            ,V_REC_HRO_SPC_EML
            ,V_REC_CLA_SPC_NM
            ,V_REC_CLA_SPC_EML
            ,V_REC_COM_CHR_NM
            ,V_REC_COM_CHR_EML
            ,V_REC_COM_CHR_ORG_NM
            ,V_REC_SME_RQRD
            ,V_REC_STFFNG_NEED_VLDTD
            ,V_REC_JSTFCTN_NOT_VLD_STAFF_ND
            ,V_REC_HIRING_OPT_GUIDE_RVWD
            ,V_REC_JSTFCTN_NOT_RVWNG
            ,V_REC_REQ_APPRVD_BY_HHS
            ,V_REC_JSTFCTN_NOT_RCVNG_HHS
            ,V_REC_POS_BSD_MGMT_SYS_NO
       FROM DUAL;

    V_RECCNT := 0;
    SELECT COUNT(1)
      INTO V_RECCNT
      FROM HHS_CDC_HR.RECRUITMENT
     WHERE CASE_ID = I_PROCID;

    IF V_RECCNT = 0 THEN
    BEGIN
        --DBMS_OUTPUT.PUT_LINE('INSERT INTO HHS_CDC_HR.RECRUITMENT');
        INSERT INTO HHS_CDC_HR.RECRUITMENT 
        (                        
                    CASE_ID
                    ,RQST_TP
                    ,ADMN_CD
                    ,ORG_NM
                    ,HIRING_MTHD
                    ,SO_NM
                    ,SO_EML
                    ,CIO_ADMN_NM
                    ,CIO_ADMN_EML
                    ,HRO_SPC_NM
                    ,HRO_SPC_EML
                    ,CLA_SPC_NM
                    ,CLA_SPC_EML
                    ,COM_CHR_NM
                    ,COM_CHR_EML
                    ,COM_CHR_ORG_NM
                    ,SME_RQRD
                    ,STFFNG_NEED_VLDTD
                    ,JSTFCTN_NOT_VLD_STAFF_ND
                    ,HIRING_OPT_GUIDE_RVWD
                    ,JSTFCTN_NOT_RVWNG_HR_OPT_GD
                    ,REQ_APPRVD_BY_HHS
                    ,JSTFCTN_NOT_RCVNG_HHS_APPRL
                    ,POS_BSD_MGMT_SYS_NO        
        )
        VALUES 
        (
                    I_PROCID
                    ,V_REC_RQST_TP
                    ,V_REC_ADMN_CD
                    ,V_REC_ORG_NM
                    ,V_REC_HIRING_MTHD
                    ,V_REC_SO_NM
                    ,V_REC_SO_EML
                    ,V_REC_CIO_ADMN_NM
                    ,V_REC_CIO_ADMN_EML
                    ,V_REC_HRO_SPC_NM
                    ,V_REC_HRO_SPC_EML
                    ,V_REC_CLA_SPC_NM
                    ,V_REC_CLA_SPC_EML
                    ,V_REC_COM_CHR_NM
                    ,V_REC_COM_CHR_EML
                    ,V_REC_COM_CHR_ORG_NM
                    ,V_REC_SME_RQRD
                    ,V_REC_STFFNG_NEED_VLDTD
                    ,V_REC_JSTFCTN_NOT_VLD_STAFF_ND
                    ,V_REC_HIRING_OPT_GUIDE_RVWD
                    ,V_REC_JSTFCTN_NOT_RVWNG
                    ,V_REC_REQ_APPRVD_BY_HHS
                    ,V_REC_JSTFCTN_NOT_RCVNG_HHS
                    ,V_REC_POS_BSD_MGMT_SYS_NO
        );

    END;    
    ELSE
    BEGIN
        --DBMS_OUTPUT.PUT_LINE('UPDATE HHS_CDC_HR.RECRUITMENT');
        UPDATE HHS_CDC_HR.RECRUITMENT
           SET 
                RQST_TP = V_REC_RQST_TP
                ,ADMN_CD = V_REC_ADMN_CD
                ,ORG_NM = V_REC_ORG_NM
                ,HIRING_MTHD = V_REC_HIRING_MTHD
                ,SO_NM = V_REC_SO_NM
                ,SO_EML = V_REC_SO_EML
                ,CIO_ADMN_NM = V_REC_CIO_ADMN_NM
                ,CIO_ADMN_EML = V_REC_CIO_ADMN_EML
                ,HRO_SPC_NM = V_REC_HRO_SPC_NM
                ,HRO_SPC_EML = V_REC_HRO_SPC_EML
                ,CLA_SPC_NM = V_REC_CLA_SPC_NM
                ,CLA_SPC_EML = V_REC_CLA_SPC_EML
                ,COM_CHR_NM = V_REC_COM_CHR_NM
                ,COM_CHR_EML = V_REC_COM_CHR_EML
                ,COM_CHR_ORG_NM = V_REC_COM_CHR_ORG_NM
                ,SME_RQRD = V_REC_SME_RQRD
                ,STFFNG_NEED_VLDTD = V_REC_STFFNG_NEED_VLDTD
                ,JSTFCTN_NOT_VLD_STAFF_ND = V_REC_JSTFCTN_NOT_VLD_STAFF_ND
                ,HIRING_OPT_GUIDE_RVWD = V_REC_HIRING_OPT_GUIDE_RVWD
                ,JSTFCTN_NOT_RVWNG_HR_OPT_GD = V_REC_JSTFCTN_NOT_RVWNG
                ,REQ_APPRVD_BY_HHS = V_REC_REQ_APPRVD_BY_HHS
                ,JSTFCTN_NOT_RCVNG_HHS_APPRL = V_REC_JSTFCTN_NOT_RCVNG_HHS    
                ,POS_BSD_MGMT_SYS_NO = V_REC_POS_BSD_MGMT_SYS_NO
         WHERE CASE_ID = I_PROCID;

    END;
    END IF;    

    ---------- REC_SME TABLE
    DELETE FROM HHS_CDC_HR.REC_SME
     WHERE CASE_ID = I_PROCID;

    --SME 1
    IF FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_NAME_1') IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.REC_SME 1');
        INSERT INTO HHS_CDC_HR.REC_SME
        (
            CASE_ID
            ,SEQ
            ,NAME
            ,EMAIL
            ,SME_TP
            ,IS_PRIMARY
            ,ORG_NM
        )
        VALUES
        (
            I_PROCID
            ,1
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_NAME_1')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_EMAIL_1')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_INTERNAL_1')
            ,'Yes'
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_ORG_1')
        );

    END IF;

    --SME 2
    IF FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_NAME_2') IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.REC_SME 2');
        INSERT INTO HHS_CDC_HR.REC_SME
        (
            CASE_ID
            ,SEQ
            ,NAME
            ,EMAIL
            ,SME_TP
            ,IS_PRIMARY
            ,ORG_NM
        )
        VALUES
        (
            I_PROCID
            ,2
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_NAME_2')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_EMAIL_2')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_INTERNAL_2')
            ,'NO'
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_ORG_2')
        );

    END IF;

    --SME 3
    IF FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_NAME_3') IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.REC_SME 3');
        INSERT INTO HHS_CDC_HR.REC_SME
        (
            CASE_ID
            ,SEQ
            ,NAME
            ,EMAIL
            ,SME_TP
            ,IS_PRIMARY
            ,ORG_NM
        )
        VALUES
        (
            I_PROCID
            ,3
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_NAME_3')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_EMAIL_3')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_INTERNAL_3')
            ,'NO'
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_ORG_3')
        );

    END IF;

    --SME 4
   IF FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_NAME_4') IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.REC_SME 4');
        INSERT INTO HHS_CDC_HR.REC_SME
        (
            CASE_ID
            ,SEQ
            ,NAME
            ,EMAIL
            ,SME_TP
            ,IS_PRIMARY
            ,ORG_NM
        )
        VALUES
        (
            I_PROCID
            ,4
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_NAME_4')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_EMAIL_4')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_INTERNAL_4')
            ,'NO'
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_ORG_4')
        );

    END IF;

    --SME 5
   IF FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_NAME_5') IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.REC_SME 5');
        INSERT INTO HHS_CDC_HR.REC_SME
        (
            CASE_ID
            ,SEQ
            ,NAME
            ,EMAIL
            ,SME_TP
            ,IS_PRIMARY
            ,ORG_NM
        )
        VALUES
        (
            I_PROCID
            ,5
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_NAME_5')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_EMAIL_5')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_INTERNAL_5')
            ,'NO'
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'SME_ORG_5')
        );

    END IF;

    ---------- AUTHORIZED_INCENTIVE TABLE
    SELECT FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'ANNUAL_LEAVE_FOR_NON_FEDERAL_SERVICE')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'MOVING_EXPENSES_AUTHORIZED')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'RELOCATION_INCENTIVE_AUTHORIZED')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'RECRUITMENT_INCENTIVE_AUTHORIZED')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'STUDENT_LOAN_REPAYMENT_AUTHORIZED')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'OTHER_INCENTIVES')
      INTO 
            V_RINC_ANN_LEAVE_NON_FED_SVC
            ,V_RINC_MOVING_EXP_ATHRZD
            ,V_RINC_RELOCATION_INC_ATHRZD
            ,V_RINC_RECRUITMENT_INC_ATHRZD
            ,V_RINC_STU_LOAN_REPAY_ATHRZD
            ,V_RINC_OTHER_INC
       FROM DUAL;    

    V_RECCNT := 0;
    SELECT COUNT(1)
      INTO V_RECCNT
      FROM HHS_CDC_HR.AUTHORIZED_INCENTIVE
     WHERE CASE_ID = I_PROCID;

    IF V_RECCNT = 0 THEN
    BEGIN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.AUTHORIZED_INCENTIVE');
        INSERT INTO HHS_CDC_HR.AUTHORIZED_INCENTIVE (
            CASE_ID
            ,ANN_LEAVE_NON_FED_SVC
            ,MOVING_EXP_ATHRZD
            ,RELOCATION_INC_ATHRZD
            ,RECRUITMENT_INC_ATHRZD
            ,STU_LOAN_REPAY_ATHRZD
            ,OTHER_INC
        ) VALUES (
            I_PROCID
            ,V_RINC_ANN_LEAVE_NON_FED_SVC
            ,V_RINC_MOVING_EXP_ATHRZD
            ,V_RINC_RELOCATION_INC_ATHRZD
            ,V_RINC_RECRUITMENT_INC_ATHRZD
            ,V_RINC_STU_LOAN_REPAY_ATHRZD
            ,V_RINC_OTHER_INC
        );

    END;
    ELSE
    BEGIN
        --DBMS_OUTPUT.PUT_LINE('UPDATE HHS_CDC_HR.AUTHORIZED_INCENTIVE');
        UPDATE HHS_CDC_HR.AUTHORIZED_INCENTIVE
           SET 
            ANN_LEAVE_NON_FED_SVC = V_RINC_ANN_LEAVE_NON_FED_SVC
            ,MOVING_EXP_ATHRZD = V_RINC_MOVING_EXP_ATHRZD
            ,RELOCATION_INC_ATHRZD = V_RINC_RELOCATION_INC_ATHRZD
            ,RECRUITMENT_INC_ATHRZD = V_RINC_RECRUITMENT_INC_ATHRZD
            ,STU_LOAN_REPAY_ATHRZD = V_RINC_STU_LOAN_REPAY_ATHRZD
            ,OTHER_INC = V_RINC_OTHER_INC
        WHERE CASE_ID = I_PROCID;

    END;
    END IF;

    ---------- VALIDATION TABLE
    SELECT FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'PRE_RECRUIT_MTG_DATE_STR')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'PRE_PPP_PCP_CLEARED')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'PRE_PPP_PCP_DT_CLEARED')
            ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'PRE_PPP_PCP_JUST_RSN')
      INTO 
            V_RVAL_PRE_RECRUITMENT_MTNG_DT
            ,V_RVAL_PPP_PCP_CLRD
            ,V_RVAL_PPP_PCP_CLRD_DT
            ,V_RVAL_PPP_PCP_JUSTFCTN
       FROM DUAL;    

    V_RECCNT := 0;
    SELECT COUNT(1)
      INTO V_RECCNT
      FROM HHS_CDC_HR.VALIDATION
     WHERE CASE_ID = I_PROCID;

    IF V_RECCNT = 0 THEN
    BEGIN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.VALIDATION');
        INSERT INTO HHS_CDC_HR.VALIDATION (
            CASE_ID
            ,PRE_RECRUITMENT_MTNG_DT
            ,PPP_PCP_CLRD
            ,PPP_PCP_CLRD_DT
            ,JUSTFCTN_PPP_PCP_NOT_CLEARED
        ) VALUES (
            I_PROCID
            ,V_RVAL_PRE_RECRUITMENT_MTNG_DT
            ,V_RVAL_PPP_PCP_CLRD
            ,V_RVAL_PPP_PCP_CLRD_DT
            ,V_RVAL_PPP_PCP_JUSTFCTN
        );

    END;
    ELSE
    BEGIN
        --DBMS_OUTPUT.PUT_LINE('UPDATE HHS_CDC_HR.VALIDATION');
        UPDATE HHS_CDC_HR.VALIDATION
           SET 
            PRE_RECRUITMENT_MTNG_DT = V_RVAL_PRE_RECRUITMENT_MTNG_DT
            ,PPP_PCP_CLRD = V_RVAL_PPP_PCP_CLRD
            ,PPP_PCP_CLRD_DT = V_RVAL_PPP_PCP_CLRD_DT
            ,JUSTFCTN_PPP_PCP_NOT_CLEARED = V_RVAL_PPP_PCP_JUSTFCTN
        WHERE CASE_ID = I_PROCID;

    END;
    END IF;    

    ---------- EMP_CONDITION TABLE    
    SELECT FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'FINANCIAL_DISCLOSURE_REQUIRED')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'PRE_EMP_PHYSICAL_REQUIRED')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'DRUG_TEST_REQUIRED')         
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'IMMUNIZATION_REQUIRED')        
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'MOBILITY_AGREEMENT_REQUIRED') 
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'LICENSE_REQUIRED')             
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'LICENSE_INFO')             
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'TRAVEL_REQUIRED')            
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'DOMESTIC_TRAVEL_PERCENTAGE')    
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'INTERNATIONAL_TRAVEL_PERCENTAGE') 
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'LANGUAGE_REQUIRED')    
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'OTHER_CONDITIONS')
      INTO 
           V_EMPC_FINANCIAL_DSCLSR_RQRD
           ,V_EMPC_PRE_EMP_PHYSCL_RQRD  
           ,V_EMPC_DRG_TST_RQRD         
           ,V_EMPC_IMMUNZTN_RQRD        
           ,V_EMPC_MOBILITY_AGRMNT_RQRD 
           ,V_EMPC_LIC_RQRD             
           ,V_EMPC_LIC_INFO             
           ,V_EMPC_TRVL_RQRD            
           ,V_EMPC_DMSTC_TRVL_PRCNTG    
           ,V_EMPC_INTRNTNL_TRVL_PRCNTG 
           ,V_EMPC_FOREIGN_LANG_RQRD    
           ,V_EMPC_OTHER_CON                  
      FROM DUAL; 

    V_RECCNT := 0;
    SELECT COUNT(1)
      INTO V_RECCNT
      FROM HHS_CDC_HR.EMP_CONDITION
     WHERE CASE_ID = I_PROCID;    

    IF V_RECCNT = 0 THEN
    BEGIN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.EMP_CONDITION');
        INSERT INTO HHS_CDC_HR.EMP_CONDITION 
        (
                CASE_ID
                ,FINANCIAL_DSCLSR_RQRD
                ,PRE_EMP_PHYSCL_RQRD  
                ,DRG_TST_RQRD         
                ,IMMUNZTN_RQRD        
                ,MOBILITY_AGRMNT_RQRD 
                ,LIC_RQRD             
                ,LIC_INFO             
                ,TRVL_RQRD            
                ,DMSTC_TRVL_PRCNTG    
                ,INTRNTNL_TRVL_PRCNTG 
                ,FOREIGN_LANG_RQRD    
                ,OTHER_CON            
        )
        VALUES 
        (
               I_PROCID 
               ,V_EMPC_FINANCIAL_DSCLSR_RQRD
               ,V_EMPC_PRE_EMP_PHYSCL_RQRD  
               ,V_EMPC_DRG_TST_RQRD         
               ,V_EMPC_IMMUNZTN_RQRD        
               ,V_EMPC_MOBILITY_AGRMNT_RQRD 
               ,V_EMPC_LIC_RQRD             
               ,V_EMPC_LIC_INFO             
               ,V_EMPC_TRVL_RQRD            
               ,V_EMPC_DMSTC_TRVL_PRCNTG    
               ,V_EMPC_INTRNTNL_TRVL_PRCNTG 
               ,V_EMPC_FOREIGN_LANG_RQRD    
               ,V_EMPC_OTHER_CON                 
        );

    END;
    ELSE
    BEGIN
        --DBMS_OUTPUT.PUT_LINE('UPDATE HHS_CDC_HR.EMP_CONDITION');
        UPDATE HHS_CDC_HR.EMP_CONDITION 
           SET FINANCIAL_DSCLSR_RQRD = V_EMPC_FINANCIAL_DSCLSR_RQRD
               ,PRE_EMP_PHYSCL_RQRD = V_EMPC_PRE_EMP_PHYSCL_RQRD
               ,DRG_TST_RQRD = V_EMPC_DRG_TST_RQRD
               ,IMMUNZTN_RQRD = V_EMPC_IMMUNZTN_RQRD       
               ,MOBILITY_AGRMNT_RQRD = V_EMPC_MOBILITY_AGRMNT_RQRD
               ,LIC_RQRD = V_EMPC_LIC_RQRD         
               ,LIC_INFO = V_EMPC_LIC_INFO            
               ,TRVL_RQRD = V_EMPC_TRVL_RQRD           
               ,DMSTC_TRVL_PRCNTG = V_EMPC_DMSTC_TRVL_PRCNTG
               ,INTRNTNL_TRVL_PRCNTG = V_EMPC_INTRNTNL_TRVL_PRCNTG
               ,FOREIGN_LANG_RQRD = V_EMPC_FOREIGN_LANG_RQRD 
               ,OTHER_CON = V_EMPC_OTHER_CON
         WHERE CASE_ID = I_PROCID;     

    END;
    END IF;


    ---------- LANGUAGE TABLE
    --DBMS_OUTPUT.PUT_LINE('DELETE HHS_CDC_HR.LANGUAGE');    
    DELETE 
      FROM HHS_CDC_HR.LANGUAGE
     WHERE CASE_ID = I_PROCID;

    SELECT FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'LANGUAGES')
      INTO V_LANGS
      FROM DUAL;

    IF V_LANGS IS NOT NULL THEN
    
        INSERT INTO HHS_CDC_HR.LANGUAGE 
        (
            CASE_ID
            ,SEQ
            ,LANG
        )
        SELECT I_PROCID
               ,ROWNUM
               ,regexp_substr(V_LANGS,'[^::]+', 1, level) from dual
               connect by regexp_substr(V_LANGS, '[^::]+', 1, level) is not null;
               
    END IF;

    ---------- POSITION TABLE
    DBMS_OUTPUT.PUT_LINE('GETTING POSITION VALUES');
    SELECT 
            FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_JOB_REQ_NUM')
           ,'' --V_POS_OFFICIAL_POS_TTL
           ,'' --V_POS_ORG_POS_TTL
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_TITLE')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_FUNCTIONAL_TITLE') --???
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_PAY_PLAN_CODE')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_SERIES')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_IS_PROMOTIONAL')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_SENSITIVITY_ID')
           ,FN_GET_XML_NODE_VALUE(V_FD_FIELD_DATA, 'POS_FULL_PERF_LEVEL') --this field sometime has both value and text, and sometimes value only. It would be safer to use value, and find a maaping label.
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_SUPERVISORY_OR_NOT')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_CAN')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_IS_BF_OR_VICE')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_BF_VICE_NAME')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_NO_BF_VICE_RSN')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_NUM_VACANCIES')
           ,FN_GET_XML_VALUE(V_FD_FIELD_DATA, 'POS_APPT_TYPE_ID', 'VALUE') -----$$$$$
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_NTE')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_NAME_REQUEST')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_IS_OPEN_CONTINUOUS')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_DAYS_TO_ADVERTISE')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_WORK_SCHED')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_HOURS_PER_WEEK')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_REMARKS')
           ,'' --V_POS_SERVICE
           ,'' --V_POS_EMPLOYING_OFF_LOC
      INTO 
           V_POS_JOB_REQ_NO       
           ,V_POS_OFFICIAL_POS_TTL 
           ,V_POS_ORG_POS_TTL      
           ,V_POS_CLSSFD_POS_TTL   
           ,V_POS_FNCTNL_POS_TTL   
           ,V_POS_PAY_PLAN         
           ,V_POS_SERIES                      
           ,V_POS_PROMO_POTENTIAL  
           ,V_POS_POS_SENSITIVITY  
           ,V_POS_FULL_PERF_LVL    
           ,V_POS_POS_TP           
           ,V_POS_COMMON_ACCT_NO              
           ,V_POS_BACKFILL_VC      
           ,V_POS_BACKFILL_VC_NM   
           ,V_POS_BACKFILL_VC_RSN  
           ,V_POS_NUM_OF_VACANCY   
           ,V_POS_APPOINTMENT_TP   
           ,V_POS_NOT_TO_EXCEED    
           ,V_POS_NAME_REQUEST     
           ,V_POS_POS_OPEN_CONT    
           ,V_POS_NUM_OF_DAYS_AD   
           ,V_POS_WORK_SCH_TP      
           ,V_POS_HRS_PER_WEEK     
           ,V_POS_REMARKS          
           ,V_POS_SERVICE          
           ,V_POS_EMPLOYING_OFF_LOC
      FROM DUAL; 

    DBMS_OUTPUT.PUT_LINE('V_POS_APPOINTMENT_TP=' || V_POS_APPOINTMENT_TP);
    
    --DBMS_OUTPUT.PUT_LINE('GETTING POSITION RECORD');
    V_RECCNT := 0;
    SELECT COUNT(1)
      INTO V_RECCNT
      FROM HHS_CDC_HR.POSITION
     WHERE CASE_ID = I_PROCID;    

    IF V_RECCNT = 0 THEN
    BEGIN
        DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.POSITION');    
        INSERT INTO HHS_CDC_HR.POSITION
        (
            CASE_ID          
            ,JOB_REQ_NO       
            ,ORG_POS_TTL      
            ,CLSSFD_POS_TTL   
            ,FNCTNL_POS_TTL   
            ,PAY_PLAN         
            ,PROMO_POTENTIAL  
            ,POS_SENSITIVITY  
            ,FULL_PERF_LVL    
            ,POS_TP           
            ,COMMON_ACCT_NO   
            ,BACKFILL_VC      
            ,BACKFILL_VC_NM   
            ,BACKFILL_VC_RSN  
            ,NUM_OF_VACANCY   
            ,APPOINTMENT_TP   
            ,NOT_TO_EXCEED    
            ,NAME_REQUEST     
            ,POS_OPEN_CONT    
            ,NUM_OF_DAYS_AD   
            ,WORK_SCH_TP      
            ,HRS_PER_WEEK     
            ,REMARKS          
            ,SERVICE          
            ,EMPLOYING_OFF_LOC
        )
        VALUES
        (
            I_PROCID 
            ,V_POS_JOB_REQ_NO       
            ,V_POS_ORG_POS_TTL      
            ,V_POS_CLSSFD_POS_TTL   
            ,V_POS_FNCTNL_POS_TTL   
            ,V_POS_PAY_PLAN         
            ,V_POS_PROMO_POTENTIAL  
            ,V_POS_POS_SENSITIVITY  
            ,FN_GET_LOOKUP_LABEL('Grade', V_POS_FULL_PERF_LVL)        
            ,V_POS_POS_TP           
            ,V_POS_COMMON_ACCT_NO   
            ,V_POS_BACKFILL_VC      
            ,V_POS_BACKFILL_VC_NM   
            ,V_POS_BACKFILL_VC_RSN  
            ,V_POS_NUM_OF_VACANCY   
            ,FN_GET_LOOKUP_LABEL('AppointmentType', V_POS_APPOINTMENT_TP)
            ,V_POS_NOT_TO_EXCEED    
            ,V_POS_NAME_REQUEST     
            ,V_POS_POS_OPEN_CONT    
            ,FN_GET_LOOKUP_LABEL('CalendarDaysToAdvertise', V_POS_NUM_OF_DAYS_AD)   
            ,V_POS_WORK_SCH_TP      
            ,V_POS_HRS_PER_WEEK     
            ,V_POS_REMARKS          
            ,V_POS_SERVICE          
            ,V_POS_EMPLOYING_OFF_LOC        
        );

    END;
    ELSE
    BEGIN
        DBMS_OUTPUT.PUT_LINE('UPDATE HHS_CDC_HR.POSITION');
        DBMS_OUTPUT.PUT_LINE('V_POS_APPOINTMENT_TP=' || TO_CHAR(V_POS_APPOINTMENT_TP));
        UPDATE HHS_CDC_HR.POSITION
           SET JOB_REQ_NO = V_POS_JOB_REQ_NO
               ,ORG_POS_TTL = V_POS_ORG_POS_TTL
               ,CLSSFD_POS_TTL = V_POS_CLSSFD_POS_TTL
               ,FNCTNL_POS_TTL = V_POS_FNCTNL_POS_TTL  
               ,PAY_PLAN = V_POS_PAY_PLAN
               ,PROMO_POTENTIAL = V_POS_PROMO_POTENTIAL
               ,POS_SENSITIVITY = V_POS_POS_SENSITIVITY
               ,FULL_PERF_LVL = FN_GET_LOOKUP_LABEL('Grade', V_POS_FULL_PERF_LVL)       
               ,POS_TP = V_POS_POS_TP
               ,COMMON_ACCT_NO = V_POS_COMMON_ACCT_NO
               ,BACKFILL_VC = V_POS_BACKFILL_VC    
               ,BACKFILL_VC_NM = V_POS_BACKFILL_VC_NM
               ,BACKFILL_VC_RSN = V_POS_BACKFILL_VC_RSN
               ,NUM_OF_VACANCY = V_POS_NUM_OF_VACANCY
               ,APPOINTMENT_TP = FN_GET_LOOKUP_LABEL('AppointmentType', V_POS_APPOINTMENT_TP)
               ,NOT_TO_EXCEED = V_POS_NOT_TO_EXCEED 
               ,NAME_REQUEST = V_POS_NAME_REQUEST  
               ,POS_OPEN_CONT = V_POS_POS_OPEN_CONT
               ,NUM_OF_DAYS_AD = FN_GET_LOOKUP_LABEL('CalendarDaysToAdvertise', V_POS_NUM_OF_DAYS_AD) 
               ,WORK_SCH_TP = V_POS_WORK_SCH_TP
               ,HRS_PER_WEEK = V_POS_HRS_PER_WEEK 
               ,REMARKS = V_POS_REMARKS
               ,SERVICE = V_POS_SERVICE          
               ,EMPLOYING_OFF_LOC = V_POS_EMPLOYING_OFF_LOC
         WHERE CASE_ID = I_PROCID;

    END;
    END IF;

    ---------- CONSIDERATION_AREA TABLE
    DBMS_OUTPUT.PUT_LINE('DELETE HHS_CDC_HR.CONSIDERATION_AREA');
    DELETE 
      FROM HHS_CDC_HR.CONSIDERATION_AREA
     WHERE CASE_ID = I_PROCID;

    SELECT FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_AOC')
           ,FN_GET_XML_NODE_VALUE(V_FD_FIELD_DATA, 'POS_AOC')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_AOC_1')  
           ,FN_GET_XML_NODE_VALUE(V_FD_FIELD_DATA, 'POS_AOC_1')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_DE_TYPE')  
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_DE_TYPE_1')  
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_MP_TYPE')
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_MP_TYPE_1')  
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_PATHWAY_TYPE')  
           ,FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_PATHWAY_TYPE_1')            
      INTO V_CAREA_CONS_PRIMARY
           ,V_CAREA_CONS_PRIMARY_ID
           ,V_CAREA_CONS_ADDL 
           ,V_CAREA_CONS_ADDL_ID
           ,V_CAREA_CONS_DE_TP
           ,V_CAREA_CONS_DE_TP_1
           ,V_CAREA_CONS_MP_TP
           ,V_CAREA_CONS_MP_TP_1
           ,V_CAREA_CONS_PATHWAY_TP
           ,V_CAREA_CONS_PATHWAY_TP_1
      FROM DUAL;


    IF V_CAREA_CONS_PRIMARY_ID = 'DE' THEN
        V_CAREA_CONS_TP := V_CAREA_CONS_DE_TP;
    ELSIF V_CAREA_CONS_PRIMARY_ID = 'MP' THEN
        V_CAREA_CONS_TP := V_CAREA_CONS_MP_TP;
    ELSIF V_CAREA_CONS_PRIMARY_ID = 'Pathways' THEN
        V_CAREA_CONS_TP := V_CAREA_CONS_PATHWAY_TP;
    END IF;

    IF V_CAREA_CONS_TP = 'Select One' THEN
        V_CAREA_CONS_TP := NULL;
    END IF;
    
    IF V_CAREA_CONS_ADDL_ID = 'DE' THEN
        V_CAREA_CONS_TP_1 := V_CAREA_CONS_DE_TP_1;
    ELSIF V_CAREA_CONS_ADDL_ID = 'MP' THEN
        V_CAREA_CONS_TP_1 := V_CAREA_CONS_MP_TP_1;
    ELSIF V_CAREA_CONS_ADDL_ID = 'Pathways' THEN        
        V_CAREA_CONS_TP := V_CAREA_CONS_PATHWAY_TP_1;
    END IF;

    IF V_CAREA_CONS_TP_1 = 'Select One' THEN
        V_CAREA_CONS_TP_1 := NULL;
    END IF;


    IF V_CAREA_CONS_PRIMARY IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.CONSIDERATION_AREA 1');
        INSERT INTO HHS_CDC_HR.CONSIDERATION_AREA 
        (
            CASE_ID
            ,SEQ
            ,CONSIDERATION
            ,CONSIDERATION_TP
        )
        VALUES
        (
            I_PROCID
            ,1
            ,V_CAREA_CONS_PRIMARY
            ,V_CAREA_CONS_TP
        );
    END IF;

    IF V_CAREA_CONS_ADDL IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.CONSIDERATION_AREA 2');
        INSERT INTO HHS_CDC_HR.CONSIDERATION_AREA 
        (
            CASE_ID
            ,SEQ
            ,CONSIDERATION
            ,CONSIDERATION_TP
        )
        VALUES
        (
            I_PROCID
            ,2
            ,V_CAREA_CONS_ADDL
            ,V_CAREA_CONS_TP_1
        );
    END IF;



    ---------- DUTY_STATION TABLE
    --DBMS_OUTPUT.PUT_LINE('DELETE HHS_CDC_HR.DUTY_STATION');
    DELETE 
      FROM HHS_CDC_HR.DUTY_STATION
     WHERE CASE_ID = I_PROCID;

    SELECT FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_DUTY_STATIONS') 
      INTO V_DS_STATIONS
      FROM DUAL;

    IF V_DS_STATIONS IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.DUTY_STATION');
        INSERT INTO HHS_CDC_HR.DUTY_STATION 
        (
            CASE_ID
            ,SEQ
            ,STATION
        )        
        SELECT I_PROCID
               ,ROWNUM
               ,regexp_substr(V_DS_STATIONS,'[^::]+', 1, level) from dual
                     connect by regexp_substr(V_DS_STATIONS, '[^::]+', 1, level) is not null;

    END IF;

    ---------- FINANCIAL_STATEMENT
    DELETE 
      FROM HHS_CDC_HR.FINANCIAL_STATEMENT
     WHERE CASE_ID = I_PROCID;

    SELECT FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'FINANCIAL_STATEMENTS') 
      INTO V_CLA_FINANCIAL_STATEMENTS
      FROM DUAL;

    IF V_CLA_FINANCIAL_STATEMENTS IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.FINANCIAL_STATEMENT');
        INSERT INTO HHS_CDC_HR.FINANCIAL_STATEMENT 
        (
            CASE_ID
            ,SEQ
            ,STATEMENT
        )        
        SELECT I_PROCID
               ,ROWNUM
               ,regexp_substr(V_CLA_FINANCIAL_STATEMENTS,'[^::]+', 1, level) from dual
                     connect by regexp_substr(V_CLA_FINANCIAL_STATEMENTS, '[^::]+', 1, level) is not null;

    END IF;     
    
    ---------- CLASSIFIED_POS_TITLE
    DELETE 
      FROM HHS_CDC_HR.CLASSIFIED_POS_TITLE
     WHERE CASE_ID = I_PROCID;

    SELECT FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_TITLES') 
      INTO V_POS_TITLES
      FROM DUAL;

    IF V_POS_TITLES IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.CLASSIFIED_POS_TITLE');
        INSERT INTO HHS_CDC_HR.CLASSIFIED_POS_TITLE 
        (
            CASE_ID
            ,SEQ
            ,TITLE
        )        
        SELECT I_PROCID
               ,ROWNUM
               ,regexp_substr(V_POS_TITLES,'[^::]+', 1, level) from dual
                     connect by regexp_substr(V_POS_TITLES, '[^::]+', 1, level) is not null;

    END IF;  
    
    ---------- GRADE TABLE
    --DBMS_OUTPUT.PUT_LINE('DELETE HHS_CDC_HR.GRADE');
    DELETE 
      FROM HHS_CDC_HR.GRADE
     WHERE CASE_ID = I_PROCID;

    SELECT FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_GRADE_IDS') 
      INTO V_POS_GRADE_IDS
      FROM DUAL;

    IF V_POS_GRADE_IDS IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.GRADE');
        INSERT INTO HHS_CDC_HR.GRADE 
        (
            CASE_ID
            ,SEQ
            ,GRADE
        )        
        SELECT I_PROCID
               ,ROWNUM
               ,FN_GET_LOOKUP_LABEL('Grade', regexp_substr(V_POS_GRADE_IDS,'[^::]+', 1, level)) from dual
                     connect by regexp_substr(V_POS_GRADE_IDS, '[^::]+', 1, level) is not null;

    END IF;  
    
    ---------- POS_TITLE_SERIES
    DELETE 
      FROM HHS_CDC_HR.POS_TITLE_SERIES
     WHERE CASE_ID = I_PROCID;
    
    /*
      <item>
         <id>POS_TITLES_SERIESES</id>
         <etype>textbox</etype>
         <value>tae%%1001::MINA%%1051</value>
      </item>
    */
    SELECT FN_GET_XML_FIELD_VALUE(V_FD_FIELD_DATA, 'POS_TITLES_SERIESES') 
      INTO V_POS_TITLES_SERIES
      FROM DUAL;
    
    IF V_POS_TITLES_SERIES IS NOT NULL THEN
        --DBMS_OUTPUT.PUT_LINE('INSERT HHS_CDC_HR.POS_TITLE_SERIES');
        --DBMS_OUTPUT.PUT_LINE('V_POS_TITLES_SERIES=' || V_POS_TITLES_SERIES);
        INSERT INTO HHS_CDC_HR.POS_TITLE_SERIES 
        (
            CASE_ID
            ,SEQ
            ,OFFICIAL_POS_TTL
        )        
        SELECT I_PROCID
               ,ROWNUM
               ,regexp_substr(V_POS_TITLES_SERIES,'[^::]+', 1, level) from dual
                     connect by regexp_substr(V_POS_TITLES_SERIES, '[^::]+', 1, level) is not null;
    
        UPDATE HHS_CDC_HR.POS_TITLE_SERIES
           SET OFFICIAL_POS_TTL = SUBSTR(OFFICIAL_POS_TTL, 1, INSTR(OFFICIAL_POS_TTL, '%%')-1)
               , SERIES = SUBSTR(OFFICIAL_POS_TTL, INSTR(OFFICIAL_POS_TTL, '%%')+2)
         WHERE CASE_ID = I_PROCID;
    
    END IF;      
    
END SP_UPDATE_RECRUITMENT_TBLS;

/
