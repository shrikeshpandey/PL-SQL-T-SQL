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
SELECT det_snumber,
       company,
       resolved_by,
       response_date,
       TO_CHAR(response_date, 'iw') Worked_Week,
       configuration_item,
       SUM (speed_to_request)   speed_to_request,
       SUM (contact_manager)    contact_manager,
       SUM (professionalism)    professsionalism,
       SUM (overall_opinion)    overall_opinion,
       SUM (Effectiveness)      Effectiveness,
       SUM (Technical_Competency) Technical_Competency,
       SUM (Net_Promoter_Score) Net_Promoter_Score,
       head_comments,
       country, 
       state, 
       city, 
       street, 
       zip
FROM 
(SELECT TBL1.DET_SNUMBER, 
        TBL5.RESOLVED_BY, 
        TBL1.DET_SURVEYRESPONSE_DT RESPONSE_DATE, 
        TBL5.CONFIGURATION_ITEM,
        TBL5.COMPANY,
        NVL (CASE WHEN STBL1.DET_SUMMARY = 'SPD,Speed To Request' THEN MAX (STBL1.DET_NUMERIC_RESPONSE) END, 0) AS Speed_To_Request,
        NVL (CASE WHEN STBL1.DET_SUMMARY = 'MGR,Contact Manager' THEN MAX (STBL1.DET_NUMERIC_RESPONSE) END, 0) AS Contact_Manager,
        NVL (CASE WHEN STBL1.DET_SUMMARY = 'PRO,Professionalism' THEN MAX (STBL1.DET_NUMERIC_RESPONSE) END, 0) AS Professionalism,
        NVL (CASE WHEN STBL1.DET_SUMMARY = 'OST,Overall Opinion' THEN MAX (STBL1.DET_NUMERIC_RESPONSE) END, 0) AS Overall_Opinion,
        NVL (CASE WHEN STBL1.DET_SUMMARY = 'EFF,Effectiveness' THEN MAX (STBL1.DET_NUMERIC_RESPONSE) END, 0) AS Effectiveness,
        NVL (CASE WHEN STBL1.DET_SUMMARY = 'TCH,Technical Competency' THEN MAX (STBL1.DET_NUMERIC_RESPONSE) END, 0) AS Technical_Competency,
        NVL (CASE WHEN STBL1.DET_SUMMARY = 'NPS,Net Promoter Score' THEN MAX (STBL1.DET_NUMERIC_RESPONSE) END, 0) AS Net_Promoter_Score,
        TBL3.HEAD_COMMENTS,
        CMP.country, 
        CMP.state, 
        CMP.city, 
        CMP.street, 
        CMP.zip
  FROM DW.T_FCT_0019_SURVEY_DETAIL TBL1
  JOIN DW.T_FCT_0013_SN_INCIDENT TBL2 
   ON TBL1.DET_SNUMBER = TBL2.INCIDENT_NUMBER
  JOIN DW.T_FCT_0018_SURVEY_HEADER TBL3 
   ON TBL1.DET_TICKET_ID = TBL3.HEAD_TICKET_ID
  JOIN DW.T_DIM_DATE TBL4 
   ON TBL1.DET_DT_SK = TBL4.DT_SK
  JOIN DW.T_DM_SNOW_INCIDENT TBL5 
   ON TBL1.DET_SNUMBER = TBL5.SNUMBER
  JOIN (SELECT DISTINCT STBL1.DET_NUMERIC_RESPONSE, 
               DET_SNUMBER, 
               DET_SUMMARY
       FROM DW.T_FCT_0019_SURVEY_DETAIL STBL1 
       WHERE DET_SUMMARY IN ('SPD,Speed To Request','MGR,Contact Manager','PRO,Professionalism','OST,Overall Opinion','EFF,Effectiveness','TCH,Technical Competency','NPS,Net Promoter Score')) STBL1 
   ON STBL1.DET_SNUMBER = TBL1.DET_SNUMBER
  LEFT JOIN IAAS.TASK TSK
   ON TSK.snumber = TBL5.Snumber
  LEFT JOIN IAAS.CORE_COMPANY cmp
   ON tsk.COMPANY = cmp.SYS_ID  
  WHERE TBL5.COMPANY  LIKE ('%%')
  GROUP BY TBL1.det_snumber,
           TBL5.COMPANY,
           STBL1.DET_SUMMARY,
           resolved_by,
           DET_SURVEYRESPONSE_DT,
           configuration_item,
           head_comments,
           CMP.country, 
           CMP.state, 
           CMP.city, 
           CMP.street, 
           CMP.zip
  )
GROUP BY det_snumber,
         company,
         resolved_by,
         response_date,
         configuration_item,
         head_comments,
         country, 
         state, 
         city, 
         street, 
         zip
ORDER BY response_date ASC, det_snumber ASC
