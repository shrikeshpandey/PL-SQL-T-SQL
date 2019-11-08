/***********************************************************************************
   ||   PROCEDURE INFORMATION
   ||
   ||   Department:     Value Engineering
   ||   Creator:        Luis Fuentes
   ||   Date:           27/08/2019
   ||   Category:       Side project for Eric Dush
   ||
   ||   Description:    This query is used for Qlik Sense Data Engine
   ||
   ||
   ||   Parameters:     iCommit:   None
   ||
   ||   Load Sequence Number:  NNN
   ||
   ||   Historic Info:
   ||    Name:               Date:        Brief Description:
   ||   -----------------------------------------------------------------------------
   ||    Luis Fuentes        27/08/2019   Initial Creation
   ||    Luis Fuentes        27/08/2019   Adding country, state, city, street, zip code
   ||   -----------------------------------------------------------------------------
   ||
   ||   CURRENT REVISION STANDARD:  v1.50
   ||
   ***********************************************************************************/
/*******************************************************************************************
*  Generated using sp_gen_bulk() jg 2006
*******************************************************************************************/
SELECT *
FROM (
    SELECT  TBL1.INCIDENT_NUMBER Ticket_Number,
            TBL2.COMPANY,
            TBL1.CTI,
            TBL1.CORRELATION_ID,
            TBL1.CAUSED_BY_CHANGE,
            TBL2.IS_PARENT,
            TBL2.CONTACT_TYPE,
            TBL2.PRIORITY,
            TBL2.SEVERITY,
            TBL1.MAJOR_INCIDENT,
            TBL2.INCIDENT_STATE,
            TBL2.VIP,
            CASE WHEN TBL1.SUPPORTABLE = '0' THEN 'False' ELSE 'True' END SUPPORTABLE,
            CASE WHEN TBL1.U_HD_WORKED = '1' THEN 'True' ELSE 'False' END HD_WORKED,
            CASE WHEN TBL1.SERVICE_DESK_RESOLVABLE = '0' THEN 'True' ELSE 'False' END SERVICE_DESK_RESOLVABLE,
            TBL2.SUPPORT_LEVEL,
            TBL2.RESOLVABLE,
            TBL2.RESOLVABLE_LEVEL,
            TBL1.COMPANY_NAME,
            TBL1.TOTAL_CHILD_INCIDENTS,
            TBL1.OPEN_CHILD_INC_COUNT,
            TBL2.CALLER,
            TBL2.CREATED_BY,
            TBL2.QUICK_CODE,
            TBL2.SHORT_DESCRIPTION,
            TBL2.DESCRIPTION,
            TBL2.CATEGORY,
            TBL2.SUB_CATEGORY,
            TBL2.SUPPORT_FUNCTION_BUNDLE,
            TBL2.SUPPORT_FUNCTION,
            TBL2.ACTION,
            TBL2.CONFIGURATION_ITEM_CLASS,
            TBL2.CONFIGURATION_ITEM,
            TBL2.ASSIGNMENT_GROUP_PARENT,
            TBL2.ASSIGNMENT_GROUP,
            TBL2.ASSIGNED_TO,
            TBL2.PROBLEM_ID,
            TBL2.HOLD_COUNT,
            TBL2.UPDATES,
            TBL2.REASSIGNMENT_COUNT,
            TBL2.REWORK_COUNT,
            TBL2.ESCALATION_COUNT,
            TBL2.RESOLVED_FIRST_CONTACT,
            TBL2.RESOLUTION_CODE,
            TBL2.RESOLVED_BY_GROUP,
            TBL2.RESOLVED_BY,
            TBL2.TECH_NAME,
            TBL2.RESOLUTION_NUMBER,
            TBL2.KNOWLEDGE_ARTICLE,
            TBL2.CLOSE_NOTES,
            TBL2.SLA_CONTRACT,
            --- Daylight Savings---
            CASE
            WHEN TBL2.CREATED_DATE BETWEEN TO_DATE('2017-03-12','yyyy/mm/dd') AND TO_DATE('2017-11-05','yyyy/mm/dd') THEN TO_DATE(TO_CHAR (NEW_TIME (TBL2.CREATED_DATE-(1/24), 'GMT', 'EDT'),'MM/DD/YYYY HH24:MI:SS'),'MM/DD/YYYY HH24:MI:SS')  
            WHEN TBL2.CREATED_DATE BETWEEN TO_DATE('2018-03-11','yyyy/mm/dd') AND TO_DATE('2018-11-04','yyyy/mm/dd') THEN TO_DATE(TO_CHAR (NEW_TIME (TBL2.CREATED_DATE-(1/24), 'GMT', 'EDT'),'MM/DD/YYYY HH24:MI:SS'),'MM/DD/YYYY HH24:MI:SS') 
            ELSE TO_DATE(TO_CHAR (NEW_TIME (TBL2.CREATED_DATE-(1/24), 'GMT', 'EST'),'MM/DD/YYYY HH24:MI:SS'),'MM/DD/YYYY HH24:MI:SS') 
            END AS CREATED_DATE,
            --TO_DATE(TO_CHAR (NEW_TIME (TBL2.CREATED_DATE-(1/24), 'GMT', 'EDT'),'MM/DD/YYYY HH24:MI:SS'),'MM/DD/YYYY HH24:MI:SS')  AS CREATED_DATE,
            TO_DATE(TO_CHAR (NEW_TIME (TBL2.OPENED_DATE-(1/24), 'GMT', 'EDT'),'MM/DD/YYYY HH24:MI:SS'),'MM/DD/YYYY HH24:MI:SS')  AS OPENED_DATE,
            TO_DATE(TO_CHAR (NEW_TIME (TBL2.ACKNOWLEDGED-(1/24), 'GMT', 'EDT'),'MM/DD/YYYY HH24:MI:SS'),'MM/DD/YYYY HH24:MI:SS')  AS ACKNOWLEDGED,
            TO_DATE(TO_CHAR (NEW_TIME (TBL2.RESPONSE_COMPLETED-(1/24), 'GMT', 'EDT'),'MM/DD/YYYY HH24:MI:SS'),'MM/DD/YYYY HH24:MI:SS')  AS RESPONSE_COMPLETED,
            TO_DATE(TO_CHAR (NEW_TIME (TBL2.WORK_STARTED-(1/24), 'GMT', 'EDT'),'MM/DD/YYYY HH24:MI:SS'),'MM/DD/YYYY HH24:MI:SS')  AS WORK_STARTED,
            TO_DATE(TO_CHAR (NEW_TIME (TBL2.UPDATED_DATE-(1/24), 'GMT', 'EDT'),'MM/DD/YYYY HH24:MI:SS'),'MM/DD/YYYY HH24:MI:SS')  AS UPDATED_DATE,
            TO_DATE(TO_CHAR (NEW_TIME (TBL2.RESOLVED_DATE-(1/24), 'GMT', 'EDT'),'MM/DD/YYYY HH24:MI:SS'),'MM/DD/YYYY HH24:MI:SS')  AS RESOLVED_DATE,
            TO_CHAR(TBL2.OPENED_DATE,'MONTH') AS OPENED_M_CALC,
            TO_CHAR(TBL2.OPENED_DATE,'WW') AS OPENED_W_CALC,
            TBL2.BUSINESS_RESOLVED_DURATION/86400 AS BUS_MTTR_CALC,
            TBL2.CALENDAR_RESOLVED_DURATION/86400 AS CAL_MTTR_CALC,
            TBL1.LOCATION_NAME LOCATION_NUMBER,
            CMP.country, 
            CMP.state, 
            CMP.city, 
            CMP.street, 
            CMP.zip
    FROM T_FCT_0013_SN_INCIDENT TBL1
    INNER JOIN T_DM_SNOW_INCIDENT TBL2 
     ON TBL1.INCIDENT_NUMBER = TBL2.SNUMBER
    INNER JOIN T_DIM_LOCATION TBL3 
     ON TBL1.LOCATION_SK = TBL3.LOCATION_SK
    LEFT JOIN IAAS.TASK TSK
     ON TSK.snumber = TBL2.Snumber
    LEFT JOIN IAAS.CORE_COMPANY cmp
     ON tsk.COMPANY = cmp.SYS_ID  
) GRL
WHERE GRL.COMPANY LIKE ('%%')
 AND GRL.CREATED_DATE BETWEEN TO_DATE('2018-02-01','yyyy/mm/dd') AND  TO_DATE ('2019-02-28','yyyy/mm/dd')+1