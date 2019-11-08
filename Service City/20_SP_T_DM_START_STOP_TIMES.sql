CREATE OR REPLACE PROCEDURE DW.SPW_T_DM_START_STOP_TIMES (iCommit IN NUMBER DEFAULT 2000
) is
/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           04/04/2018
||   Category:       Table
||
||   Description:    Creates table T_DM_START_STOP_TIMES
||
||   Parameters:     None
||
||   Historic Info:
||    Name:           Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes      04/03/2018   Initial Creation
||   Luis Fuentes      08/06/2018   Changing date logic for closed_calls
||   Luis Fuentes      09/10/2018   Adding travel_start_time & travel_end_time
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/
/*******************************************************************************************
*  Generated using sp_gen_bulk() jg 2006
*******************************************************************************************/

--Data to INSERT into DW.T_DM_START_STOP_TIMES
CURSOR c IS
SELECT   A.Service_Date2 AS service_date
        ,A.TECHKEY AS f_tech_empl_key
        ,MIN(A.Service_Date1) - TRUNC(MIN(A.Service_Date1)) AS work_start_time
        ,MIN(CASE WHEN A.time_type = 'Work' THEN A.Service_Date1 END) - TRUNC(MIN(CASE WHEN A.time_type = 'Work' THEN A.Service_Date1 END)) AS onsite_start_time
        ,MAX(CASE WHEN A.time_type = 'Work' THEN A.Service_Date3 END) - TRUNC(MAX(CASE WHEN A.time_type = 'Work' then A.Service_Date3 END)) AS onsite_end_time
        ,MAX(A.Service_Date3) - TRUNC(max(A.Service_Date3)) AS work_end_time
        --Begin Luis Fuentes  09/10/2018
        ,MIN(CASE WHEN A.time_type = 'Travel' THEN A.Service_Date1 END) - TRUNC(MIN(CASE WHEN A.time_type = 'Travel' THEN A.Service_Date1 END)) AS travel_start_time
        ,MAX(CASE WHEN A.time_type = 'Travel' THEN A.Service_Date3 END) - TRUNC(MAX(case when A.time_type = 'Travel' THEN A.Service_Date3 END)) AS travel_end_time
        --End Luis Fuentes  09/10/2018
FROM (
 Select
  B.techkey
  ,B.time_type
  ,B.Service_Date1
  ,B.Service_Date2
  ,B.Service_Date3
  ,B.Effective_date
  ,B.bizcalstarttime
 from  (
        SELECT J.objid bizcal
            ,M.start_time bizcalstarttime
            ,K.effective_date
            ,D.objid as techkey
            ,nvl(A.time_type, 'Work') time_type
            ,A.START_TIME+((I.GMT_DIFF+18000)/86400) AS Service_Date1
            ,TRUNC(A.START_TIME+((I.GMT_DIFF+18000)/86400)) AS Service_Date2
            ,A.X_ACTUAL_END_TIME+((I.GMT_DIFF+18000)/86400 ) AS Service_Date3
        FROM DW.T_CLAR_TIME_LOG A
        INNER JOIN DW.T_CLAR_ONSITE_LOG B
         ON A.TIME2ONSITE_LOG = B.OBJID
        INNER JOIN dw.T_DIM_DATE C
         ON TRUNC(A.START_TIME) = C.DAY_DT
        INNER JOIN DW.T_CLAR_EMPLOYEE D
         ON B.ONSITE_DOER2EMPLOYEE = D.OBJID
        INNER JOIN DW.T_CLAR_SITE G
         ON D.EMP_PHYSICAL_SITE2SITE = G.OBJID
        INNER JOIN DW.T_CLAR_ADDRESS H
         ON G.CUST_PRIMADDR2ADDRESS = H.OBJID
        INNER JOIN DW.T_CLAR_TIME_ZONE I
         ON H.ADDRESS2TIME_ZONE = I.OBJID
        INNER JOIN dw.t_clar_biz_cal_hdr J
         ON J.objid = D.Empl_Hrs2biz_Cal_Hdr
        INNER JOIN dw.t_clar_biz_cal K
         ON K.biz_cal2biz_cal_hdr = J.objid
        INNER JOIN dw.t_clar_wk_work_hr L
         ON K.biz_cal2wk_work_hr = L.objid
        left JOIN dw.t_clar_work_hr M
         ON L.objid = M.work_hr2wk_work_hr AND trunc(C.clndr_week_start_dt + (1/24) * (M.start_time/3600)) = trunc(A.START_TIME + ((I.GMT_DIFF+18000 )/86400))
        WHERE
        --Beging Luis Fuentes 08/06/2018
        TRUNC(A.START_TIME + ((I.GMT_DIFF+18000 )/86400)) >=  (SELECT CASE
      WHEN TRUNC (SYSDATE) > DW.GET_BUSINESS_DATE (TRUNC (ADD_MONTHS (SYSDATE, 0), 'MM'),3)
         THEN TRUNC (ADD_MONTHS (SYSDATE, 0), 'MM')
         ELSE TRUNC (ADD_MONTHS (SYSDATE, -1), 'MM')
              END AS d_begin
          FROM DUAL)
        AND TRUNC(A.START_TIME + ((I.GMT_DIFF+18000 )/86400)) < (SELECT LAST_DAY(TRUNC (ADD_MONTHS (TRUNC (SYSDATE), 0), 'MM')) AS d_end FROM DUAL)
        --End Luis Fuentes 08/06/2018
         AND (A.time_type <> 'Appt' or A.time_type is null)
         AND A.START_TIME + ((I.GMT_DIFF+18000 )/86400) >= trunc(K.effective_date)
     ) B
    LEFT JOIN dw.t_clar_biz_cal N
      ON N.biz_cal2biz_cal_hdr = B.bizcal and N.Effective_date > B.effective_date
      HAVING B.Service_Date2 < nvl(min(trunc(N.Effective_date)), sysdate)
            and B.bizcalstarttime is not null
    GROUP BY
    B.techkey
    ,B.time_type
    ,B.Service_Date1
    ,B.Service_Date2
    ,B.Service_Date3
    ,B.Effective_date
    ,B.bizcalstarttime
  ) A
  GROUP BY A.Service_Date2, A.TECHKEY
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
service_date_t      DBMS_SQL.DATE_table;
f_tech_empl_key_t   DBMS_SQL.NUMBER_table;
work_start_time_t   DBMS_SQL.NUMBER_table;
onsite_start_time_t DBMS_SQL.NUMBER_table;
onsite_end_time_t   DBMS_SQL.NUMBER_table;
work_end_time_t     DBMS_SQL.NUMBER_table;
travel_start_time_t DBMS_SQL.NUMBER_table;
travel_end_time_t   DBMS_SQL.NUMBER_table;

BEGIN --B1

-- Conditional Create of New Seq Number
dw.sp_md_get_next_seq('T_DM_START_STOP_TIMES',
     'T_DM_START_STOP_TIMES',
     'OBJID',
     1, --- ACTIVE CODE 1 OR 0 PRETTY MUCH ALWAYS ACTIVE '
     'T_DM_START_STOP_TIMES',
     'ORACLE DB-LINK',
     'DW TABLE LOAD',
     'SPW_T_DM_START_STOP_TIMES',
     iLoadSequence,
     'DW');

dw.pkg_load_verify.p_begin_load(iloadsequence,iloadinstanceseq);
--dw.sp_truncate('DW.T_DM_START_STOP_TIMES');
--dw.sp_rebuild_bitmap_indexes('DW','T_DM_START_STOP_TIMES');

-----------------------------------------------------------------
--Calculate and load new data
-----------------------------------------------------------------
OPEN c;
LOOP
     FETCH c BULK COLLECT INTO
       service_date_t,
       f_tech_empl_key_t,
       work_start_time_t,
       onsite_start_time_t,
       onsite_end_time_t,
       work_end_time_t,
       travel_start_time_t,
       travel_end_time_t
     LIMIT iCommit;
     FOR i in 1 .. service_date_t.COUNT
     LOOP
          BEGIN --B2 insert
          INSERT INTO DW.T_DM_START_STOP_TIMES (
            service_date,
            f_tech_empl_key,
            work_start_time,
            onsite_start_time,
            onsite_end_time,
            work_end_time,
            travel_start_time,
            travel_end_time
          )
          VALUES (
            service_date_t(i),
            f_tech_empl_key_t(i),
            work_start_time_t(i),
            onsite_start_time_t(i),
            onsite_end_time_t(i),
            work_end_time_t(i),
            travel_start_time_t(i),
            travel_end_time_t(i)
          );
EXCEPTION -- B2
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
--HADLE OTHER ERRORS
EXCEPTION --B2
     WHEN OTHERS THEN
     --INSERT ERROR INFORMATION
          BEGIN --B4
          itotalerrors := itotalerrors + 1;
          dw.pkg_load_verify.p_record_exception(iloadinstanceseq
          ,substr('DW.T_DM_START_STOP_TIMES err:'||sqlerrm,1,256)
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
,substr('DW.T_DM_START_STOP_TIMES GENERAL err:'||sqlerrm,1,256)
,SQLCODE
,SQLERRM
,'');
END; --B4
     ------------------------------------------------------
     -- END MAIN
     ------------------------------------------------------
END; --B1
/

GRANT EXECUTE ON DW.SPW_T_DM_START_STOP_TIMES TO TM1_ETL_ROLE;
GRANT EXECUTE ON DW.SPW_T_DM_START_STOP_TIMES TO LF188653;
GRANT EXECUTE ON DW.SPW_T_DM_START_STOP_TIMES TO SERVICE_ROLE;
GRANT ALL ON DW.GET_BUSINESS_DATE TO LF188653;
