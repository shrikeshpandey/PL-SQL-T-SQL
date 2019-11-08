-- Control File Name:  T_BMO_DISPOSITION_STG.ctl	
--	
-- Description:	
-- SQL*Loader control file for the T_BMO_DISPOSITION_STG table.
-- History
-- Luis Fuentes       10/22/2019     Initial Creation
--	
options (skip=1)
LOAD DATA
CHARACTERSET UTF8
TRUNCATE
CONTINUEIF LAST != X'22'   
INTO TABLE T_BMO_DISPOSITION_STG
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
   case_id CHAR(500) NULLIF case_id=BLANKS
  ,recv_date CHAR(500) NULLIF recv_date=BLANKS
  ,store_address CHAR(500) NULLIF store_address=BLANKS
  ,floor_id CHAR(500) NULLIF floor_id=BLANKS
  ,city CHAR(500) NULLIF city=BLANKS
  ,postal_code CHAR(500) NULLIF postal_code=BLANKS
  ,asset_tag CHAR(500) NULLIF asset_tag=BLANKS
  ,serial CHAR(500) NULLIF serial=BLANKS
  ,brand CHAR(500) NULLIF brand=BLANKS
  ,model CHAR(500) NULLIF model=BLANKS
  ,type_desc CHAR(500) NULLIF type_desc=BLANKS
  ,skid CHAR(500) NULLIF skid=BLANKS
  ,text CHAR(500) NULLIF text=BLANKS
  ,redeploy CHAR(500) NULLIF redeploy=BLANKS
  ,donate CHAR(500) NULLIF donate=BLANKS
  ,recycle CHAR(500) NULLIF recycle=BLANKS
  ,bmo_comments CHAR(500) NULLIF bmo_comments=BLANKS
  ,dw_mod_date "SYSDATE"
  ,dw_load_date "SYSDATE" 
)
