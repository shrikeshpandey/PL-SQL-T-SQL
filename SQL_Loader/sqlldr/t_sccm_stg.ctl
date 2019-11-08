-- Control File Name: T_SCCM_STG.ctl
-- Description:
-- SQL*Loader control file for the T_SCCM_STG table.
--

options (skip=1)
LOAD DATA
CHARACTERSET UTF8
TRUNCATE
--CONTINUEIF LAST != X'22'   
INTO TABLE T_SCCM_STG
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(   
     device_name               CHAR(500) NULLIF device_name=BLANKS
    ,app_name                  CHAR(500) NULLIF app_name=BLANKS
    ,publisher                 CHAR(500) NULLIF publisher=BLANKS
    ,app_version               CHAR(500) NULLIF app_version=BLANKS
    ,install_date              CHAR(500) NULLIF install_date=BLANKS
    ,dw_mod_date "SYSDATE"
    ,dw_load_date "SYSDATE" 
)