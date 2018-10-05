--Hiring Options Guide
UPDATE HHS_CDC_HR.external_link_lookup
SET LINK_URL = 'http://intranet.cdc.gov/hro/docs/jobs/hiring-options-guide.pdf',
LINK_DESCRIPTION = 'Provides hiring options, or hiring authorities, which are regulatory requirements under which certain individuals are eligible to be hired.'
WHERE LINK_ID = 1;

--Position Description (PD) Library
UPDATE HHS_CDC_HR.external_link_lookup
SET LINK_URL = 'https://nccdintra.cdc.gov/ORG/Default/Default.aspx',
LINK_DESCRIPTION = 'A database of established Position Descriptions that have already been classified and approved by HRO and assigned to the vacated positions.'
WHERE LINK_ID = 3;

--CDC Fellowship Program Policy
UPDATE HHS_CDC_HR.external_link_lookup
SET LINK_URL = 'http://masoapplications.cdc.gov/Policy/Doc/policy64.pdf',
LINK_DESCRIPTION = 'Provides the requirements for the CDC Fellowship Program, which is used for the temporary employment and professional development of promising research scientists.'
WHERE LINK_ID = 15;

Commit;
/