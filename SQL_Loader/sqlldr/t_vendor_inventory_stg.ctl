-- Control File Name: T_VENDOR_INVENTORY_STG.ctl
-- Description:
-- SQL*Loader control file for the T_VENDOR_INVENTORY_STG table.
--

options (skip=1)
LOAD DATA
CHARACTERSET UTF8
TRUNCATE
CONTINUEIF LAST != X'22'   
INTO TABLE T_VENDOR_INVENTORY_STG
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(   
     partnerId              CHAR(500) NULLIF partnerId=BLANKS
    ,reportNameProvided     CHAR(500) NULLIF reportNameProvided=BLANKS
    ,customerName           CHAR(500) NULLIF customerName=BLANKS
    ,forecastName           CHAR(500) NULLIF forecastName=BLANKS
    ,mfgPartno              CHAR(500) NULLIF mfgPartno=BLANKS
    ,reservedQuantity       CHAR(500) NULLIF reservedQuantity=BLANKS
    ,availQuantity          CHAR(500) NULLIF availQuantity=BLANKS
    ,boQty                  CHAR(500) NULLIF boQty=BLANKS
    ,age                    CHAR(500) NULLIF age=BLANKS
    ,poEta                  CHAR(500) NULLIF poEta=BLANKS
    ,oemPo                  CHAR(500) NULLIF oemPo=BLANKS
    ,currency               CHAR(500) NULLIF currency=BLANKS
    ,dw_mod_date "SYSDATE"
    ,dw_load_date "SYSDATE"    
)