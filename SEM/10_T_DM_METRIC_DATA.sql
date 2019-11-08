/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           08/07/2018
||   Category:       Table creation
||
||   Description:    Creates table DW.T_DM_METRIC_DATA
||
||   Parameters:     None
||
||   Historic Info:
||    Name:              Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes        08/07/2018   Initial Creation
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

-- BEGIN
--   DW.SP_TRUNCATE('DW.T_DM_METRIC_DATA');
-- END;

DROP TABLE DW.T_DM_METRIC_DATA cascade constraints;

create table DW.T_DM_METRIC_DATA
(
  metric_id         NUMBER not null,
  metric_data_value NUMBER,
  metric_data_date  DATE,
  import_date       DATE,
  flex_01           VARCHAR2(100),
  flex_02           VARCHAR2(100),
  flex_03           VARCHAR2(100),
  flex_04           VARCHAR2(100),
  flex_05           VARCHAR2(100),
  flex_06           VARCHAR2(100),
  flex_07           VARCHAR2(100),
  flex_08           VARCHAR2(100),
  flex_09           VARCHAR2(100),
  flex_10           VARCHAR2(100),
  flex_11           VARCHAR2(100),
  flex_12           VARCHAR2(100),
  flex_13           VARCHAR2(100),
  flex_14           VARCHAR2(100),
  flex_15           VARCHAR2(100),
  flex_16           VARCHAR2(100),
  flex_17           VARCHAR2(100),
  flex_18           VARCHAR2(100),
  flex_19           VARCHAR2(2000),
  flex_20           VARCHAR2(2000),
  cust_record_id    VARCHAR2(20),
  flex_21           VARCHAR2(50),
  flex_22           VARCHAR2(50),
  flex_23           VARCHAR2(50),
  flex_24           VARCHAR2(50),
  flex_25           VARCHAR2(50),
  flex_26           VARCHAR2(50),
  flex_27           VARCHAR2(50),
  flex_28           VARCHAR2(50),
  flex_29           VARCHAR2(50),
  flex_30           VARCHAR2(50),
  defects           NUMBER,
  opportunities     NUMBER
)
TABLESPACE TS_LARGE
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
-- Create/Recreate indexes
create index DW.MDT_IMPORT_DATE on DW.T_DM_METRIC_DATA (IMPORT_DATE)
  tablespace TS_MEDIUMX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 25280K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index DW.MDT_METRIC_DATA_DATE on DW.T_DM_METRIC_DATA (METRIC_DATA_DATE)
  tablespace TS_MEDIUMX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 38112K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index DW.MDT_METRIC_ID on DW.T_DM_METRIC_DATA (METRIC_ID)
  tablespace TS_MEDIUMX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 38000K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Create/Recreate primary, unique and foreign key constraints

/*alter table DW.T_DM_METRIC_DATA
  add constraint FK_METRIC_ID foreign key (METRIC_ID)
  references DW.METRIC_DEFINITION (METRIC_ID);
*/
-- Grant/Revoke object privileges

GRANT SELECT ON DW.T_DM_METRIC_DATA TO MSTR;
GRANT SELECT ON DW.T_DM_METRIC_DATA TO RPTGEN;
GRANT SELECT ON DW.T_DM_METRIC_DATA TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DM_METRIC_DATA TO lf188653;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DM_METRIC_DATA TO TM1_ETL_ROLE;
