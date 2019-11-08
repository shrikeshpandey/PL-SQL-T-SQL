/*************************************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           06/12/2019
||   Category:       Table Update
||
||   Description:    Updates table DW.T_BMS_REPLICON_TIMESHEET_STG
||
||   Parameters:     None
||
||   Historic Info:
||   Name:              Date:         Brief Description:
||   ----------------------------------------------------------------------------------------------
||   Luis Fuentes       04/26/2019    Update f_approval_dttm to V
||   ----------------------------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***************************************************************************************************/

-- BEGIN
--   DW.SP_TRUNCATE('DW.T_BMS_REPLICON_TIMESHEET_STG');
-- END;

DROP TABLE DW.T_BMS_REPLICON_TIMESHEET_STG cascade constraints;

create table DW.T_BMS_REPLICON_TIMESHEET_STG
(
  f_user_last_name   VARCHAR2(50),
  f_user_first_name  VARCHAR2(50),
  f_employee_id      VARCHAR2(20),
  f_login_name       VARCHAR2(50),
  f_timesheet_period VARCHAR2(50),
  f_entry_date       DATE,
  f_client_name      VARCHAR2(50),
  f_time_off_type    VARCHAR2(20),
  f_project_code     VARCHAR2(25),
  f_billing_rate     VARCHAR2(50),
  f_work_type        VARCHAR2(20),
  f_total_hours      NUMBER(15,2),
  f_pager_duty_days  NUMBER(15,2),
  f_submitted_date   DATE,
  f_approval_status  VARCHAR2(20),
  f_approval_dttm    VARCHAR2(100),
  f_1099             VARCHAR2(10),
  f_branch           VARCHAR2(10),
  f_dept             VARCHAR2(10),
  f_user_geo         VARCHAR2(10),
  f_user_cost_ctr    VARCHAR2(10)
)
tablespace TS_STAGING
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  )
nologging;

grant select, insert, update, delete, alter, debug on DW.T_BMS_REPLICON_TIMESHEET_STG to LF188653;
grant select, insert, update, delete, alter, debug on DW.T_BMS_REPLICON_TIMESHEET_STG to TM1_ETL_ROLE;

