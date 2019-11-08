/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Value Engineering
||   Programmer:     Luis Fuentes
||   Date:           08/18/2019
||   Category:       Table creation
||
||   Description:    Creates table T_SLA_MISS_PREL_ROOT_CAUSE
||
||   Parameters:     None
||
||   Historic Info:
||    Name:              Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes        08/18/2019   Initial Creation
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

-- BEGIN
--   DW.SP_TRUNCATE('DW.T_SLA_MISS_PREL_ROOT_CAUSE');
-- END;

DROP TABLE DW.T_SLA_MISS_PREL_ROOT_CAUSE cascade constraints;

CREATE TABLE DW.T_SLA_MISS_PREL_ROOT_CAUSE
(
  f_cust_corp_id             VARCHAR2(80),
  f_cust_corp_name           VARCHAR2(80),
  f_case_id                  VARCHAR2(255),
  cust_ref_no                VARCHAR2(30),
  area                       VARCHAR2(80),
  create_date                DATE,
  closed_date                DATE,
  sla_due_date               DATE,
  sla_due_week               NUMBER,
  f_case_closed_dt           DATE,
  kb                         VARCHAR2(100),
  root_cause                 VARCHAR2(44),
  f_case_resolution_desc     VARCHAR2(80),
  f_case_severity            VARCHAR2(80),
  f_equip_class              VARCHAR2(80),
  x_service_type             VARCHAR2(20),
  x_cust_ent_code            VARCHAR2(60),
  f_ctr_site_spt_prog        VARCHAR2(30),
  f_cust_site_name           VARCHAR2(80),
  f_cust_site_city           VARCHAR2(30),
  f_cust_site_state          VARCHAR2(40),
  f_tech_dispatched_user_id  VARCHAR2(100),
  f_tech_dispatched_geo_code VARCHAR2(8),
  f_case_closed_d            DATE,
  f_rload                    NUMBER,
  parts_used                 VARCHAR2(400),
  work_time                  NUMBER,
  travel_time                NUMBER,
  trips                      NUMBER,
  last_tech_name             VARCHAR2(60),
  last_tech_org              VARCHAR2(100),
  last_tech_manager          VARCHAR2(40),
  first_tech_id              VARCHAR2(100),
  first_start_time           DATE,
  f_svc_tech_city            VARCHAR2(50),
  f_svc_tech_team            VARCHAR2(30),
  f_district_name            VARCHAR2(80),
  dw_mod_date                DATE DEFAULT ON NULL SYSDATE,
  dw_load_date               DATE DEFAULT ON NULL SYSDATE
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

CREATE UNIQUE INDEX DW.T_SLA_MISS_PREL_ROOT_CAUSE_UQ on DW.T_SLA_MISS_PREL_ROOT_CAUSE (f_cust_corp_id, f_case_id, first_tech_id)
  TABLESPACE TS_MEDIUMX
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

CREATE INDEX DW.T_SLA_MISS_PREL_ROOT_CAUSE_I1 ON DW.T_SLA_MISS_PREL_ROOT_CAUSE (f_cust_corp_id)
  TABLESPACE TS_SMALLX
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

CREATE INDEX DW.T_SLA_MISS_PREL_ROOT_CAUSE_I2 ON DW.T_SLA_MISS_PREL_ROOT_CAUSE (f_cust_corp_name)
  TABLESPACE TS_SMALLX
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

CREATE INDEX DW.T_SLA_MISS_PREL_ROOT_CAUSE_I3 ON DW.T_SLA_MISS_PREL_ROOT_CAUSE (root_cause)
  TABLESPACE TS_SMALLX
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

CREATE INDEX DW.T_SLA_MISS_PREL_ROOT_CAUSE_I4 ON DW.T_SLA_MISS_PREL_ROOT_CAUSE (f_case_resolution_desc)
  TABLESPACE TS_SMALLX
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

CREATE BITMAP INDEX DW.T_SLA_MISS_PREL_ROOT_CAUSE_I5 ON DW.T_SLA_MISS_PREL_ROOT_CAUSE (f_case_severity)
  tablespace TS_SMALLX
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

CREATE INDEX DW.T_SLA_MISS_PREL_ROOT_CAUSE_I6 ON DW.T_SLA_MISS_PREL_ROOT_CAUSE (f_case_closed_dt)
  TABLESPACE TS_MEDIUMX
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

CREATE INDEX DW.T_SLA_MISS_PREL_ROOT_CAUSE_I7 ON DW.T_SLA_MISS_PREL_ROOT_CAUSE (f_case_closed_d)
  TABLESPACE TS_MEDIUMX
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

GRANT SELECT ON DW.T_SLA_MISS_PREL_ROOT_CAUSE TO MSTR;
GRANT SELECT ON DW.T_SLA_MISS_PREL_ROOT_CAUSE TO RPTGEN;
GRANT SELECT ON DW.T_SLA_MISS_PREL_ROOT_CAUSE TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_SLA_MISS_PREL_ROOT_CAUSE TO lf188653;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_SLA_MISS_PREL_ROOT_CAUSE TO TM1_ETL_ROLE;
