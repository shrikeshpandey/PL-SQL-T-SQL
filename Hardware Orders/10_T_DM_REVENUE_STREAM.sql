/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           08/30/2017
||   Category:       Table creation
||
||   Description:    Creates table Revenue_Stream (orders and invoices)
||
||   Parameters:     None
||
||   Historic Info:
||    Name:                                Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes                          30/08/2017   Initial Creation
||   Luis Fuentes                          13/09/2017   Adding ADJ_REVENUE
||   Luis Fuentes                          18/09/2017   Adding REP_NAME, OEM, changing for TS_MEDIUM and granting privilages
||   Steve Novorolsky & Luis Fuentes       21/09/2017   Adding OEM_GROUP
||   Luis Fuentes &Steve Novorolsky        21/09/2017   Adding REB_EXT_COST & REB_EXT_PRICE
||   Luis Fuentes                          11/08/2018   WHS_CODE & indexing the table
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

-- BEGIN
--   DW.SP_TRUNCATE('DW.T_DM_REVENUE_STREAM');
-- END;

DROP TABLE DW.T_DM_REVENUE_STREAM CASCADE CONSTRAINTS;

CREATE TABLE DW.T_DM_REVENUE_STREAM
(
  order_no                     NUMBER(15),
  order_date                   DATE,
  invoice_no                   NUMBER(15),
  invoice_date                 DATE,
  cust_no                      CHAR(15),
  currency_code                VARCHAR2(10),
  rep_code                     VARCHAR2(10),
  vbranch                      VARCHAR2(10),
  ora_name                     VARCHAR2(60),
  ora_corp_id                  VARCHAR2(50),
  lob                          VARCHAR2(10),
  order_status                 VARCHAR2(10),
  expected_date                DATE,
  promise_date                 DATE,
  revised_promise_date         DATE,
  anticipated_arrival_date     DATE,
  anticipated_ship_date        DATE,
  estimated_ship_date          DATE,
  request_date                 DATE,
  ship_not_inv_flag            VARCHAR2(1),
  ext_revenue                  NUMBER(15,2),
  ext_cost                     NUMBER(15,2),
  qty                          NUMBER(10),
  qty_bo                       NUMBER(10),
  margin                       NUMBER(15,2),
  adj_revenue                  NUMBER(15,2),
  whs_type                     VARCHAR2(10),
  ord_group                    VARCHAR2(10),
  vend_date                    DATE,
  measure_date                 DATE,
  crad                         NUMBER(15,2),
  sales_region                 VARCHAR2(170),
  tvp                          VARCHAR2(50),
  uncommitted                  NUMBER(15,2),
  category                     VARCHAR2(100),
  is_from                      CHAR(20),
  rep_name                     CHAR(100),
  oem                          CHAR(100),
  oem_group                    VARCHAR2(100),
  ent_flag                     VARCHAR2(3),
  reb_ext_cost                 NUMBER(15,2),
  reb_ext_price                NUMBER(15,2),
  dw_mod_date                  DATE,
  dw_load_date                 DATE,
  whs_code                     CHAR(10)
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

create index DW.T_DM_REVENUE_STREAM_I1 ON DW.T_DM_REVENUE_STREAM (order_date)
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

create index DW.T_DM_REVENUE_STREAM_I2 ON DW.T_DM_REVENUE_STREAM (invoice_date)
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

create index DW.T_DM_REVENUE_STREAM_I3 ON DW.T_DM_REVENUE_STREAM (is_from)
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

GRANT SELECT ON DW.T_DM_REVENUE_STREAM TO MSTR;
GRANT SELECT ON DW.T_DM_REVENUE_STREAM TO RPTGEN;
GRANT SELECT ON DW.T_DM_REVENUE_STREAM TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DM_REVENUE_STREAM TO TM1_ETL_ROLE;
