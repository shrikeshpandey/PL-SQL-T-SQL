
/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           04/03/2018
||   Category:       Table creation
||
||   Description:    Creates table T_DIM_CLIENT_EMPLOYEE
||
||   Parameters:     None
||
||   Historic Info:
||    Name:              Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes        04/03/2018   Initial Creation
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

-- BEGIN
--   DW.SP_TRUNCATE('DW.T_DIM_CLIENT_EMPLOYEE');
-- END;

--DROP TABLE DW.T_DIM_CLIENT_EMPLOYEE cascade constraints;

CREATE TABLE DW.T_DIM_CLIENT_EMPLOYEE
(
   employee_full_name         VARCHAR2(75)
  ,title                      VARCHAR2(100)
  ,email                      VARCHAR2(75)
  ,ad_username                VARCHAR2(75)
  ,manager_full_name          VARCHAR2(75)
  ,manager_email              VARCHAR2(75)
  ,department_name            VARCHAR2(75)
  ,area                       VARCHAR2(50)
  ,territory                  VARCHAR2(75)
  ,location_name              VARCHAR2(100)
  ,resource_type              VARCHAR2(75)
  ,dw_mod_date                DATE DEFAULT ON NULL SYSDATE
  ,dw_load_date               DATE DEFAULT ON NULL SYSDATE
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

ALTER TABLE DW.T_DIM_CLIENT_EMPLOYEE
ADD CONSTRAINT t_dim_client_employee_pk PRIMARY KEY (ad_username);

GRANT SELECT ON DW.T_DIM_CLIENT_EMPLOYEE TO MSTR;
GRANT SELECT ON DW.T_DIM_CLIENT_EMPLOYEE TO RPTGEN;
GRANT SELECT ON DW.T_DIM_CLIENT_EMPLOYEE TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DIM_CLIENT_EMPLOYEE TO lf188653;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DIM_CLIENT_EMPLOYEE TO TM1_ETL_ROLE;
