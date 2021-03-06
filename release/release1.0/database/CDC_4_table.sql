------------------------------------------------------------------------------------------
--  Name	            : 	CDC_4_tables.sql
--	Author				:	Taeho Lee <thee@bizflow.com>
--	
--	Project				:	HHS CDC HR Workflow Solution - EWITS 2.0
--	Purpose				:	Creating tables in HHS_CDC_HR database schema
--	
--  Notes               :   Run on HHS_CDC_HR schema
--
-- 	WHEN		WHO			WHAT		
-- 	-----------	--------	-------------------------------------------------------
-- 	11/14/2018	THLEE		Created
------------------------------------------------------------------------------------------

--------------------------------------------------------
--  DDL for Table NAMED_ACTION
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."NAMED_ACTION" 
   (	"CASE_ID" NUMBER(10,0), 
	"PAR_ACTN" VARCHAR2(200 BYTE), 
	"PAR_ACTN_TP" VARCHAR2(200 BYTE), 
	"PRPSD_EFFCTV_DT" VARCHAR2(20 BYTE), 
	"EMPL_ID" VARCHAR2(200 BYTE), 
	"EMPL_NM" VARCHAR2(200 BYTE), 
	"PRE_CNSLTTN_REQD" VARCHAR2(10 BYTE), 
	"NA_MTNG_DT" VARCHAR2(20 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table HR_CASE
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."HR_CASE" 
   (	"CASE_ID" NUMBER(10,0), 
	"CASE_TP" VARCHAR2(20 BYTE), 
	"CREATOR_NM" VARCHAR2(100 BYTE), 
	"CREATION_DT" TIMESTAMP (6), 
	"MODIFIER_NM" VARCHAR2(100 BYTE), 
	"MODIFICATION_DT" TIMESTAMP (6)
   );
   
--------------------------------------------------------
--  DDL for Table GRADE_INFO
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."GRADE_INFO" 
   (	"CASE_ID" NUMBER(10,0), 
	"GRADE_SEQ" NUMBER(*,0), 
	"FAIR_LABOR_STND_ACT" VARCHAR2(4000 BYTE), 
	"COMP_LVL_CD" VARCHAR2(4000 BYTE), 
	"PD_NO" VARCHAR2(200 BYTE), 
	"JOB_CD" VARCHAR2(200 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table AUTHORIZED_INCENTIVE
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."AUTHORIZED_INCENTIVE" 
   (	"CASE_ID" NUMBER(10,0), 
	"ANN_LEAVE_NON_FED_SVC" VARCHAR2(10 BYTE), 
	"MOVING_EXP_ATHRZD" VARCHAR2(10 BYTE), 
	"RELOCATION_INC_ATHRZD" VARCHAR2(10 BYTE), 
	"RECRUITMENT_INC_ATHRZD" VARCHAR2(10 BYTE), 
	"STU_LOAN_REPAY_ATHRZD" VARCHAR2(10 BYTE), 
	"OTHER_INC" VARCHAR2(4000 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table APP_APPROVAL
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."APP_APPROVAL" 
   (	"CASE_ID" NUMBER(10,0), 
	"HR_ASSSTNT_NM" VARCHAR2(200 BYTE), 
	"HR_ASSSTNT_APPRVL_DT" VARCHAR2(20 BYTE), 
	"HRS_SPC_NM" VARCHAR2(200 BYTE), 
	"HRS_SPC_APPRVL_DT" VARCHAR2(20 BYTE), 
	"ADDTNL_APPRVL_RQRD" VARCHAR2(20 BYTE), 
	"ADDTNL_APPRVL_NM" VARCHAR2(200 BYTE), 
	"ADDTNL_APPRVL_EMAIL" VARCHAR2(100 BYTE), 
	"SR_HRS_SPC_NM" VARCHAR2(200 BYTE), 
	"SR_HRS_SPC_APPRVL_DT" VARCHAR2(20 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table ATC_POSITION_INFO
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."ATC_POSITION_INFO" 
   (	"CASE_ID" NUMBER(10,0), 
	"POS_TTL" VARCHAR2(4000 BYTE), 
	"PAY_PLAN" VARCHAR2(4000 BYTE), 
	"SERIES" VARCHAR2(4000 BYTE), 
	"GRADE" VARCHAR2(100 BYTE), 
	"LOCATION" VARCHAR2(400 BYTE), 
	"LAST_NM" VARCHAR2(200 BYTE), 
	"FIRST_NM" VARCHAR2(200 BYTE), 
	"MIDDLE_INITIAL" VARCHAR2(200 BYTE), 
	"CNTRY_OF_CTZNSHP" VARCHAR2(200 BYTE), 
	"VISA_ASSSTNC_RQRD" VARCHAR2(200 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table ATC_PERSONNEL_ACTION
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."ATC_PERSONNEL_ACTION" 
   (	"CASE_ID" NUMBER(10,0), 
	"EFFCTV_DT" VARCHAR2(20 BYTE), 
	"NTE_DT" VARCHAR2(20 BYTE), 
	"VETS_PRFRNC" VARCHAR2(400 BYTE), 
	"INT_HRS_DYS_WRKD_LAST_APPT" VARCHAR2(100 BYTE), 
	"INT_HRS_DYS_WRKD_THIS_APPT" VARCHAR2(100 BYTE), 
	"INT_HRS_DYS_WRKD_LAST_APPT_TP" VARCHAR2(10 BYTE), 
	"INT_HRS_DYS_WRKD_THIS_APPT_TP" VARCHAR2(10 BYTE), 
	"DT_WRKD_LST_APPNTMNT_FROM" VARCHAR2(20 BYTE), 
	"DT_WRKD_LST_APPNTMNT_TO" VARCHAR2(200 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table CLA_STANDARD
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."CLA_STANDARD" 
   (	"CASE_ID" NUMBER(10,0), 
	"SEQ" NUMBER(*,0), 
	"STANDARD" VARCHAR2(400 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table DUTY_STATION
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."DUTY_STATION" 
   (	"CASE_ID" NUMBER(10,0), 
	"SEQ" NUMBER(*,0), 
	"STATION" VARCHAR2(400 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table POSITION_BUILD_APPROVAL
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."POSITION_BUILD_APPROVAL" 
   (	"CASE_ID" NUMBER(10,0), 
	"ACTV_N_ACCRT" VARCHAR2(100 BYTE), 
	"ALL_SIGN_OF8" VARCHAR2(100 BYTE), 
	"CAPHR_POS_NO" VARCHAR2(100 BYTE), 
	"JOB_CODE" VARCHAR2(100 BYTE), 
	"BUS_ARRVD" VARCHAR2(100 BYTE), 
	"SPRVSRY_STTS_APPRVD" VARCHAR2(100 BYTE), 
	"FLSA_APPRVD" VARCHAR2(100 BYTE), 
	"ADMIN_CD_APPRVD" VARCHAR2(100 BYTE), 
	"PM_STWRD_NM" VARCHAR2(100 BYTE), 
	"PM_STWRD_APPRVD" VARCHAR2(100 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table REC_SME
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."REC_SME" 
   (	"CASE_ID" NUMBER(10,0), 
	"SEQ" NUMBER(*,0), 
	"NAME" VARCHAR2(200 BYTE), 
	"EMAIL" VARCHAR2(100 BYTE), 
	"SME_TP" VARCHAR2(10 BYTE), 
	"IS_PRIMARY" VARCHAR2(10 BYTE), 
	"ORG_NM" VARCHAR2(200 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table CONSIDERATION_AREA
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."CONSIDERATION_AREA" 
   (	"CASE_ID" NUMBER(10,0), 
	"SEQ" NUMBER(*,0), 
	"CONSIDERATION" VARCHAR2(400 BYTE), 
	"CONSIDERATION_TP" VARCHAR2(400 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table RECRUITMENT
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."RECRUITMENT" 
   (	"CASE_ID" NUMBER(10,0), 
	"RQST_TP" VARCHAR2(100 BYTE), 
	"ADMN_CD" VARCHAR2(20 BYTE), 
	"ORG_NM" VARCHAR2(200 BYTE), 
	"HIRING_MTHD" VARCHAR2(20 BYTE), 
	"SO_NM" VARCHAR2(100 BYTE), 
	"SO_EML" VARCHAR2(100 BYTE), 
	"CIO_ADMN_NM" VARCHAR2(100 BYTE), 
	"CIO_ADMN_EML" VARCHAR2(100 BYTE), 
	"HRO_SPC_NM" VARCHAR2(100 BYTE), 
	"HRO_SPC_EML" VARCHAR2(100 BYTE), 
	"CLA_SPC_NM" VARCHAR2(100 BYTE), 
	"CLA_SPC_EML" VARCHAR2(100 BYTE), 
	"COM_CHR_NM" VARCHAR2(100 BYTE), 
	"COM_CHR_EML" VARCHAR2(100 BYTE), 
	"COM_CHR_ORG_NM" VARCHAR2(200 BYTE), 
	"SME_RQRD" VARCHAR2(10 BYTE), 
	"STFFNG_NEED_VLDTD" VARCHAR2(10 BYTE), 
	"JSTFCTN_NOT_VLD_STAFF_ND" VARCHAR2(4000 BYTE), 
	"HIRING_OPT_GUIDE_RVWD" VARCHAR2(10 BYTE), 
	"JSTFCTN_NOT_RVWNG_HR_OPT_GD" VARCHAR2(4000 BYTE), 
	"POS_BSD_MGMT_SYS_NO" VARCHAR2(100 BYTE), 
	"REQ_APPRVD_BY_HHS" VARCHAR2(10 BYTE), 
	"JSTFCTN_NOT_RCVNG_HHS_APPRL" VARCHAR2(4000 BYTE), 
	"SLOT_RQSTD" VARCHAR2(10 BYTE), 
	"JSTFCTN_NOT_RCVNG_SLOT" VARCHAR2(4000 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table ATC_SELECTED_BENEFITS
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."ATC_SELECTED_BENEFITS" 
   (	"CASE_ID" NUMBER(10,0), 
	"SEQ" NUMBER(*,0), 
	"ENTTLD_BNFT" VARCHAR2(4000 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table ATC_NATURE_OF_ACTION
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."ATC_NATURE_OF_ACTION" 
   (	"CASE_ID" NUMBER(10,0), 
	"SEQ" NUMBER(*,0), 
	"NOAC" VARCHAR2(400 BYTE), 
	"FRST_AUTH" VARCHAR2(400 BYTE), 
	"SCND_AUTH" VARCHAR2(400 BYTE), 
	"ZLM_DSCRPTN" VARCHAR2(4000 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table ATC_BENEFITS
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."ATC_BENEFITS" 
   (	"CASE_ID" NUMBER(10,0), 
	"VISA_TP" VARCHAR2(400 BYTE), 
	"EMP_ENTTLD_TO_BNFTS" VARCHAR2(100 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table CLASSIFIED_POS_TITLE
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."CLASSIFIED_POS_TITLE" 
   (	"CASE_ID" NUMBER(10,0), 
	"SEQ" NUMBER(*,0), 
	"TITLE" VARCHAR2(4000 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table VALIDATION
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."VALIDATION" 
   (	"CASE_ID" NUMBER(10,0), 
	"PRE_RECRUITMENT_MTNG_DT" VARCHAR2(20 BYTE), 
	"PPP_PCP_CLRD" VARCHAR2(10 BYTE), 
	"PPP_PCP_CLRD_DT" VARCHAR2(20 BYTE), 
	"JUSTFCTN_PPP_PCP_NOT_CLEARED" VARCHAR2(4000 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table EXTERNAL_LINK_LOOKUP
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."EXTERNAL_LINK_LOOKUP" 
   (	"LINK_ID" NUMBER(*,0), 
	"LINK_GROUP" NVARCHAR2(100), 
	"LINK_URL" NVARCHAR2(1000), 
	"LINK_DISPLAY" NVARCHAR2(100), 
	"LINK_DESCRIPTION" NVARCHAR2(1000), 
	"LINK_ACTIVE" CHAR(1 BYTE), 
	"LINK_EFFECTIVE_DT" DATE, 
	"LINK_EXPIRATION_DT" DATE, 
	"LINK_DISP_ORDER" NUMBER(38,0)
   );
   
--------------------------------------------------------
--  DDL for Table TSA_PROCESSING
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."TSA_PROCESSING" 
   (	"CASE_ID" NUMBER(10,0), 
	"TSA_PRCSSR_NM" VARCHAR2(200 BYTE), 
	"TSA_PRCSSR_APPRVL_DT" VARCHAR2(100 BYTE), 
	"ADDTNL_APPRVL_RQRD" VARCHAR2(20 BYTE), 
	"ADDTNL_TSA_PRCSSR_NM" VARCHAR2(200 BYTE), 
	"ADDTNL_TSA_PRCSSR_EMAIL" VARCHAR2(200 BYTE), 
	"LEAD_TSA_PRCSSR_NM" VARCHAR2(200 BYTE), 
	"LEAD_TSA_PRCSSR_APPRVL_DT" VARCHAR2(20 BYTE), 
	"DOC_SCANNED_TO_EOPF" VARCHAR2(100 BYTE), 
	"QLTY_ASSRNC_RVW_CMPL" VARCHAR2(100 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table CAPHR_INFO
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."CAPHR_INFO" 
   (	"CASE_ID" NUMBER(10,0), 
	"CAPHR_RMRKS" VARCHAR2(4000 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table TRIAGE
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."TRIAGE" 
   (	"CASE_ID" NUMBER(10,0), 
	"STAFFING_NEED_TP" VARCHAR2(200 BYTE), 
	"HR_ACTION_TP" VARCHAR2(200 BYTE), 
	"JOB_REQ_NO" VARCHAR2(200 BYTE), 
	"EMP_ID" VARCHAR2(200 BYTE), 
	"EMP_NM" VARCHAR2(200 BYTE), 
	"PAR_ACTION" VARCHAR2(200 BYTE), 
	"HIRING_METHOD" VARCHAR2(20 BYTE), 
	"PAR_ACTION_TP" VARCHAR2(200 BYTE), 
	"PROPOSED_EFF_DT" VARCHAR2(20 BYTE), 
	"ADMIN_CD" VARCHAR2(20 BYTE), 
	"ORG_NM" VARCHAR2(200 BYTE), 
	"CAN" VARCHAR2(200 BYTE), 
	"SO_NM" VARCHAR2(100 BYTE), 
	"SO_EMAIL" VARCHAR2(100 BYTE), 
	"CIO_ADMN_NM" VARCHAR2(100 BYTE), 
	"CIO_ADMN_EMAIL" VARCHAR2(100 BYTE), 
	"HRO_SPC_NM" VARCHAR2(100 BYTE), 
	"HRO_SPC_EMAIL" VARCHAR2(100 BYTE), 
	"CLA_SPC_NM" VARCHAR2(100 BYTE), 
	"CLA_SPC_EMAIL" VARCHAR2(100 BYTE), 
	"NOAC" VARCHAR2(200 BYTE), 
	"FIRST_AUTH" VARCHAR2(100 BYTE), 
	"SECOND_AUTH" VARCHAR2(100 BYTE), 
	"IS_PRECONSULT_RQRD" VARCHAR2(100 BYTE), 
	"MEETING_DT" VARCHAR2(20 BYTE), 
	"REMAKRS" VARCHAR2(4000 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table CONCURRENCE
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."CONCURRENCE" 
   (	"CASE_ID" NUMBER(10,0), 
	"SEQ" NUMBER(*,0), 
	"SUPERVISOR_CERT" VARCHAR2(20 BYTE), 
	"SUPERVISOR_NM" VARCHAR2(100 BYTE), 
	"SUPERVISOR_APPRVL_DT" VARCHAR2(20 BYTE), 
	"SUPERVISOR_TP" VARCHAR2(20 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table ATC_COMPENSATION
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."ATC_COMPENSATION" 
   (	"CASE_ID" NUMBER(10,0), 
	"COMMON_ACCT_NO" VARCHAR2(400 BYTE), 
	"FED_FSCL_YR" VARCHAR2(100 BYTE), 
	"PRIOR_FED_SVC" VARCHAR2(400 BYTE), 
	"HIGHEST_PRE_PAY_PLAN" VARCHAR2(400 BYTE), 
	"HIGHEST_PRE_GRADE" VARCHAR2(400 BYTE), 
	"HIGHEST_PRE_STEP" VARCHAR2(400 BYTE), 
	"HIGHEST_PRE_SALARY" VARCHAR2(400 BYTE), 
	"TERM_RTNTIN_ALLWNC" VARCHAR2(400 BYTE), 
	"PAY_SET_EQV_PAY_PLAN" VARCHAR2(400 BYTE), 
	"PAY_SET_EQV_GRADE" VARCHAR2(400 BYTE), 
	"PAY_SET_STEP" VARCHAR2(400 BYTE), 
	"PAY_SET_EQV_AMOUNT" VARCHAR2(400 BYTE), 
	"INCENTIVES" VARCHAR2(400 BYTE), 
	"MRKT_PAY" VARCHAR2(400 BYTE), 
	"POST_DIFF_PER" VARCHAR2(400 BYTE), 
	"POST_DIFF_STTS" VARCHAR2(100 BYTE), 
	"COLA_PER" VARCHAR2(400 BYTE), 
	"COLA_STTS" VARCHAR2(100 BYTE), 
	"DANGER_PAY_STTS" VARCHAR2(100 BYTE), 
	"PAY_CRDNTD_W_SO" VARCHAR2(400 BYTE), 
	"PRIOR_REMARKS" VARCHAR2(4000 BYTE), 
	"PRIOR_YR" VARCHAR2(20 BYTE), 
	"PRIOR_LCTN" VARCHAR2(400 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table GRADE
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."GRADE" 
   (	"CASE_ID" NUMBER(10,0), 
	"SEQ" NUMBER(*,0), 
	"GRADE" VARCHAR2(100 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table EMP_CONDITION
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."EMP_CONDITION" 
   (	"CASE_ID" NUMBER(10,0), 
	"FINANCIAL_DSCLSR_RQRD" VARCHAR2(10 BYTE), 
	"PRE_EMP_PHYSCL_RQRD" VARCHAR2(10 BYTE), 
	"DRG_TST_RQRD" VARCHAR2(10 BYTE), 
	"IMMUNZTN_RQRD" VARCHAR2(10 BYTE), 
	"MOBILITY_AGRMNT_RQRD" VARCHAR2(10 BYTE), 
	"LIC_RQRD" VARCHAR2(10 BYTE), 
	"LIC_INFO" VARCHAR2(1000 BYTE), 
	"TRVL_RQRD" VARCHAR2(10 BYTE), 
	"DMSTC_TRVL_PRCNTG" VARCHAR2(100 BYTE), 
	"INTRNTNL_TRVL_PRCNTG" VARCHAR2(100 BYTE), 
	"FOREIGN_LANG_RQRD" VARCHAR2(10 BYTE), 
	"OTHER_CON" VARCHAR2(4000 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table ATC_VALIDATION
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."ATC_VALIDATION" 
   (	"CASE_ID" NUMBER(10,0), 
	"STFFNG_NEED_VLDTD" VARCHAR2(100 BYTE), 
	"JSTFCTN_NOT_STFFNG_NEED_VLDTD" VARCHAR2(4000 BYTE), 
	"PBMS_FUND_CNFRMD" VARCHAR2(100 BYTE), 
	"JSTFCTN_NOT_PBMS_FUND_CNFRMD" VARCHAR2(4000 BYTE), 
	"HRNG_OPTNS_GID_RVWD" VARCHAR2(100 BYTE), 
	"JSTFCTN_NOT_HRNG_OPTNS_GID" VARCHAR2(4000 BYTE), 
	"SLT_RQSTD" VARCHAR2(100 BYTE), 
	"JSTFCTN_NOT_SLT_RQSTD" VARCHAR2(4000 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table POS_TITLE_SERIES
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."POS_TITLE_SERIES" 
   (	"CASE_ID" NUMBER(10,0), 
	"SEQ" NUMBER(*,0), 
	"OFFICIAL_POS_TTL" VARCHAR2(4000 BYTE), 
	"SERIES" VARCHAR2(4000 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table APPOINTMENT
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."APPOINTMENT" 
   (	"CASE_ID" NUMBER(10,0), 
	"RQST_TP" VARCHAR2(100 BYTE), 
	"HIRING_METHOD" VARCHAR2(20 BYTE), 
	"ADMIN_CD" VARCHAR2(20 BYTE), 
	"ORG_NM" VARCHAR2(200 BYTE), 
	"SHRD_CERT" VARCHAR2(200 BYTE), 
	"VA_NO" VARCHAR2(200 BYTE), 
	"CERT_NO" VARCHAR2(200 BYTE), 
	"AREA_OF_CONSIDERATION" VARCHAR2(200 BYTE), 
	"NON_COMP_TYPE" VARCHAR2(200 BYTE), 
	"JOB_REQ_NO" VARCHAR2(100 BYTE), 
	"POS_BSD_MGMT_SYS_NO" VARCHAR2(100 BYTE), 
	"SO_NM" VARCHAR2(100 BYTE), 
	"SO_EMAIL" VARCHAR2(100 BYTE), 
	"CIO_ADMN_NM" VARCHAR2(100 BYTE), 
	"CIO_ADMN_EMAIL" VARCHAR2(100 BYTE), 
	"HRO_SPC_NM" VARCHAR2(100 BYTE), 
	"HRO_SPC_EMAIL" VARCHAR2(100 BYTE), 
	"CLA_SPC_NM" VARCHAR2(100 BYTE), 
	"CLA_SPC_EMAIL" VARCHAR2(100 BYTE), 
	"HRO_SPC_ASSSTNT_NM" VARCHAR2(100 BYTE), 
	"HRO_SPC_ASSSTNT_EMAIL" VARCHAR2(100 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table APP_TRACKING
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."APP_TRACKING" 
   (	"CASE_ID" NUMBER(10,0), 
	"CSO_DEPUTY_DIR_APPRVL" VARCHAR2(400 BYTE), 
	"MEMO_SGND_DT" VARCHAR2(20 BYTE), 
	"CAPHR_POS_NO" VARCHAR2(100 BYTE), 
	"JOB_CD" VARCHAR2(100 BYTE), 
	"ETHICS_CLRNC_STTS" VARCHAR2(100 BYTE), 
	"ETHICS_DCSN_RCVD_DT" VARCHAR2(20 BYTE), 
	"SEC_CLRNC_STTS" VARCHAR2(100 BYTE), 
	"SEC_DCSN_RCVD_DT" VARCHAR2(20 BYTE), 
	"WRK_ATHRZTN_STTS" VARCHAR2(20 BYTE), 
	"WRK_ATHRZTN_DCSN_RCVD_DT" VARCHAR2(20 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table POSITION
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."POSITION" 
   (	"CASE_ID" NUMBER(10,0), 
	"JOB_REQ_NO" VARCHAR2(100 BYTE), 
	"ORG_POS_TTL" VARCHAR2(4000 BYTE), 
	"FNCTNL_POS_TTL" VARCHAR2(4000 BYTE), 
	"PAY_PLAN" VARCHAR2(4000 BYTE), 
	"PROMO_POTENTIAL" VARCHAR2(400 BYTE), 
	"POS_SENSITIVITY" VARCHAR2(4000 BYTE), 
	"FULL_PERF_LVL" VARCHAR2(400 BYTE), 
	"POS_TP" VARCHAR2(400 BYTE), 
	"COMMON_ACCT_NO" VARCHAR2(400 BYTE), 
	"BACKFILL_VC" VARCHAR2(400 BYTE), 
	"BACKFILL_VC_NM" VARCHAR2(400 BYTE), 
	"BACKFILL_VC_RSN" VARCHAR2(1000 BYTE), 
	"NUM_OF_VACANCY" VARCHAR2(400 BYTE), 
	"APPOINTMENT_TP" VARCHAR2(400 BYTE), 
	"NOT_TO_EXCEED" VARCHAR2(400 BYTE), 
	"NAME_REQUEST" VARCHAR2(400 BYTE), 
	"POS_OPEN_CONT" VARCHAR2(400 BYTE), 
	"NUM_OF_DAYS_AD" VARCHAR2(400 BYTE), 
	"WORK_SCH_TP" VARCHAR2(400 BYTE), 
	"HRS_PER_WEEK" VARCHAR2(400 BYTE), 
	"REMARKS" VARCHAR2(4000 BYTE), 
	"SERVICE" VARCHAR2(400 BYTE), 
	"EMPLOYING_OFF_LOC" VARCHAR2(400 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table FINANCIAL_STATEMENT
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."FINANCIAL_STATEMENT" 
   (	"CASE_ID" NUMBER(10,0), 
	"SEQ" NUMBER(*,0), 
	"STATEMENT" VARCHAR2(400 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table CLASSIFICATION
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."CLASSIFICATION" 
   (	"CASE_ID" NUMBER(10,0), 
	"ADMN_CD" VARCHAR2(20 BYTE), 
	"ORG_NM" VARCHAR2(200 BYTE), 
	"HIRING_METHOD" VARCHAR2(20 BYTE), 
	"FIRST_SUBDVSN" VARCHAR2(200 BYTE), 
	"SECOND_SUBDVSN" VARCHAR2(200 BYTE), 
	"THIRD_SUBDVSN" VARCHAR2(200 BYTE), 
	"FOURTH_SUBDVSN" VARCHAR2(200 BYTE), 
	"FIFTH_SUBDVSN" VARCHAR2(200 BYTE), 
	"PROPOSED_ACTION" VARCHAR2(100 BYTE), 
	"PA_OTHER_DESC" VARCHAR2(400 BYTE), 
	"RQST_TP" VARCHAR2(100 BYTE), 
	"POS_STATUS" VARCHAR2(20 BYTE), 
	"EXSTING_PD_NO" VARCHAR2(200 BYTE), 
	"JOB_REQ_NO" VARCHAR2(200 BYTE), 
	"SO_NM" VARCHAR2(100 BYTE), 
	"SO_EMAIL" VARCHAR2(100 BYTE), 
	"CIO_ADMN_NM" VARCHAR2(100 BYTE), 
	"CIO_ADMN_EMAIL" VARCHAR2(100 BYTE), 
	"HRO_SPC_NM" VARCHAR2(100 BYTE), 
	"HRO_SPC_EMAIL" VARCHAR2(100 BYTE), 
	"CLA_SPC_NM" VARCHAR2(100 BYTE), 
	"CLA_SPC_EMAIL" VARCHAR2(100 BYTE), 
	"POS_BSD_MGMT_SYS_NO" VARCHAR2(100 BYTE), 
	"EXPLANATION" VARCHAR2(4000 BYTE), 
	"OFFCL_RSN_SBMSSN" VARCHAR2(400 BYTE), 
	"EMP_TP" VARCHAR2(200 BYTE), 
	"EXSTING_SOD_NO" VARCHAR2(200 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table CLA_CONDITION
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."CLA_CONDITION" 
   (	"CASE_ID" NUMBER(10,0), 
	"PHYSICIAN_COMP_ALLWNC" VARCHAR2(20 BYTE), 
	"DRUG_TEST_RQRD" VARCHAR2(20 BYTE), 
	"PRE_EMP_PHYSCL_RQRD" VARCHAR2(20 BYTE), 
	"SEL_AGNT_ACCSS_RQRD" VARCHAR2(20 BYTE), 
	"SUBJ_TO_ADDTNL_IDENTICAL" VARCHAR2(20 BYTE), 
	"INCUMBENT_ONLY" VARCHAR2(20 BYTE), 
	"COMM_CORP_ELIGIBLE" VARCHAR2(20 BYTE), 
	"FINANCIAL_DSCLSR_RQRD" VARCHAR2(20 BYTE), 
	"CYBER_SEC_CD" VARCHAR2(4000 BYTE), 
	"BUS_CD" VARCHAR2(4000 BYTE), 
	"ACQUISITION_CD" VARCHAR2(4000 BYTE), 
	"OPM_CERT_NO" VARCHAR2(400 BYTE), 
	"LMTD_TRM" VARCHAR2(100 BYTE), 
	"LMTD_EMRGNCY" VARCHAR2(100 BYTE), 
	"LMTD_TRM_NTE" VARCHAR2(100 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Table LANGUAGE
--------------------------------------------------------

  CREATE TABLE "HHS_CDC_HR"."LANGUAGE" 
   (	"CASE_ID" NUMBER(10,0), 
	"SEQ" NUMBER(*,0), 
	"LANG" VARCHAR2(100 BYTE)
   );
   
--------------------------------------------------------
--  DDL for Index XPKNAMED_ACTTION
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKNAMED_ACTTION" ON "HHS_CDC_HR"."NAMED_ACTION" ("CASE_ID") ;
  
--------------------------------------------------------
--  DDL for Index XPKHR_CASE
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKHR_CASE" ON "HHS_CDC_HR"."HR_CASE" ("CASE_ID") ;
  
--------------------------------------------------------
--  DDL for Index XPKGRADE_RELATED_INFORMATION
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKGRADE_RELATED_INFORMATION" ON "HHS_CDC_HR"."GRADE_INFO" ("CASE_ID", "GRADE_SEQ");
  
--------------------------------------------------------
--  DDL for Index XPK_AUTHORIZED_INCENTIVE
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPK_AUTHORIZED_INCENTIVE" ON "HHS_CDC_HR"."AUTHORIZED_INCENTIVE" ("CASE_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HHS_CDC_HR_TS" ;
--------------------------------------------------------
--  DDL for Index XPKAPPOINTMENT_APPROVAL
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKAPPOINTMENT_APPROVAL" ON "HHS_CDC_HR"."APP_APPROVAL" ("CASE_ID") ;
  
--------------------------------------------------------
--  DDL for Index XPKATC_POSITION_INFORMATION
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKATC_POSITION_INFORMATION" ON "HHS_CDC_HR"."ATC_POSITION_INFO" ("CASE_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HHS_CDC_HR_TS" ;
--------------------------------------------------------
--  DDL for Index XPKATC_PERSONNEL_ACTION
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKATC_PERSONNEL_ACTION" ON "HHS_CDC_HR"."ATC_PERSONNEL_ACTION" ("CASE_ID") ;
  
--------------------------------------------------------
--  DDL for Index XPK_CLA_STANDARD
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPK_CLA_STANDARD" ON "HHS_CDC_HR"."CLA_STANDARD" ("CASE_ID", "SEQ") ;
  
--------------------------------------------------------
--  DDL for Index XPK_DUTY_STATION
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPK_DUTY_STATION" ON "HHS_CDC_HR"."DUTY_STATION" ("CASE_ID", "SEQ") ;
  
--------------------------------------------------------
--  DDL for Index XPKPOSITION_BUILD_APPROVAL
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKPOSITION_BUILD_APPROVAL" ON "HHS_CDC_HR"."POSITION_BUILD_APPROVAL" ("CASE_ID") ;
  
--------------------------------------------------------
--  DDL for Index XPK_REC_SME
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPK_REC_SME" ON "HHS_CDC_HR"."REC_SME" ("CASE_ID", "SEQ") ;
  
--------------------------------------------------------
--  DDL for Index XPK_CONSIDERATION_AREA
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPK_CONSIDERATION_AREA" ON "HHS_CDC_HR"."CONSIDERATION_AREA" ("CASE_ID", "SEQ") ;
  
--------------------------------------------------------
--  DDL for Index XPK_RECRUITMENT
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPK_RECRUITMENT" ON "HHS_CDC_HR"."RECRUITMENT" ("CASE_ID") ;
  
--------------------------------------------------------
--  DDL for Index XPKATC_SELECTED_ENTITLED_BENEF
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKATC_SELECTED_ENTITLED_BENEF" ON "HHS_CDC_HR"."ATC_SELECTED_BENEFITS" ("CASE_ID", "SEQ") ;
  
--------------------------------------------------------
--  DDL for Index XPKATC_NATURE_OF_ACTION
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKATC_NATURE_OF_ACTION" ON "HHS_CDC_HR"."ATC_NATURE_OF_ACTION" ("CASE_ID", "SEQ") ;
  
--------------------------------------------------------
--  DDL for Index XPKATC_BENEFITS
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKATC_BENEFITS" ON "HHS_CDC_HR"."ATC_BENEFITS" ("CASE_ID") ;
  
--------------------------------------------------------
--  DDL for Index XPKCLASSIFIED_POSITION_TITLE
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKCLASSIFIED_POSITION_TITLE" ON "HHS_CDC_HR"."CLASSIFIED_POS_TITLE" ("CASE_ID", "SEQ") ;
  
--------------------------------------------------------
--  DDL for Index XPK_VALIDATION
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPK_VALIDATION" ON "HHS_CDC_HR"."VALIDATION" ("CASE_ID") ;
  
--------------------------------------------------------
--  DDL for Index XPKEXTERNAL_LINK_LOOKUP
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKEXTERNAL_LINK_LOOKUP" ON "HHS_CDC_HR"."EXTERNAL_LINK_LOOKUP" ("LINK_ID") ;
  
--------------------------------------------------------
--  DDL for Index XPKTSA_PROCESSING
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKTSA_PROCESSING" ON "HHS_CDC_HR"."TSA_PROCESSING" ("CASE_ID") ;
  
--------------------------------------------------------
--  DDL for Index XPKCAPHR_INFO
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKCAPHR_INFO" ON "HHS_CDC_HR"."CAPHR_INFO" ("CASE_ID") ;
  
--------------------------------------------------------
--  DDL for Index XPKTRIAGE
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKTRIAGE" ON "HHS_CDC_HR"."TRIAGE" ("CASE_ID") ;
  
--------------------------------------------------------
--  DDL for Index XPK_CONCURRENCE
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPK_CONCURRENCE" ON "HHS_CDC_HR"."CONCURRENCE" ("CASE_ID", "SEQ") ;
  
--------------------------------------------------------
--  DDL for Index XPKATC_COMPENSATION
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKATC_COMPENSATION" ON "HHS_CDC_HR"."ATC_COMPENSATION" ("CASE_ID") ;
  
--------------------------------------------------------
--  DDL for Index XPK_GRADE
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPK_GRADE" ON "HHS_CDC_HR"."GRADE" ("CASE_ID", "SEQ") ;
  
--------------------------------------------------------
--  DDL for Index XPK_EMP_CONDITION
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPK_EMP_CONDITION" ON "HHS_CDC_HR"."EMP_CONDITION" ("CASE_ID") ;
  
--------------------------------------------------------
--  DDL for Index XPKNEED_AND_FUNDING_VALIDATION
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKNEED_AND_FUNDING_VALIDATION" ON "HHS_CDC_HR"."ATC_VALIDATION" ("CASE_ID") ;
  
--------------------------------------------------------
--  DDL for Index XPKPOSITION_TITLE_SERIES
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKPOSITION_TITLE_SERIES" ON "HHS_CDC_HR"."POS_TITLE_SERIES" ("CASE_ID", "SEQ") ;
  
--------------------------------------------------------
--  DDL for Index XPKAPPOINTMENT
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKAPPOINTMENT" ON "HHS_CDC_HR"."APPOINTMENT" ("CASE_ID") ;
  
--------------------------------------------------------
--  DDL for Index XPKAPPOINTMENT_TRACKING
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPKAPPOINTMENT_TRACKING" ON "HHS_CDC_HR"."APP_TRACKING" ("CASE_ID") ;
  
--------------------------------------------------------
--  DDL for Index XPK_POSITION
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPK_POSITION" ON "HHS_CDC_HR"."POSITION" ("CASE_ID") ;
  
--------------------------------------------------------
--  DDL for Index XPK_FINANCIAL_STATEMENT
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPK_FINANCIAL_STATEMENT" ON "HHS_CDC_HR"."FINANCIAL_STATEMENT" ("CASE_ID", "SEQ") ;
  
--------------------------------------------------------
--  DDL for Index XPK_CLASSIFICATION
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPK_CLASSIFICATION" ON "HHS_CDC_HR"."CLASSIFICATION" ("CASE_ID") ;
--------------------------------------------------------
--  DDL for Index XPK_CLA_CONDITION
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPK_CLA_CONDITION" ON "HHS_CDC_HR"."CLA_CONDITION" ("CASE_ID") ;
  
--------------------------------------------------------
--  DDL for Index XPK_LANGUAGE
--------------------------------------------------------

  CREATE UNIQUE INDEX "HHS_CDC_HR"."XPK_LANGUAGE" ON "HHS_CDC_HR"."LANGUAGE" ("CASE_ID", "SEQ") ;
  
--------------------------------------------------------
--  Constraints for Table NAMED_ACTION
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."NAMED_ACTION" ADD CONSTRAINT "XPKNAMED_ACTTION" PRIMARY KEY ("CASE_ID");
  
--------------------------------------------------------
--  Constraints for Table HR_CASE
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."HR_CASE" ADD CONSTRAINT "XPKHR_CASE" PRIMARY KEY ("CASE_ID");
  ALTER TABLE "HHS_CDC_HR"."HR_CASE" MODIFY ("CREATOR_NM" NOT NULL ENABLE);
  ALTER TABLE "HHS_CDC_HR"."HR_CASE" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table GRADE_INFO
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."GRADE_INFO" ADD CONSTRAINT "XPKGRADE_RELATED_INFORMATION" PRIMARY KEY ("CASE_ID", "GRADE_SEQ");
  ALTER TABLE "HHS_CDC_HR"."GRADE_INFO" MODIFY ("GRADE_SEQ" NOT NULL ENABLE);
  ALTER TABLE "HHS_CDC_HR"."GRADE_INFO" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table AUTHORIZED_INCENTIVE
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."AUTHORIZED_INCENTIVE" ADD CONSTRAINT "XPK_AUTHORIZED_INCENTIVE" PRIMARY KEY ("CASE_ID");
  ALTER TABLE "HHS_CDC_HR"."AUTHORIZED_INCENTIVE" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table APP_APPROVAL
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."APP_APPROVAL" ADD CONSTRAINT "XPKAPPOINTMENT_APPROVAL" PRIMARY KEY ("CASE_ID");
  ALTER TABLE "HHS_CDC_HR"."APP_APPROVAL" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table ATC_POSITION_INFO
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."ATC_POSITION_INFO" ADD CONSTRAINT "XPKATC_POSITION_INFORMATION" PRIMARY KEY ("CASE_ID");
  ALTER TABLE "HHS_CDC_HR"."ATC_POSITION_INFO" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table ATC_PERSONNEL_ACTION
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."ATC_PERSONNEL_ACTION" ADD CONSTRAINT "XPKATC_PERSONNEL_ACTION" PRIMARY KEY ("CASE_ID");
  ALTER TABLE "HHS_CDC_HR"."ATC_PERSONNEL_ACTION" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table CLA_STANDARD
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."CLA_STANDARD" ADD CONSTRAINT "XPK_CLA_STANDARD" PRIMARY KEY ("CASE_ID", "SEQ");
  ALTER TABLE "HHS_CDC_HR"."CLA_STANDARD" MODIFY ("SEQ" NOT NULL ENABLE);
  ALTER TABLE "HHS_CDC_HR"."CLA_STANDARD" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table DUTY_STATION
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."DUTY_STATION" ADD CONSTRAINT "XPK_DUTY_STATION" PRIMARY KEY ("CASE_ID", "SEQ");
  ALTER TABLE "HHS_CDC_HR"."DUTY_STATION" MODIFY ("SEQ" NOT NULL ENABLE);
  ALTER TABLE "HHS_CDC_HR"."DUTY_STATION" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table POSITION_BUILD_APPROVAL
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."POSITION_BUILD_APPROVAL" ADD CONSTRAINT "XPKPOSITION_BUILD_APPROVAL" PRIMARY KEY ("CASE_ID");
  ALTER TABLE "HHS_CDC_HR"."POSITION_BUILD_APPROVAL" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table REC_SME
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."REC_SME" ADD CONSTRAINT "XPK_REC_SME" PRIMARY KEY ("CASE_ID", "SEQ");
  ALTER TABLE "HHS_CDC_HR"."REC_SME" MODIFY ("SEQ" NOT NULL ENABLE);
  ALTER TABLE "HHS_CDC_HR"."REC_SME" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table CONSIDERATION_AREA
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."CONSIDERATION_AREA" ADD CONSTRAINT "XPK_CONSIDERATION_AREA" PRIMARY KEY ("CASE_ID", "SEQ");
  ALTER TABLE "HHS_CDC_HR"."CONSIDERATION_AREA" MODIFY ("SEQ" NOT NULL ENABLE);
  ALTER TABLE "HHS_CDC_HR"."CONSIDERATION_AREA" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table RECRUITMENT
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."RECRUITMENT" ADD CONSTRAINT "XPK_RECRUITMENT" PRIMARY KEY ("CASE_ID");
  ALTER TABLE "HHS_CDC_HR"."RECRUITMENT" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table ATC_SELECTED_BENEFITS
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."ATC_SELECTED_BENEFITS" ADD CONSTRAINT "XPKATC_SELECTED_ENTITLED_BENEF" PRIMARY KEY ("CASE_ID", "SEQ");
  ALTER TABLE "HHS_CDC_HR"."ATC_SELECTED_BENEFITS" MODIFY ("SEQ" NOT NULL ENABLE);
  ALTER TABLE "HHS_CDC_HR"."ATC_SELECTED_BENEFITS" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table ATC_NATURE_OF_ACTION
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."ATC_NATURE_OF_ACTION" ADD CONSTRAINT "XPKATC_NATURE_OF_ACTION" PRIMARY KEY ("CASE_ID", "SEQ");
  ALTER TABLE "HHS_CDC_HR"."ATC_NATURE_OF_ACTION" MODIFY ("SEQ" NOT NULL ENABLE);
  ALTER TABLE "HHS_CDC_HR"."ATC_NATURE_OF_ACTION" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table ATC_BENEFITS
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."ATC_BENEFITS" ADD CONSTRAINT "XPKATC_BENEFITS" PRIMARY KEY ("CASE_ID");
  ALTER TABLE "HHS_CDC_HR"."ATC_BENEFITS" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table CLASSIFIED_POS_TITLE
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."CLASSIFIED_POS_TITLE" ADD CONSTRAINT "XPKCLASSIFIED_POSITION_TITLE" PRIMARY KEY ("CASE_ID", "SEQ");
  ALTER TABLE "HHS_CDC_HR"."CLASSIFIED_POS_TITLE" MODIFY ("SEQ" NOT NULL ENABLE);
  ALTER TABLE "HHS_CDC_HR"."CLASSIFIED_POS_TITLE" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table VALIDATION
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."VALIDATION" ADD CONSTRAINT "XPK_VALIDATION" PRIMARY KEY ("CASE_ID");
  ALTER TABLE "HHS_CDC_HR"."VALIDATION" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table EXTERNAL_LINK_LOOKUP
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."EXTERNAL_LINK_LOOKUP" ADD CONSTRAINT "XPKEXTERNAL_LINK_LOOKUP" PRIMARY KEY ("LINK_ID");
  ALTER TABLE "HHS_CDC_HR"."EXTERNAL_LINK_LOOKUP" MODIFY ("LINK_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TSA_PROCESSING
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."TSA_PROCESSING" ADD CONSTRAINT "XPKTSA_PROCESSING" PRIMARY KEY ("CASE_ID");
  ALTER TABLE "HHS_CDC_HR"."TSA_PROCESSING" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table CAPHR_INFO
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."CAPHR_INFO" ADD CONSTRAINT "XPKCAPHR_INFO" PRIMARY KEY ("CASE_ID");
  ALTER TABLE "HHS_CDC_HR"."CAPHR_INFO" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TRIAGE
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."TRIAGE" ADD CONSTRAINT "XPKTRIAGE" PRIMARY KEY ("CASE_ID");
  ALTER TABLE "HHS_CDC_HR"."TRIAGE" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table CONCURRENCE
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."CONCURRENCE" ADD CONSTRAINT "XPK_CONCURRENCE" PRIMARY KEY ("CASE_ID", "SEQ");
  ALTER TABLE "HHS_CDC_HR"."CONCURRENCE" MODIFY ("SEQ" NOT NULL ENABLE);
  ALTER TABLE "HHS_CDC_HR"."CONCURRENCE" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table ATC_COMPENSATION
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."ATC_COMPENSATION" ADD CONSTRAINT "XPKATC_COMPENSATION" PRIMARY KEY ("CASE_ID");
  ALTER TABLE "HHS_CDC_HR"."ATC_COMPENSATION" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table GRADE
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."GRADE" ADD CONSTRAINT "XPK_GRADE" PRIMARY KEY ("CASE_ID", "SEQ");
  ALTER TABLE "HHS_CDC_HR"."GRADE" MODIFY ("SEQ" NOT NULL ENABLE);
  ALTER TABLE "HHS_CDC_HR"."GRADE" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table EMP_CONDITION
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."EMP_CONDITION" ADD CONSTRAINT "XPK_EMP_CONDITION" PRIMARY KEY ("CASE_ID");
  ALTER TABLE "HHS_CDC_HR"."EMP_CONDITION" MODIFY ("CASE_ID" NOT NULL ENABLE);
  
--------------------------------------------------------
--  Constraints for Table ATC_VALIDATION
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."ATC_VALIDATION" ADD CONSTRAINT "XPKNEED_AND_FUNDING_VALIDATION" PRIMARY KEY ("CASE_ID");
  ALTER TABLE "HHS_CDC_HR"."ATC_VALIDATION" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table POS_TITLE_SERIES
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."POS_TITLE_SERIES" ADD CONSTRAINT "XPKPOSITION_TITLE_SERIES" PRIMARY KEY ("CASE_ID", "SEQ");
  ALTER TABLE "HHS_CDC_HR"."POS_TITLE_SERIES" MODIFY ("SEQ" NOT NULL ENABLE);
  ALTER TABLE "HHS_CDC_HR"."POS_TITLE_SERIES" MODIFY ("CASE_ID" NOT NULL ENABLE);
  
--------------------------------------------------------
--  Constraints for Table APPOINTMENT
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."APPOINTMENT" ADD CONSTRAINT "XPKAPPOINTMENT" PRIMARY KEY ("CASE_ID");
  ALTER TABLE "HHS_CDC_HR"."APPOINTMENT" MODIFY ("CASE_ID" NOT NULL ENABLE);
  
--------------------------------------------------------
--  Constraints for Table APP_TRACKING
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."APP_TRACKING" ADD CONSTRAINT "XPKAPPOINTMENT_TRACKING" PRIMARY KEY ("CASE_ID");
  ALTER TABLE "HHS_CDC_HR"."APP_TRACKING" MODIFY ("CASE_ID" NOT NULL ENABLE);
  
--------------------------------------------------------
--  Constraints for Table POSITION
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."POSITION" ADD CONSTRAINT "XPK_POSITION" PRIMARY KEY ("CASE_ID");
  ALTER TABLE "HHS_CDC_HR"."POSITION" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table FINANCIAL_STATEMENT
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."FINANCIAL_STATEMENT" ADD CONSTRAINT "XPK_FINANCIAL_STATEMENT" PRIMARY KEY ("CASE_ID", "SEQ");
  ALTER TABLE "HHS_CDC_HR"."FINANCIAL_STATEMENT" MODIFY ("SEQ" NOT NULL ENABLE);
  ALTER TABLE "HHS_CDC_HR"."FINANCIAL_STATEMENT" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table CLASSIFICATION
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."CLASSIFICATION" ADD CONSTRAINT "XPK_CLASSIFICATION" PRIMARY KEY ("CASE_ID");
  ALTER TABLE "HHS_CDC_HR"."CLASSIFICATION" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table CLA_CONDITION
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."CLA_CONDITION" ADD CONSTRAINT "XPK_CLA_CONDITION" PRIMARY KEY ("CASE_ID");
  ALTER TABLE "HHS_CDC_HR"."CLA_CONDITION" MODIFY ("CASE_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table LANGUAGE
--------------------------------------------------------

  ALTER TABLE "HHS_CDC_HR"."LANGUAGE" ADD CONSTRAINT "XPK_LANGUAGE" PRIMARY KEY ("CASE_ID", "SEQ");
  ALTER TABLE "HHS_CDC_HR"."LANGUAGE" MODIFY ("SEQ" NOT NULL ENABLE);
  ALTER TABLE "HHS_CDC_HR"."LANGUAGE" MODIFY ("CASE_ID" NOT NULL ENABLE);
