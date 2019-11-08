/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           11/13/2017
||   Category:       Table creation
||
||   Description:    Table structure for DW.T_BMS_REPLICON_TIMESHEET_F
||
||   Parameters:     None
||
||   Historic Info:
||    Name:                                 Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes                           11/13/2017   Initial Creation
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

--DROP TABLE DW.T_DM_PR_AGING_HISTORICAL_DATA CASCADE CONSTRAINTS;

CREATE TABLE DW.T_BMS_REPLICON_TIMESHEET_F
 (
    F_USER_LAST_NAME      VARCHAR2(50)
   ,F_USER_FIRST_NAME    VARCHAR2(50)
   ,F_EMPLOYEE_ID        VARCHAR2(20)
   ,F_LOGIN_NAME         VARCHAR2(50)
   ,F_TIMESHEET_PERIOD   VARCHAR2(50)
   ,F_ENTRY_DATE         DATE
   ,F_CLIENT_NAME        VARCHAR2(50)
   ,F_TIME_OFF_TYPE      VARCHAR2(20)
   ,F_PROJECT_CODE       VARCHAR2(20)
   ,F_BILLING_RATE       VARCHAR2(50)
   ,F_WORK_TYPE          VARCHAR2(20)
   ,F_TOTAL_HOURS        NUMBER(15,2)
   ,F_PAGER_DUTY_DAYS    NUMBER(15,2)
   ,F_SUBMITTED_DATE     DATE
   ,F_APPROVAL_STATUS    VARCHAR2(20)
   ,F_APPROVAL_DTTM      DATE
   ,F_1099               VARCHAR2(10)
   ,F_BRANCH             VARCHAR2(10)
   ,F_DEPT               VARCHAR2(10)
   ,F_USER_GEO           VARCHAR2(10)
   ,F_USER_COST_CTR      VARCHAR2(10)
   ,DW_LOAD_DATE         DATE
   ,DW_MOD_DATE          DATE
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

GRANT SELECT ON DW.T_BMS_REPLICON_TIMESHEET_F TO MSTR;
GRANT SELECT ON DW.T_BMS_REPLICON_TIMESHEET_F TO RPTGEN;
GRANT SELECT ON DW.T_BMS_REPLICON_TIMESHEET_F TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_BMS_REPLICON_TIMESHEET_F TO TM1_ETL_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_BMS_REPLICON_TIMESHEET_F TO SNOVOROL;
