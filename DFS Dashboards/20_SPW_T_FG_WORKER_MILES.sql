CREATE OR REPLACE PROCEDURE DW.SPW_T_FG_WORKER_MILES (
  iCommit   IN INTEGER DEFAULT 2000,
  pdBegin   IN DATE DEFAULT TRUNC (SYSDATE) - 3,
  pdEnd     IN DATE DEFAULT TRUNC (SYSDATE) + 1
) is
/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           9/4/2018
||   Category:       Table
||
||   Description:    Loads table T_FG_WORKER_MILEAGE
||
||   Parameters:     None
||
||   Historic Info:
||    Name:           Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes     9/15/2018     Initial Creation
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/
/*******************************************************************************************
*  Generated using sp_gen_bulk() jg 2006
*******************************************************************************************/
d_Begin             DATE;
d_End               DATE;

--Data to insert into DW.T_DM_SVC_FS_DETAIL_STG
CURSOR c IS
SELECT HR.F_RESOURCE_ID AS F_RESOURCE_ID
       ,'FGTEMP_MILES' AS F_SOURCE_TYPE
       ,WM.expense_entry_date AS F_TXN_DT
       ,WM.expense_sheet_approved_date AS F_AIDA_GL_DT
       ,WM.expense_sheet_approved_date AS F_AIA_INV_DT
       ,WM.geo_branch_code AS F_GLCC_GEO
       ,WM.currency AS F_AIA_INV_CURR_CD
       ,WM.expense_sheet_id AS F_AIA_DESC
       ,WM.billable_amount AS F_AIDA_AMT
       ,WM.expense_name AS F_AIDA_DESC
       ,NULL AS F_CASE_KEY
       ,NULL AS F_CASE_ID
       ,TO_CHAR(CASE
         WHEN UPPER(WM.currency) = 'CAD' THEN (WM.units*0.621371)
         ELSE WM.units
        END) AS F_ORIG_SYSTEM_MILES
       ,WM.dw_load_date AS DW_LOAD_DATE
       ,WM.dw_mod_date  AS DW_MOD_DATE
FROM DW.T_FG_WORKER_MILEAGE WM
INNER JOIN DW.T_DM_HUMAN_RESOURCES HR
 ON WM.compucom_user_id = HR.f_resource_net_id
WHERE UPPER(WM.expense_name) = 'PERSONAL CAR MILEAGE'
 AND UPPER(WM.expense_sheet_status) IN ('INVOICED', 'PAID')
 AND TRUNC(WM.expense_entry_date) >= d_Begin
 AND TRUNC(WM.expense_entry_date) < d_End
 ;

--Standard Variables
dNow              Date    := Sysdate;
iTotalRows        Integer := 0;
iTotalDeleted     Integer := 0;
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
f_resource_id_t       dbms_sql.varchar2_table;
f_source_type_t       dbms_sql.varchar2_table;
f_txn_dt_t            dbms_sql.date_table;
f_aida_gl_dt_t        dbms_sql.date_table;
f_aia_inv_dt_t        dbms_sql.date_table;
f_glcc_geo_t          dbms_sql.varchar2_table;
f_aia_inv_curr_cd_t   dbms_sql.varchar2_table;
f_aia_desc_t          dbms_sql.varchar2_table;
f_aida_amt_t          dbms_sql.number_table;
f_aida_desc_t         dbms_sql.varchar2_table;
f_case_key_t          dbms_sql.number_table;
f_case_id_t           dbms_sql.varchar2_table;
f_orig_system_miles_t dbms_sql.varchar2_table;
dw_load_date_t        dbms_sql.date_table;
dw_mod_date_t         dbms_sql.date_table;

BEGIN --B1

-- Conditional Create of New Seq Number
dw.sp_md_get_next_seq('T_DM_SVC_FS_DETAIL_STG_WORKER_MILES',
                      'T_DM_SVC_FS_DETAIL_STG_WORKER_MILES',
                      'OBJID',
                      1, --- ACTIVE CODE 1 OR 0 PRETTY MUCH ALWAYS ACTIVE '
                      'T_DM_SVC_FS_DETAIL_STG_WORKER_MILES',
                      'ORACLE DB-LINK',
                      'DW TABLE LOAD',
                      'SPW_T_FG_WORKER_MILES',
                      iLoadSequence,
                      'DW');

dw.pkg_load_verify.p_begin_load(iloadsequence,iloadinstanceseq);

IF iCommit = 1100
THEN
   d_Begin := pdBegin;
   d_End := pdEnd;
ELSE
   SELECT CASE
            WHEN TRUNC (SYSDATE) > (SELECT  TO_DATE (F_REPORT_PARAM_VALUE,
                                        'DD-MON-YYYY')
                             + 1
                        FROM dw.T_SEC_REPORTING_TOOL RT
                       WHERE     F_REPORT_TYPE_ID = 1
                             AND F_REPORT_ID = 170
                             AND F_REPORT_PARAM_ID > 100
                             AND TO_CHAR (
                                    TO_DATE (F_REPORT_PARAM_VALUE,
                                             'DD-MON-YYYY'),
                                    'MM-YYYY') =
                                    TO_CHAR (SYSDATE, 'MM-YYYY'))
             and to_number(to_char(sysdate,'DD')) > 19    --added on 10/20/2016 to fix month end data issue
             THEN                   --- note uses DD, day of month value
                TRUNC (ADD_MONTHS (SYSDATE, 0), 'MM') --- refresh prior month and start current month selection
             ELSE
                TRUNC (ADD_MONTHS (SYSDATE, -1), 'MM')
          END,
          LAST_DAY (TRUNC (ADD_MONTHS (TRUNC (SYSDATE), 0), 'MM')) + 1
     INTO d_Begin, d_End
     FROM DUAL;
END IF;

iTotalDeleted := iTotalDeleted + SQL%ROWCOUNT;

COMMIT;

-----------------------------------------------------------------
--load new data
-----------------------------------------------------------------
OPEN c;
LOOP
     FETCH c BULK COLLECT INTO
        f_resource_id_t
       ,f_source_type_t
       ,f_txn_dt_t
       ,f_aida_gl_dt_t
       ,f_aia_inv_dt_t
       ,f_glcc_geo_t
       ,f_aia_inv_curr_cd_t
       ,f_aia_desc_t
       ,f_aida_amt_t
       ,f_aida_desc_t
       ,f_case_key_t
       ,f_case_id_t
       ,f_orig_system_miles_t
       ,dw_load_date_t
       ,dw_mod_date_t
     LIMIT iCommit;
     FOR i in 1 .. f_resource_id_t.COUNT
     LOOP
          BEGIN --B2 insert
          INSERT INTO DW.T_DM_SVC_FS_DETAIL_STG (
            f_resource_id
           ,f_source_type
           ,f_txn_dt
           ,f_aida_gl_dt
           ,f_aia_inv_dt
           ,f_glcc_geo
           ,f_aia_inv_curr_cd
           ,f_aia_desc
           ,f_aida_amt
           ,f_aida_desc
           ,f_case_key
           ,f_case_id
           ,f_orig_system_miles
           ,dw_load_date
           ,dw_mod_date
          )
          VALUES (
            f_resource_id_t(i)
           ,f_source_type_t(i)
           ,f_txn_dt_t(i)
           ,f_aida_gl_dt_t(i)
           ,f_aia_inv_dt_t(i)
           ,f_glcc_geo_t(i)
           ,f_aia_inv_curr_cd_t(i)
           ,f_aia_desc_t(i)
           ,f_aida_amt_t(i)
           ,f_aida_desc_t(i)
           ,f_case_key_t(i)
           ,f_case_id_t(i)
           ,f_orig_system_miles_t(i)
           ,dw_load_date_t(i)
           ,dw_mod_date_t(i)
          );
EXCEPTION --B2
     WHEN OTHERS THEN
     --INSERT ERROR INFORMATION
          BEGIN --B4
          itotalerrors := itotalerrors + 1;
          dw.pkg_load_verify.p_record_exception(iloadinstanceseq
          ,substr('DW.T_DM_SVC_FS_DETAIL_STG_WORKER_MILES err:'||sqlerrm,1,256)
          ,SQLCODE
          ,SQLERRM
          ,'');
          END; --B4
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
,substr('DW.T_DM_SVC_FS_DETAIL_STG_WORKER_MILES GENERAL err:'||sqlerrm,1,256)
,SQLCODE
,SQLERRM
,'');
END; --B4
     ------------------------------------------------------
     -- END MAIN
     ------------------------------------------------------
END; --B1
/

GRANT EXECUTE ON DW.SPW_T_FG_WORKER_MILES TO TM1_ETL_ROLE;
--GRANT EXECUTE ON DW.SPW_T_FG_WORKER_MILES TO LF188653;
