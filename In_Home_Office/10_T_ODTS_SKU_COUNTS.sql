/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           06/19/2019
||   Category:       Table creation T_ODTS_SKU_COUNTS
||
||   Description:    Table structure for DW.T_ODTS_SKU_COUNTS
||
||   Parameters:     None
||
||   Historic Info:
||   Name:               Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes        06/19/2019   Initial Creation
||   Luis Fuentes        06/23/2019   Adding f_case_closed_d
||   Luis Fuentes        08/06/2019   Rebuilding table with new fields
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

--DROP TABLE DW.T_ODTS_SKU_COUNTS CASCADE CONSTRAINTS;

CREATE TABLE DW.T_ODTS_SKU_COUNTS
 (
    f_case_id            VARCHAR2(30)
   ,sku                  VARCHAR2(255)
   ,sku_no               VARCHAR2(20)
   ,sku_desc             VARCHAR2(255)
   ,qty                  NUMBER(15,0)
   ,f_case_closed_d      DATE
   ,dw_load_date         DATE DEFAULT SYSDATE
   ,dw_mod_date          DATE DEFAULT SYSDATE
 )
TABLESPACE TS_SMALL
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

GRANT SELECT ON DW.T_ODTS_SKU_COUNTS TO MSTR;
GRANT SELECT ON DW.T_ODTS_SKU_COUNTS TO RPTGEN;
GRANT SELECT ON DW.T_ODTS_SKU_COUNTS TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_ODTS_SKU_COUNTS TO TM1_ETL_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_ODTS_SKU_COUNTS TO LF188653;
