CREATE OR REPLACE PROCEDURE DW.SPW_T_FG_WORKER_MILEAGE (iCommit IN NUMBER DEFAULT 2000
) is
/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           8/2/2018
||   Category:       Table
||
||   Description:    Loads table T_FG_WORKER_MILEAGE
||
||   Parameters:     None
||
||   Historic Info:
||    Name:           Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes     8/31/2018     Initial Creation
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/
/*******************************************************************************************
*  Generated using sp_gen_bulk() jg 2006
*******************************************************************************************/

--Data to INSERT into T_FG_WORKER_MILEAGE
CURSOR c IS
SELECT A.buyer_name,
       A.buyer_code,
       A.vendor_name,
       A.vendor_code,
       A.account_name,
       A.account_code,
       A.remit_to_address_code,
       A.requisition_owner,
       A.work_order_id,
       A.worker_id,
       A.candidate_id,
       A.worker_last_name,
       A.worker_first_name,
       A.site_code,
       A.site_name,
       A.department_cost_center_code,
       A.department_cost_center_name,
       A.final_approver_first_name,
       A.final_approver_last_name,
       A.final_approver_employee_id,
       A.final_approver_email,
       A.expense_sheet_id,
       A.expense_sheet_status,
       A.expense_sheet_submit_date,
       A.expense_sheet_approved_date,
       A.expense_entry_date,
       A.geo_branch_code,
       A.geo_branch_name,
       A.expense_code,
       A.expense_name,
       A.general_ledger_account_code,
       A.merchant,
       A.description,
       SUM(A.units) AS units,
       AVG(A.rate) AS rate,
       SUM(A.billable_amount) AS billable_amount,
       SUM(A.non_billable_amount) AS non_billable_amount,
       A.currency,
       A.id,
       AVG(A.msp_percentage) AS msp_percentage,
       A.compucom_user_id,
       A.fieldglass_id,
       SYSDATE AS dw_load_date,
       SYSDATE AS dw_mod_date
FROM (
  SELECT TRIM(TS.buyer_name) AS buyer_name,
         TRIM(TS.buyer_code) AS buyer_code,
         TRIM(TS.vendor_name) AS vendor_name,
         TRIM(TS.vendor_code) AS vendor_code,
         TRIM(TS.account_name) AS account_name,
         TRIM(TS.account_code) AS account_code,
         TRIM(TS.remit_to_address_code) AS remit_to_address_code,
         TRIM(TS.requisition_owner) AS requisition_owner,
         TRIM(TS.work_order_id) AS work_order_id,
         NVL(W1.worker_id,TRIM(TS.worker_id)) AS worker_id,
         TRIM(TS.candidate_id) AS candidate_id,
         TRIM(TS.worker_last_name) AS worker_last_name,
         TRIM(TS.worker_first_name) AS worker_first_name,
         TRIM(TS.site_code) AS site_code,
         TRIM(TS.site_name) AS site_name,
         TRIM(TS.department_cost_center_code) AS department_cost_center_code,
         TRIM(TS.department_cost_center_name) AS department_cost_center_name,
         TRIM(TS.final_approver_first_name) AS final_approver_first_name,
         TRIM(TS.final_approver_last_name) AS final_approver_last_name,
         TRIM(TS.final_approver_employee_id) AS final_approver_employee_id,
         TRIM(TS.final_approver_email) AS final_approver_email,
         TRIM(TS.expense_sheet_id) AS expense_sheet_id,
         TRIM(TS.expense_sheet_status) AS expense_sheet_status,
         TRUNC(TO_DATE(TS.expense_sheet_submit_date, 'MM/DD/YYYY HH24:MI:SS')) AS expense_sheet_submit_date,
         TRUNC(TO_DATE(TS.expense_sheet_approved_date, 'MM/DD/YYYY HH24:MI:SS')) AS expense_sheet_approved_date,
         TRUNC(TO_DATE(TS.expense_entry_date, 'MM/DD/YYYY HH24:MI:SS')) AS expense_entry_date,
         TRIM(TS.geo_branch_code) AS geo_branch_code,
         TRIM(TS.geo_branch_name) AS geo_branch_name,
         TRIM(TS.expense_code) AS expense_code,
         TRIM(TS.expense_name) AS expense_name,
         TRIM(TS.general_ledger_account_code) AS general_ledger_account_code,
         TRIM(TS.merchant) AS merchant,
         TRIM(TS.description) AS description,
         TO_NUMBER(TS.units) AS units,
         TO_NUMBER(TS.rate) AS rate,
         TO_NUMBER(TS.billable_amount) AS billable_amount,
         TO_NUMBER(TS.non_billable_amount) AS non_billable_amount,
         TRIM(TS.currency) AS currency,
         TRIM(TS.id) AS id,
         TO_NUMBER(TS.msp_percentage) AS msp_percentage,
         --we do a substring because the unix server is adding and extra space when we load it to T_FG_WORKER_MILEAGE_STG
         UPPER(SUBSTR(TRIM(TS.compucom_user_id),1,LENGTH(TRIM(TS.compucom_user_id))-1)) AS compucom_user_id,
         W1.fieldglass_id AS fieldglass_id
  FROM DW.T_FG_WORKER_MILEAGE_STG TS
  LEFT JOIN (
   SELECT worker_id, fieldglass_id--, jobseeker_id
   FROM DW.T_FG_WORKER_WO
   WHERE worker_id is not null OR worker_id <> ''
   GROUP BY worker_id, fieldglass_id--, jobseeker_id
   ) W1
  ON TRIM(TS.worker_id) = W1.worker_id
  WHERE TRIM(TS.expense_sheet_status) IN ('Approved','Invoiced','Paid')
) A
GROUP BY A.buyer_name,
         A.buyer_code,
         A.vendor_name,
         A.vendor_code,
         A.account_name,
         A.account_code,
         A.remit_to_address_code,
         A.requisition_owner,
         A.work_order_id,
         A.worker_id,
         A.candidate_id,
         A.worker_last_name,
         A.worker_first_name,
         A.site_code,
         A.site_name,
         A.department_cost_center_code,
         A.department_cost_center_name,
         A.final_approver_first_name,
         A.final_approver_last_name,
         A.final_approver_employee_id,
         A.final_approver_email,
         A.expense_sheet_id,
         A.expense_sheet_status,
         A.expense_sheet_submit_date,
         A.expense_sheet_approved_date,
         A.expense_entry_date,
         A.geo_branch_code,
         A.geo_branch_name,
         A.expense_code,
         A.expense_name,
         A.general_ledger_account_code,
         A.merchant,
         A.description,
         A.currency,
         A.id,
         A.compucom_user_id,
         A.fieldglass_id
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
--bulk collect variables c CURSOR
buyer_name_t dbms_sql.varchar2_table;
buyer_code_t dbms_sql.varchar2_table;
vendor_name_t dbms_sql.varchar2_table;
vendor_code_t dbms_sql.varchar2_table;
account_name_t dbms_sql.varchar2_table;
account_code_t dbms_sql.varchar2_table;
remit_to_address_code_t dbms_sql.varchar2_table;
requisition_owner_t dbms_sql.varchar2_table;
work_order_id_t dbms_sql.varchar2_table;
worker_id_t dbms_sql.varchar2_table;
candidate_id_t dbms_sql.varchar2_table;
worker_last_name_t dbms_sql.varchar2_table;
worker_first_name_t dbms_sql.varchar2_table;
site_code_t dbms_sql.varchar2_table;
site_name_t dbms_sql.varchar2_table;
department_cost_center_code_t dbms_sql.varchar2_table;
department_cost_center_name_t dbms_sql.varchar2_table;
final_approver_first_name_t dbms_sql.varchar2_table;
final_approver_last_name_t dbms_sql.varchar2_table;
final_approver_employee_id_t dbms_sql.varchar2_table;
final_approver_email_t dbms_sql.varchar2_table;
expense_sheet_id_t dbms_sql.varchar2_table;
expense_sheet_status_t dbms_sql.varchar2_table;
expense_sheet_submit_date_t dbms_sql.date_table;
expense_sheet_approved_date_t dbms_sql.date_table;
expense_entry_date_t dbms_sql.date_table;
geo_branch_code_t dbms_sql.varchar2_table;
geo_branch_name_t dbms_sql.varchar2_table;
expense_code_t dbms_sql.varchar2_table;
expense_name_t dbms_sql.varchar2_table;
general_ledger_account_code_t dbms_sql.varchar2_table;
merchant_t dbms_sql.varchar2_table;
description_t dbms_sql.varchar2_table;
units_t dbms_sql.number_table;
rate_t dbms_sql.number_table;
billable_amount_t dbms_sql.number_table;
non_billable_amount_t dbms_sql.number_table;
currency_t dbms_sql.varchar2_table;
id_t dbms_sql.varchar2_table;
msp_percentage_t dbms_sql.number_table;
compucom_user_id_t dbms_sql.varchar2_table;
fieldglass_id_t dbms_sql.VARCHAR2_table;
dw_load_date_t dbms_sql.DATE_table;
dw_mod_date_t dbms_sql.DATE_table;


BEGIN --B1

-- Conditional Create of New Seq Number
dw.sp_md_get_next_seq('T_FG_WORKER_MILEAGE',
     'T_FG_WORKER_MILEAGE',
     'OBJID',
     1, --- ACTIVE CODE 1 OR 0 PRETTY MUCH ALWAYS ACTIVE '
     'T_FG_WORKER_MILEAGE',
     'ORACLE DB-LINK',
     'DW TABLE LOAD',
     'SPW_T_FG_WORKER_MILEAGE',
     iLoadSequence,
     'DW');

dw.pkg_load_verify.p_begin_load(iloadsequence,iloadinstanceseq);

-----------------------------------------------------------------
--Calculate and load new data
-----------------------------------------------------------------
OPEN c;
LOOP
     FETCH c BULK COLLECT INTO
       buyer_name_t,
       buyer_code_t,
       vendor_name_t,
       vendor_code_t,
       account_name_t,
       account_code_t,
       remit_to_address_code_t,
       requisition_owner_t,
       work_order_id_t,
       worker_id_t,
       candidate_id_t,
       worker_last_name_t,
       worker_first_name_t,
       site_code_t,
       site_name_t,
       department_cost_center_code_t,
       department_cost_center_name_t,
       final_approver_first_name_t,
       final_approver_last_name_t,
       final_approver_employee_id_t,
       final_approver_email_t,
       expense_sheet_id_t,
       expense_sheet_status_t,
       expense_sheet_submit_date_t,
       expense_sheet_approved_date_t,
       expense_entry_date_t,
       geo_branch_code_t,
       geo_branch_name_t,
       expense_code_t,
       expense_name_t,
       general_ledger_account_code_t,
       merchant_t,
       description_t,
       units_t,
       rate_t,
       billable_amount_t,
       non_billable_amount_t,
       currency_t,
       id_t,
       msp_percentage_t,
       compucom_user_id_t,
       fieldglass_id_t,
       dw_load_date_t,
       dw_mod_date_t
     LIMIT iCommit;
     FOR i in 1 .. buyer_name_t.COUNT
     LOOP
          BEGIN --B2 insert
          INSERT INTO DW.T_FG_WORKER_MILEAGE (
            buyer_name,
            buyer_code,
            vendor_name,
            vendor_code,
            account_name,
            account_code,
            remit_to_address_code,
            requisition_owner,
            work_order_id,
            worker_id,
            candidate_id,
            worker_last_name,
            worker_first_name,
            site_code,
            site_name,
            department_cost_center_code,
            department_cost_center_name,
            final_approver_first_name,
            final_approver_last_name,
            final_approver_employee_id,
            final_approver_email,
            expense_sheet_id,
            expense_sheet_status,
            expense_sheet_submit_date,
            expense_sheet_approved_date,
            expense_entry_date,
            geo_branch_code,
            geo_branch_name,
            expense_code,
            expense_name,
            general_ledger_account_code,
            merchant,
            description,
            units,
            rate,
            billable_amount,
            non_billable_amount,
            currency,
            id,
            msp_percentage,
            compucom_user_id,
            fieldglass_id,
            dw_load_date,
            dw_mod_date
          )
          VALUES (
            buyer_name_t(i),
            buyer_code_t(i),
            vendor_name_t(i),
            vendor_code_t(i),
            account_name_t(i),
            account_code_t(i),
            remit_to_address_code_t(i),
            requisition_owner_t(i),
            work_order_id_t(i),
            worker_id_t(i),
            candidate_id_t(i),
            worker_last_name_t(i),
            worker_first_name_t(i),
            site_code_t(i),
            site_name_t(i),
            department_cost_center_code_t(i),
            department_cost_center_name_t(i),
            final_approver_first_name_t(i),
            final_approver_last_name_t(i),
            final_approver_employee_id_t(i),
            final_approver_email_t(i),
            expense_sheet_id_t(i),
            expense_sheet_status_t(i),
            expense_sheet_submit_date_t(i),
            expense_sheet_approved_date_t(i),
            expense_entry_date_t(i),
            geo_branch_code_t(i),
            geo_branch_name_t(i),
            expense_code_t(i),
            expense_name_t(i),
            general_ledger_account_code_t(i),
            merchant_t(i),
            description_t(i),
            units_t(i),
            rate_t(i),
            billable_amount_t(i),
            non_billable_amount_t(i),
            currency_t(i),
            id_t(i),
            msp_percentage_t(i),
            compucom_user_id_t(i),
            fieldglass_id_t(i),
            dw_load_date_t(i),
            dw_mod_date_t(i)
          );
EXCEPTION -- B2
  WHEN dup_val_on_index THEN
  --UPDATE ERROR Information
  BEGIN--B3
  UPDATE DW.T_FG_WORKER_MILEAGE
  SET buyer_name = buyer_name_t(i),
      buyer_code = buyer_code_t(i),
      vendor_name = vendor_name_t(i),
      vendor_code = vendor_code_t(i),
      account_name = account_name_t(i),
      account_code = account_code_t(i),
      remit_to_address_code = remit_to_address_code_t(i),
      requisition_owner = requisition_owner_t(i),
      work_order_id = work_order_id_t(i),
      worker_id = worker_id_t(i),
      candidate_id = candidate_id_t(i),
      worker_last_name = worker_last_name_t(i),
      worker_first_name = worker_first_name_t(i),
      site_code = site_code_t(i),
      site_name = site_name_t(i),
      department_cost_center_code = department_cost_center_code_t(i),
      department_cost_center_name = department_cost_center_name_t(i),
      final_approver_first_name = final_approver_first_name_t(i),
      final_approver_last_name = final_approver_last_name_t(i),
      final_approver_employee_id = final_approver_employee_id_t(i),
      final_approver_email = final_approver_email_t(i),
      expense_sheet_id = expense_sheet_id_t(i),
      expense_sheet_status = expense_sheet_status_t(i),
      expense_sheet_submit_date = expense_sheet_submit_date_t(i),
      expense_sheet_approved_date = expense_sheet_approved_date_t(i),
      expense_entry_date = expense_entry_date_t(i),
      geo_branch_code = geo_branch_code_t(i),
      geo_branch_name = geo_branch_name_t(i),
      expense_code = expense_code_t(i),
      expense_name = expense_name_t(i),
      general_ledger_account_code = general_ledger_account_code_t(i),
      merchant = merchant_t(i),
      description = description_t(i),
      units = units_t(i),
      rate = rate_t(i),
      billable_amount = billable_amount_t(i),
      non_billable_amount = non_billable_amount_t(i),
      currency = currency_t(i),
      id = id_t(i),
      msp_percentage = msp_percentage_t(i),
      compucom_user_id = compucom_user_id_t(i),
      fieldglass_id = fieldglass_id_t(i),
      dw_mod_date = sysdate
  WHERE expense_sheet_id = expense_sheet_id_t(i)
    AND expense_entry_date = expense_entry_date_t(i)
    AND expense_code = expense_code_t(i)
    AND merchant = merchant_t(i)
    AND description = description_t(i)
;
--HADLE OTHER ERRORS
EXCEPTION --B2
     WHEN OTHERS THEN
     --INSERT ERROR INFORMATION
          BEGIN --B4
          itotalerrors := itotalerrors + 1;
          dw.pkg_load_verify.p_record_exception(iloadinstanceseq
          ,substr('DW.T_FG_WORKER_MILEAGE err:'||sqlerrm,1,256)
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
COMMIT;

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
,substr('DW.T_FG_WORKER_MILEAGE GENERAL err:'||sqlerrm,1,256)
,SQLCODE
,SQLERRM
,'');
END; --B4
     ------------------------------------------------------
     -- END MAIN
     ------------------------------------------------------
END; --B1
/

GRANT EXECUTE ON DW.SPW_T_FG_WORKER_MILEAGE TO TM1_ETL_ROLE;
