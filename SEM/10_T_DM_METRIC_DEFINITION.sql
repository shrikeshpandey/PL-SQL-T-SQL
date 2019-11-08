
/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           08/07/2018
||   Category:       Table creation
||
||   Description:    Creates table DW.T_DM_METRIC_DEFINITION
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
--   DW.SP_TRUNCATE('DW.T_DM_METRIC_DEFINITION');
-- END;

--DROP TABLE DW.T_DM_METRIC_DEFINITION cascade constraints;

-- Create table
create table DW.T_DM_METRIC_DEFINITION
(
  metric_id                  NUMBER not null,
  metric_name                VARCHAR2(100) not null,
  metric_definition          VARCHAR2(2500) not null,
  upper_spec                 NUMBER,
  lower_spec                 NUMBER,
  flex_01                    VARCHAR2(50),
  flex_02                    VARCHAR2(50),
  flex_03                    VARCHAR2(50),
  flex_04                    VARCHAR2(50),
  flex_05                    VARCHAR2(50),
  flex_06                    VARCHAR2(50),
  flex_07                    VARCHAR2(50),
  flex_08                    VARCHAR2(50),
  flex_09                    VARCHAR2(50),
  flex_10                    VARCHAR2(50),
  flex_11                    VARCHAR2(50),
  flex_12                    VARCHAR2(50),
  flex_13                    VARCHAR2(50),
  flex_14                    VARCHAR2(50),
  flex_15                    VARCHAR2(50),
  flex_16                    VARCHAR2(50),
  flex_17                    VARCHAR2(50),
  flex_18                    VARCHAR2(50),
  flex_19                    VARCHAR2(50),
  flex_20                    VARCHAR2(50),
  attainment_percentage      NUMBER(6,2),
  active                     CHAR(10) default 'N',
  created_date               DATE,
  iscontractual              VARCHAR2(3),
  usespecboundingraph        CHAR(1),
  manager_id                 NUMBER,
  uom_id                     NUMBER,
  customer_id                NUMBER,
  use_opportunities_defects  CHAR(1),
  owner_id                   NUMBER,
  inbound_uom_id             NUMBER,
  reporting_uom_id           NUMBER,
  metric_data_type           VARCHAR2(50),
  group_name                 VARCHAR2(100),
  attainment_level           VARCHAR2(50),
  spec_alerts                VARCHAR2(3) default 'ON',
  control_alerts             VARCHAR2(3) default 'ON',
  volume_alerts              VARCHAR2(3) default 'ON',
  volume_level               NUMBER(17),
  average_alerts             VARCHAR2(3) default 'ON',
  flex_21                    VARCHAR2(50),
  flex_22                    VARCHAR2(50),
  flex_23                    VARCHAR2(50),
  flex_24                    VARCHAR2(50),
  flex_25                    VARCHAR2(50),
  flex_26                    VARCHAR2(50),
  flex_27                    VARCHAR2(50),
  flex_28                    VARCHAR2(50),
  flex_29                    VARCHAR2(50),
  flex_30                    VARCHAR2(50),
  measured_yield             VARCHAR2(3),
  measured_average           VARCHAR2(3),
  service_tower              VARCHAR2(50),
  service_category           VARCHAR2(50),
  smanager_id                NUMBER,
  volume_level_percent       NUMBER(6,2),
  volume_daily_level         NUMBER(17),
  volume_daily_percent       NUMBER(6,2),
  volume_daily_start         VARCHAR2(10),
  volume_daily_end           VARCHAR2(10),
  penalty                    VARCHAR2(3),
  pool_allocation_percentage VARCHAR2(4),
  service_credit_percentage  VARCHAR2(4),
  percent_invoice            VARCHAR2(4),
  portfolio_tower            VARCHAR2(300),
  portfolio_category         VARCHAR2(300),
  portfolio_subcategory      VARCHAR2(300),
  volume_notes               VARCHAR2(2000),
  at_risk_amount             VARCHAR2(25),
  at_risk_percentage         VARCHAR2(10),
  penalty_amount             VARCHAR2(20 CHAR),
  created_by                 NUMBER,
  modified_by                NUMBER,
  modified_date              DATE,
  bu_id                      NUMBER,
  busu_id                    NUMBER,
  bcategory_id               NUMBER
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
create index DW.MD_CUSTOMER_ID on DW.T_DM_METRIC_DEFINITION (CUSTOMER_ID)
  tablespace TS_MEDIUMX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 4M
    next 1M
    minextents 1
    maxextents unlimited
  );
create index DW.MD_MANAGER_ID on DW.T_DM_METRIC_DEFINITION (MANAGER_ID)
  tablespace TS_MEDIUMX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 4M
    next 1M
    minextents 1
    maxextents unlimited
  );
create index DW.MD_METRIC_NAME on DW.T_DM_METRIC_DEFINITION (METRIC_NAME)
  tablespace TS_MEDIUMX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 4M
    next 1M
    minextents 1
    maxextents unlimited
  );
create index DW.MD_OWNER_ID on DW.T_DM_METRIC_DEFINITION (OWNER_ID)
  tablespace TS_MEDIUMX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 4M
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Create/Recreate primary, unique and foreign key constraints
alter table DW.T_DM_METRIC_DEFINITION
  add constraint PK_METRIC_DATA_DEFINITION primary key (METRIC_ID)
  using index
  tablespace TS_MEDIUMX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 4M
    next 1M
    minextents 1
    maxextents unlimited
  );

-- alter table DW.T_DM_METRIC_DEFINITION
--   add constraint MDD_FK foreign key (MANAGER_ID)
--   references DW.USER_TABLE (USER_ID);
-- alter table DW.T_DM_METRIC_DEFINITION
--   add constraint MDD_FK1 foreign key (OWNER_ID)
--   references DW.USER_TABLE (USER_ID);
-- Create/Recreate check constraints

alter table DW.T_DM_METRIC_DEFINITION
  add check (useSpecBoundInGraph in ('L','U'));
alter table DW.T_DM_METRIC_DEFINITION
  add check (AVERAGE_ALERTS in ('OFF','ON'));
alter table DW.T_DM_METRIC_DEFINITION
  add check (isContractual  IN ('YES','NO'));
alter table DW.T_DM_METRIC_DEFINITION
  add check (MEASURED_YIELD  IN ('YES','NO'));
alter table DW.T_DM_METRIC_DEFINITION
  add check (MEASURED_AVERAGE  IN ('YES','NO'));

-- Grant/Revoke object privileges
GRANT SELECT ON DW.T_DM_METRIC_DEFINITION TO MSTR;
GRANT SELECT ON DW.T_DM_METRIC_DEFINITION TO RPTGEN;
GRANT SELECT ON DW.T_DM_METRIC_DEFINITION TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DM_METRIC_DEFINITION TO lf188653;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DM_METRIC_DEFINITION TO TM1_ETL_ROLE;
