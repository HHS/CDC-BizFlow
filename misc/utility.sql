
--Generate process variable XML elements
SELECT '<' || RLVNTDATADEFNAME || ' />' AS ProcessVariable
FROM RLVNTDATADEF
WHERE PROCDEFID = (SELECT PROCDEFID
        FROM PROCDEF
        WHERE ISFINAL = 'T'
        AND ENVTYPE = 'O'
        AND NAME = 'Appointment'
        )
AND RLVNTDATADEFNAME != 'wihmode'
ORDER BY RLVNTDATADEFNAME
;
        
SELECT * --RLVNTDATANAME, VALUE, DISPVALUE
FROM RLVNTDATA
WHERE PROCID = 722
AND VALUETYPE = 'P'
AND RLVNTDATANAME = 'higherSupervisor'
;
