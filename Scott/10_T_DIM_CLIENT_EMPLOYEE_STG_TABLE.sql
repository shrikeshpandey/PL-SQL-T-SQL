
/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           07/28/2018
||   Category:       Table creation
||
||   Description:    Creates table T_DIM_CLIENT_EMPLOYEE_STG
||
||   Parameters:     None
||
||   Historic Info:
||    Name:              Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes       07/28/2018   Initial Creation
||
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

-- BEGIN
--   DW.SP_TRUNCATE('DW.T_DIM_CLIENT_EMPLOYEE_STG');
-- END;

--DROP TABLE DW.T_DIM_CLIENT_EMPLOYEE_STG cascade constraints;

CREATE TABLE DW.T_DIM_CLIENT_EMPLOYEE_STG
(
  employee_full_name         VARCHAR2(255)
 ,title                      VARCHAR2(255)
 ,email                      VARCHAR2(255)
 ,ad_username                VARCHAR2(255)
 ,manager_full_name          VARCHAR2(255)
 ,manager_email              VARCHAR2(255)
 ,department_name            VARCHAR2(255)
 ,area                       VARCHAR2(255)
 ,territory                  VARCHAR2(255)
 ,location_name              VARCHAR2(255)
 ,resource_type              VARCHAR2(255)
)
TABLESPACE TS_MEDIUM
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING
NOCOMPRESS
NOCACHE
MONITORING;

GRANT SELECT ON DW.T_DIM_CLIENT_EMPLOYEE_STG TO MSTR;
GRANT SELECT ON DW.T_DIM_CLIENT_EMPLOYEE_STG TO RPTGEN;
GRANT SELECT ON DW.T_DIM_CLIENT_EMPLOYEE_STG TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DIM_CLIENT_EMPLOYEE_STG TO lf188653;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DIM_CLIENT_EMPLOYEE_STG TO TM1_ETL_ROLE;
