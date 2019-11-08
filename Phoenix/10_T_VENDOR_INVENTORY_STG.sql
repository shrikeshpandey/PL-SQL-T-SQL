
/*************************************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           3/11/2019
||   Category:       Table creation
||
||   Description:    Creates table DW.T_VENDOR_INVENTORY_STG
||                   Attributes: parnerId, reportNameProvided, customerName, 
||                               forecastName, mfgPartno, reservedQuantity, 
||                               availQuantity, boQty, age, poEta, oemPo
||
||   Parameters:     None
||
||   Historic Info:
||   Name:              Date:         Brief Description:
||   ----------------------------------------------------------------------------------------------
||   Luis Fuentes       03/11/2019     Initial Creation: This table is for project
||                                     Phoenix
||   Luis Fuentes       03/17/2019     Adding the value1 that joins with DW.T_LKP_ORDER_CLIENT_DATA
||   Luis Fuentes       03/27/2019     Changing the name of vlaue1 for customerId
||   Luis Fuentes       04/19/2019     Adding Currency
||   Luis Fuentes       05/14/2019     
||   ----------------------------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***************************************************************************************************/

-- BEGIN
--   DW.SP_TRUNCATE('DW.T_VENDOR_INVENTORY_STG');
-- END;

DROP TABLE DW.T_VENDOR_INVENTORY_STG cascade constraints;

CREATE TABLE DW.T_VENDOR_INVENTORY_STG
(
  partnerId                  VARCHAR2(500)   
 ,reportNameProvided         VARCHAR2(500)
 ,customerName               VARCHAR2(500)
 ,forecastName               VARCHAR2(500)
 ,mfgPartno                  VARCHAR2(500)
 ,reservedQuantity           VARCHAR2(500)
 ,availQuantity              VARCHAR2(500)
 ,boQty                      VARCHAR2(500)
 ,age                        VARCHAR2(500)
 ,poEta                      VARCHAR2(500)
 ,oemPo                      VARCHAR2(500)
 ,currency                   VARCHAR2(500)
 ,dw_mod_date                DATE
 ,dw_load_date               DATE
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

GRANT SELECT ON DW.T_VENDOR_INVENTORY_STG TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_VENDOR_INVENTORY_STG TO lf188653;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_VENDOR_INVENTORY_STG TO TM1_ETL_ROLE;