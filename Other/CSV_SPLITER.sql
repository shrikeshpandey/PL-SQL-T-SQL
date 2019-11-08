
/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           07/26/2018
||   Category:       Table
||
||   Description:    Returns the value of a bad csv file with commas in parentesis
||
||   Parameters:     None
||
||   Historic Info:
||    Name:             Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes       07/26/2018   csvSeparator
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

CREATE OR REPLACE FUNCTION DW.CSV_SPLITER (in_char IN VARCHAR2(4000) DEFAULT NULL, in_level IN NUMBER DEFAULT 1)
--RETURN NUMBER DETERMINISTIC
RETURN VARCHAR2 DETERMINISTIC
IS

in_char_v VARCHAR2(4000) := in_char;
in_level_v NUMBER := in_level;
return_char VARCHAR2(255);

BEGIN

  WITH C AS
  (
    SELECT in_char_v AS str FROM DUAL
  )
  SELECT TRIM('"' FROM REGEXP_SUBSTR(str, '(".*?"|.*?)(,|$)', 1, level, NULL, 1))
  INTO return_char
  FROM C
  WHERE LEVEL = in_level_v
  CONNECT BY LEVEL <= LENGTH(REGEXP_REPLACE(str,'".*?"|[^,]*'))+1;

  --RETURN return_val ;
  RETURN return_char;

END CSV_SPLITER;
/

GRANT EXECUTE ON DW.CSV_SPLITER TO TM1_ETL_ROLE;
GRANT EXECUTE ON DW.CSV_SPLITER TO MSTR;
GRANT EXECUTE ON DW.CSV_SPLITER TO LF188653;
GRANT EXECUTE ON DW.CSV_SPLITER TO SERVICE_ROLE;
