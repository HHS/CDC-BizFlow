
SELECT
        JOB.EMPLID AS EMP_ID
        ,CASE
            WHEN EMP.LAST_NAME IS NOT NULL OR EMP.FIRST_NAME IS NOT NULL THEN
            EMP.LAST_NAME || ', ' || EMP.FIRST_NAME || ' ' || SUBSTR(EMP.MIDDLE_NAME, 0, 1)
        END AS EMP_NAME
        ,JOB.DEPTID AS ADMIN_CODE
        ,AC.ADMIN_CODE_DESC AS ORG_NAME
        ,TO_CHAR(JOB.GVT_EFFDT, 'YYYY/MM/DD HH24:MI:SS') AS GVT_EFFDT_FORMATTED
        ,TO_CHAR(JOB.GVT_EFFDT_PROPOSED, 'YYYY/MM/DD HH24:MI:SS') AS GVT_EFFDT_PROPOSED_FORMATTED
        ,JOB.ACTION AS PAR_ACTION
        ,JOB.ACTION_REASON AS PAR_ACTION_REASON
        ,JOB.GVT_WIP_STATUS AS PAR_STATUS
        ,JOB.GVT_NOA_CODE
        ,TRIM(JOB.GVT_LEG_AUTH_1 || ' ' || GVT_PAR_AUTH_D1 || ' ' || GVT_PAR_AUTH_D1_2) AS FIRST_AUTH
        ,TRIM(JOB.GVT_LEG_AUTH_2 || ' ' || GVT_PAR_AUTH_D2 || ' ' || GVT_PAR_AUTH_D2_2) AS SECOND_AUTH
        ,EMP.CAN_CD AS CAN
        ,LISTAGG(
                TRIM(RMK.GVT_REMARK_LINE1)
                || DECODE(TRIM(RMK.GVT_REMARK_LINE2), NULL, '', chr(13) || chr(10) || RMK.GVT_REMARK_LINE2)
                || DECODE(TRIM(RMK.GVT_REMARK_LINE3), NULL, '', chr(13) || chr(10) || RMK.GVT_REMARK_LINE3)
                || DECODE(TRIM(RMK.GVT_REMARK_LINE4), NULL, '', chr(13) || chr(10) || RMK.GVT_REMARK_LINE4)
                || DECODE(TRIM(RMK.GVT_REMARK_LINE5), NULL, '', chr(13) || chr(10) || RMK.GVT_REMARK_LINE5)
                || DECODE(TRIM(RMK.GVT_REMARK_LINE6), NULL, '', chr(13) || chr(10) || RMK.GVT_REMARK_LINE6)
                || DECODE(TRIM(RMK.GVT_REMARK_LINE7), NULL, '', chr(13) || chr(10) || RMK.GVT_REMARK_LINE7)
                || DECODE(TRIM(RMK.GVT_REMARK_LINE8), NULL, '', chr(13) || chr(10) || RMK.GVT_REMARK_LINE8)
                || DECODE(TRIM(RMK.GVT_REMARK_LINE9), NULL, '', chr(13) || chr(10) || RMK.GVT_REMARK_LINE9)
                , ';' || chr(13) || chr(10) || chr(13) || chr(10)) WITHIN GROUP(ORDER BY RMK.EMPLID ) AS REMARKS
  FROM HHS_HR.PS_GVT_JOB JOB
        LEFT JOIN HHS_HR.PS_GVT_PAR_REMARKS RMK ON JOB.EMPLID = RMK.EMPLID AND JOB.EFFDT = RMK.EFFDT AND JOB.EMPL_RCD = RMK.EMPL_RCD AND JOB.EFFSEQ = RMK.EFFSEQ
        LEFT JOIN HHS_HR.EMPLOYEE_LOOKUP EMP ON JOB.EMPLID = EMP.EMPLID
        LEFT OUTER JOIN HHS_HR.ADMINISTRATIVE_CODE AC ON AC.ADMIN_CODE = JOB.DEPTID 
WHERE JOB.BUSINESS_UNIT = 'CDC00'
  AND JOB.GVT_WIP_STATUS = 'INI'
  AND JOB.ACTION IN ('PRO','XFR','EXT','DEM','PAY','EZT')
   AND NOT EXISTS (SELECT 1
                     FROM HHS_CDC_HR.ERA_LOG_CAPHR_PAR ERA
                    WHERE ERA.EMPLID = JOB.EMPLID
                      AND ERA.ADMIN_CODE = JOB.DEPTID
                      AND ERA.PAR_ACTION = JOB.ACTION
                      AND ERA.PAR_ACTION_REASON = JOB.ACTION_REASON
                      AND ERA.PAR_STATUS = JOB.GVT_WIP_STATUS
                      AND ERA.GVT_EFFDT = JOB.GVT_EFFDT
                      AND ERA.GVT_EFFDT_PROPOSED_DT = JOB.GVT_EFFDT_PROPOSED
                      )  
  AND JOB.EFFDT = 
		(
			SELECT MAX(EFFDT)
			  FROM HHS_HR.PS_GVT_JOB
			 WHERE EMPLID = JOB.EMPLID
			   AND EMPL_RCD = JOB.EMPL_RCD
			   AND EFFSEQ = JOB.EFFSEQ
               AND EFFDT >= (
                            SELECT LAST_RUN_DTIME               
                              FROM (
                                    SELECT LAST_RUN_DTIME 
                                      FROM HHS_CDC_HR.ERA_LOG_CAPHR_LAST_RUN 
                                     WHERE ERA_SVC_TYPE = 'CAPHR-ERA-PAR'
                                     UNION
                                    SELECT (SYSDATE - 14)
                                      FROM DUAL 
                                   ) TMP                            
                             WHERE ROWNUM = 1
                               AND LAST_RUN_DTIME IS NOT NULL
                           )
		)
  AND RMK.EFFDT = 
		(
			SELECT MAX(EFFDT)
			  FROM HHS_HR.PS_GVT_PAR_REMARKS
			 WHERE EMPLID = RMK.EMPLID
			   AND EMPL_RCD = RMK.EMPL_RCD
			   AND EFFSEQ = RMK.EFFSEQ
               AND EFFDT >= (
                            SELECT LAST_RUN_DTIME               
                              FROM (
                                    SELECT LAST_RUN_DTIME 
                                      FROM HHS_CDC_HR.ERA_LOG_CAPHR_LAST_RUN 
                                     WHERE ERA_SVC_TYPE = 'CAPHR-ERA-PAR'
                                     UNION
                                    SELECT (SYSDATE - 14)
                                      FROM DUAL 
                                   ) TMP                            
                             WHERE ROWNUM = 1
                               AND LAST_RUN_DTIME IS NOT NULL
                           )
		)
GROUP BY
        JOB.EMPLID
        ,CASE
            WHEN EMP.LAST_NAME IS NOT NULL OR EMP.FIRST_NAME IS NOT NULL THEN
            EMP.LAST_NAME || ', ' || EMP.FIRST_NAME || ' ' || SUBSTR(EMP.MIDDLE_NAME, 0, 1)
        END
        ,JOB.DEPTID 
        ,AC.ADMIN_CODE_DESC 
        ,TO_CHAR(JOB.GVT_EFFDT, 'YYYY/MM/DD HH24:MI:SS')
        ,TO_CHAR(JOB.GVT_EFFDT_PROPOSED, 'YYYY/MM/DD HH24:MI:SS') 
        ,JOB.ACTION 
        ,JOB.ACTION_REASON 
        ,JOB.GVT_WIP_STATUS
        ,JOB.GVT_NOA_CODE
        ,TRIM(JOB.GVT_LEG_AUTH_1 || ' ' || GVT_PAR_AUTH_D1 || ' ' || GVT_PAR_AUTH_D1_2)
        ,TRIM(JOB.GVT_LEG_AUTH_2 || ' ' || GVT_PAR_AUTH_D2 || ' ' || GVT_PAR_AUTH_D2_2)
        ,EMP.CAN_CD
    ;


----------------------------------------------------

    
INSERT INTO HHS_CDC_HR.ERA_LOG_CAPHR_PAR
    (
    EMPLID
    ,ADMIN_CODE
    ,PAR_ACTION
    ,PAR_ACTION_REASON
    ,PAR_STATUS
    ,GVT_EFFDT
    ,GVT_EFFDT_PROPOSED_DT
    ,PROCID
    ,ERA_STATUS
    ,DSCRPTN
    ,CREATIONDTIME
    )
VALUES
    (
    '${xpath:/records/record/EMP_ID}'
    ,'${xpath:/records/record/ADMIN_CODE}'
    ,'${xpath:/records/record/PAR_ACTION}'
    ,'${xpath:/records/record/PAR_ACTION_REASON}'
    ,'${xpath:/records/record/PAR_STATUS}'
    ,TO_DATE('${xpath:/records/record/GVT_EFFDT_FORMATTED}', 'YYYY/MM/DD HH24:MI:SS')
    ,TO_DATE('${xpath:/records/record/GVT_EFFDT_PROPOSED_FORMATTED}', 'YYYY/MM/DD HH24:MI:SS')
    ,1
    ,'PROCESSED'
    ,'${xpath:/records/record/REMARKS}'
    ,SYSDATE)
;

-------------------------------------------------

INSERT INTO HHS_CDC_HR.ERA_LOG_CAPHR_PAR
    (
    EMPLID
    ,ADMIN_CODE
    ,PAR_ACTION
    ,PAR_ACTION_REASON
    ,PAR_STATUS
    ,GVT_EFFDT
    ,GVT_EFFDT_PROPOSED_DT
    ,PROCID
    ,ERA_STATUS
    ,DSCRPTN
    ,CREATIONDTIME
    )
VALUES
    (
    '${xpath:/records/record/EMP_ID}'
    ,'${xpath:/records/record/ADMIN_CODE}'
    ,'${xpath:/records/record/PAR_ACTION}'
    ,'${xpath:/records/record/PAR_ACTION_REASON}'
    ,'${xpath:/records/record/PAR_STATUS}'
    ,TO_DATE('${xpath:/records/record/GVT_EFFDT_FORMATTED}', 'YYYY/MM/DD HH24:MI:SS')
    ,TO_DATE('${xpath:/records/record/GVT_EFFDT_PROPOSED_FORMATTED}', 'YYYY/MM/DD HH24:MI:SS')
    ,1
    ,'ERROR'
    ,'${xpath:/records/record/REMARKS}'
    ,SYSDATE)
    ;

SELECT *
FROM HHS_CDC_HR.ERA_LOG_CAPHR_PAR
ORDER BY EMPLID, ADMIN_CODE, PAR_ACTION, PAR_STATUS, GVT_EFFDT
;

DELETE
FROM HHS_CDC_HR.ERA_LOG_CAPHR_PAR
;
COMMIT;
/
