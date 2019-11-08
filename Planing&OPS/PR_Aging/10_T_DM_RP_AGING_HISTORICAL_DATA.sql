/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           09/06/2017
||   Category:       Table creation
||
||   Description:    Table structure for DW.T_DM_PR_AGING_HISTORICAL_DATA
||
||   Parameters:     None
||
||   Historic Info:
||    Name:                                 Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes                           09/06/2017   Initial Creation
||   Steve Novorolsky & Luis Fuentes        09/11/2017   Adding team an changing USA_Cost for Usa
||   Luis Fuentes                           09/13/2017   Adding empty fields to salesRegion and TVP,
||   Luis Fuentes                           09/21/2017   Getting rid of the AGE and Adding Inserted date
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

DROP TABLE DW.T_DM_PR_AGING_HISTORICAL_DATA CASCADE CONSTRAINTS;

CREATE TABLE DW.T_DM_PR_AGING_HISTORICAL_DATA
 (
   INSERT_DATE      DATE,
   CURRENCY_NAME    VARCHAR2(20),
   LOC_CLASS        VARCHAR2(20),
   TEAM             VARCHAR2(20),
   CTGY_AGE         VARCHAR2(20),
   CTGY_QTY         NUMBER(15),
   COST             NUMBER(15,2),
   DW_LOAD_DT       DATE,
   DW_MOD_DT        DATE
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

GRANT SELECT ON DW.T_DM_PR_AGING_HISTORICAL_DATA TO MSTR;
GRANT SELECT ON DW.T_DM_PR_AGING_HISTORICAL_DATA TO RPTGEN;
GRANT SELECT ON DW.T_DM_PR_AGING_HISTORICAL_DATA TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DM_PR_AGING_HISTORICAL_DATA TO TM1_ETL_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DM_PR_AGING_HISTORICAL_DATA TO SNOVOROL;
