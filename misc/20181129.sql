
select EXSTING_SOD_NO 
from HHS_CDC_HR.classification
WHERE CASE_ID = 31224
;

select * from 
hhs_cdc_hr.named_action
;

ALTER TABLE "HHS_CDC_HR"."NAMED_ACTION" 
ADD "JOB_REQ_NO" VARCHAR2(200 BYTE);

