/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           11/13/2017
||   Category:       Table
||
||   Description:    Creates table T_BMS_REPLICON_TIMESHEET_F
||
||   Parameters:     None
||
||   Historic Info:
||    Name:               Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes       11/13/2017   Initial Creation
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

DELETE FROM DW.T_BMS_REPLICON_TIMESHEET_F@DWDEV WHERE 1=1;
COMMIT;

INSERT INTO DW.T_BMS_REPLICON_TIMESHEET_F(
   F_USER_LAST_NAME
  ,F_USER_FIRST_NAME
  ,F_EMPLOYEE_ID
  ,F_LOGIN_NAME
  ,F_TIMESHEET_PERIOD
  ,F_ENTRY_DATE
  ,F_CLIENT_NAME
  ,F_TIME_OFF_TYPE
  ,F_PROJECT_CODE
  ,F_BILLING_RATE
  ,F_WORK_TYPE
  ,F_TOTAL_HOURS
  ,F_PAGER_DUTY_DAYS
  ,F_SUBMITTED_DATE
  ,F_APPROVAL_STATUS
  ,F_APPROVAL_DTTM
  ,F_1099
  ,F_BRANCH
  ,F_DEPT
  ,F_USER_GEO
  ,F_USER_COST_CTR
  ,DW_LOAD_DATE
  ,DW_MOD_DATE
)
SELECT F_USER_LAST_NAME
      ,F_USER_FIRST_NAME
      ,F_EMPLOYEE_ID
      ,F_LOGIN_NAME
      ,F_TIMESHEET_PERIOD
      ,F_ENTRY_DATE
      ,CASE
        WHEN UPPER(F_CLIENT_NAME) LIKE '%NONE%' THEN NULL
        ELSE F_CLIENT_NAME
       END AS F_CLIENT_NAME
      ,TRIM(SUBSTR(F_TIME_OFF_TYPE,INSTR(F_TIME_OFF_TYPE,'.',1)+1)) AS F_TIME_OFF_TYPE
      ,F_PROJECT_CODE
      ,F_BILLING_RATE
      ,F_WORK_TYPE
      ,F_TOTAL_HOURS
      ,F_PAGER_DUTY_DAYS
      ,F_SUBMITTED_DATE
      ,F_APPROVAL_STATUS
      ,F_APPROVAL_DTTM
      ,F_1099
      ,F_BRANCH
      ,F_DEPT
      ,F_USER_GEO
      ,F_USER_COST_CTR
      ,DW_LOAD_DATE
      ,DW_MOD_DATE
FROM DW.T_BMS_REPLICON_TIMESHEET;

COMMIT;

--THE IS A MIX BETWEEN CAPPITAL AND LOWER CASE, SHOULD I LEAVE IT LIKE THAT ?
--should I get more information from other tables ?
