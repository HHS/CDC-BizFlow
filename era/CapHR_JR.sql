----------------------------------------------------
-- SQL Queries for "CDC - CapHR - JR" Event Response
-- This is not a really source code but part of sql queries to make ERA service creation easier.
-- SQL below can be changed afterward. Only use this file when to setup CDC HR solution for the first time on Production server
-- You can copy and pastes these queries to ERA Wizard screen.
-- Last Updated 11/15/2018 by Taeho Lee tae.lee@hhs.gov
----------------------------------------------------

----------------------------------------------------
-- Copy query below and paste it to "SQL SELECT query" textbox
----------------------------------------------------

SELECT  distinct REQ.HRS_JOB_OPENING_ID as JOB_OPENING_ID
       ,REQ.ADMIN_CODE as ADMIN_CODE
       ,AC.ADMIN_CODE_DESC as ORG_NAME
       ,REQ.CAN as CAN
       ,REQ.GVT_SEL_OFFICIAL as SELECTING_OFFICIAL_ID
       ,DECODE(M_SO.MEMBERID, NULL, NULL, '[U]' || M_SO.MEMBERID) AS SELECTING_OFFICIAL_MID
       ,M_SO.NAME AS SELECTING_OFFICIAL_NAME
       ,M_SO.EMAIL AS SELECTING_OFFICIAL_EMAIL
       ,REQ.GVT_STAFF_SPCLST as STAFF_SPCLST_ID
       ,DECODE(M_SS.MEMBERID, NULL, NULL, '[U]' || M_SS.MEMBERID) AS STAFF_SPCLST_MID
       ,M_SS.NAME AS STAFF_SPCLST_NAME
       ,M_SS.EMAIL AS STAFF_SPCLST_EMAIL
       ,REQ.ORIGINATOR_ID as CIO_ADMIN_ID
       ,DECODE(M_CA.MEMBERID, NULL, NULL, '[U]' || M_CA.MEMBERID) AS CIO_ADMIN_MID
       ,M_CA.NAME AS CIO_ADMIN_NAME
       ,M_CA.EMAIL AS CIO_ADMIN_EMAIL
       ,dbms_lob.substr( REQ.HE_COMMENTS, 4000, 1 )  AS REMARKS
       ,REQ.STATUS_DT AS STATUS_DT
       ,REQ.CREATE_DATE AS CREATIONDTIME
  FROM HHS_HR.VW_EHRP_15_MIN REQ
        LEFT OUTER JOIN HHS_HR.PS_OPR_DEFN P_SO ON P_SO.OPRID = REQ.GVT_SEL_OFFICIAL
        LEFT OUTER JOIN HHS_HR.PS_OPR_DEFN P_SS ON P_SS.OPRID = REQ.GVT_STAFF_SPCLST
        LEFT OUTER JOIN HHS_HR.PS_OPR_DEFN P_CA ON P_CA.OPRID = REQ.ORIGINATOR_ID
        LEFT OUTER JOIN BIZFLOW.MEMBER M_SO ON lower(M_SO.EMAIL) = lower(P_SO.EMAILID)
        LEFT OUTER JOIN BIZFLOW.MEMBER M_SS ON lower(M_SS.EMAIL) = lower(P_SS.EMAILID)
        LEFT OUTER JOIN BIZFLOW.MEMBER M_CA ON lower(M_CA.EMAIL) = lower(P_CA.EMAILID)
        LEFT OUTER JOIN HHS_HR.ADMINISTRATIVE_CODE AC ON AC.ADMIN_CODE = REQ.ADMIN_CODE
 WHERE REQ.BUSINESS_UNIT = 'CDC00'
   AND NOT EXISTS (SELECT 1 
                     FROM HHS_CDC_HR.ERA_LOG_CAPHR_JR ERA
                    WHERE ERA.JOB_OPENING_ID = REQ.HRS_JOB_OPENING_ID)
   AND REQ.CREATE_DATE >= (
                            SELECT LAST_RUN_DTIME               
                              FROM (
                                    SELECT LAST_RUN_DTIME 
                                      FROM HHS_CDC_HR.ERA_LOG_CAPHR_LAST_RUN 
                                     WHERE ERA_SVC_TYPE = 'CAPHR-ERA-JR'
                                     UNION
                                    SELECT (SYSDATE - 7)
                                      FROM DUAL 
                                   ) TMP                            
                             WHERE ROWNUM = 1
                               AND LAST_RUN_DTIME IS NOT NULL
                           )                      
 ORDER BY REQ.CREATE_DATE DESC
 
 


----------------------------------------------------
-- Copy query below and paste it to "SQL UPDATE/DELETE" textbox
----------------------------------------------------

INSERT INTO HHS_CDC_HR.ERA_LOG_CAPHR_JR
    (JOB_OPENING_ID
    ,PROCID
    ,ERA_STATUS
    ,DSCRPTN
    ,CREATIONDTIME)
VALUES
    ('${xpath:/records/record/JOB_OPENING_ID}'
    ,1
    ,'PROCESSED'
    ,q'[${xpath:/records/record/REMARKS}]'
    ,SYSDATE)
    


----------------------------------------------------
-- Copy query below and paste it to "SQL error recovery statement" textbox
----------------------------------------------------
INSERT INTO HHS_CDC_HR.ERA_LOG_CAPHR_JR
    (JOB_OPENING_ID
    ,PROCID
    ,ERA_STATUS
    ,DSCRPTN
    ,CREATIONDTIME)
VALUES
    ('${xpath:/records/record/JOB_OPENING_ID}'
    ,1
    ,'ERROR'
    ,'''
    ,SYSDATE)
