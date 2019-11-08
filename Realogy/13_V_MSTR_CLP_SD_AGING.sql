/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           07/24/2019
||   Category:       Table
||
||   Description:    Change view V_MSTR_CLP_SD_AGING
||
||   Parameters:     None
||
||   Historic Info:
||    Name:           Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes     07/24/2019   Adding a11.caller_sk, a12.Call_Type_Sk
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

CREATE OR REPLACE VIEW DW.V_MSTR_CLP_SD_AGING AS
select  a12.LAST_DAY_OF_CLND_MO LAST_DAY_OF_CLND_MO,
  a11.DT_SK  DT_SK,
  a12.DAY_DT  DAY_DT,
  a13.ORACLE_ID  CORP_ID,
  --CHANGE 07/24/2019 
  a17.call_type_sk,
  --CHANGE 07/24/2019 
  a11.ASSIGNED_TO_GROUP_SK  ASSIGNED_TO_GROUP_SK,
  a14.name AS GROUP_NAME,
  a14.level_num,
  a12.CLNDR_MO_YEAR_NO  CLNDR_MO_YEAR_NO,
  sum((Case when a11.DAYS_OPEN = 0 then a11.TOT_SN_CASES_OPEN else 0 end))  AGING0LASTDAY,
  sum((Case when (a11.DAYS_OPEN > 3
   and a11.DAYS_OPEN < 8) then a11.TOT_SN_CASES_OPEN else 0 end))  AGING47LASTDAY,
  sum((Case when (a11.DAYS_OPEN > 7
   and a11.DAYS_OPEN < 16) then a11.TOT_SN_CASES_OPEN else 0 end))  AGING815LASTDAY,
  sum((Case when (a11.DAYS_OPEN > 15
   and a11.DAYS_OPEN < 31) then a11.TOT_SN_CASES_OPEN else 0 end))  AGING1630LASTDAY,
  sum((Case when (a11.DAYS_OPEN > 30
   and a11.DAYS_OPEN < 60) then a11.TOT_SN_CASES_OPEN else 0 end))  AGING3159LASTDAY,
  sum((Case when (a11.DAYS_OPEN > 59
   and a11.DAYS_OPEN < 181) then a11.TOT_SN_CASES_OPEN else 0 end))  AGING60180LASTDAY,
  sum((Case when a11.DAYS_OPEN > 180 then a11.TOT_SN_CASES_OPEN else 0 end))  AGING181LASTDAY,
  sum((Case when (a11.DAYS_OPEN > 0
   and a11.DAYS_OPEN < 4) then a11.TOT_SN_CASES_OPEN else 0 end))  AGING13LASTDAY,
  sum((Case when (a11.DAYS_OPEN >=  0
   and a11.DAYS_OPEN < 4) then a11.TOT_SN_CASES_OPEN else 0 end))  AGING03LASTDAY,
  sum(a11.TOT_SN_CASES_OPEN)  TOTALSNCASESOPEN
from  DW.T_DM_SN_0013_DAILY  a11
  join  DW.T_DIM_DATE  a12
    on   (a11.DT_SK = a12.DT_SK)
  join  DW.T_DIM_COMPANY  a13
    on   (a11.COMPANY_SK = a13.COMPANY_SK)
  join  DW.T_DIM_GROUP  a14
    on   (a11.ASSIGNED_TO_GROUP_SK = a14.GROUP_SK)
 join  (select distinct a14.CLNDR_MO_YEAR_NO  CLNDR_MO_YEAR_NO,
    a14.CLNDR_MO_YEAR_SHRT_DESC  CLNDR_MO_DESC,
    a14.CLNDR_MO_START_DT  CLNDR_MO_START_DT,
    a14.CLNDR_MO_SHRT_DESC  CLNDR_MO_SHRT_DESC,
    a14.CLNDR_MO_DESC  CLNDR_MO_YEAR_SHRT_DESC,
 A14.CLNDR_YEAR_NO
    from dw.t_dim_date a14)  a16
on   (a12.CLNDR_MO_YEAR_NO = a16.CLNDR_MO_YEAR_NO)
join  (select O.ORACLENAME AS COMPANY_NAME,
         C.COMPANY_SK AS COMPANY_SK,
         O.CORP_ID AS CORP_ID,
         --CHANGE 07/24/2019
         CT.call_type_sk,
         --CHANGE 07/24/2019 
         MIN( CT.STARTDATE) AS STARTDATE
 from DW.T_DIM_CALL_TYPE CT
   join DW.T_CM_MAPORACLE O
     on CT.CORP_ID = O.CORP_ID
    left join DW.T_DIM_COMPANY C
      on O.CORP_ID = C.ORACLE_ID
GROUP BY O.ORACLENAME,
                C.COMPANY_SK ,
                 O.CORP_ID,
                 --CHANGE 07/24/2019 
                 CT.call_type_sk
                 --CHANGE 07/24/2019 
                 )  a17
    on   (a13.ORACLE_ID = a17.CORP_ID)
    where  (
  a12.DAY_DT >= To_Date('01-07-2015', 'dd-mm-yyyy')
 and a12.LAST_DAY_OF_CLND_MO in ('Y'))
group by  a12.LAST_DAY_OF_CLND_MO,
  a11.DT_SK,
  a14.level_num,
  a14.name,
  a12.DAY_DT,
  a13.ORACLE_ID,
  a11.ASSIGNED_TO_GROUP_SK,
  a12.CLNDR_MO_YEAR_NO,
  --CHANGE 07/24/2019 
  a17.call_type_sk
  --CHANGE 07/24/2019 
;
/
--GRANT
GRANT ALL ON DW.V_MSTR_CLP_SD_AGING TO LF188653;
GRANT SELECT ON DW.V_MSTR_CLP_SD_AGING TO RPTGEN;
GRANT SELECT ON DW.V_MSTR_CLP_SD_AGING TO SERVICE_ROLE;
GRANT SELECT ON DW.V_MSTR_CLP_SD_AGING TO MSTR;