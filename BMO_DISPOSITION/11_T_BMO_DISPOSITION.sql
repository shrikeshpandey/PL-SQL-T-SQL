
/*************************************************************************************************
||   QUERY INFORMATION
||
||   Department:     Value Engineering
||   Programmer:     Luis Fuentes
||   Date:           10/16/2019
||   Category:       Table creation
||
||   Description:    Creates table DW.T_BMO_DISPOSITION
||
||   Parameters:     None
||
||   Historic Info:
||   Name:              Date:         Brief Description:
||   ----------------------------------------------------------------------------------------------
||   Luis Fuentes       10/16/2019    Initial Creation: This table is for project BMO_DISPOSITION
||   ----------------------------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***************************************************************************************************/

-- BEGIN
--   DW.SP_TRUNCATE('DW.T_BMO_DISPOSITION');
-- END;

-- DROP TABLE DW.T_BMO_DISPOSITION cascade constraints;

CREATE TABLE DW.T_BMO_DISPOSITION
(
  case_id       VARCHAR2(50),
  recv_date     DATE,
  store_address VARCHAR2(70),
  floor_id      VARCHAR2(70),
  city1         VARCHAR2(70),
  postal_code   VARCHAR2(70),
  asset_tag     VARCHAR2(70),
  serial        VARCHAR2(70),
  brand         VARCHAR2(70),
  model         VARCHAR2(70),
  type_desc     VARCHAR2(70),
  skid          VARCHAR2(70),
  text          VARCHAR2(70),
  redeploy      VARCHAR2(70),
  donate        VARCHAR2(70),
  recycle       VARCHAR2(70),
  bmo_comments  VARCHAR2(70),
  ponum         VARCHAR2(30),
  disptype      VARCHAR2(30),
  siteid        VARCHAR2(80),
  addr1         VARCHAR2(255),
  city2         VARCHAR2(60),
  prov          VARCHAR2(80),
  postcd        VARCHAR2(50),
  costctr       VARCHAR2(120),
  floorno       VARCHAR2(255),
  warehouse     VARCHAR2(20),
  dw_mod_date   DATE DEFAULT ON NULL SYSDATE,
  dw_load_date  DATE DEFAULT ON NULL SYSDATE
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

CREATE UNIQUE INDEX DW.T_BMO_DISPOSITION_UQ on DW.T_BMO_DISPOSITION (
  case_id,
  recv_date,
  store_address,
  floor_id,
  city1,
  postal_code,
  asset_tag,
  serial,
  brand,
  model,
  type_desc,
  skid,
  text,
  redeploy,
  donate,
  recycle,
  bmo_comments,
  ponum,
  disptype,
  siteid,
  addr1,
  city2,
  prov,
  postcd,
  costctr,
  floorno,
  warehouse
)
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

GRANT SELECT ON DW.T_BMO_DISPOSITION TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_BMO_DISPOSITION TO lf188653;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_BMO_DISPOSITION TO TM1_ETL_ROLE;