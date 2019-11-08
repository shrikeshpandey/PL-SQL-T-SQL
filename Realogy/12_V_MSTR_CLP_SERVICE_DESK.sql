/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           07/24/2019
||   Category:       Table
||
||   Description:    Change view V_MSTR_CLP_SERVICE_DESK
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

CREATE OR REPLACE VIEW DW.V_MSTR_CLP_SERVICE_DESK AS
SELECT
a11.CATEGORY_SK  CATEGORY_SK,
upper(a18.CATEGORY_NAME)  CATEGORY_NAME,
a11.OPEN_DT_SK  DT_SK,
a14.DAY_DT  DAY_DT,
a12.CORP_ID  CORP_ID,
a12.COMPANY_NAME  COMPANY_NAME,
a11.LOCATION_SK  LOCATION_SK,
a16.LOCATION_NAME  LOCATION_NAME,
a16.CITY  CITY,
--CHANGE 07/24/2019 
a11.caller_sk,
a12.call_type_sk,
--CHANGE 07/24/2019 
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
--count(distinct a11.INCIDENT_SK)  COUNTINCIDENTS
 a11.INCIDENT_SK
FROM
 DW.T_FCT_0013_SN_INCIDENT  a11 
Join (select O.ORACLENAME AS COMPANY_NAME,
         C.COMPANY_SK AS COMPANY_SK,
         O.CORP_ID AS CORP_ID,
         --CHANGE 07/24/2019 
         CT.call_type_sk,
         --CHANGE 07/24/2019 
         MIN( CT.STARTDATE) AS STARTDATE
 from DW.T_DIM_CALL_TYPE  CT 
join DW.T_CM_MAPORACLE O  on CT.CORP_ID = O.CORP_ID
    left join DW.T_DIM_COMPANY C on O.CORP_ID = C.ORACLE_ID  and C.oracle_id = CT.Corp_Id
GROUP BY O.ORACLENAME,
                C.COMPANY_SK ,
                 O.CORP_ID,
                 --CHANGE 07/24/2019 
                 CT.call_type_sk
                 --CHANGE 07/24/2019 
                 ) a12
 on (a11.COMPANY_SK = a12.COMPANY_SK)
join  DW.T_DIM_GROUP  a13 ON (a11.ASSIGNED_TO_GROUP_SK = a13.GROUP_SK)
join DW.T_DIM_DATE a14 ON (a11.OPEN_DT_SK = a14.DT_SK)  
Join DW.T_DIM_CONTACT_TYPE a15 ON (a11.CONTACT_TYPE_SK = a15.CONTACT_TYPE_SK)
join DW.T_DIM_LOCATION  a16 on (a11.LOCATION_SK = a16.LOCATION_SK)
join DW.T_DIM_SUBCATEGORY a17 on  (a11.SUBCATEGORY_SK = a17.SUBCATEGORY_SK)
JOIN DW.T_DIM_CATEGORY a18 ON  (a11.CATEGORY_SK = a18.CATEGORY_SK)
join  DW.T_DIM_PRIORITY   a19 on   (a11.PRIORITY_SK = a19.PRIORITY_SK)
WHERE
a12.CORP_ID in (SELECT DISTINCT CORP_ID FROM DW.T_DIM_CALL_TYPE) AND
 (Case when (a11.RESOLUTION_CODE_SK in (12417, 12418, 12419, 12421, 12423, 3, 4, 5, 6, 7)
or a11.CONTACT_TYPE_SK in (5)) then 0 else 1 end) in (1)
 and a14.DAY_DT between add_months(trunc(sysdate,'MM'),-12) and trunc(sysdate-1)
 and NVL(a12.STARTDATE,To_Date('01-01-1901', 'dd-mm-yyyy')) <=  a14.DAY_DT
;
/
--GRANT
GRANT ALL ON DW.V_MSTR_CLP_SERVICE_DESK TO LF188653;
GRANT SELECT ON DW.V_MSTR_CLP_SERVICE_DESK TO RPTGEN;
GRANT SELECT ON DW.V_MSTR_CLP_SERVICE_DESK TO SERVICE_ROLE;
GRANT SELECT ON DW.V_MSTR_CLP_SERVICE_DESK TO MSTR;