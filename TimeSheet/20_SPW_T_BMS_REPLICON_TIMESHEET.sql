CREATE OR REPLACE PROCEDURE DW.SPW_T_BMS_REPLICON_TIMESHEET (iCommit IN NUMBER DEFAULT 2000
) is
   /***********************************************************************************
   ||   PROCEDURE INFORMATION
   ||
   ||   Department:     Data Warehouse
   ||   Programmer:     Steve Novorolsky
   ||   Date:           11/03/2017
   ||   Category:       Load Procedure to load TARGET data from SOURCE
   ||
   ||   Description:    LOAD T_BMS_REPLICON_TIMESHEET
   ||
   ||
   ||   Parameters:     iCommit:   is batch size used to commit record changes.
   ||
   ||   Load Sequence Number:  NNN
   ||
   ||   Historic Info:
   ||    Name:               Date:        Brief Description:
   ||   -----------------------------------------------------------------------------
   ||     Steve Novorolsky             11/03/2017   Initial Creation
   ||     luis Fuentes                 11/14/2017   Chenging F_CLIENT_NAME AND F_TIME_OFF_TYPE
   ||     luis Fuentes                 06/12/2019   Enhancing the logic for f_approval_dttm
   ||   -----------------------------------------------------------------------------
   ||
   ||   CURRENT REVISION STANDARD:  v1.50
   ||
   ***********************************************************************************/
/*******************************************************************************************
*  Generated using sp_gen_bulk() jg 2006
*******************************************************************************************/
CURSOR c is
     SELECT
     TRIM(F_USER_LAST_NAME) AS F_USER_LAST_NAME,
     TRIM(F_USER_FIRST_NAME) AS F_USER_FIRST_NAME,
     TRIM(F_EMPLOYEE_ID) AS F_EMPLOYEE_ID,
     TRIM(F_LOGIN_NAME) AS F_LOGIN_NAME,
     TRIM(F_TIMESHEET_PERIOD) AS F_TIMESHEET_PERIOD,
     F_ENTRY_DATE AS F_ENTRY_DATE,
     CASE
      WHEN UPPER(TRIM(F_CLIENT_NAME)) LIKE '%NONE%' THEN NULL
      ELSE UPPER(TRIM(F_CLIENT_NAME))
     END AS F_CLIENT_NAME,
     TRIM(SUBSTR(F_TIME_OFF_TYPE,INSTR(F_TIME_OFF_TYPE,'.',1)+1)) AS F_TIME_OFF_TYPE,
     TRIM(F_PROJECT_CODE) AS F_PROJECT_CODE,
     TRIM(F_BILLING_RATE) AS F_BILLING_RATE,
     TRIM(F_WORK_TYPE) AS F_WORK_TYPE,
     F_TOTAL_HOURS AS F_TOTAL_HOURS,
     F_PAGER_DUTY_DAYS AS F_PAGER_DUTY_DAYS,
     F_SUBMITTED_DATE AS F_SUBMITTED_DATE,
     TRIM(F_APPROVAL_STATUS) AS F_APPROVAL_STATUS,
     CASE 
        WHEN UPPER(f_approval_dttm) LIKE '%M%' THEN DECODE(REGEXP_INSTR(f_approval_dttm,'[0-9]*\:[0-9]*\:[0-9]*'), 12, TO_DATE(TRIM(f_approval_dttm), 'mm/dd/yyyy hh:mi:ss AM'), TO_DATE(TRIM(f_approval_dttm), 'mm/dd/yyyy hh:mi AM'))
        ELSE DECODE(REGEXP_INSTR(f_approval_dttm,'[0-9]*\:[0-9]*\:[0-9]*'), 12, TO_DATE(TRIM(f_approval_dttm), 'mm/dd/yyyy hh24:mi:ss'), TO_DATE(TRIM(f_approval_dttm), 'mm/dd/yyyy hh24:mi'))
       END AS f_approval_dttm,
     TRIM(F_1099) AS F_1099,
     TRIM(F_BRANCH) AS F_BRANCH,
     TRIM(F_DEPT) AS F_DEPT,
     TRIM(F_USER_GEO) AS F_USER_GEO,
     TRIM(F_USER_COST_CTR) AS F_USER_COST_CTR
FROM DW.T_BMS_REPLICON_TIMESHEET_STG
;

--Standard Variables
dNow              Date := Sysdate;
iTotalRows        Integer := 0;
iTotalErrors      Integer := 0;
iLoadSequence     Integer := 999999;
iLoadInstanceSeq  Integer;
iExceptionCode    Integer;
vExceptionMessage Varchar2(256);
  ------------------------------------------------------
  -- END DECLARATIONS
  ------------------------------------------------------


  ------------------------------------------------------
  -- BEGIN MAIN
  ------------------------------------------------------
--bulk collect variables
F_USER_LAST_NAME_t dbms_sql.VARCHAR2_table;
F_USER_FIRST_NAME_t dbms_sql.VARCHAR2_table;
F_EMPLOYEE_ID_t dbms_sql.VARCHAR2_table;
F_LOGIN_NAME_t dbms_sql.VARCHAR2_table;
F_TIMESHEET_PERIOD_t dbms_sql.VARCHAR2_table;
F_ENTRY_DATE_t dbms_sql.DATE_table;
F_CLIENT_NAME_t dbms_sql.VARCHAR2_table;
F_TIME_OFF_TYPE_t dbms_sql.VARCHAR2_table;
F_PROJECT_CODE_t dbms_sql.VARCHAR2_table;
F_BILLING_RATE_t dbms_sql.VARCHAR2_table;
F_WORK_TYPE_t dbms_sql.VARCHAR2_table;
F_TOTAL_HOURS_t dbms_sql.NUMBER_table;
F_PAGER_DUTY_DAYS_t dbms_sql.NUMBER_table;
F_SUBMITTED_DATE_t dbms_sql.DATE_table;
F_APPROVAL_STATUS_t dbms_sql.VARCHAR2_table;
F_APPROVAL_DTTM_t dbms_sql.DATE_table;
F_1099_t dbms_sql.VARCHAR2_table;
F_BRANCH_t dbms_sql.VARCHAR2_table;
F_DEPT_t dbms_sql.VARCHAR2_table;
F_USER_GEO_t dbms_sql.VARCHAR2_table;
F_USER_COST_CTR_t dbms_sql.VARCHAR2_table;
DW_LOAD_DATE_t dbms_sql.DATE_table;
DW_MOD_DATE_t dbms_sql.DATE_table;

BEGIN --B1

  -- Conditional Create of New Seq Number

dw.sp_md_get_next_seq('T_BMS_REPLICON_TIMESHEET',
     'T_BMS_REPLICON_TIMESHEET',
     'OBJID',
     1, --- ACTIVE CODE 1 OR 0 PRETTY MUCH ALWAYS ACTIVE '
     'T_BMS_REPLICON_TIMESHEET',
     'ORACLE DB-LINK',
     'DW TABLE LOAD',
     'SPW_T_BMS_REPLICON_TIMESHEET',
     iLoadSequence,
     'DW');

dw.pkg_load_verify.p_begin_load(iloadsequence,iloadinstanceseq);
OPEN c;
LOOP
     FETCH c BULK COLLECT INTO
          F_USER_LAST_NAME_t,
          F_USER_FIRST_NAME_t,
          F_EMPLOYEE_ID_t,
          F_LOGIN_NAME_t,
          F_TIMESHEET_PERIOD_t,
          F_ENTRY_DATE_t,
          F_CLIENT_NAME_t,
          F_TIME_OFF_TYPE_t,
          F_PROJECT_CODE_t,
          F_BILLING_RATE_t,
          F_WORK_TYPE_t,
          F_TOTAL_HOURS_t,
          F_PAGER_DUTY_DAYS_t,
          F_SUBMITTED_DATE_t,
          F_APPROVAL_STATUS_t,
          F_APPROVAL_DTTM_t,
          F_1099_t,
          F_BRANCH_t,
          F_DEPT_t,
          F_USER_GEO_t,
          F_USER_COST_CTR_t
     LIMIT iCommit;
     FOR i in 1..F_USER_LAST_NAME_t.COUNT
     LOOP
          BEGIN --B2 insert
          INSERT INTO DW.T_BMS_REPLICON_TIMESHEET (
               F_USER_LAST_NAME,
               F_USER_FIRST_NAME,
               F_EMPLOYEE_ID,
               F_LOGIN_NAME,
               F_TIMESHEET_PERIOD,
               F_ENTRY_DATE,
               F_CLIENT_NAME,
               F_TIME_OFF_TYPE,
               F_PROJECT_CODE,
               F_BILLING_RATE,
               F_WORK_TYPE,
               F_TOTAL_HOURS,
               F_PAGER_DUTY_DAYS,
               F_SUBMITTED_DATE,
               F_APPROVAL_STATUS,
               F_APPROVAL_DTTM,
               F_1099,
               F_BRANCH,
               F_DEPT,
               F_USER_GEO,
               F_USER_COST_CTR,
               DW_LOAD_DATE,
               DW_MOD_DATE
          )
          VALUES (
               F_USER_LAST_NAME_t(i),
               F_USER_FIRST_NAME_t(i),
               F_EMPLOYEE_ID_t(i),
               F_LOGIN_NAME_t(i),
               F_TIMESHEET_PERIOD_t(i),
               F_ENTRY_DATE_t(i),
               F_CLIENT_NAME_t(i),
               F_TIME_OFF_TYPE_t(i),
               F_PROJECT_CODE_t(i),
               F_BILLING_RATE_t(i),
               F_WORK_TYPE_t(i),
               F_TOTAL_HOURS_t(i),
               F_PAGER_DUTY_DAYS_t(i),
               F_SUBMITTED_DATE_t(i),
               F_APPROVAL_STATUS_t(i),
               F_APPROVAL_DTTM_t(i),
               F_1099_t(i),
               F_BRANCH_t(i),
               F_DEPT_t(i),
               F_USER_GEO_t(i),
               F_USER_COST_CTR_t(i),
               TRUNC(SYSDATE),
               SYSDATE
          );
EXCEPTION --B2
     WHEN dup_val_on_index THEN
     --UPDATE ERROR INFORMATION
     BEGIN --B3;
     UPDATE DW.T_BMS_REPLICON_TIMESHEET
        SET
     F_USER_LAST_NAME = F_USER_LAST_NAME_t(i),
     F_USER_FIRST_NAME = F_USER_FIRST_NAME_t(i),
     F_LOGIN_NAME = F_LOGIN_NAME_t(i),
     F_TIMESHEET_PERIOD = F_TIMESHEET_PERIOD_t(i),
     F_CLIENT_NAME = F_CLIENT_NAME_t(i),
     F_TIME_OFF_TYPE = F_TIME_OFF_TYPE_t(i),
     F_PROJECT_CODE = F_PROJECT_CODE_t(i),
     F_BILLING_RATE = F_BILLING_RATE_t(i),
     F_TOTAL_HOURS = F_TOTAL_HOURS_t(i),
     F_PAGER_DUTY_DAYS = F_PAGER_DUTY_DAYS_t(i),
     F_SUBMITTED_DATE = F_SUBMITTED_DATE_t(i),
     F_APPROVAL_STATUS = F_APPROVAL_STATUS_t(i),
     F_APPROVAL_DTTM = F_APPROVAL_DTTM_t(i),
     F_1099 = F_1099_t(i),
     F_BRANCH = F_BRANCH_t(i),
     F_DEPT = F_DEPT_t(i),
     F_USER_GEO = F_USER_GEO_t(i),
     F_USER_COST_CTR = F_USER_COST_CTR_t(i),
     DW_MOD_DATE = sysdate
     WHERE F_EMPLOYEE_ID = F_EMPLOYEE_ID_t(i)
     AND F_WORK_TYPE = F_WORK_TYPE_t(i)
     AND F_ENTRY_DATE = F_ENTRY_DATE_t(i)
;
     --HANDLE OTHER ERRORS
     EXCEPTION --B3
     WHEN OTHERS THEN
     --INSERT ERROR INFORMATION
          BEGIN --B4
          itotalerrors := itotalerrors + 1;
          dw.pkg_load_verify.p_record_exception(iloadinstanceseq
          ,substr(F_EMPLOYEE_ID_t(i) || '-' || F_WORK_TYPE_t(i) || '-' || F_ENTRY_DATE_t(i),1,256)
          ,SQLCODE
          ,SQLERRM
          ,'');
          END; --B4
     END; --B3 dup_val_on_index block
     END; --B2 insert exception block
     END LOOP;
     -- ASSIGN HOW MANY RECORDS PROCESSED
     itotalrows := c%ROWCOUNT;
     -- CONDITIONAL/INCREMENTAL TRANSACTION COMMIT
          dw.pkg_load_verify.p_commit_load(iloadinstanceseq
          ,itotalrows - itotalerrors
          ,itotalerrors);
     EXIT WHEN c%NOTFOUND;
END LOOP;

CLOSE c;
     -- FINAL COMMIT AND MD UPDATE
     dw.pkg_load_verify.p_commit_load(iloadinstanceseq
          ,itotalrows - itotalerrors
          ,itotalerrors);
     -- END LOAD AND UPDATE MD INFO
     dw.pkg_load_verify.p_end_load(iloadinstanceseq
          ,itotalrows - itotalerrors
          ,itotalerrors);
     EXCEPTION
     WHEN OTHERS THEN
     --GENERAL ERROR INFORMATION
          BEGIN --B4
          itotalerrors := itotalerrors + 1;
          dw.pkg_load_verify.p_record_exception(iloadinstanceseq
          ,substr('DW.T_BMS_REPLICON_TIMESHEET GENERAL err:'||sqlerrm,1,256)
          ,SQLCODE
          ,SQLERRM
          ,'');
          END; --B4
     ------------------------------------------------------
     -- END MAIN
     ------------------------------------------------------
END;  --B1
/

GRANT EXECUTE ON DW.SPW_T_VENDOR_INVENTORY TO TM1_ETL_ROLE;
GRANT EXECUTE ON DW.SPW_T_VENDOR_INVENTORY TO LF188653;
