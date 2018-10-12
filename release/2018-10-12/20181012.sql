
--Updating Resources URL
--	Hiring Options Guide
UPDATE HHS_CDC_HR.external_link_lookup
   SET LINK_URL = 'http://intranet.cdc.gov/hro/docs/jobs/hiring-options-guide.pdf'
       ,LINK_DESCRIPTION = 'Provides hiring options, or hiring authorities, which are regulatory requirements under which certain individuals are eligible to be hired.'
 WHERE LINK_ID = 1;

--	Position Description (PD) Library
UPDATE HHS_CDC_HR.external_link_lookup
   SET LINK_URL = 'https://nccdintra.cdc.gov/ORG/Default/Default.aspx'
      ,LINK_DESCRIPTION = 'A database of established Position Descriptions that have already been classified and approved by HRO and assigned to the vacated positions.'
 WHERE LINK_ID = 3;

--	CDC Fellowship Program Policy
UPDATE HHS_CDC_HR.external_link_lookup
   SET LINK_URL = 'http://masoapplications.cdc.gov/Policy/Doc/policy64.pdf'
      ,LINK_DESCRIPTION = 'Provides the requirements for the CDC Fellowship Program, which is used for the temporary employment and professional development of promising research scientists.'
WHERE LINK_ID = 15;

commit;
/


--Table for CapHR Integration. This table will be used to check if a case has been initiated already.
CREATE TABLE CAPHR_INTERFACE_LOG
(
    ID              INTEGER NOT NULL
    ,ACTION_TYPE    VARCHAR2(100)
    ,JR_NO          VARCHAR2(200)
    ,EMP_ID         VARCHAR2(200)
    ,NAMED_ACTION   VARCHAR2(200)
    ,PAR_STATUS     VARCHAR2(200)
    ,PROCID         INTEGER
    ,DSCRPTN        VARCHAR2(4000)
    ,CREATIONDTIME  TIMESTAMP
);

ALTER TABLE CAPHR_INTERFACE_LOG ADD CONSTRAINT CAPHR_INTERFACE_LOG_PK PRIMARY KEY (ID);
/

CREATE INDEX CAPHR_INTERFACE_LOG_NK1 ON CAPHR_INTERFACE_LOG (ID, ACTION_TYPE);
/

CREATE INDEX CAPHR_INTERFACE_LOG_NK2 ON CAPHR_INTERFACE_LOG (JR_NO);
/

CREATE INDEX CAPHR_INTERFACE_LOG_NK3 ON CAPHR_INTERFACE_LOG (EMP_ID, NAMED_ACTION, PAR_STATUS);
/

CREATE SEQUENCE CAPHR_INTERFACE_LOG_SEQ
	INCREMENT BY 1
	START WITH 1
	NOMAXVALUE
	NOCYCLE
	NOCACHE;

/

CREATE OR REPLACE TRIGGER CAPHR_INTERFACE_LOG_BIR
BEFORE INSERT ON CAPHR_INTERFACE_LOG
FOR EACH ROW
BEGIN
	SELECT CAPHR_INTERFACE_LOG_SEQ.NEXTVAL
	INTO :NEW.ID
	FROM DUAL;
END;

/

GRANT SELECT ON HHS_CDC_HR.CAPHR_INTERFACE_LOG TO HHS_CDC_HR_RW_ROLE;
GRANT SELECT ON HHS_CDC_HR.CAPHR_INTERFACE_LOG TO HHS_CDC_HR_DEV_ROLE;
/



