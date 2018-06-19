--------------------------------------------------------
--  File created - Wednesday-June-06-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function FN_CONCAT_HR_RECORDS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "HHS_CDC_HR"."FN_CONCAT_HR_RECORDS" (
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

    PLSQL_BLOCK := ' BEGIN select listagg( ' || columnname || ' , '';'') WITHIN GROUP (ORDER BY case_id) '
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
--  DDL for Function FN_GET_FORM_DATA_FIELD_VALUE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "HHS_CDC_HR"."FN_GET_FORM_DATA_FIELD_VALUE" ( 
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

  CREATE OR REPLACE FUNCTION "HHS_CDC_HR"."FN_GET_LOOKUP_LABEL" 
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

  CREATE OR REPLACE FUNCTION "HHS_CDC_HR"."FN_GET_LOOKUP_LABEL_BY_NAME" 
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

  CREATE OR REPLACE FUNCTION "HHS_CDC_HR"."FN_GET_XML_FIELD_VALUE" (   
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

  CREATE OR REPLACE FUNCTION "HHS_CDC_HR"."FN_GET_XML_NODE_VALUE" (   
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
