/*************************************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           5/28/2019
||   Category:       Table creation
||
||   Description:    Creates table DW.T_SCCM_STG
||                   Attributes: 
||
||   Parameters:     None
||
||   Historic Info:
||   Name:              Date:         Brief Description:
||   ----------------------------------------------------------------------------------------------
||   Luis Fuentes       5/28/2019    Initial Creation: This table is for project
||   ----------------------------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***************************************************************************************************/

-- BEGIN
--   DW.SP_TRUNCATE('DW.T_SCCM_STG');
-- END;

-- DROP TABLE DW.T_SCCM_STG cascade constraints;

CREATE TABLE DW.T_SCCM_STG
(
     device_name               VARCHAR2(500)
    ,app_name                  VARCHAR2(500)
    ,publisher                 VARCHAR2(500)
    ,app_version               VARCHAR2(500)
    ,install_date              VARCHAR2(500)
    ,dw_mod_date               DATE
    ,dw_load_date              DATE
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

GRANT SELECT ON DW.T_SCCM_STG TO MSTR;
GRANT SELECT ON DW.T_SCCM_STG TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_SCCM_STG TO lf188653;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_SCCM_STG TO TM1_ETL_ROLE;
