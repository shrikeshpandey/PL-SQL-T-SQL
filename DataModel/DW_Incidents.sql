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
--Incidents
SELECT    sn.snumber, 
          sn.company, 
          sn.short_description, 
          sn.close_notes, 
          sn.description, 
          sn.contact_type, 
          sn.category, 
          sn.incident_state, 
          sn.state, 
          cast((from_tz(cast(sn.created_date AS timestamp),'UTC') AT               TIME zone 'US/Central') AS DATE) created_date,
          cast((from_tz(cast(sn.acknowledged AS timestamp),'UTC') AT               TIME zone 'US/Central') AS DATE) acknowledged,
          cast((from_tz(cast(sn.resolved_date AS timestamp),'UTC') AT              TIME zone 'US/Central') AS DATE) resolved_date,
          cast((from_tz(cast(sn.closed_date AS timestamp),'UTC') AT                TIME zone 'US/Central') AS DATE) closed_date,
          cast((from_tz(cast(sn.updated_date AS timestamp),'UTC') AT               TIME zone 'US/Central') AS DATE) updated_date,
          cast((from_tz(cast(sn.opened_date AS timestamp),'UTC') AT                TIME zone 'US/Central') AS DATE) opened_date,
          cast((from_tz(cast(ft.work_started_on AS timestamp),'UTC') AT            TIME zone 'US/Central') AS DATE) work_started,
          cast((from_tz(cast(agh.current_group_change_dt AS timestamp),'UTC') AT   TIME zone 'US/Central') AS DATE) current_group_dt,
          cast((from_tz(cast(sn.response_completed AS timestamp),'UTC') AT         TIME zone 'US/Central') AS DATE) response_completed,
          cast((from_tz(cast(sn.negotiated_resolution_date AS timestamp),'UTC') AT TIME zone 'US/Central') AS DATE) negotiated_resolution_date,
          sn.priority, 
          sn.severity, 
          sn.impact, 
          sn.urgency, 
          sn.caller, 
          cll.manager_name    callers_mngr, 
          cll.department_name callers_department, 
          cll.user_id         caller_user_id, 
          cll.u_flex_field_2  region, 
          sn.location, 
          lc.street, 
          lc.city, 
          lc.state loc_state, 
          lc.country, 
          sn.opened_by, 
          sn.opened_by_user_id, 
          sn.created_by, 
          sn.assignment_group, 
          sn.assignment_group_parent, 
          sn.assigned_to, 
          gr.level_num, 
          gr.manager_name, 
          sn.resolved_by_group, 
          sn.resolved_by, 
          sn.resolved_by_user_id, 
          sn.updated_by, 
          sn.closed_by, 
          sn.created_by_group, 
          sn.configuration_item, 
          sn.configuration_item_class, 
          sn.sub_category, 
          sn.support_function, 
          sn.support_function_bundle, 
          sn.parent_inc, 
          sn.is_parent, 
          sn.major_incident, 
          sn.rfc, 
          sn.problem_id, 
          sn.action, 
          sn.supportable, 
          sn.service_desk_resolvable, 
          sn.resolvable, 
          sn.resolvable_level, 
          sn.support_level, 
          sn.hd_worked sd_worked, 
          sn.resolved_first_contact, 
          sn.sla_contract, 
          sn.calendar_seconds_to_resolve, 
          sn.business_seconds_to_resolve, 
          sn.calendar_seconds_to_response, 
          sn.business_seconds_to_response, 
          sn.business_resolved_duration, 
          sn.calendar_resolved_duration, 
          sn.resolution_code, 
          sn.resolution_number, 
          sn.resolution, 
          sn.resolution_type, 
          sn.correlation_id, 
          sn.tech_name, 
          sn.cti, 
          sn.caused_by_change, 
          sn.stopwatch_seconds_to_resolve, 
          sn.vip, 
          sn.quick_code, 
          sn.rim_number, 
          sn.flex_field_1, 
          sn.flex_field_2, 
          sn.flex_field_3, 
          sn.flex_field_4, 
          sn.u_flex_field_5, 
          kb.knowledge_article kba, 
          sn.knowledge, 
          sn.knowledge_article,( 
          CASE 
                    WHEN sn.incident_state IN ('Resolved', 
                                               'Closed') THEN (0) 
                    ELSE (cast((current_date-cast((from_tz(cast(sn.updated_date AS timestamp),'UTC') AT TIME zone 'US/Central') AS DATE)) AS INTEGER))
          END) days_from_update,( 
          CASE 
                    WHEN sn.incident_state IN('Resolved', 
                                              'Closed') THEN (cast ((sn.resolved_date - sn.created_date) AS INTEGER))
                    ELSE (cast((SYSDATE                                               -cast((from_tz(cast(sn.created_date AS timestamp),'UTC') AT TIME zone 'US/Central') AS DATE)) AS INTEGER))
          END)                                                         days_opened, 
          trunc(sn.business_seconds_to_resolve/86400)                  business_days_open, 
          cast(sn.calendar_seconds_to_resolve /86400 AS NUMBER(15,6))  cal_mttr, 
          cast(sn.business_seconds_to_resolve /86400 AS NUMBER (15,5)) bus_mttr, ( 
          CASE 
                    WHEN sn.rework_count='0' THEN 'FALSE' 
                    ELSE 'TRUE' 
          END) rework, 
          sn.rework_count, ( 
          CASE 
                    WHEN sn.reassignment_count >=3 THEN 'TRUE' 
                    ELSE 'FALSE' 
          END) reassigned, 
          sn.reassignment_count, 
          sn.hold_count, 
          sn.escalation_count, 
          sn.updates, 
          trunc(add_months(last_day(cast((from_tz(cast(sn.created_date AS timestamp),'UTC') AT TIME zone 'US/Central') AS DATE))+1,-1))month_created,
          to_char(cast((from_tz(cast(sn.created_date AS timestamp),'UTC') AT TIME zone 'US/Central') AS DATE),'Day')                   weekday,
          to_number(to_char(cast((from_tz(cast(sn.created_date AS timestamp),'UTC') AT TIME zone 'US/Central') AS DATE),'IW'))         created_week, (
          CASE 
                    WHEN sn.resolved_date IS NOT NULL THEN trunc(add_months(last_day(cast((from_tz(cast(sn.resolved_date AS timestamp),'UTC') AT TIME zone 'US/Central') AS DATE))+1,-1))
          END) month_resolved, ( 
          CASE 
                    WHEN sn.opened_by = sn.resolved_by THEN 'TRUE' 
                    ELSE 'FALSE' 
          END)            resolved_by_created, 
          ft.customer_num ext_correlation_id,
          CMP.country, 
          CMP.state, 
          CMP.city, 
          CMP.street, 
          CMP.zip 
FROM      dw.t_dm_snow_incident sn 
left join dw.t_fct_0013_sn_incident ft 
ON        sn.snumber = ft.incident_number
LEFT JOIN IAAS.TASK TSK
ON TSK.snumber = sn.Snumber
LEFT JOIN IAAS.CORE_COMPANY cmp
ON tsk.COMPANY = cmp.SYS_ID  
left join dw.t_dim_group gr 
ON        ft.assigned_to_group_sk=gr.group_sk 
left join dw.t_dim_caller cll 
ON        cll.caller_sk = ft.caller_sk 
left join 
          ( 
                   SELECT   tmp.incident_no inc, 
                            tmp.current_group_change_dt, 
                            row_number() over (PARTITION BY tmp.incident_no ORDER BY tmp.current_group_change_dt DESC) sk
                   FROM     dw.t_fct_0213_incident_group_hist tmp) agh 
ON        agh.inc=sn.snumber 
AND       agh.sk = 1 
left join dw.t_dim_location lc 
ON        ft.location_sk = lc.location_sk 
left join dw.t_dim_know_article kb 
ON        kb.know_article_sk = ft.know_article_sk 
WHERE     ( 
                    sn.created_date>SYSDATE-420 
          OR        sn.resolved_date>SYSDATE-420 
          OR        sn.resolved_date IS NULL) 
AND       sn.company IN ('GameStop, Inc', 
                         'CVS', 
                         '7-Eleven');