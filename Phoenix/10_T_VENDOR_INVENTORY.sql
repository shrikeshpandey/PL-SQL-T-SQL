
/*************************************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           3/11/2019
||   Category:       Table creation
||
||   Description:    Creates table DW.T_VENDOR_INVENTORY
||                   Attributes: parnerId, reportNameProvided, customerName, 
||                               forecastName, mfgPartno, reservedQuantity, 
||                               availQuantity, boQty, age, poEta, oemPo
||
||   Parameters:     None
||
||   Historic Info:
||   Name:              Date:         Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes       03/11/2019    Initial Creation: This table is for project
||                                    Phoenix       
||   Luis Fuentes       03/17/2019    Adding the value1 that joins with DW.T_LKP_ORDER_CLIENT_DATA                      
||   Luis Fuentes       03/18/2019    Changing the ddl for all the columns, TS_MEDIUM changed
||   Luis Fuentes       03/27/2019    Changing the name of vlaue1 for customerId
||   Luis Fuentes       04/19/2019    Adding Currency
||   Luis Fuentes       05/14/2019    
||   ----------------------------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***************************************************************************************************/

--BEGIN
-- DW.SP_TRUNCATE('DW.T_VENDOR_INVENTORY');
--END;

DROP TABLE DW.T_VENDOR_INVENTORY cascade constraints;

CREATE TABLE DW.T_VENDOR_INVENTORY
(
  partnerId                  VARCHAR2(255)   
 ,reportNameProvided         VARCHAR2(255)
 ,customerName               VARCHAR2(255)
 ,forecastName               VARCHAR2(255)
 ,mfgPartno                  VARCHAR2(255)
 ,reservedQuantity           NUMBER(15)
 ,availQuantity              NUMBER(15)
 ,boQty                      NUMBER(15)
 ,age                        NUMBER(15)
 ,poEta                      DATE
 ,oemPo                      VARCHAR2(255)
 ,currency                   VARCHAR2(255)
 ,dw_mod_date                DATE
 ,dw_load_date               DATE
 ,item_no                    VARCHAR2(255)
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

CREATE INDEX DW.parnerid ON DW.T_VENDOR_INVENTORY(partnerId)
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
CREATE INDEX DW.mfgPartno ON DW.T_VENDOR_INVENTORY(mfgPartno)
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

GRANT SELECT ON DW.T_VENDOR_INVENTORY TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_VENDOR_INVENTORY TO lf188653;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_VENDOR_INVENTORY TO TM1_ETL_ROLE;