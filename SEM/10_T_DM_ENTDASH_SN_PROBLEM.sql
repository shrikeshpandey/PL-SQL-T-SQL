
/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           04/03/2018
||   Category:       Table creation
||
||   Description:    Creates table T_DM_ENTDASH_SN_PROBLEM
||
||   Parameters:     None
||
||   Historic Info:
||    Name:              Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes        05/23/2018   Initial Creation
||   luis Fuentes        05/24/2018   Adding ci_name
||   luis Fuentes        05/24/2018   Adding sys_class_name
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

DROP TABLE DW.T_DM_ENTDASH_SN_PROBLEM cascade constraints;

CREATE TABLE DW.T_DM_ENTDASH_SN_PROBLEM
(
  company_sk                    NUMBER(22)
  ,open_dt                      NUMBER(22)
  ,close_dt                     NUMBER(22)
  ,contact_type_sk              NUMBER(22)
  ,group_sk                     NUMBER(22)
  ,ci_name                      VARCHAR2(255)
  ,NoOfInc                      NUMBER(22)
  ,sys_class_name               VARCHAR2(255)
  ,resolvedSameDay              NUMBER(22)
  ,IncLv1                       NUMBER(22)
  ,IncLv2                       NUMBER(22)
  ,IncLv3                       NUMBER(22)
  ,IncLv4                       NUMBER(22)
  ,dw_mod_date                  DATE DEFAULT ON NULL SYSDATE
  ,dw_load_date                 DATE DEFAULT ON NULL SYSDATE
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

create bitmap index DW.T_DM_ENTDASH_SN_PROBLEM_I1 ON DW.T_DM_ENTDASH_SN_PROBLEM (company_sk)
  tablespace TS_SMALLX
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

create bitmap index DW.T_DM_ENTDASH_SN_PROBLEM_I2 ON DW.T_DM_ENTDASH_SN_PROBLEM (open_dt)
  tablespace TS_SMALLX
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

create bitmap index DW.T_DM_ENTDASH_SN_PROBLEM_I3 ON DW.T_DM_ENTDASH_SN_PROBLEM (close_dt)
  tablespace TS_SMALLX
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

create bitmap index DW.T_DM_ENTDASH_SN_PROBLEM_I4 ON DW.T_DM_ENTDASH_SN_PROBLEM (contact_type_sk)
  tablespace TS_SMALLX
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

create bitmap index DW.T_DM_ENTDASH_SN_PROBLEM_I5 ON DW.T_DM_ENTDASH_SN_PROBLEM (group_sk)
  tablespace TS_SMALLX
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

GRANT SELECT ON DW.T_DM_ENTDASH_SN_PROBLEM TO MSTR;
GRANT SELECT ON DW.T_DM_ENTDASH_SN_PROBLEM TO RPTGEN;
GRANT SELECT ON DW.T_DM_ENTDASH_SN_PROBLEM TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DM_ENTDASH_SN_PROBLEM TO lf188653;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DM_ENTDASH_SN_PROBLEM TO TM1_ETL_ROLE;
