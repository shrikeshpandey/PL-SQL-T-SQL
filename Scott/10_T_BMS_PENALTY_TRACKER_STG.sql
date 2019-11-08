/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           12/5/2018
||   Category:       Table creation
||
||   Description:    Creates table T_BMS_PENALTY_TRACKER_STG   
||
||   Parameters:     None
||
||   Historic Info:
||   Name:              Date:         Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes       12/5/2018     Initial Creation
||
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

-- BEGIN
--   DW.SP_TRUNCATE('DW.T_BMS_PENALTY_TRACKER_STG');
-- END;

DROP TABLE DW.T_BMS_PENALTY_TRACKER_STG cascade constraints;

CREATE TABLE DW.T_BMS_PENALTY_TRACKER_STG
(
  geo                        VARCHAR2(500)
 ,client                     VARCHAR2(500)
 ,bu                         VARCHAR2(500)
 ,period                     VARCHAR2(500)
 ,penalty_amt                VARCHAR2(500)
 ,root_cause                 VARCHAR2(500)
 ,sla_missed                 VARCHAR2(500)
 ,target                     VARCHAR2(500)
 ,actual                     VARCHAR2(500)
 ,earned_back                VARCHAR2(500)
 ,note                       VARCHAR2(500)
 ,updated_dt                 VARCHAR2(500)
 ,updated_by                 VARCHAR2(500)
 
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

GRANT SELECT ON DW.T_BMS_PENALTY_TRACKER_STG TO MSTR;
GRANT SELECT ON DW.T_BMS_PENALTY_TRACKER_STG TO RPTGEN;
GRANT SELECT ON DW.T_BMS_PENALTY_TRACKER_STG TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_BMS_PENALTY_TRACKER_STG TO lf188653;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_BMS_PENALTY_TRACKER_STG TO TM1_ETL_ROLE;