/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           12/5/2018
||   Category:       Table creation
||
||   Description:    Creates table T_BMS_PENALTY_TRACKER
||
||   Parameters:     None
||
||   Historic Info:
||   Name:              Date:         Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes       12/29/2018     Initial Creation
||
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

-- BEGIN
--   DW.SP_TRUNCATE('DW.T_BMS_PENALTY_TRACKER');
-- END;

DROP TABLE DW.T_BMS_PENALTY_TRACKER cascade constraints;

CREATE TABLE DW.T_BMS_PENALTY_TRACKER
(
  geo                        VARCHAR2(7)
 ,client                     VARCHAR2(150)
 ,bu                         VARCHAR2(7)
 ,period                     DATE
 ,penalty_amt                FLOAT(20)
 ,root_cause                 VARCHAR2(100)
 ,sla_missed                 VARCHAR2(255)
 ,target                     VARCHAR2(7)
 ,actual                     VARCHAR2(7)
 ,earned_back                FLOAT(20)
 ,note                       VARCHAR2(500)
 ,updated_dt                 DATE
 ,updated_by                 VARCHAR2(100)
 ,dw_mod_date                DATE DEFAULT ON NULL SYSDATE
 ,dw_load_date               DATE DEFAULT ON NULL SYSDATE
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

GRANT SELECT ON DW.T_BMS_PENALTY_TRACKER TO MSTR;
GRANT SELECT ON DW.T_BMS_PENALTY_TRACKER TO RPTGEN;
GRANT SELECT ON DW.T_BMS_PENALTY_TRACKER TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_BMS_PENALTY_TRACKER TO lf188653;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_BMS_PENALTY_TRACKER TO TM1_ETL_ROLE;