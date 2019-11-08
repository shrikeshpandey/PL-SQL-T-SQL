-- Control File Name: T_UPS_MASTER_STG.ctl
-- Description:
-- SQL*Loader control file for the T_UPS_MASTER_STG table.
--

options (skip=1)
LOAD DATA
TRUNCATE
CONTINUEIF LAST != X'22'   
INTO TABLE T_UPS_MASTER_STG
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(   
     trackingnumber            CHAR(500) NULLIF trackingnumber=BLANKS
    ,deliverydate              CHAR(500) NULLIF deliverydate=BLANKS
    ,deliverylocation          CHAR(500) NULLIF deliverylocation=BLANKS
    ,signedforby               CHAR(500) NULLIF signedforby=BLANKS
    ,exceptiondate             CHAR(500) NULLIF exceptiondate=BLANKS
    ,exceptionreason           CHAR(500) NULLIF exceptionreason=BLANKS
    ,exceptionresolution       CHAR(500) NULLIF exceptionresolution=BLANKS
    ,updatedate                CHAR(500) NULLIF updatedate=BLANKS
    ,status                    CHAR(500) NULLIF status=BLANKS
    ,scheduleddeliverydate     CHAR(500) NULLIF scheduleddeliverydate=BLANKS
    ,servicetype               CHAR(500) NULLIF servicetype=BLANKS
    ,interfacemodifydate       CHAR(500) NULLIF interfacemodifydate=BLANKS
    ,source                    CHAR(500) NULLIF source=BLANKS
    ,dw_load_date "SYSDATE"
    ,dw_mod_date "SYSDATE"   
)