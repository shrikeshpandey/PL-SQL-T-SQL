/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           08/07/2018
||   Category:       Table creation
||
||   Description:    Creates table DW.T_DM_SLA_COCKPIT_CUSTOMERS
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
--   DW.SP_TRUNCATE('DW.T_DM_SLA_COCKPIT_CUSTOMERS');
-- END;

--DROP TABLE DW.T_DM_SLA_COCKPIT_CUSTOMERS cascade constraints;

-- Create table

create table DW.T_DM_SLA_COCKPIT_CUSTOMERS
(
  customer_id           NUMBER not null,
  customer_name         VARCHAR2(50),
  address1              VARCHAR2(100),
  address2              VARCHAR2(100),
  ftp_folder_name       VARCHAR2(50),
  ftp_commit_folder     VARCHAR2(50),
  active                VARCHAR2(10),
  city                  VARCHAR2(50),
  state                 VARCHAR2(50),
  phone_number          VARCHAR2(15),
  manager_id            NUMBER,
  stale_data_tx         CHAR(1),
  zip                   VARCHAR2(20),
  country               VARCHAR2(50),
  industry              VARCHAR2(50),
  website               VARCHAR2(50),
  executive_owner       NUMBER,
  client_contact        NUMBER,
  sales_rep_id          NUMBER,
  report_group_id       VARCHAR2(10),
  senior_vice_president NUMBER,
  sales_executive_vp    NUMBER,
  sales_svp             NUMBER,
  black_belt            NUMBER,
  sales_executive_vpjr  NUMBER,
  executive_owner2jr    NUMBER,
  service_levels        VARCHAR2(3),
  preferred_name        VARCHAR2(100),
  revenue               VARCHAR2(25),
  notes                 CLOB,
  revenue_rank          NUMBER(4),
  geo_code              VARCHAR2(20),
  created_by            NUMBER,
  created_date          DATE,
  modified_by           NUMBER,
  modified_date         DATE
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
create index DW.SCC_CUSTOMER_NAME on DW.T_DM_SLA_COCKPIT_CUSTOMERS (CUSTOMER_NAME)
  tablespace TS_MEDIUMX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 32K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index DW.SCC_MANAGER_ID on DW.T_DM_SLA_COCKPIT_CUSTOMERS (MANAGER_ID)
  tablespace TS_MEDIUMX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 32K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Create/Recreate primary, unique and foreign key constraints
alter table DW.T_DM_SLA_COCKPIT_CUSTOMERS
  add constraint PK_CUSTOMER primary key (CUSTOMER_ID)
  using index
  tablespace TS_MEDIUMX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 32K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Grant/Revoke object privileges
GRANT SELECT ON DW.T_DM_SLA_COCKPIT_CUSTOMERS TO MSTR;
GRANT SELECT ON DW.T_DM_SLA_COCKPIT_CUSTOMERS TO RPTGEN;
GRANT SELECT ON DW.T_DM_SLA_COCKPIT_CUSTOMERS TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DM_SLA_COCKPIT_CUSTOMERS TO lf188653;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DM_SLA_COCKPIT_CUSTOMERS TO TM1_ETL_ROLE;
