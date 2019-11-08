/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           04/03/2018
||   Category:       Table
||
||   Description:    Creates table T_DM_START_STOP_TIMES
||
||   Parameters:     None
||
||   Historic Info:
||    Name:             Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes       04/03/2018   Initial Creation
||   Luis Fuentes       04/11/2018   changing table´s name and attributes
||   Mary Rupert        04/27/2018   Adding scheduled work days
||   Mary Rupert        05/7/2018    Adding schedule for specific day of week worked
||   Mary Rupert        05/7/2018    Fixing start_time isssue
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

BEGIN
  DW.SP_TRUNCATE('DW.T_DM_START_STOP_TIMES');
END;

INSERT INTO DW.T_DM_START_STOP_TIMES@DWDEV.WORLD(
   service_date
  ,f_tech_empl_key
  ,work_start_time
  ,onsite_start_time
  ,onsite_end_time
  ,work_end_time
  ,travel_start_time
  ,travel_end_time
)
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
        TRUNC(A.START_TIME + ((I.GMT_DIFF+18000 )/86400)) >=  (to_date('&StartDate', 'mm/dd/yyyy'))
        AND TRUNC(A.START_TIME + ((I.GMT_DIFF+18000 )/86400)) < (to_date('&BeforeDate', 'mm/dd/yyyy'))
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
COMMIT;
