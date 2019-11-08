/*************************************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Science
||   Programmer:     Luis Fuentes
||   Date:           05/11/2019
||   Category:       SQL Tuning 
||   Description:    This query has been optimize using Hierarchical and recursive queries 
||
||   Parameters:     None
||
||   Historic Info:
||   Name:           Date:         Brief Description:
||   ----------------------------------------------------------------------------------------------
||   Luis Fuentes    05/11/2019    Applying Recursive queries
||   ----------------------------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***************************************************************************************************/
WITH
cte1 AS (SELECT objid, 
                UPPER(x_network_id) AS x_network_id, 
                s_last_name, s_first_name 
         FROM DW.T_CLAR_EMPLOYEE),
cte2 AS (SELECT UPPER(f_resource_net_id) AS f_resource_net_id,
                f_resource_name,
                f_resource_mgr_name,
                f_resource_region_id,
                f_resource_area_id,
                f_Employee_Team,
                f_tech_srvc_city 
          FROM DW.T_DM_HUMAN_RESOURCES),
cte3 AS (SELECT part_trans2demand_dtl,
                part_trans_owner2user,
                trans_type,
                creation_date
         FROM DW.T_CLAR_PART_TRANS
         WHERE trans_type = '2')             
SELECT  emprole.S_LAST_NAME || ', ' || emprole.S_FIRST_NAME AS "Log Analyst",
        emprole.X_GEOGRAPHY_CODE as GEO,
        case when (case when substr(CND.S_TITLE, -4) = 'SHIP' THEN RMA.x_days_to_burn else RMA.x_days_to_burn - 1 end ) < 0 then 'Missed'
        when (case when substr(CND.S_TITLE, -4) = 'SHIP' THEN RMA.x_days_to_burn else RMA.x_days_to_burn - 1 end)  between 0 and 6 then '0 to 6'
        else '7 Plus'
        end as "Bucket",
        case when (case when substr(CND.S_TITLE, -4) = 'SHIP' THEN RMA.x_days_to_burn else RMA.x_days_to_burn - 1 end ) < 0 then 'Missed'
        when (case when substr(CND.S_TITLE, -4) = 'SHIP' THEN RMA.x_days_to_burn else RMA.x_days_to_burn - 1 end)  between 0 and 6 then 'At Risk'
        else 'Needs Attention'
        end as "Status",
        DTL.DETAIL_NUMBER as "PR Number",
        DTL.DETAILS_DATE as "Create Date",
        DTL.REQUEST_TYPE as "PR Type",
        DTL.DEMAND_QTY as "Qty",
        CND.S_TITLE as "Condition",
        Decode(pov.Rtrn_Days, null, 15, 0, 15, pov.Rtrn_Days) as "Rtrn Days",
        Decode(RMA.x_days_to_burn, null, 15, case when substr(CND.S_TITLE, 1,4) = 'SHIP' THEN RMA.x_days_to_burn else RMA.x_days_to_burn - 1 end) as "Days to Burn",
        RMA.X_DUE_DATE AS "Due Date",
        RMA.X_RETURN_AGE as "Return Age",
        FRU.PART_NO as "Part Number",
        substr(FRU.PART_DESC, 1, 10) as "Description",
        FRU.PART_CLASS as "Part Class",
        substr(DTL.PRICE_PROGRAM, 1, 2) as "Currency",
        DTL.X_PART_COST as "Cost",
        emprole.S_LOCATION_NAME as "LA Inv Loc",
        HDR.X_INV_LOC as "Inv Loc",
        DTL.X_VENDOR_RMA as RMA,
        HDR.HEADER_CASE_NO as "Case",
        /* if there is a receiving tech, use that tech, otherwise use the tech on the part request */
        case when HR2.F_RESOURCE_NET_ID is not null then HR2.F_RESOURCE_NAME  || ' (RCV)' else case when HR.F_Resource_name is null then  'None' else HR.F_Resource_name || ' (OA)' end end as "Tech Name",
        pov.PO_VENDOR as "Vendor ID",
        pov.VENDOR_NAME as "Vendor Name",
        ODS.F_CUST_CORP_ID as "Corp ID",
        ODS.F_CUST_CORP_NAME as "Corp Name",
        (CASE
        WHEN UPPER(DTL.REQUEST_TYPE) = 'GNU-XSHIP' THEN 0
        ELSE DTL.X_LABOR_REIMB_ORIG
        END) "Wty Reimb Dollars",
        /* if there is a receiving tech, use that tech's info, otherwise use the tech on the part request */
        case when HR2.F_RESOURCE_NET_ID is not null then HR2.f_resource_mgr_name else HR.f_resource_mgr_name end as  "Tech Manager",
        case when HR2.F_RESOURCE_NET_ID is not null then HR2.f_resource_region_id else HR.f_resource_region_id end as "Tech Region",
        case when HR2.F_RESOURCE_NET_ID is not null then HR2.f_resource_area_id else  HR.f_resource_area_id end as "Tech Area",
        case when HR2.F_RESOURCE_NET_ID is not null then HR2.f_Employee_Team else HR.f_Employee_Team end as "Tech Team" ,
        case when HR2.F_RESOURCE_NET_ID is not null then HR2.f_tech_srvc_city else HR.f_tech_srvc_city end as "Tech Srv City"
FROM DW.T_CLAR_DEMAND_DTL DTL
INNER JOIN DW.T_CLAR_DEMAND_HDR HDR    
 ON DTL.DEMAND_DTL2DEMAND_HDR = HDR.OBJID
INNER JOIN cte1 EMP    
 ON HDR.X_DEM_HDR_TECH2EMPLOYEE = EMP.OBJID
INNER JOIN DW.T_CLAR_CONDITION CND    
 ON DTL.DEMAND_DTL2CONDITION = CND.OBJID
INNER JOIN DW.T_CLAR_INV_LOCATN LOC    
 ON HDR.X_DEM_HDR_LOC2INV_LOCATN = LOC.OBJID
/* this is tech assigned to the part request */
LEFT JOIN cte2 HR     
 ON EMP.X_NETWORK_ID = HR.F_RESOURCE_NET_ID
LEFT JOIN DW.V_CLAR_X_RMA RMA    
 ON DTL.OBJID = RMA.X_RMA2DEMAND_DTL
LEFT JOIN DW.T_CLAR_ODS_CASE ODS    
 ON HDR.CASEINFO2CASE = ODS.F_CASE_KEY
/* if part has been received, get tech who received it */
LEFT JOIN (
        SELECT part_trans2demand_dtl, UPPER(U.s_login_name) AS s_login_name
        FROM cte3 TR1
        INNER JOIN t_clar_user U 
         ON TR1.part_trans_owner2user = U.OBJID
         AND TR1.creation_date = (
                 SELECT MIN(tr2.creation_date) 
                 FROM cte3 TR2 
                 WHERE TR2.part_trans2demand_dtl = TR1.part_trans2demand_dtl
                )
) RCV 
 ON RCV.part_trans2demand_dtl = DTL.objid
/* add another join to HR for the receiving tech */
LEFT JOIN cte2 HR2
 ON RCV.s_login_name = HR2.f_resource_net_id
LEFT JOIN (
        SELECT  VW.S_LOCATION_NAME,
                VW.S_LOCATION_DESCR,
                VW.S_LOCATION_TYPE,
                VW.X_GEOGRAPHY_CODE,
                VW.S_SITE_ID,
                VW.ACTIVE,
                VW.ROLE_NAME,
                EMP2.S_LAST_NAME,
                EMP2.S_FIRST_NAME,
                RLE.X_POSITION,
                RLE.X_STR_ROLE_NAME,
                RLE.X_STR_POSITION,
                RLE.X_INV_ROLE2EMPLOYEE,
                RLE.X_INV_ROLE2INV_LOC,
                EMP2.OBJID
        FROM cte1 EMP2
        INNER JOIN DW.T_CLAR_X_EMP_INV_ROLE RLE 
         ON EMP2.OBJID = RLE.X_INV_ROLE2EMPLOYEE
        INNER JOIN DW.T_CLAR_LOCATN_VIEW VW  
         ON VW.LOC_OBJID = RLE.X_INV_ROLE2INV_LOC
        WHERE VW.ACTIVE=1
         AND VW.ROLE_NAME='located at'
         AND RLE.X_STR_ROLE_NAME='Primary'
         AND RLE.X_STR_POSITION='Analyst'
) emprole 
 ON LOC.S_LOCATION_NAME = emprole.S_LOCATION_NAME
LEFT JOIN DW.T_CLAR_GBST_ELM ELM 
 ON DTL.DMND_DTL_STS2GBST_ELM = ELM.OBJID
LEFT JOIN DW.T_DM_CLAR_FRU_PARTS FRU 
 ON DTL.DEMAND_DTL2PART_INFO = FRU.MODLEVEL_OBJID
LEFT JOIN (
        SELECT PO.PO_CREATION_DATE,
               PO.PO_DATE,
               PO.PO_REQ_NUM_SEGMENT,
               PO.REQUEST_TYPE,
               PO.PO_VENDOR,
               PO.VENDOR_NAME,
               PO.PO_UNIT_PRICE,
               PO.PO_COST,
        DECODE(STE.X_DAYS_RETURN, null, 15, 0, 15, STE.X_DAYS_RETURN) AS Rtrn_Days
        FROM DW.T_CLAR_SITE STE
        RIGHT JOIN DW.T_DM_CLAR_PO PO 
         ON STE.SITE_ID = PO.PO_VENDOR
        WHERE PO.PO_DATE >= SYSDATE - 180
) pov 
 ON DTL.DETAIL_NUMBER = pov.PO_REQ_NUM_SEGMENT
WHERE ((DTL.DETAILS_DATE >= sysdate - 180)
--(DTL.DETAILS_DATE)>= sysdate - 3)
AND ((DTL.REQUEST_TYPE) NOT IN ('Pick','Replenishment','Purchase','GNU-Pick','DOA-Pick','Loaner Out','Refurb','Misc PO','Cust-Purchase')
And (DTL.REQUEST_TYPE) NOT LIKE 'SC%')
AND ((CND.S_TITLE) <> 'CLOSED')
AND ((FRU.PART_NO) IS NOT NULL)
AND ((ELM.TITLE)<>'PO Cancelled'
And (ELM.TITLE)<>'Rej - Await Info'
And (ELM.TITLE)<>'Rej - Missing Info')
AND ((LOC.S_LOCATION_NAME) NOT LIKE 'SIMS%')
AND (DTL.X_SUPPLIER_SHIP_DATE> to_date('01/01/1753', 'MM/DD/YYYY')));
