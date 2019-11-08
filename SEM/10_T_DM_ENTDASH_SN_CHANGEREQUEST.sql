
/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           29/05/2018
||   Category:       Table creation
||
||   Description:    Creates table T_DM_ENTDASH_SN_CHANGEREQUEST
||
||   Parameters:     None
||
||   Historic Info:
||    Name:              Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes        05/23/2018   Initial Creation
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

DROP TABLE DW.T_DM_ENTDASH_SN_CHANGEREQUEST cascade constraints;

CREATE TABLE DW.T_DM_ENTDASH_SN_CHANGEREQUEST
(
   company_sk        NUMBER
  ,open_dt_sk        NUMBER
  ,close_dt_sk       NUMBER
  ,contact_type_sk   NUMBER
  ,group_sk          NUMBER
  ,ci_name           VARCHAR2(255)
  ,phase_state       VARCHAR2(100)
  ,no_of_inc         NUMBER
  ,sys_class_name    CHAR(14)
  ,resolved_same_day NUMBER
  ,inc_lv1           NUMBER
  ,inc_lv2           NUMBER
  ,inc_lv3           NUMBER
  ,inc_lv4           NUMBER
  ,dw_mod_date       DATE DEFAULT ON NULL SYSDATE
  ,dw_load_date      DATE DEFAULT ON NULL SYSDATE
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

create bitmap index DW.T_DM_ENTDASH_SN_CHANGEREQ_I1 ON DW.T_DM_ENTDASH_SN_CHANGEREQUEST (company_sk)
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

create bitmap index DW.T_DM_ENTDASH_SN_CHANGEREQ_I2 ON DW.T_DM_ENTDASH_SN_CHANGEREQUEST (open_dt_sk)
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

create bitmap index DW.T_DM_ENTDASH_SN_CHANGEREQ_I3 ON DW.T_DM_ENTDASH_SN_CHANGEREQUEST (close_dt_sk)
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

create bitmap index DW.T_DM_ENTDASH_SN_CHANGEREQ_I4 ON DW.T_DM_ENTDASH_SN_CHANGEREQUEST (contact_type_sk)
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

create bitmap index DW.T_DM_ENTDASH_SN_CHANGEREQ_I5 ON DW.T_DM_ENTDASH_SN_CHANGEREQUEST (group_sk)
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

GRANT SELECT ON DW.T_DM_ENTDASH_SN_CHANGEREQUEST TO MSTR;
GRANT SELECT ON DW.T_DM_ENTDASH_SN_CHANGEREQUEST TO RPTGEN;
GRANT SELECT ON DW.T_DM_ENTDASH_SN_CHANGEREQUEST TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DM_ENTDASH_SN_CHANGEREQUEST TO lf188653;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DM_ENTDASH_SN_CHANGEREQUEST TO TM1_ETL_ROLE;
