
/*************************************************************************************************
||   QUERY INFORMATION
||
||   Department:     Value Engineering
||   Programmer:     Luis Fuentes
||   Date:           10/02/2019
||   Category:       Table creation
||
||   Description:    Creates table DW.T_BMO_DISPOSITION_STG
||                   Attributes: case_id, recv_date, store_address, floor_id,
||                               city, postal_code, asset_tag, serial, brand, model, type, skid, text, redeploy, donate	
||                               recycle, bmo_comments
||
||
||   Parameters:     None
||
||   Historic Info:
||   Name:              Date:         Brief Description:
||   ----------------------------------------------------------------------------------------------
||   Luis Fuentes       10/02/2019     Initial Creation: This table is for project
||   ----------------------------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***************************************************************************************************/

-- BEGIN
--   DW.SP_TRUNCATE('DW.T_BMO_DISPOSITION');
-- END;

-- DROP TABLE DW.T_BMO_DISPOSITION_STG cascade constraints;

CREATE TABLE DW.T_BMO_DISPOSITION_STG
(
     case_id                    VARCHAR2(500)
    ,recv_date                  VARCHAR2(500)
    ,store_address              VARCHAR2(500)
    ,floor_id                   VARCHAR2(500)
    ,city                       VARCHAR2(500)
    ,postal_code                VARCHAR2(500)
    ,asset_tag                  VARCHAR2(500)
    ,serial                     VARCHAR2(500)
    ,brand                      VARCHAR2(500)
    ,model                      VARCHAR2(500)
    ,type_desc                  VARCHAR2(500)
    ,skid                       VARCHAR2(500)
    ,text                       VARCHAR2(500)
    ,redeploy                   VARCHAR2(500)
    ,donate                     VARCHAR2(500)
    ,recycle                    VARCHAR2(500)
    ,bmo_comments               VARCHAR2(500)
    ,dw_mod_date                DATE DEFAULT ON NULL SYSDATE
    ,dw_load_date               DATE DEFAULT ON NULL SYSDATE
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

GRANT SELECT ON DW.T_BMO_DISPOSITION_STG TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_BMO_DISPOSITION_STG TO lf188653;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_BMO_DISPOSITION_STG TO TM1_ETL_ROLE;