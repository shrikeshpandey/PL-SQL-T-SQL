/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           07/24/2019
||   Category:       Table
||
||   Description:    Change view V_MSTR_CLP_SD_CLOSED_INC
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

CREATE OR REPLACE VIEW DW.V_MSTR_CLP_SD_CLOSED_INC AS
SELECT a11.CATEGORY_SK  CATEGORY_SK,
upper(a18.CATEGORY_NAME)  CATEGORY_NAME,
a11.OPEN_DT_SK  DT_SK,
a13.DAY_DT  DAY_DT,
a12.CORP_ID  CORP_ID,
a12.COMPANY_NAME  COMPANY_NAME,
a11.LOCATION_SK  LOCATION_SK,
a16.LOCATION_NAME  LOCATION_NAME,
a16.CITY  CITY,
a16.COUNTRY  COUNTRY,
a16.STATE  STATE,
a16.SITE_ID  SITE_ID,
NVL(a12.STARTDATE,To_Date('01-01-1901', 'dd-mm-yyyy'))  STARTDATE,
a11.SUBCATEGORY_SK  SUBCATEGORY_SK,
a17.SUBCATEGORY_NAME  SUBCATEGORY_NAME,
a11.CONTACT_TYPE_SK  CONTACT_TYPE_SK,
upper(a15.CONTACT_TYPE)  CONTACT_TYPE,
a15.CONTACT_TYPE  CustCol_29,
(Case when a11.CI_NAME is not null then a11.CI_NAME else ' ' end)  CI_NAME,
a11.PRIORITY_SK  PRIORITY_SK,
a19.DESCRIPTION  DESCRIPTION,
  case when a19.DESCRIPTION = 'P1' THEN '1 - Critical'
    WHEN a19.DESCRIPTION = 'P2' THEN '2 - High'
    when a19.DESCRIPTION = 'P3' THEN '3 - Moderate'
    when a19.DESCRIPTION = 'P4' THEN '4 - Low'
    when a19.DESCRIPTION = 'P5' THEN '5 - Planning'
  ELSE ' ' END  CustCol_411,
a13.GROUP_SK  ASSIGNED_TO_GROUP_SK,
a13.NAME  NAME,
a13.LEVEL_NUM  LEVEL_NUM,
a13.U_ACTUAL_COMPANY  U_ACTUAL_COMPANY,
--CHANGE 07/24/2019 
a11.caller_sk,
a12.Call_Type_Sk,
--CHANGE 07/24/2019 
count(distinct a11.INCIDENT_SK)  COUNTINCIDENTS,
 a11.INCIDENT_SK,
  count( a11.INCIDENT_SK)  TOTALINCIDENTSCLOSED,
      (CASE WHEN a11.CLOSE_DT_SK is not null THEN
           (Case when max((Case when a13.LEVEL_NUM in (1) then 1 else 0 end)) = 1 then count(distinct (Case when a13.LEVEL_NUM in (1) then a11.INCIDENT_SK else NULL end)) else NULL end) END)  CLOSEDLEVEL1SERVICEDESK,
      (CASE WHEN a11.CLOSE_DT_SK is not null THEN
           (Case when max((Case when a13.LEVEL_NUM in (2) then 1 else 0 end)) = 1 then count(distinct (Case when a13.LEVEL_NUM in (2) then a11.INCIDENT_SK else NULL end)) else NULL end)   END)CLOSEDLEVEL2DESKSIDE,
      (CASE WHEN a11.CLOSE_DT_SK is not null THEN
           (Case when max((Case when a13.LEVEL_NUM in (3) then 1 else 0 end)) = 1 then count(distinct (Case when a13.LEVEL_NUM in (3) then a11.INCIDENT_SK else NULL end)) else NULL end) END)  CLOSEDLEVEL3RESOLVERGROUP,
      (CASE WHEN a11.CLOSE_DT_SK is not null THEN
           (Case when max((Case when a13.LEVEL_NUM in (4) then 1 else 0 end)) = 1 then count(distinct (Case when a13.LEVEL_NUM in (4) then a11.INCIDENT_SK else NULL end)) else NULL end)  END) CLOSEDLEVEL4VENDOR,
      (CASE WHEN a11.CLOSE_DT_SK is not null THEN
           (Case when max((Case when (a13.LEVEL_NUM in (0, 5, 6, 7, 8, 9) or a13.LEVEL_NUM is null) then 1 else 0 end)) = 1 then count(distinct (Case when (a13.LEVEL_NUM in (0, 5, 6, 7, 8, 9) or a13.LEVEL_NUM is null) then a11.INCIDENT_SK else NULL end)) else NULL end)  END) CLOSEDOTHER,
    COUNT(CASE WHEN(a20.U_RESOLVABLE in (1) and a20.U_RESOLVER_LEVEL = 1) THEN 1 END)FLROPPORTUNITIES,
        COUNT(CASE WHEN(a20.U_RESOLVABLE in (1) and a20.U_RESOLVER_LEVEL = 1  and a13.LEVEL_NUM in (1)) THEN 1 END) FLRATTAINMENT
from      DW.T_FCT_0013_SN_INCIDENT a11
                join        (select O.ORACLENAME AS COMPANY_NAME,
         C.COMPANY_SK AS COMPANY_SK,
         O.CORP_ID AS CORP_ID,
         --CHANGE 07/24/2019 
         CT.Call_Type_Sk,
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
                 CT.Call_Type_Sk
                 --CHANGE 07/24/2019 
                  )     a12
                  on         (a11.COMPANY_SK = a12.COMPANY_SK)
                join        DW.T_DIM_DATE            a13
                  on         (a11.CLOSE_DT_SK = a13.DT_SK)
join Dw.t_Dim_Priority p oN a11.priority_sk = p.priority_sk
LEFT join    IAAS.CMDB_CI    a20
          on     (a11.SUPPORT_FUNCTION_ID = a20.SYS_ID)
join  DW.T_DIM_GROUP a13 ON (a11.ASSIGNED_TO_GROUP_SK = a13.GROUP_SK)
Join DW.T_DIM_CONTACT_TYPE a15 ON (a11.CONTACT_TYPE_SK = a15.CONTACT_TYPE_SK)
join DW.T_DIM_LOCATION  a16 on (a11.LOCATION_SK = a16.LOCATION_SK)
join DW.T_DIM_SUBCATEGORY a17 on  (a11.SUBCATEGORY_SK = a17.SUBCATEGORY_SK)
JOIN DW.T_DIM_CATEGORY a18 ON  (a11.CATEGORY_SK = a18.CATEGORY_SK)
join  DW.T_DIM_PRIORITY  a19 on   (a11.PRIORITY_SK = a19.PRIORITY_SK)
where   (a13.DAY_DT between add_months(trunc(sysdate,'MM'),-12) and trunc(sysdate-1)
--and a12.CORP_ID in ('192136')
and NVL(a12.STARTDATE,To_Date('01-01-1901', 'dd-mm-yyyy')) <=  a13.DAY_DT
and (Case when (a11.RESOLUTION_CODE_SK in (12417, 12418, 12419, 12421, 12423, 3, 4, 5, 6, 7)
                or a11.CONTACT_TYPE_SK in (5)) then 0 else 1 end) in (1))
group by
a11.INCIDENT_SK,
a11.CATEGORY_SK  ,
upper(a18.CATEGORY_NAME),
a11.OPEN_DT_SK,
a13.DAY_DT,
a12.CORP_ID,
a12.COMPANY_NAME,
--CHANGE 07/24/2019 
a11.caller_sk,
a12.Call_Type_Sk,
--CHANGE 07/24/2019 
a11.LOCATION_SK,
a16.LOCATION_NAME,
a16.CITY  ,
a16.COUNTRY ,
a16.STATE  ,
a16.SITE_ID  ,
NVL(a12.STARTDATE,To_Date('01-01-1901', 'dd-mm-yyyy'))  ,
a11.SUBCATEGORY_SK  ,
a17.SUBCATEGORY_NAME  ,
a11.CONTACT_TYPE_SK  ,
upper(a15.CONTACT_TYPE)  ,
a15.CONTACT_TYPE  ,
(Case when a11.CI_NAME is not null then a11.CI_NAME else ' ' end)  ,
a11.PRIORITY_SK  ,
a19.DESCRIPTION  ,
  case when a19.DESCRIPTION = 'P1' THEN '1 - Critical'
    WHEN a19.DESCRIPTION = 'P2' THEN '2 - High'
    when a19.DESCRIPTION = 'P3' THEN '3 - Moderate'
    when a19.DESCRIPTION = 'P4' THEN '4 - Low'
    when a19.DESCRIPTION = 'P5' THEN '5 - Planning'
  ELSE ' ' END  ,
a13.GROUP_SK  ,
a13.NAME  ,
a13.LEVEL_NUM  ,
a13.U_ACTUAL_COMPANY,
a11.CLOSE_DT_SK
;
/
--GRANT
GRANT ALL ON DW.V_MSTR_CLP_SD_CLOSED_INC TO LF188653;
GRANT SELECT ON DW.V_MSTR_CLP_SD_CLOSED_INC TO RPTGEN;
GRANT SELECT ON DW.V_MSTR_CLP_SD_CLOSED_INC TO SERVICE_ROLE;
GRANT SELECT ON DW.V_MSTR_CLP_SD_CLOSED_INC TO MSTR;