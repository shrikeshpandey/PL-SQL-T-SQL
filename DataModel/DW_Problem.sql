/***********************************************************************************
   ||   PROCEDURE INFORMATION
   ||
   ||   Department:     Value Engineering
   ||   Creator:        Luis Fuentes
   ||   Date:           05/09/2019
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
   ||    Luis Fuentes        05/09/2019   Initial Creation
   ||   -----------------------------------------------------------------------------
   ||
   ||   CURRENT REVISION STANDARD:  v1.50
   ||
   ***********************************************************************************/
/*******************************************************************************************
*  Generated using sp_gen_bulk() jg 2006
*******************************************************************************************/
--Problems section
SELECT PRB.snumber, 
       PRB.company, 
       PRB.short_description, 
       PRB.description, 
       PRB.category, 
       RCA.u_root_cause_summary            ROOT_CAUSE_SUMMARY, 
       RCA.u_workaround                    RCA_WORKAROUND, 
       RCA.u_contributing_factors          CONTRIBUTING_FACTORS, 
       RCA.u_corrective_action             CORRECTIVE_ACTION, 
       RCA.u_preventative_action           PREVENTATIVE_ACTION, 
       Cast(( From_tz(Cast(PRB.opened_date AS TIMESTAMP), 'UTC') AT TIME zone 
              'US/Central' ) 
            AS DATE)                       OPENED_DATE, 
       Cast(( From_tz(Cast(PRB.closed_date AS TIMESTAMP), 'UTC') AT TIME zone 
              'US/Central' ) 
            AS DATE)                       CLOSED_DATE, 
       Cast(( From_tz(Cast(PRB.updated_date AS TIMESTAMP), 'UTC') AT TIME zone 
              'US/Central' 
            ) AS DATE)                     UPDATED_DATE, 
       Cast(( From_tz(Cast(PRB.root_cause_begin AS TIMESTAMP), 'UTC') AT TIME 
              zone 
                   'US/Central' ) AS DATE) ROOT_CAUSE_BEGIN, 
       Cast(( From_tz(Cast(PRB.known_error_date AS TIMESTAMP), 'UTC') AT TIME 
              zone 
                   'US/Central' ) AS DATE) KNOWN_ERROR_DATE, 
       PRB.assignment_group, 
       PRB.assigned_to, 
       PRB.comments, 
       PRB.configuration_item, 
       PRB.state, 
       PRB.priority, 
       PRB.impact, 
       PRB.rfc,
       CMP.country, 
       CMP.state, 
       CMP.city, 
       CMP.street, 
       CMP.zip  
FROM   dw.t_dm_snow_problem PRB 
left join iaas.u_rca RCA 
 ON RCA.u_problem = PRB.sys_id
LEFT JOIN IAAS.TASK TSK
 ON TSK.snumber = PRB.Snumber
LEFT JOIN IAAS.CORE_COMPANY cmp
 ON tsk.COMPANY = cmp.SYS_ID  
WHERE  PRB.company IN ( 'GameStop, Inc', 'CVS', '7-Eleven' ); 