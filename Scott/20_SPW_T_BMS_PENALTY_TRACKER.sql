CREATE OR REPLACE PROCEDURE DW.SPW_T_BMS_PENALTY_TRACKER (iCommit IN NUMBER DEFAULT 2000
) is

/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           04/04/2018
||   Category:       Table
||
||   Description:    Creates table T_DIM_CLIENT_EMPLOYEE
||
||   Parameters:     None
||
||   Historic Info:
||    Name:           Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes      04/03/2018   Initial Creation That's a small transaction. No pl/sql needed or desired.
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

--Data to INSERT into DW.T_BMS_PENALTY_TRACKER
CURSOR c IS
SELECT TRIM(geo) AS geo, 
       TRIM(client) AS client,
       TRIM(bu) AS bu, 
       TO_DATE(period, 'mm/dd/yyyy') AS period,
       CASE 
         WHEN SUBSTR(penalty_amt,0,1) = '(' THEN CAST(REGEXP_REPLACE(penalty_amt, '[^\.0-9]+?', '') AS FLOAT)*-1
         ELSE CAST(REGEXP_REPLACE(penalty_amt, '[^\.0-9]+?', '') AS FLOAT )
       END AS penalty_amt,
       TRIM(root_cause) AS root_cause,
       TRIM(sla_missed) AS sla_missed,
       TRIM(target) AS target, 
       TRIM(actual) AS actual,
       CASE 
         WHEN SUBSTR(earned_back,0,1) = '(' THEN CAST(REGEXP_REPLACE(earned_back, '[^\.0-9]+?', '') AS FLOAT)*-1
         ELSE CAST(REGEXP_REPLACE(earned_back, '[^\.0-9]+?', '') AS FLOAT )
       END AS earned_back,
       TRIM(note) AS note,
       TO_DATE(TRIM(updated_dt), 'yy-mm-dd hh24:mi') AS updated_dt,
       TRIM(SUBSTR(updated_by,0,LENGTH(updated_by)-1)) AS updated_by
FROM DW.T_BMS_PENALTY_TRACKER_STG
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
geo_t               DBMS_SQL.VARCHAR2_table;
client_t            DBMS_SQL.VARCHAR2_table;
bu_t                DBMS_SQL.VARCHAR2_table;
period_t            DBMS_SQL.DATE_table;
penalty_amt_t       DBMS_SQL.NUMBER_table;
root_cause_t        DBMS_SQL.VARCHAR2_table;
sla_missed_t        DBMS_SQL.VARCHAR2_table;
target_t            DBMS_SQL.VARCHAR2_table;
actual_t            DBMS_SQL.VARCHAR2_table;
earned_back_t       DBMS_SQL.NUMBER_table;
note_t              DBMS_SQL.VARCHAR2_table;
updated_dt_t        DBMS_SQL.DATE_table;
updated_by_t        DBMS_SQL.VARCHAR2_table;

BEGIN --B1

-- Conditional Create of New Seq Number
dw.sp_md_get_next_seq('T_BMS_PENALTY_TRACKER',
     'T_BMS_PENALTY_TRACKER',
     'OBJID',
     1, --- ACTIVE CODE 1 OR 0 PRETTY MUCH ALWAYS ACTIVE '
     'T_BMS_PENALTY_TRACKER',
     'ORACLE DB-LINK',
     'DW TABLE LOAD',
     'SPW_T_BMS_PENALTY_TRACKER',
     iLoadSequence,
     'DW');

dw.pkg_load_verify.p_begin_load(iloadsequence,iloadinstanceseq);

-----------------------------------------------------------------
--Calculate and load new data
-----------------------------------------------------------------
OPEN c;
LOOP
     FETCH c BULK COLLECT INTO
       geo_t,               
       client_t,            
       bu_t,                
       period_t,            
       penalty_amt_t,       
       root_cause_t,        
       sla_missed_t,        
       target_t,            
       actual_t,            
       earned_back_t,       
       note_t,              
       updated_dt_t,        
       updated_by_t    
     LIMIT iCommit;
     FOR i in 1 .. client_t.COUNT
     LOOP
          BEGIN --B2 insert
          INSERT INTO DW.T_BMS_PENALTY_TRACKER (
            geo,               
            client,            
            bu,                
            period,            
            penalty_amt,       
            root_cause,        
            sla_missed,        
            target,            
            actual,            
            earned_back,       
            note,              
            updated_dt,        
            updated_by
          )
          VALUES (
            geo_t(i),               
            client_t(i),            
            bu_t(i),                
            period_t(i),            
            penalty_amt_t(i),       
            root_cause_t(i),        
            sla_missed_t(i),        
            target_t(i),            
            actual_t(i),            
            earned_back_t(i),       
            note_t(i),              
            updated_dt_t(i),        
            updated_by_t(i) 
          );

/*EXCEPTION -- B2
  WHEN dup_val_on_index THEN
  --UPDATE ERROR Information
  BEGIN--B3
  UPDATE DW.T_DM_START_STOP_TIMES
  SET work_start_time   = work_start_time_t(i),
      onsite_start_time = onsite_start_time_t(i),
      onsite_end_time   = onsite_end_time_t(i),
      work_end_time     = work_end_time_t(i),
      travel_start_time = travel_start_time_t(i),
      travel_end_time   = travel_end_time_t(i),
      dw_mod_date       = SYSDATE
  WHERE service_date = service_date_t(i)
    AND f_tech_empl_key = f_tech_empl_key_t(i)
;
*/
--HADLE OTHER ERRORS
EXCEPTION --B2
     WHEN OTHERS THEN
     --INSERT ERROR INFORMATION
          BEGIN --B4
          itotalerrors := itotalerrors + 1;
          dw.pkg_load_verify.p_record_exception(iloadinstanceseq
          ,substr('DW.T_BMS_PENALTY_TRACKER err:'||sqlerrm,1,256)
          ,SQLCODE
          ,SQLERRM
          ,'');
          END; --B4
     --END; --B3 dup_val_on_index block
     END; --B2 insert exception block
     END LOOP;
     -- ASSIGN HOW MANY RECORDS PROCESSED
     itotalrows := c%ROWCOUNT;
     -- CONDITIONAL/INCREMENTAL TRANSACTION COMMIT
          dw.pkg_load_verify.p_commit_load(iloadinstanceseq
          ,itotalrows - itotalerrors
          ,itotalerrors);
     EXIT WHEN c%NOTFOUND
     ;


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
,substr('DW.T_BMS_PENALTY_TRACKER GENERAL err:'||sqlerrm,1,256)
,SQLCODE
,SQLERRM
,'');
END; --B4
     ------------------------------------------------------
     -- END MAIN
     ------------------------------------------------------
END; --B1
/

GRANT EXECUTE ON DW.SPW_T_BMS_PENALTY_TRACKER TO TM1_ETL_ROLE;
GRANT EXECUTE ON DW.SPW_T_BMS_PENALTY_TRACKER TO LF188653;
GRANT EXECUTE ON DW.SPW_T_BMS_PENALTY_TRACKER TO SERVICE_ROLE;
