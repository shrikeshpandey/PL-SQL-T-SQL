-- Control File Name:  T_BMS_REPLICON_TIMESHEET_STG.ctl	
--	
-- Description:	
-- SQL*Loader control file for the T_BMS_REPLICON_TIMESHEET_STG table.  
--	
options (skip=1)
LOAD DATA	
TRUNCATE	
INTO TABLE T_BMS_REPLICON_TIMESHEET_STG
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
(
  F_USER_LAST_NAME           CHAR(50),
  F_USER_FIRST_NAME          CHAR(50),
  F_EMPLOYEE_ID              CHAR(20),
  F_LOGIN_NAME               CHAR(50),
  F_TIMESHEET_PERIOD         CHAR(50),
  F_ENTRY_DATE               DATE 'MM/DD/YYYY',
  F_CLIENT_NAME              CHAR(50),
  F_TIME_OFF_TYPE            CHAR(20),
  F_PROJECT_CODE             CHAR(25),
  F_BILLING_RATE             CHAR(50),
  F_WORK_TYPE                CHAR(20),
  F_TOTAL_HOURS              DECIMAL EXTERNAL,
  F_PAGER_DUTY_DAYS          DECIMAL EXTERNAL,
  F_SUBMITTED_DATE           DATE 'MM/DD/YYYY',
  F_APPROVAL_STATUS          CHAR(20),
  F_APPROVAL_DTTM            CHAR(100),
  F_1099                     CHAR(10),
  F_BRANCH                   CHAR(10),
  F_DEPT                     CHAR(10),
  F_USER_GEO                 CHAR(10),
  F_USER_COST_CTR            CHAR(10)
)
