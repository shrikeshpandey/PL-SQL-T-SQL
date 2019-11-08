/*************************************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           4/26/2019
||   Category:       Table creation
||
||   Description:    Creates table DW.T_UPS_MASTER_STG
||                   Attributes: TrackingNumber, DeliveryDate, DeliveryLocation, SignedForBy, ExceptionDate
||                               ExceptionReason, ExceptionResolution, UpdateDate, Status, ScheduledDeliveryDate
||                               ServiceType, InterfaceModifyDate, Source
||
||   Parameters:     None
||
||   Historic Info:
||   Name:              Date:         Brief Description:
||   ----------------------------------------------------------------------------------------------
||   Luis Fuentes       04/26/2019    Initial Creation: This table is for project
||   ----------------------------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***************************************************************************************************/

-- BEGIN
--   DW.SP_TRUNCATE('DW.T_UPS_MASTER_STG');
-- END;

-- DROP TABLE DW.T_UPS_MASTER_STG cascade constraints;

CREATE TABLE DW.T_UPS_MASTER_STG
(
     trackingnumber            VARCHAR2(500)
    ,deliverydate              VARCHAR2(500)
    ,deliverylocation          VARCHAR2(500)
    ,signedforby               VARCHAR2(500)
    ,exceptiondate             VARCHAR2(500)
    ,exceptionreason           VARCHAR2(500)
    ,exceptionresolution       VARCHAR2(500)
    ,updatedate                VARCHAR2(500)
    ,status                    VARCHAR2(500)
    ,scheduleddeliverydate     VARCHAR2(500)
    ,servicetype               VARCHAR2(500)
    ,interfacemodifydate       VARCHAR2(500)
    ,source                    VARCHAR2(500)
    ,dw_mod_date               DATE
    ,dw_load_date              DATE
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

GRANT SELECT ON DW.T_UPS_MASTER_STG TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_UPS_MASTER_STG TO lf188653;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_UPS_MASTER_STG TO TM1_ETL_ROLE;
