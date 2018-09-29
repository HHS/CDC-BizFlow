--------------------------------------------------------
--  File created - Friday-September-21-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for View ADMIN_CODES
--------------------------------------------------------

  CREATE OR REPLACE VIEW "HHS_CDC_HR"."ADMIN_CODES" ("AC_ADMIN_CD", "AC_ADMIN_CD_DESCR", "AC_PARENT_CD") AS 
  SELECT
	ADMINISTRATIVE_CODE            AS AC_ADMIN_CD
	, DESCRIPTION                  AS AC_ADMIN_CD_DESCR
	, SUBSTR(ADMINISTRATIVE_CODE, 1, LENGTH(ADMINISTRATIVE_CODE) -1) AS AC_PARENT_CD
FROM
	HHS_CDC_HR.ADMINISTRATIVE_CODE
WHERE
	ADMINISTRATIVE_CODE LIKE 'HC%'
;
