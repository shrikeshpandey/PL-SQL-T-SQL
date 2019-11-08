CREATE OR REPLACE PROCEDURE DW.SPW_T_DIM_CLIENT_EMPLOYEE (iCommit IN NUMBER DEFAULT 2000
) is

/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           04/04/2018
||   Category:       Table
||
||   Description:    Creates table T_DIM_CLIENT_EMPLOYEE
||
||   Parameters:     None
||
||   Historic Info:
||    Name:           Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes      04/03/2018   Initial Creation That's a small transaction. No pl/sql needed or desired.
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

--Standard Variables
dNow              Date := Sysdate;
iTotalRows        Integer := 0;
iTotalErrors      Integer := 0;
iLoadSequence     Integer := 999999;
iLoadInstanceSeq  Integer;
iExceptionCode    Integer;
vExceptionMessage Varchar2(256);
  ------------------------------------------------------
  -- END DECLARATIONS
  ------------------------------------------------------

  ------------------------------------------------------
  -- BEGIN MAIN
  ------------------------------------------------------
BEGIN --B1

-- Conditional Create of New Seq Number
dw.sp_md_get_next_seq('T_DIM_CLIENT_EMPLOYEE',
     'T_DIM_CLIENT_EMPLOYEE',
     'OBJID',
     1, --- ACTIVE CODE 1 OR 0 PRETTY MUCH ALWAYS ACTIVE '
     'T_DIM_CLIENT_EMPLOYEE',
     'ORACLE DB-LINK',
     'DW TABLE LOAD',
     'SPW_T_DIM_CLIENT_EMPLOYEE',
     iLoadSequence,
     'DW');

dw.pkg_load_verify.p_begin_load(iloadsequence,iloadinstanceseq);
--------------------------------------------------------------------
--That's a small transaction. No pl/sql needed or desired.
-----------------------------------------------------------------
MERGE INTO DW.T_DIM_CLIENT_EMPLOYEE LOCAL
USING(
    SELECT EMPLOYEE_FULL_NAME,
         TITLE,
         EMAIL,
         AD_USERNAME,
         MANAGER_FULL_NAME,
         MANAGER_EMAIL,
         DEPARTMENT_NAME,
         AREA,
         TERRITORY,
         LOCATION_NAME,
         RESOURCE_TYPE,
         DW_MOD_DATE,
         DW_LOAD_DATE
  FROM (
    SELECT ROW_NUMBER() OVER(PARTITION BY AD_USERNAME ORDER BY length(EMPLOYEE_FULL_NAME)) R,
           UPPER(TRIM(EMPLOYEE_FULL_NAME)) AS EMPLOYEE_FULL_NAME,
           UPPER(TRIM(TITLE)) AS TITLE,
           UPPER(TRIM(EMAIL)) AS EMAIL,
           UPPER(TRIM(AD_USERNAME)) AS AD_USERNAME,
           UPPER(TRIM(MANAGER_FULL_NAME)) AS MANAGER_FULL_NAME,
           UPPER(TRIM(MANAGER_EMAIL)) AS MANAGER_EMAIL,
           UPPER(TRIM(DEPARTMENT_NAME)) AS DEPARTMENT_NAME,
           UPPER(TRIM(AREA)) AS AREA,
           UPPER(TRIM(TERRITORY)) AS TERRITORY,
           UPPER(TRIM(LOCATION_NAME)) AS LOCATION_NAME,
           UPPER(TRIM(RESOURCE_TYPE)) AS RESOURCE_TYPE,
           SYSDATE AS DW_MOD_DATE,
           SYSDATE AS DW_LOAD_DATE
    FROM DW.T_DIM_CLIENT_EMPLOYEE_STG
    WHERE AD_USERNAME IS NOT NULL
  ) A
  WHERE A.R = 1
) NEW
 ON (LOCAL.AD_USERNAME = NEW.AD_USERNAME)
WHEN MATCHED THEN
  UPDATE SET LOCAL.EMPLOYEE_FULL_NAME = NEW.EMPLOYEE_FULL_NAME,
             LOCAL.TITLE = NEW.TITLE,
             LOCAL.EMAIL = NEW.EMAIL,
             LOCAL.MANAGER_FULL_NAME = NEW.MANAGER_FULL_NAME,
             LOCAL.MANAGER_EMAIL = NEW.MANAGER_EMAIL,
             LOCAL.DEPARTMENT_NAME = NEW.DEPARTMENT_NAME,
             LOCAL.AREA = NEW.AREA,
             LOCAL.TERRITORY = NEW.TERRITORY,
             LOCAL.LOCATION_NAME = NEW.LOCATION_NAME,
             LOCAL.RESOURCE_TYPE = NEW.RESOURCE_TYPE
WHEN NOT MATCHED THEN
 INSERT (EMPLOYEE_FULL_NAME, TITLE, EMAIL, AD_USERNAME, MANAGER_FULL_NAME, MANAGER_EMAIL, DEPARTMENT_NAME, AREA, LOCATION_NAME, TERRITORY, RESOURCE_TYPE, DW_MOD_DATE, DW_LOAD_DATE)
 VALUES (NEW.EMPLOYEE_FULL_NAME,  NEW.TITLE,  NEW.EMAIL,  NEW.AD_USERNAME,  NEW.MANAGER_FULL_NAME,  NEW.MANAGER_EMAIL,  NEW.DEPARTMENT_NAME,  NEW.AREA, NEW.LOCATION_NAME, NEW.TERRITORY,  NEW.RESOURCE_TYPE,  NEW.DW_MOD_DATE,  NEW.DW_LOAD_DATE);
COMMIT;
   ------------------------------------------------------
   -- END MAIN
   ------------------------------------------------------
END; --B1
/

GRANT EXECUTE ON DW.SPW_T_DIM_CLIENT_EMPLOYEE TO TM1_ETL_ROLE;
GRANT EXECUTE ON DW.SPW_T_DIM_CLIENT_EMPLOYEE TO LF188653;
