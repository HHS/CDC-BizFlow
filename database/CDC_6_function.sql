------------------------------------------------------------------------------------------
--  Name	            : 	CDC_6_function.sql
--	Author				:	Taeho Lee <thee@bizflow.com>
--	
--	Project				:	HHS CDC HR Workflow Solution - EWITS 2.0
--	Purpose				:	Creating functions in HHS_CDC_HR database schema
--	
--  Notes               :   Run on HHS_CDC_HR schema
--
-- 	WHEN		WHO			WHAT		
-- 	-----------	--------	-------------------------------------------------------
-- 	11/14/2018	THLEE		Created
------------------------------------------------------------------------------------------

--------------------------------------------------------
--  DDL for Function FN_CONCAT_HR_RECORDS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "HHS_CDC_HR"."FN_CONCAT_HR_RECORDS" (
  tablename in varchar2, 
  columnname in varchar2, 
  case_id in number 
) return varchar2 

    ------------------------------------------------------------------------------------------
    --  Procedure name	    : 	fn_concat_hr_records
    --	Author				:	Taeho Lee <thee@bizflow.com>
    --	Copyright			:	BizFlow Corp.	
    --	
    --	Project				:	HHS CDC HR Workflow Solution - EWITS 2.0
    --	Purpose				:	Concatenate records in a column in a CASE_ID into one string value
    --	
    --  Example
    --  To use in SQL statements:
    --
    -- 	WHEN		WHO			WHAT		
    -- 	-----------	--------	-------------------------------------------------------
    -- 	04/13/2018	THLEE		Created
    ------------------------------------------------------------------------------------------

is 

    PLSQL_BLOCK VARCHAR2(4000);
    resultStr VARCHAR2(4000);

begin

/*
    select listagg(grade, ',') WITHIN GROUP (ORDER BY case_id)
    into resultStr
    from grade
    where case_id = 2
    group by case_id;
*/

    PLSQL_BLOCK := ' BEGIN select listagg( ' || columnname || ' , ''; '') WITHIN GROUP (ORDER BY case_id) '
                    || ' into :x '
                    || ' from ' || tablename || ' '
                    || ' where case_id = ' || TO_CHAR(case_id)
                    || ' group by case_id; '
                    || ' END;';

    EXECUTE IMMEDIATE PLSQL_BLOCK USING out resultStr; -- USING IN CONF_DEBUGMODE;

  return resultStr;

end fn_concat_hr_records;

/

--------------------------------------------------------
--  DDL for Function FN_PARSENAME
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "HHS_CDC_HR"."FN_PARSENAME" 
(
  I_FULLNAME IN VARCHAR2 
, I_NAMEFORMAT IN VARCHAR2 
) RETURN VARCHAR2 AS

    FORMATTED_NAME VARCHAR2(1000);
    FULL_NAME VARCHAR2(1000);
    FIRST_NAME VARCHAR2(200);
    MIDDLE_NAME VARCHAR2(200);
    LAST_NAME VARCHAR2(200);
    SUFFIX_NAME VARCHAR2(200);
    IDX_COMMA INTEGER;
    IDX_SPACE INTEGER;

BEGIN

    IF I_FULLNAME IS NOT NULL THEN
        BEGIN    

            SELECT REPLACE(I_FULLNAME, '  ', '')
              INTO FULL_NAME
              FROM DUAL;

            SELECT INSTR(FULL_NAME, ',')
              INTO IDX_COMMA
              FROM DUAL;

            SELECT INSTR(FULL_NAME, ' ')
              INTO IDX_SPACE
              FROM DUAL;

            IF (IDX_COMMA > 0) THEN
                --FORMATTED_NAME := 'COMMA';

                SELECT REGEXP_SUBSTR(FULL_NAME,'[^, .]+',1,1),
                      REGEXP_SUBSTR(FULL_NAME,'[^, .]+',1,2),
                      REGEXP_SUBSTR(FULL_NAME,'[^, .]+',1,3),
                      TRANSLATE(REGEXP_SUBSTR(FULL_NAME,'( |\.|,)(JR|MR|MS|SR)(\.|,|$)',1,1),'A ,.','A')
                  INTO
                        LAST_NAME
                        ,FIRST_NAME
                        ,MIDDLE_NAME
                        ,SUFFIX_NAME
                  FROM DUAL;

            ELSE

                IF (IDX_SPACE > 0) THEN
                    SELECT REGEXP_SUBSTR(FULL_NAME,'[^, .]+',1,1),
                          REGEXP_SUBSTR(FULL_NAME,'[^, .]+',1,2),
                          REGEXP_SUBSTR(FULL_NAME,'[^, .]+',1,3),
                          TRANSLATE(REGEXP_SUBSTR(FULL_NAME,'( |\.|,)(JR|MR|MS|SR)(\.|,|$)',1,1),'A ,.','A')
                      INTO
                            FIRST_NAME
                            ,MIDDLE_NAME
                            ,LAST_NAME
                            ,SUFFIX_NAME
                      FROM DUAL;
                ELSE
                    LAST_NAME := FULL_NAME;
                    FIRST_NAME := '';
                    MIDDLE_NAME := '';
                    SUFFIX_NAME := '';

                END IF;

            END IF;

            --Exception Cases
            IF LAST_NAME IS NULL AND MIDDLE_NAME IS NOT NULL THEN
                LAST_NAME := MIDDLE_NAME;
                MIDDLE_NAME := '';
            END IF;

            IF MIDDLE_NAME = SUFFIX_NAME THEN
                MIDDLE_NAME := '';
            END IF;            

            IF LAST_NAME = SUFFIX_NAME THEN
                LAST_NAME := MIDDLE_NAME;
                MIDDLE_NAME := '';
            END IF;

            IF LAST_NAME = SUFFIX_NAME THEN
                LAST_NAME := MIDDLE_NAME;
                MIDDLE_NAME := '';
            END IF;

        END;    
    ELSE
        FORMATTED_NAME := '';
    END IF;

    IF (I_NAMEFORMAT = 'FULL') THEN

        IF (SUFFIX_NAME IS NOT NULL) THEN
            FORMATTED_NAME := LAST_NAME || ', ' || FIRST_NAME || ' ' || MIDDLE_NAME || '.' || SUFFIX_NAME;
        ELSE
            FORMATTED_NAME := LAST_NAME || ', ' || FIRST_NAME || ' ' || MIDDLE_NAME;
        END IF;

    ELSIF (I_NAMEFORMAT = 'INITIAL') THEN
        FORMATTED_NAME := UPPER(SUBSTR(FIRST_NAME,1,1)) || UPPER(SUBSTR(LAST_NAME, 1,1));

    ELSIF (I_NAMEFORMAT = 'FULL+INITIAL') THEN
        IF (SUFFIX_NAME IS NOT NULL) THEN
            FORMATTED_NAME := LAST_NAME || ', ' || FIRST_NAME || ' ' || MIDDLE_NAME || '.' || SUFFIX_NAME || ' [' || UPPER(SUBSTR(FIRST_NAME,1,1)) || UPPER(SUBSTR(LAST_NAME, 1,1)) || ']';
        ELSE
            FORMATTED_NAME := LAST_NAME || ', ' || FIRST_NAME || ' ' || MIDDLE_NAME || ' [' || UPPER(SUBSTR(FIRST_NAME,1,1)) || UPPER(SUBSTR(LAST_NAME, 1,1)) || ']';
        END IF;
    ELSE
        IF (SUFFIX_NAME IS NOT NULL) THEN
            FORMATTED_NAME := LAST_NAME || ', ' || FIRST_NAME || ' ' || MIDDLE_NAME || '.' || SUFFIX_NAME;
        ELSE
            FORMATTED_NAME := LAST_NAME || ', ' || FIRST_NAME || ' ' || MIDDLE_NAME;
        END IF;

    END IF;

    RETURN FORMATTED_NAME;

END FN_PARSENAME;

/

--------------------------------------------------------
--  DDL for Function FN_GET_ACT_CMPLTUSR
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "HHS_CDC_HR"."FN_GET_ACT_CMPLTUSR" 
(
  I_PROCID IN NUMBER 
, I_ACTNAME IN VARCHAR2 
, I_RETTYPE IN VARCHAR2 
) RETURN VARCHAR2 IS

    RETVALUE VARCHAR2(2000);
    CMPLT_USR_ID VARCHAR2(10);
    CMPLT_USR_NAME VARCHAR2(200);

BEGIN

    WITH CMPLUSRS AS (
        SELECT W.CMPLTUSRNAME, W.CMPLTUSR
        FROM bizflow.ACT A
            JOIN bizflow.WITEM W ON W.PROCID = A.PROCID and W.ACTSEQ = A.ACTSEQ
        WHERE A.TYPE = 'P'
        AND A.CMPLTDTIME IS NOT NULL
        AND A.PROCID = I_PROCID
        AND UPPER(A.NAME) = UPPER(I_ACTNAME)
        ORDER BY W.WITEMSEQ DESC)
    SELECT CMPLTUSRNAME, CMPLTUSR
      INTO CMPLT_USR_NAME
            ,CMPLT_USR_ID  
    FROM CMPLUSRS
    WHERE rownum = 1;

    IF (I_RETTYPE = 'ID') THEN
        RETVALUE := CMPLT_USR_ID;
    ELSE
        SELECT HHS_CDC_HR.FN_PARSENAME(CMPLT_USR_NAME, I_RETTYPE)
          INTO CMPLT_USR_NAME
          FROM DUAL;

        RETVALUE := CMPLT_USR_NAME;
    END IF;

  RETURN RETVALUE;

END FN_GET_ACT_CMPLTUSR;

/

--------------------------------------------------------
--  DDL for Function FN_GET_FORM_DATA_FIELD_VALUE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "HHS_CDC_HR"."FN_GET_FORM_DATA_FIELD_VALUE" ( 
    I_PROCID IN INTEGER
    ,I_FIELD_ID IN VARCHAR2
) RETURN VARCHAR2 

    ------------------------------------------------------------------------------------------
    --  Procedure name	    : 	FN_GET_FORM_DATA_FIELD_VALUE
    --	Author				:	Taeho Lee <thee@bizflow.com>
    --	Copyright			:	BizFlow Corp.	
    --	
    --	Project				:	HHS CDC HR Workflow Solution - EWITS 2.0
    --	Purpose				:	Get a field value in HHS_CDC_HR.TBL_FORM_DTL.FIELD_DATA XMLTYPE column in a CASE_ID
    --	
    --  Example
    --  To use in SQL statements:
    --
    -- 	WHEN		WHO			WHAT		
    -- 	-----------	--------	-------------------------------------------------------
    -- 	04/17/2018	THLEE		Created
    ------------------------------------------------------------------------------------------


AS 

    NODE_VALUE  VARCHAR2(10000) := NULL;

BEGIN

    --DBMS_OUTPUT.PUT_LINE('I_FIELD_ID=' || I_FIELD_ID);

    SELECT TBL.FIELDVALUE
      INTO NODE_VALUE
      FROM ( 
            SELECT extractvalue(FIELD_DATA, '/formData/items/item[id="' || I_FIELD_ID || '"]/text/text()') as FIELDVALUE
              FROM HHS_CDC_HR.TBL_FORM_DTL
             WHERE PROCID = I_PROCID
             UNION ALL    
            SELECT extractvalue(FIELD_DATA, '/formData/items/item[id="' || I_FIELD_ID || '"]/value/text()')
              FROM HHS_CDC_HR.TBL_FORM_DTL
             WHERE PROCID = I_PROCID
           ) TBL
     WHERE (TBL.FIELDVALUE IS NOT NULL OR TBL.FIELDVALUE != '') 
       AND ROWNUM = 1;

    RETURN NODE_VALUE;

EXCEPTION 
WHEN NO_DATA_FOUND THEN
    RETURN '';
WHEN OTHERS THEN
    RETURN '';
END FN_GET_FORM_DATA_FIELD_VALUE;

/

--------------------------------------------------------
--  DDL for Function FN_GET_LOOKUP_LABEL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "HHS_CDC_HR"."FN_GET_LOOKUP_LABEL" 
(
  LTYPE IN VARCHAR2 
, LCODE IN VARCHAR2 
) RETURN VARCHAR2 AS 

L_LABEL VARCHAR2(4000);

BEGIN

    BEGIN
        SELECT TBL_LABEL
          INTO L_LABEL
          FROM TBL_LOOKUP
         WHERE TBL_LTYPE = LTYPE
           AND TBL_ID = LCODE
           AND TBL_ACTIVE = 1;

    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            L_LABEL := LCODE;
    END;

  RETURN L_LABEL;

END FN_GET_LOOKUP_LABEL;



/
--------------------------------------------------------
--  DDL for Function FN_GET_LOOKUP_LABEL_BY_NAME
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "HHS_CDC_HR"."FN_GET_LOOKUP_LABEL_BY_NAME" 
(
  LTYPE IN VARCHAR2 
, LNAME IN VARCHAR2 
) RETURN VARCHAR2 AS 

L_LABEL VARCHAR2(4000);

BEGIN

    BEGIN
        SELECT TBL_LABEL
          INTO L_LABEL
          FROM TBL_LOOKUP
         WHERE TBL_LTYPE = LTYPE
           AND TBL_NAME = LNAME
           AND TBL_ACTIVE = 1;

    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            L_LABEL := LNAME;
    END;

  RETURN L_LABEL;

END FN_GET_LOOKUP_LABEL_BY_NAME;

/

--------------------------------------------------------
--  DDL for Function FN_GET_XML_FIELD_VALUE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "HHS_CDC_HR"."FN_GET_XML_FIELD_VALUE" (   
    I_XMLNODE IN XMLTYPE,
    I_FIELD_ID IN VARCHAR2
) RETURN VARCHAR2

    ------------------------------------------------------------------------------------------
    --  Procedure name	    : 	FN_GET_FORM_DATA_FIELD_VALUE
    --	Author				:	Taeho Lee <thee@bizflow.com>
    --	Copyright			:	BizFlow Corp.	
    --	
    --	Project				:	HHS CDC HR Workflow Solution - EWITS 2.0
    --	Purpose				:	Get a field value in a XMLTYPE field
    --	
    --  Example
    --  To use in SQL statements:
    --
    -- 	WHEN		WHO			WHAT		
    -- 	-----------	--------	-------------------------------------------------------
    -- 	04/17/2018	THLEE		Created
    ------------------------------------------------------------------------------------------

AS 

    NODE_VALUE  VARCHAR2(10000) := NULL;

BEGIN
    --DBMS_OUTPUT.PUT_LINE('I_FIELD_ID=' || I_FIELD_ID);
    IF I_XMLNODE IS NOT NULL THEN

        SELECT TBL.FIELDVALUE
          INTO NODE_VALUE
          FROM ( 
                SELECT extractvalue(I_XMLNODE, '/formData/items/item[id="' || I_FIELD_ID || '"]/text/text()') as FIELDVALUE
                  FROM DUAL
                 UNION ALL    
                SELECT extractvalue(I_XMLNODE, '/formData/items/item[id="' || I_FIELD_ID || '"]/value/text()')
                  FROM DUAL
               ) TBL
         WHERE (TBL.FIELDVALUE IS NOT NULL OR TBL.FIELDVALUE != '') 
           AND ROWNUM = 1;

    END IF;

    RETURN NODE_VALUE;

EXCEPTION 
WHEN NO_DATA_FOUND THEN
    RETURN '';
WHEN OTHERS THEN
    RETURN '';
END FN_GET_XML_FIELD_VALUE;

/

--------------------------------------------------------
--  DDL for Function FN_GET_XML_NODE_VALUE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "HHS_CDC_HR"."FN_GET_XML_NODE_VALUE" (   
    I_XMLNODE IN XMLTYPE,
    I_FIELD_ID IN VARCHAR2
) RETURN VARCHAR2

    ------------------------------------------------------------------------------------------
    --  Procedure name	    : 	FN_GET_XML_NODE_VALUE
    --	Author				:	Taeho Lee <thee@bizflow.com>
    --	Copyright			:	BizFlow Corp.	
    --	
    --	Project				:	HHS CDC HR Workflow Solution - EWITS 2.0
    --	Purpose				:	Get a field value in a XMLTYPE node
    --	
    --  Example
    --  To use in SQL statements:
    --
    -- 	WHEN		WHO			WHAT		
    -- 	-----------	--------	-------------------------------------------------------
    -- 	06/05/2018	THLEE		Created
    ------------------------------------------------------------------------------------------

AS 

    NODE_VALUE  VARCHAR2(10000) := NULL;

BEGIN
    --DBMS_OUTPUT.PUT_LINE('I_FIELD_ID=' || I_FIELD_ID);
    IF I_XMLNODE IS NOT NULL THEN

        SELECT extractvalue(I_XMLNODE, '/formData/items/item[id="' || I_FIELD_ID || '"]/value/text()')
          INTO NODE_VALUE
          FROM DUAL;

    END IF;

    RETURN NODE_VALUE;

EXCEPTION 
WHEN NO_DATA_FOUND THEN
    RETURN '';
WHEN OTHERS THEN
    RETURN '';
END FN_GET_XML_NODE_VALUE;

/

--------------------------------------------------------
--  DDL for Function FN_GET_XML_VALUE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "HHS_CDC_HR"."FN_GET_XML_VALUE" (   
    I_XMLNODE IN XMLTYPE,
    I_FIELD_ID IN VARCHAR2,
    I_VALUE_TYPE IN VARCHAR2
) RETURN VARCHAR2

    ------------------------------------------------------------------------------------------
    --  Procedure name	    : 	FN_GET_XML_VALUE
    --	Author				:	Taeho Lee <thee@bizflow.com>
    --	Copyright			:	BizFlow Corp.	
    --	
    --	Project				:	HHS CDC HR Workflow Solution - EWITS 2.0
    --	Purpose				:	Get a field value in a XMLTYPE field
    --	
    --  Example
    --  To use in SQL statements:
    --
    -- 	WHEN		WHO			WHAT		
    -- 	-----------	--------	-------------------------------------------------------
    -- 	08/29/2018	THLEE		Created
    ------------------------------------------------------------------------------------------

AS 

    NODE_VALUE  VARCHAR2(10000) := NULL;

BEGIN
    --DBMS_OUTPUT.PUT_LINE('I_FIELD_ID=' || I_FIELD_ID);
    IF I_XMLNODE IS NOT NULL THEN

        IF UPPER(I_VALUE_TYPE) = 'VALUE' THEN
            BEGIN
                    SELECT TBL.FIELDVALUE
                      INTO NODE_VALUE
                      FROM ( 
                            SELECT extractvalue(I_XMLNODE, '/formData/items/item[id="' || I_FIELD_ID || '"]/value/text()') as FIELDVALUE
                              FROM DUAL
                           ) TBL
                     WHERE (TBL.FIELDVALUE IS NOT NULL OR TBL.FIELDVALUE != '') 
                       AND ROWNUM = 1;
            END;
        ELSE
            BEGIN
                    SELECT TBL.FIELDVALUE
                      INTO NODE_VALUE
                      FROM ( 
                            SELECT extractvalue(I_XMLNODE, '/formData/items/item[id="' || I_FIELD_ID || '"]/text/text()') as FIELDVALUE
                              FROM DUAL
                           ) TBL
                     WHERE (TBL.FIELDVALUE IS NOT NULL OR TBL.FIELDVALUE != '') 
                       AND ROWNUM = 1;        
            END;
        END IF;

    END IF;

    RETURN NODE_VALUE;

EXCEPTION 
WHEN NO_DATA_FOUND THEN
    RETURN '';
WHEN OTHERS THEN
    RETURN '';
END FN_GET_XML_VALUE;

/

