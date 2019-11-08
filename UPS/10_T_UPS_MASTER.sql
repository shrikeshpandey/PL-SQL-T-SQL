/*************************************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           4/26/2019
||   Category:       Table creation
||
||   Description:    Creates table DW.T_UPS_MASTER
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
--   DW.SP_TRUNCATE('DW.T_UPS_MASTER');
-- END;

DROP TABLE DW.T_UPS_MASTER cascade constraints;

CREATE TABLE DW.T_UPS_MASTER
(
     trackingnumber            VARCHAR2(255) NOT NULL
    ,deliverydate              DATE NULL
    ,deliverylocation          VARCHAR2(255) NULL
    ,signedforby               VARCHAR2(255) NULL
    ,exceptiondate             DATE NULL
    ,exceptionreason           VARCHAR2(255) NULL
    ,exceptionresolution       VARCHAR2(255) NULL
    ,updatedate                DATE NULL
    ,status                    VARCHAR2(255) NULL
    ,scheduleddeliverydate     DATE NULL
    ,servicetype               VARCHAR2(255) NULL
    ,interfacemodifydate       DATE NULL
    ,source                    VARCHAR2(255) NULL
    ,dw_load_date             DATE
    ,dw_mod_date              DATE
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
CREATE UNIQUE INDEX DW.T_UPS_MASTER_UX ON DW.T_UPS_MASTER
(trackingnumber)
  TABLESPACE TS_SMALLX
  PCTFREE 10
  INITRANS 2
  MAXTRANS 255
  STORAGE
  (
    INITIAL 64K
    NEXT 1M
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  )
  NOLOGGING;
CREATE INDEX DW.T_UPS_MASTER_X1 ON DW.T_UPS_MASTER(deliverydate, deliverylocation, status, servicetype)
  TABLESPACE TS_MEDIUMX
  PCTFREE 10
  INITRANS 2
  MAXTRANS 255
  STORAGE
  (
    INITIAL 64K
    NEXT 1M
    MINEXTENTS 1
    MAXEXTENTS UNLIMITED
  )
  NOLOGGING;

GRANT SELECT ON DW.T_UPS_MASTER TO MSTR;
GRANT SELECT ON DW.T_UPS_MASTER TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_UPS_MASTER TO lf188653;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_UPS_MASTER TO TM1_ETL_ROLE;
