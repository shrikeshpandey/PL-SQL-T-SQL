/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           08/07/2018
||   Category:       Table creation
||
||   Description:    Creates table DW.T_DM_METRIC_OUTSPEC_ACTIONLIST
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
--   DW.SP_TRUNCATE('DW.T_DM_METRIC_OUTSPEC_ACTIONLIST');
-- END;

--DROP TABLE DW.T_DM_METRIC_OUTSPEC_ACTIONLIST cascade constraints;

-- Create table

create table DW.T_DM_METRIC_OUTSPEC_ACTIONLIST
(
  metric_id             NUMBER,
  outspec_date          DATE,
  actiontaken_rootcause VARCHAR2(4000),
  response_date         DATE,
  username              VARCHAR2(100),
  unique_key            VARCHAR2(50),
  sort_date             DATE,
  ticket_number         VARCHAR2(20),
  category              VARCHAR2(200),
  exclude               VARCHAR2(3),
  other_category        VARCHAR2(64),
  exception_reason      VARCHAR2(4000),
  exception_category    VARCHAR2(250),
  calabrio_number       NUMBER,
  qa_score              NUMBER,
  feedback              CHAR(3)
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
create index DW.MET_OSC_INDEX1 on DW.T_DM_METRIC_OUTSPEC_ACTIONLIST (METRIC_ID)
  tablespace TS_MEDIUMX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index DW.MET_OSC_INDEX2 on DW.T_DM_METRIC_OUTSPEC_ACTIONLIST (METRIC_ID, OUTSPEC_DATE)
  tablespace TS_MEDIUMX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index DW.MET_OSC_INDEX3 on DW.T_DM_METRIC_OUTSPEC_ACTIONLIST (UNIQUE_KEY)
  tablespace TS_MEDIUMX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index DW.MET_OSC_INDEX4 on DW.T_DM_METRIC_OUTSPEC_ACTIONLIST (METRIC_ID, OUTSPEC_DATE, UNIQUE_KEY)
  tablespace TS_MEDIUMX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index DW.MET_OSC_INDEX5 on DW.T_DM_METRIC_OUTSPEC_ACTIONLIST (TICKET_NUMBER)
  tablespace TS_MEDIUMX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index DW.MET_OSC_INDEX6 on DW.T_DM_METRIC_OUTSPEC_ACTIONLIST (METRIC_ID, OUTSPEC_DATE, UNIQUE_KEY, TICKET_NUMBER)
  tablespace TS_MEDIUMX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
create index DW.MET_OSC_INDEX7 on DW.T_DM_METRIC_OUTSPEC_ACTIONLIST (METRIC_ID, TICKET_NUMBER)
  tablespace TS_MEDIUMX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Create/Recreate check constraints
alter table DW.T_DM_METRIC_OUTSPEC_ACTIONLIST
  add check (Exclude  IN ('YES','NO'));
-- Grant/Revoke object privileges
GRANT SELECT ON DW.T_DM_METRIC_OUTSPEC_ACTIONLIST TO MSTR;
GRANT SELECT ON DW.T_DM_METRIC_OUTSPEC_ACTIONLIST TO RPTGEN;
GRANT SELECT ON DW.T_DM_METRIC_OUTSPEC_ACTIONLIST TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DM_METRIC_OUTSPEC_ACTIONLIST TO lf188653;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DM_METRIC_OUTSPEC_ACTIONLIST TO TM1_ETL_ROLE;
