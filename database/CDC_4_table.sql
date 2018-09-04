------------------------------------------------------------------------------------------
--  Name	            : 	4_table.sql
--	Author				:	Taeho Lee <thee@bizflow.com>
--	Copyright			:	BizFlow Corp.	
--	
--	Project				:	HHS CDC HR Workflow Solution - EWITS 2.0
--	Purpose				:	Create HHS_CDC_HR database tables
--	
--  Example
--  To use in SQL statements:
--
-- 	WHEN		WHO			WHAT		
-- 	-----------	--------	-------------------------------------------------------
-- 	04/13/2018	THLEE		Created
------------------------------------------------------------------------------------------

CREATE TABLE HHS_CDC_HR.AUTHORIZED_INCENTIVE
(
	CASE_ID              NUMBER(10) NOT NULL ,
	ANN_LEAVE_NON_FED_SVC VARCHAR2(10) NULL ,
	MOVING_EXP_ATHRZD    VARCHAR2(10) NULL ,
	RELOCATION_INC_ATHRZD VARCHAR2(10) NULL ,
	RECRUITMENT_INC_ATHRZD VARCHAR2(10) NULL ,
	STU_LOAN_REPAY_ATHRZD VARCHAR2(10) NULL ,
	OTHER_INC            VARCHAR2(4000) NULL 
);



CREATE UNIQUE INDEX HHS_CDC_HR.XPK_AUTHORIZED_INCENTIVE ON HHS_CDC_HR.AUTHORIZED_INCENTIVE
(CASE_ID   ASC);


CREATE TABLE HHS_CDC_HR.CLA_CONDITION
(
	CASE_ID              NUMBER(10) NOT NULL ,
	PHYSICIAN_COMP_ALLWNC VARCHAR2(20) NULL ,
	DRUG_TEST_RQRD       VARCHAR2(20) NULL ,
	PRE_EMP_PHYSCL_RQRD  VARCHAR2(20) NULL ,
	SEL_AGNT_ACCSS_RQRD  VARCHAR2(20) NULL ,
	SUBJ_TO_ADDTNL_IDENTICAL VARCHAR2(20) NULL ,
	INCUMBENT_ONLY       VARCHAR2(20) NULL ,
	COMM_CORP_ELIGIBLE   VARCHAR2(20) NULL ,
	FINANCIAL_DSCLSR_RQRD VARCHAR2(20) NULL ,
	CYBER_SEC_CD         VARCHAR2(4000) NULL ,
	BUS_CD               VARCHAR2(4000) NULL ,
	ACQUISITION_CD       VARCHAR2(4000) NULL ,
    OPM_CERT_NO          VARCHAR2(400) NULL ,
    LMTD_TRM             VARCHAR2(100) NULL ,
    LMTD_EMRGNCY         VARCHAR2(100) NULL ,
    LMTD_TRM_NTE         VARCHAR2(100) NULL 
);



CREATE UNIQUE INDEX HHS_CDC_HR.XPK_CLA_CONDITION ON HHS_CDC_HR.CLA_CONDITION
(CASE_ID   ASC);



CREATE TABLE HHS_CDC_HR.CLA_STANDARD
(
	CASE_ID              NUMBER(10) NOT NULL ,
	SEQ                  INTEGER NOT NULL ,
	STANDARD             VARCHAR2(400) NULL 
);



CREATE UNIQUE INDEX HHS_CDC_HR.XPK_CLA_STANDARD ON HHS_CDC_HR.CLA_STANDARD
(CASE_ID   ASC, SEQ   ASC);



CREATE TABLE HHS_CDC_HR.CLASSIFICATION
(
	CASE_ID              NUMBER(10) NOT NULL ,
	ADMN_CD              VARCHAR2(20) NULL ,
	ORG_NM               VARCHAR2(200) NULL ,
	HIRING_METHOD        VARCHAR2(20) NULL ,
	FIRST_SUBDVSN        VARCHAR2(200) NULL ,
	SECOND_SUBDVSN       VARCHAR2(200) NULL ,
	THIRD_SUBDVSN        VARCHAR2(200) NULL ,
	FOURTH_SUBDVSN       VARCHAR2(200) NULL ,
	FIFTH_SUBDVSN        VARCHAR2(200) NULL ,
	SUBMISSION_RSN       VARCHAR2(100) NULL ,
	OTHER_SBMSSN_RSN_DSC VARCHAR2(400) NULL ,
    RQST_TP              VARCHAR2(100) NULL ,
	POS_STATUS           VARCHAR2(20) NULL ,
	EXSTING_PD_NO        VARCHAR2(200) NULL ,
	JOB_REQ_NO           VARCHAR2(200) NULL ,
	SO_NM                VARCHAR2(100) NULL ,
	SO_EMAIL             VARCHAR2(100) NULL ,
	CIO_ADMN_NM          VARCHAR2(100) NULL ,
	CIO_ADMN_EMAIL       VARCHAR2(100) NULL ,
	HRO_SPC_NM           VARCHAR2(100) NULL ,
	HRO_SPC_EMAIL        VARCHAR2(100) NULL ,
	CLA_SPC_NM           VARCHAR2(100) NULL ,
	CLA_SPC_EMAIL        VARCHAR2(100) NULL ,
    POS_BSD_MGMT_SYS_NO  VARCHAR2(100) NULL ,
    EXPLANATION          VARCHAR2(4000) NULL ,
    OFFCL_RSN_SBMSSN     VARCHAR2(400) NULL
);



CREATE UNIQUE INDEX HHS_CDC_HR.XPK_CLASSIFICATION ON HHS_CDC_HR.CLASSIFICATION
(CASE_ID   ASC);



CREATE TABLE HHS_CDC_HR.CLASSIFIED_POS_TITLE
(
   CASE_ID              NUMBER(10) NOT NULL,
   SEQ                  INTEGER NOT NULL ,
   TITLE               VARCHAR2(4000) NULL

);

ALTER TABLE HHS_CDC_HR.CLASSIFIED_POS_TITLE
   ADD CONSTRAINT  XPKClassified_Position_Title PRIMARY KEY (CASE_ID,SEQ);


CREATE TABLE HHS_CDC_HR.CONCURRENCE
(
	CASE_ID              NUMBER(10) NOT NULL ,
	SEQ                  INTEGER NOT NULL ,
	SUPERVISOR_CERT      VARCHAR2(20) NULL ,
	SUPERVISOR_NM        VARCHAR2(100) NULL ,
	SUPERVISOR_APPRVL_DT VARCHAR2(20) NULL ,
	SUPERVISOR_TP        VARCHAR2(20) NULL 
);



CREATE UNIQUE INDEX HHS_CDC_HR.XPK_CONCURRENCE ON HHS_CDC_HR.CONCURRENCE
(CASE_ID   ASC,SEQ   ASC);



CREATE  INDEX HHS_CDC_HR.XIF1_CONCURRENCE ON HHS_CDC_HR.CONCURRENCE
(CASE_ID   ASC);



CREATE TABLE HHS_CDC_HR.CONSIDERATION_AREA
(
	CASE_ID              NUMBER(10) NOT NULL ,
	SEQ                  INTEGER NOT NULL ,
	CONSIDERATION        VARCHAR2(400) NULL ,
    CONSIDERATION_TP     VARCHAR2(400) NULL
);



CREATE UNIQUE INDEX HHS_CDC_HR.XPK_CONSIDERATION_AREA ON HHS_CDC_HR.CONSIDERATION_AREA
(CASE_ID   ASC,SEQ   ASC);



CREATE  INDEX HHS_CDC_HR.XIF1_CONSIDERATION_AREA ON HHS_CDC_HR.CONSIDERATION_AREA
(CASE_ID   ASC);



CREATE TABLE HHS_CDC_HR.DUTY_STATION
(
	CASE_ID              NUMBER(10) NOT NULL ,
	SEQ                  INTEGER NOT NULL ,
	STATION              VARCHAR2(400) NULL 
);



CREATE UNIQUE INDEX HHS_CDC_HR.XPK_DUTY_STATION ON HHS_CDC_HR.DUTY_STATION
(CASE_ID   ASC,SEQ   ASC);



CREATE  INDEX HHS_CDC_HR.XIF1_DUTY_STATION ON HHS_CDC_HR.DUTY_STATION
(CASE_ID   ASC);



CREATE TABLE HHS_CDC_HR.EMP_CONDITION
(
	CASE_ID              NUMBER(10) NOT NULL ,
	FINANCIAL_DSCLSR_RQRD VARCHAR2(10) NULL ,
	PRE_EMP_PHYSCL_RQRD  VARCHAR2(10) NULL ,
	DRG_TST_RQRD         VARCHAR2(10) NULL ,
	IMMUNZTN_RQRD        VARCHAR2(10) NULL ,
	MOBILITY_AGRMNT_RQRD VARCHAR2(10) NULL ,
	LIC_RQRD             VARCHAR2(10) NULL ,
	LIC_INFO             VARCHAR2(1000) NULL ,
	TRVL_RQRD            VARCHAR2(10) NULL ,
	DMSTC_TRVL_PRCNTG    VARCHAR2(100) NULL ,
	INTRNTNL_TRVL_PRCNTG VARCHAR2(100) NULL ,
	FOREIGN_LANG_RQRD    VARCHAR2(10) NULL ,
	OTHER_CON            VARCHAR2(4000) NULL 
);



CREATE UNIQUE INDEX HHS_CDC_HR.XPK_EMP_CONDITION ON HHS_CDC_HR.EMP_CONDITION
(CASE_ID   ASC);



CREATE TABLE HHS_CDC_HR.FINANCIAL_STATEMENT
(
	CASE_ID              NUMBER(10) NOT NULL ,
	SEQ                  INTEGER NOT NULL ,
	STATEMENT            VARCHAR2(400) NULL 
);



CREATE UNIQUE INDEX HHS_CDC_HR.XPK_FINANCIAL_STATEMENT ON HHS_CDC_HR.FINANCIAL_STATEMENT
(CASE_ID, SEQ   ASC);



CREATE TABLE HHS_CDC_HR.GRADE
(
	CASE_ID              NUMBER(10) NOT NULL ,
	SEQ                  INTEGER NOT NULL ,
	GRADE                VARCHAR2(100) NULL 
);



CREATE UNIQUE INDEX HHS_CDC_HR.XPK_GRADE ON HHS_CDC_HR.GRADE
(CASE_ID   ASC,SEQ   ASC);



CREATE  INDEX HHS_CDC_HR.XIF1_GRADE ON HHS_CDC_HR.GRADE
(CASE_ID   ASC);


CREATE TABLE HHS_CDC_HR.POS_TITLE_SERIES
(
	CASE_ID              NUMBER(10) NOT NULL ,
	SEQ                  INTEGER NOT NULL ,
	OFFICIAL_POS_TTL     VARCHAR2(4000) NULL ,
    SERIES               VARCHAR2(4000) NULL
);



CREATE UNIQUE INDEX HHS_CDC_HR.XPK_POS_TITLE_SERIES ON HHS_CDC_HR.POS_TITLE_SERIES
(CASE_ID   ASC,SEQ   ASC);



CREATE  INDEX HHS_CDC_HR.XIF1_POS_TITLE_SERIES ON HHS_CDC_HR.POS_TITLE_SERIES
(CASE_ID   ASC);



CREATE TABLE HHS_CDC_HR.HR_CASE
(
	CASE_ID              NUMBER(10) NOT NULL ,
    CASE_TP              VARCHAR2(20) NULL ,
	CREATOR_NM           VARCHAR2(100) NULL ,
	CREATION_DT          TIMESTAMP NULL, 
	MODIFIER_NM          VARCHAR2(100) NULL ,
	MODIFICATION_DT      TIMESTAMP NULL 
);



CREATE UNIQUE INDEX HHS_CDC_HR.XPKHR_Case ON HHS_CDC_HR.HR_CASE
(CASE_ID   ASC);



CREATE TABLE HHS_CDC_HR.LANGUAGE
(
	CASE_ID              NUMBER(10) NOT NULL ,
    SEQ                  INTEGER NOT NULL ,
	LANG                 VARCHAR2(100) NULL 
);



CREATE UNIQUE INDEX HHS_CDC_HR.XPK_LANGUAGE ON HHS_CDC_HR.LANGUAGE
(CASE_ID   ASC, SEQ ASC);



CREATE TABLE HHS_CDC_HR.POSITION
(
	CASE_ID              NUMBER(10) NOT NULL ,
	JOB_REQ_NO           VARCHAR2(100) NULL ,
	OFFICIAL_POS_TTL     VARCHAR2(4000) NULL ,
	ORG_POS_TTL          VARCHAR2(4000) NULL ,
	CLSSFD_POS_TTL       VARCHAR2(4000) NULL ,
	FNCTNL_POS_TTL       VARCHAR2(4000) NULL ,
	PAY_PLAN             VARCHAR2(4000) NULL ,
	SERIES               VARCHAR2(4000) NULL ,
	PROMO_POTENTIAL      VARCHAR2(400) NULL ,
	POS_SENSITIVITY      VARCHAR2(4000) NULL ,
	FULL_PERF_LVL        VARCHAR2(400) NULL ,
	POS_TP               VARCHAR2(400) NULL ,
	COMMON_ACCT_NO       VARCHAR2(400) NULL ,
	BACKFILL_VC          VARCHAR2(400) NULL ,
	BACKFILL_VC_NM       VARCHAR2(400) NULL ,
	BACKFILL_VC_RSN      VARCHAR2(1000) NULL ,
	NUM_OF_VACANCY       VARCHAR2(400) NULL ,
	APPOINTMENT_TP       VARCHAR2(400) NULL ,
	NOT_TO_EXCEED        VARCHAR2(400) NULL ,
	NAME_REQUEST         VARCHAR2(400) NULL ,
	POS_OPEN_CONT        VARCHAR2(400) NULL ,
	NUM_OF_DAYS_AD       VARCHAR2(400) NULL ,
	WORK_SCH_TP          VARCHAR2(400) NULL ,
	HRS_PER_WEEK         VARCHAR2(400) NULL ,
	REMARKS              VARCHAR2(4000) NULL ,
	SERVICE              VARCHAR2(400) NULL ,
	EMPLOYING_OFF_LOC    VARCHAR2(400) NULL ,
    FAIR_LABOR_STND_ACT  VARCHAR2(4000) NULL ,
    COMP_LVL_CD          VARCHAR2(4000) NULL
);



CREATE UNIQUE INDEX HHS_CDC_HR.XPK_POSITION ON HHS_CDC_HR.POSITION
(CASE_ID   ASC);



CREATE TABLE HHS_CDC_HR.REC_SME
(
	CASE_ID              NUMBER(10) NOT NULL ,
	SEQ                  INTEGER NOT NULL ,
    NAME                 VARCHAR2(200) NULL ,
	EMAIL                VARCHAR2(100) NULL ,
	SME_TP               VARCHAR2(10) NULL ,
	IS_PRIMARY           VARCHAR2(10) NULL ,
	ORG_NM               VARCHAR2(200) NULL 
);



CREATE UNIQUE INDEX HHS_CDC_HR.XPK_REC_SME ON HHS_CDC_HR.REC_SME
(CASE_ID   ASC,SEQ   ASC);



CREATE  INDEX HHS_CDC_HR.XIF1_REC_SME ON HHS_CDC_HR.REC_SME
(CASE_ID   ASC);



CREATE TABLE HHS_CDC_HR.RECRUITMENT
(
	CASE_ID              NUMBER(10) NOT NULL ,
	RQST_TP              VARCHAR2(100) NULL ,
    ADMN_CD              VARCHAR2(20) NULL ,
	ORG_NM               VARCHAR2(200) NULL ,
	HIRING_MTHD          VARCHAR2(20) NULL ,
	SO_NM                VARCHAR2(100) NULL ,
	SO_EML               VARCHAR2(100) NULL ,
	CIO_ADMN_NM          VARCHAR2(100) NULL ,
	CIO_ADMN_EML         VARCHAR2(100) NULL ,
	HRO_SPC_NM           VARCHAR2(100) NULL ,
	HRO_SPC_EML          VARCHAR2(100) NULL ,
	CLA_SPC_NM           VARCHAR2(100) NULL ,
	CLA_SPC_EML          VARCHAR2(100) NULL ,
	COM_CHR_NM           VARCHAR2(100) NULL ,
	COM_CHR_EML          VARCHAR2(100) NULL ,
	COM_CHR_ORG_NM       VARCHAR2(200) NULL ,
	SME_RQRD             VARCHAR2(10) NULL ,
	STFFNG_NEED_VLDTD    VARCHAR2(10) NULL ,
	JSTFCTN_NOT_VLD_STAFF_ND VARCHAR2(4000) NULL ,
	HIRING_OPT_GUIDE_RVWD VARCHAR2(10) NULL ,
	JSTFCTN_NOT_RVWNG_HR_OPT_GD VARCHAR2(4000) NULL ,
    REQ_APPRVD_BY_HHS   VARCHAR2(10) NULL ,
    JSTFCTN_NOT_RCVNG_HHS_APPRL VARCHAR2(4000) NULL ,
	POS_BSD_MGMT_SYS_NO  VARCHAR2(100) NULL 
);



CREATE UNIQUE INDEX HHS_CDC_HR.XPK_RECRUITMENT ON HHS_CDC_HR.RECRUITMENT
(CASE_ID   ASC);



CREATE TABLE HHS_CDC_HR.VALIDATION
(
	CASE_ID              NUMBER(10) NOT NULL ,
	PRE_RECRUITMENT_MTNG_DT VARCHAR2(20) NULL ,
	PPP_PCP_CLRD         VARCHAR2(10) NULL ,
	PPP_PCP_CLRD_DT              VARCHAR2(20) NULL ,
	JUSTFCTN_PPP_PCP_NOT_CLEARED             VARCHAR2(4000) NULL 
);



CREATE UNIQUE INDEX HHS_CDC_HR.XPK_VALIDATION ON HHS_CDC_HR.VALIDATION
(CASE_ID   ASC);


CREATE TABLE GRADE_INFO
(
	CASE_ID              NUMBER(10) NOT NULL ,
	GRADE_SEQ            INTEGER NOT NULL ,
	FAIR_LABOR_STND_ACT  VARCHAR2(4000) NULL ,
	COMP_LVL_CD          VARCHAR2(4000) NULL ,
	PD_NO                VARCHAR2(200) NULL ,
	JOB_CD               VARCHAR2(200) NULL 
);



CREATE UNIQUE INDEX XPKGRADE_INFO ON GRADE_INFO
(CASE_ID   ASC,GRADE_SEQ   ASC);



ALTER TABLE GRADE_INFO
ADD  PRIMARY KEY (CASE_ID,GRADE_SEQ);

--------------------------------------------------
-- Appointment
--------------------------------------------------

CREATE TABLE APP_APPROVAL
(
	CASE_ID              NUMBER(10) NOT NULL ,
	HR_ASSSTNT_NM        VARCHAR2(200) NULL ,
	HR_ASSSTNT_APPRVL_DT VARCHAR2(20) NULL ,
	HRS_SPC_NM           VARCHAR2(200) NULL ,
	HRS_SPC_APPRVL_DT    VARCHAR2(20) NULL ,
	SR_HRS_SPC_NM        VARCHAR2(200) NULL ,
	SR_HRS_SPC_APPRVL_DT VARCHAR2(20) NULL ,
	SLCTD_ADDTNL_APPRVR_NM VARCHAR2(200) NULL ,
	ADDTNL_APPRVL_RQRD   VARCHAR(20) NULL 
);



CREATE UNIQUE INDEX XPKAppointment_Approval ON APP_APPROVAL
(CASE_ID   ASC);



ALTER TABLE APP_APPROVAL
	ADD CONSTRAINT  XPKAppointment_Approval PRIMARY KEY (CASE_ID);



CREATE TABLE APP_TRACKING
(
	CASE_ID              NUMBER(10) NOT NULL ,
	CSO_DEPUTY_DIR_APPRVL VARCHAR2(400) NULL ,
	MEMO_SGND_DT         VARCHAR2(20) NULL ,
	ETHICS_CLRNC_STTS    VARCHAR2(100) NULL ,
	ETHICS_DCSN_RCVD_DT  VARCHAR2(20) NULL ,
	SEC_CLRNC_STTS       VARCHAR2(100) NULL ,
	SEC_DCSN_RCVD_DT     VARCHAR2(20) NULL ,
	WRK_ATHRZTN_STTS     VARCHAR2(20) NULL ,
	WRK_ATHRZTN_DCSN_RCVD_DT VARCHAR2(20) NULL ,
	CAPHR_POS_NO         VARCHAR2(100) NULL ,
	JOB_CD               VARCHAR2(100) NULL 
);



CREATE UNIQUE INDEX XPKAppointment_Tracking ON APP_TRACKING
(CASE_ID   ASC);



ALTER TABLE APP_TRACKING
	ADD CONSTRAINT  XPKAppointment_Tracking PRIMARY KEY (CASE_ID);



CREATE TABLE APPOINTMENT
(
	CASE_ID              NUMBER(10) NOT NULL ,
	RQST_TP              VARCHAR2(100) NULL ,
	HIRING_METHOD        VARCHAR2(20) NULL ,
	POS_STTS             VARCHAR2(200) NULL ,
	ADMIN_CD             VARCHAR2(20) NULL ,
	ORG_NM               VARCHAR2(200) NULL ,
	SHRD_CERT            VARCHAR2(200) NULL ,
	VA_NO                VARCHAR2(200) NULL ,
	CERT_NO              VARCHAR2(200) NULL ,
	AREA_OF_CONSIDERATION VARCHAR(200) NULL ,
	PD_NO                VARCHAR2(200) NULL ,
	JOB_REQ_NO           VARCHAR2(100) NULL ,
	POS_BSD_MGMT_SYS_NO  VARCHAR2(100) NULL ,
	SO_NM                VARCHAR2(100) NULL ,
	SO_EMAIL             VARCHAR2(100) NULL ,
	CIO_ADMN_NM          VARCHAR2(100) NULL ,
	CIO_ADMN_EMAIL       VARCHAR2(100) NULL ,
	HRO_SPC_NM           VARCHAR2(100) NULL ,
	HRO_SPC_EMAIL        VARCHAR2(100) NULL ,
	CLA_SPC_NM           VARCHAR2(100) NULL ,
	CLA_SPC_EMAIL        VARCHAR2(100) NULL ,
	HRO_SPC_ASSSTNT_NM   VARCHAR2(100) NULL ,
	HRO_SPC_ASSSTNT_EMAIL VARCHAR2(100) NULL 
);



CREATE UNIQUE INDEX XPKAppointment ON APPOINTMENT
(CASE_ID   ASC);



ALTER TABLE APPOINTMENT
	ADD CONSTRAINT  XPKAppointment PRIMARY KEY (CASE_ID);



CREATE TABLE ATC_BENEFITS
(
	VISA_TP              VARCHAR2(400) NULL ,
	EMP_ENTTLD_TO_BNFTS  VARCHAR2(100) NULL ,
	ENTTLD_BNFTS         VARCHAR2(4000) NULL ,
	CASE_ID              NUMBER(10) NOT NULL 
);



CREATE UNIQUE INDEX XPKATC_Benefits ON ATC_BENEFITS
(CASE_ID   ASC);



ALTER TABLE ATC_BENEFITS
	ADD CONSTRAINT  XPKATC_Benefits PRIMARY KEY (CASE_ID);



CREATE TABLE ATC_COMPENSATION
(
	CASE_ID              NUMBER(10) NOT NULL ,
	COMMON_ACCT_NO       VARCHAR2(400) NULL ,
	FED_FSCL_YR          VARCHAR2(100) NULL ,
	PRIOR_FED_SVC        VARCHAR2(400) NULL ,
	HIGHEST_PRE_PAY_PLAN VARCHAR2(400) NULL ,
	HIGHEST_PRE_GRADE    VARCHAR2(400) NULL ,
	HIGHEST_PRE_STEP     VARCHAR2(400) NULL ,
	HIGHEST_PRE_SALARY   VARCHAR2(400) NULL ,
	LOCALITY             VARCHAR2(400) NULL ,
	REMARKS              VARCHAR2(4000) NULL ,
	TERM_RTNTIN_ALLWNC   VARCHAR2(400) NULL ,
	PAY_SET_EQV_PAY_PLAN VARCHAR2(400) NULL ,
	PAY_SET_EQV_GRADE    VARCHAR2(400) NULL ,
	PAY_SET_EQV_AMOUNT   VARCHAR2(400) NULL ,
	INCENTIVES           VARCHAR2(400) NULL ,
	MRKT_PAY             VARCHAR2(400) NULL ,
	POST_DIFF_PER        VARCHAR2(400) NULL ,
	POST_DIFF_STTS       VARCHAR2(100) NULL ,
	COLA_PER             VARCHAR2(400) NULL ,
	COLA_STTS            VARCHAR2(100) NULL ,
	DANGER_PAY_STTS      VARCHAR2(100) NULL ,
	PAY_CRDNTD_W_SO      VARCHAR2(400) NULL 
);



CREATE UNIQUE INDEX XPKATC_Compensation ON ATC_COMPENSATION
(CASE_ID   ASC);



ALTER TABLE ATC_COMPENSATION
	ADD CONSTRAINT  XPKATC_Compensation PRIMARY KEY (CASE_ID);



CREATE TABLE ATC_NATURE_OF_ACTION
(
	SEQUENCE             INTEGER NOT NULL ,
	NOAC                 VARCHAR2(400) NULL ,
	FRST_AUTH            VARCHAR2(400) NULL ,
	SCND_AUTH            VARCHAR2(400) NULL ,
	ZLM_DSCRPTN          VARCHAR2(4000) NULL ,
	CASE_ID              NUMBER(10) NOT NULL 
);



CREATE UNIQUE INDEX XPKATC_Nature_of_Action ON ATC_NATURE_OF_ACTION
(CASE_ID   ASC,SEQUENCE   ASC);



ALTER TABLE ATC_NATURE_OF_ACTION
	ADD CONSTRAINT  XPKATC_Nature_of_Action PRIMARY KEY (CASE_ID,SEQUENCE);



CREATE TABLE ATC_PERSONNEL_ACTION
(
	CASE_ID              NUMBER(10) NOT NULL ,
	EFFCTV_DT            VARCHAR2(20) NULL ,
	NTE_DT               VARCHAR2(20) NULL ,
	VETS_PRFRNC          VARCHAR2(400) NULL ,
	INT_HRS_DYS_WRKD_LAST_APPT VARCHAR2(100) NULL ,
	INT_HRS_DYS_WRKD_THIS_APPT VARCHAR2(100) NULL ,
	INT_HRS_DYS_WRKD_LAST_APPT_TP VARCHAR2(10) NULL ,
	INT_HRS_DYS_WRKD_THIS_APPT_TP VARCHAR2(10) NULL 
);



CREATE UNIQUE INDEX XPKATC_Personnel_Action ON ATC_PERSONNEL_ACTION
(CASE_ID   ASC);



ALTER TABLE ATC_PERSONNEL_ACTION
	ADD CONSTRAINT  XPKATC_Personnel_Action PRIMARY KEY (CASE_ID);



CREATE TABLE ATC_POSITION_INFO
(
	CASE_ID              NUMBER(10) NOT NULL ,
	POS_TTL              VARCHAR2(4000) NULL ,
	PAY_PLAN             VARCHAR2(4000) NULL ,
	SERIES               VARCHAR2(4000) NULL ,
	GRADE                VARCHAR2(100) NULL ,
	LOCATION             VARCHAR2(400) NULL ,
	EMPLY_TP             VARCHAR2(100) NULL ,
	LAST_NM              VARCHAR2(200) NULL ,
	FIRST_NM             VARCHAR2(200) NULL ,
	MIDDLE_INITIAL       VARCHAR2(200) NULL ,
	CNTRY_OF_CTZNSHP     VARCHAR2(200) NULL ,
	EMP_ID               VARCHAR2(200) NULL 
);



CREATE UNIQUE INDEX XPKATC_Position_Information ON ATC_POSITION_INFO
(CASE_ID   ASC);



ALTER TABLE ATC_POSITION_INFO
	ADD CONSTRAINT  XPKATC_Position_Information PRIMARY KEY (CASE_ID);



CREATE TABLE ATC_VALIDATION
(
	CASE_ID              NUMBER(10) NOT NULL ,
	STFFNG_NEED_VLDTD    VARCHAR2(100) NULL ,
	JSTFCTN_NOT_STFFNG_NEED_VLDTD VARCHAR2(4000) NULL ,
	PBMS_FUND_CNFRMD     VARCHAR2(100) NULL ,
	JSTFCTN_NOT_PBMS_FUND_CNFRMD VARCHAR2(4000) NULL ,
	HRNG_OPTNS_GID_RVWD  VARCHAR2(100) NULL ,
	JSTFCTN_NOT_HRNG_OPTNS_GID VARCHAR2(4000) NULL ,
	SLT_RQSTD            VARCHAR2(100) NULL ,
	JSTFCTN_NOT_SLT_RQSTD VARCHAR2(4000) NULL 
);



CREATE UNIQUE INDEX XPKNeed_And_Funding_Validation ON ATC_VALIDATION
(CASE_ID   ASC);



ALTER TABLE ATC_VALIDATION
	ADD CONSTRAINT  XPKNeed_And_Funding_Validation PRIMARY KEY (CASE_ID);



CREATE TABLE POSITION_BUILD_APPROVAL
(
	CASE_ID              NUMBER(10) NOT NULL ,
	ACTV_N_ACCRT         VARCHAR2(100) NULL ,
	ALL_SIGN_OF8         VARCHAR2(100) NULL ,
	CAPHR_POS_NO         VARCHAR2(100) NULL ,
	JOB_CODE             VARCHAR2(100) NULL ,
	BUS_ARRVD            VARCHAR2(100) NULL ,
	SPRVSRY_STTS_APPRVD  VARCHAR2(100) NULL ,
	FLSA_APPRVD          VARCHAR2(100) NULL ,
	ADMIN_CD_APPRVD      VARCHAR2(100) NULL ,
	PM_STWRD_NM          VARCHAR2(100) NULL ,
	PM_STWRD_APPRVD      VARCHAR2(100) NULL 
);



CREATE UNIQUE INDEX XPKPosition_Build_Approval ON POSITION_BUILD_APPROVAL
(CASE_ID   ASC);



ALTER TABLE POSITION_BUILD_APPROVAL
	ADD CONSTRAINT  XPKPosition_Build_Approval PRIMARY KEY (CASE_ID);



CREATE TABLE TSA_PROCESSING
(
	CASE_ID              NUMBER(10) NOT NULL ,
	TSA_PRCSSR_NM        VARCHAR2(200) NULL ,
	TSA_PRCSSR_APPRVL_DT VARCHAR2(100) NULL ,
	DOC_SCANNED_TO_EOPF  VARCHAR2(100) NULL ,
	QLTY_ASSRNC_RVW_CMPL VARCHAR2(100) NULL ,
	ADDTNL_APPRVL_RQRD   VARCHAR2(20) NULL ,
	ADDTNL_TSA_PRCSSR_NM VARCHAR2(200) NULL ,
	SLCTD_ADDTNL_TSA_PRCSSR_NM VARCHAR2(200) NULL ,
	ADDTNL_TSA_PRCSSR_APPRVL_DT VARCHAR2(20) NULL 
);



CREATE UNIQUE INDEX XPKTSA_Processing ON TSA_PROCESSING
(CASE_ID   ASC);



ALTER TABLE TSA_PROCESSING
	ADD CONSTRAINT  XPKTSA_Processing PRIMARY KEY (CASE_ID);








