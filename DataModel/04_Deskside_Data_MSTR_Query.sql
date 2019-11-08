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

SELECT
    a177.case_id case_id,
    a177.close_month close_month,
    a177.admin_hours admin_hours,
    a177.bot_opportunity bot_opportunity,
    a177.busorg_flex3 busorg_flex3,
    a177.call_category call_category,
    a177.call_count call_count,
    a177.cancel_duplicate cancel_duplicate,
    a177.client_name client_name,
    a177.closed_date closed_date,
    a177.contract_title contract_title,
    a177.corp_id corp_id,
    a177.corp_name corp_name,
    a177.created_date created_date,
    a177.dispatch_avoided dispatch_avoided,
    a177.dispatch_avoided_1_5 dispatch_avoided_1_5,
    a177.entitlement_code entitlement_code,
    a177.family family,
    a177.fri_weekending fri_weekending,
    a177.ftf ftf,
    a177.in_warranty in_warranty,
    a177.kb kb,
    a177.miles miles,
    a177.model_number model_number,
    a177.oem oem,
    a177.part_desc part_desc,
    a177.part_number part_number,
    a177.parts_doa parts_doa,
    a177.parts_gnu parts_gnu,
    a177.parts_ordered parts_ordered,
    a177.parts_received parts_received,
    a177.parts_used parts_used,
    a177.problem_code_1 problem_code_1,
    a177.problem_code_2 problem_code_2,
    a177.problem_code_3 problem_code_3,
    a177.problem_code_4 problem_code_4,
    a177.problem_code_5 problem_code_5,
    a177.problem_desc problem_desc,
    a177.product_line product_line,
    a177.repair_code repair_code,
    a177.repair_desc repair_desc,
    a177.repair_due_date repair_due_date,
    a177.resolution_desc resolution_desc,
    a177.rlf rlf,
    a177.rlmon rlmon,
    a177.rload rload,
    a177.rls rls,
    a177.schedule_id schedule_id,
    a177.serial_number serial_number,
    a177.service_type service_type,
    a177.f_cust_site_address_2,
    a177.site_service_city site_service_city,
    a177.site_support_program site_support_program,
    a177.store_id store_id,
    a177.tech_area_id tech_area_id,
    a177.tech_dept_id tech_dept_id,
    a177.tech_district_id tech_district_id,
    a177.tech_empl_id tech_empl_id,
    a177.tech_manager tech_manager,
    a177.resource_name resource_name,
    a177.tech_org tech_org,
    a177.tech_region_id tech_region_id,
    a177.tech_service_city tech_service_city,
    a177.tech_team tech_team,
    a177.tech_title tech_title,
    a177.tech_user_id tech_user_id,
    a177.total_hours total_hours,
    a177.travel_hours travel_hours,
    a177.travel_lines travel_lines,
    a177.triage_category triage_category,
    a177.warranty_parts warranty_parts,
    a177.work_hours work_hours,
    a177.work_lines work_lines,
    a177.customer_ref_number customer_ref_number,
    parts.detail_number,
    parts.x_action_type,
    parts.s_part_number,
    parts.s_description,
    parts.part_price,
   case
   when a177.f_project_date < '01jan1954' then null  else  a177.f_project_date end   as f_project_date,
    a177.f_project_id,
    a177.f_cust_site_country country, 
    a177.f_cust_site_state state, 
    a177.f_cust_site_city city, 
    a177.f_cust_site_address_1 address, 
    a177.f_cust_site_zip zip
FROM
    (
        SELECT
            h.f_case_id AS case_id,
            b.clndr_mo_year_shrt_desc AS close_month,
            b.fri_weekend_date AS fri_weekending,
            h.f_case_created_d AS created_date,
            h.f_case_closed_d AS closed_date,
            d.f_empl_name AS resource_name,
            d.f_tech_user_id AS tech_user_id,
            d.f_tech_empl_id AS tech_empl_id,
            h.f_tech_dispatched_tech_title AS tech_title,
            h.f_tech_dispatched_tech_org AS tech_org,
            h.f_tech_dispatched_district_id AS tech_district_id,
            h.f_tech_dispatched_mgr_name AS tech_manager,
            h.f_tech_dispatched_srvc_city AS tech_service_city,
            h.f_tech_dispatched_dept_id AS tech_dept_id,
            h.f_tech_dispatched_area_id AS tech_area_id,
            h.f_tech_dispatched_region_id AS tech_region_id,
            h.f_employee_team AS tech_team,
            g.f_top_account_name AS client_name,
            g.f_org_id AS corp_id,
            g.f_name AS corp_name,
            h.f_call_category AS call_category,
            j.f_service_type AS service_type,
            h.f_problem_desc AS problem_desc,
            t.f_case_resolution_desc AS resolution_desc,
            h.f_case_repair_desc AS repair_desc,
            v.f_case_repair_code AS repair_code,
            k.f_case_problem_code_1 AS problem_code_1,
            k.f_case_problem_code_2 AS problem_code_2,
            k.f_case_problem_code_3 AS problem_code_3,
            k.f_case_problem_code_4 AS problem_code_4,
            k.f_case_problem_code_5 AS problem_code_5,
            d.f_tech_srvc_city AS site_service_city,
            x.f_ctr_contract_title AS contract_title,
            y.f_ctr_sched_id AS schedule_id,
            z.f_ctr_spt_prog AS site_support_program,
            c.f_cust_ent_code AS entitlement_code,
            aa.f_part_number AS part_number,
            aa.f_model_number AS model_number,
            aa.f_part_description AS part_desc,
            h.f_equip_serial_nmbr AS serial_number,
            h.f_cust_reference_id AS customer_ref_number,
            aa.f_product_family AS family,
            aa.f_product_line AS product_line,
            aa.f_oem AS oem,
            bms.f_triage_category AS triage_category,
            h.f_mileage AS miles,
            a.f_close_ftf AS ftf,
            h.f_admin_duration / 3600 AS admin_hours,
            h.f_work_duration / 3600 AS work_hours,
            h.f_travel_duration / 3600 AS travel_hours,
            h.f_admin_duration / 3600 + h.f_work_duration / 3600 + h.f_travel_duration / 3600 AS total_hours,
                CASE
                    WHEN a.f_case_id IS NULL THEN 0
                    ELSE 1
                END
            AS call_count,
            h.f_subcase_work_count AS work_lines,
            h.f_subcase_travel_count AS travel_lines,
            bms.f_parts_ordered AS parts_ordered,
            bms.f_parts_received AS parts_received,
            bms.f_parts_used AS parts_used,
            bms.f_parts_gnu AS parts_gnu,
            bms.f_parts_doa AS parts_doa,
            nvl(
                TO_CHAR(h.f_sla_repair_sched_comp_dt,'MM/DD/YYYY HH:MI:SS AM'),
                ' '
            ) AS repair_due_date,
            h.f_cust_store_id AS store_id,
            bms.f_rload AS rload,
            bms.f_rlmon AS rlmon,
            bms.f_rls AS rls,
            bms.f_rlf AS rlf,
            bms.f_kb AS kb,
            bms.f_in_warranty AS in_warranty,
            bms.f_wty_parts AS warranty_parts,
            h.f_busorg_flex3 AS busorg_flex3,
            h.f_avoided AS dispatch_avoided,
            h.f_avoided_1_5 AS dispatch_avoided_1_5,
            h.f_bot_opportunity AS bot_opportunity,
                CASE
                    WHEN t.f_case_resolution_desc IN (
                        'CANCELLED','DUPLICATE CASE','CANCEL/WORK STARTED'
                    ) THEN 1
                    ELSE 0
                END
            AS cancel_duplicate,
            w.f_cust_site_address_2,
            h.f_project_date,
            h.f_project_id,
            w.f_cust_site_country, 
            w.f_cust_site_state, 
            w.f_cust_site_city, 
            w.f_cust_site_address_1, 
            w.f_cust_site_zip 
        FROM
            dw.t_fct_0050_case h
            INNER JOIN dw.t_dim_date b ON h.f_case_closed_d = b.day_dt
            LEFT JOIN dw.t_dim_svc_employee d ON h.f_tech_dispatched_user_sk = d.f_tech_sk
            INNER JOIN dw.t_dim_svc_city e ON d.f_tech_svc_city_sk = e.svc_city_sk
            LEFT JOIN dw.t_dim_svc_bus_org g ON h.f_bus_org_id = g.f_org_id
            INNER JOIN dw.t_dim_svc_service_type j ON h.f_service_type_sk = j.f_service_type_sk
            INNER JOIN dw.t_dim_svc_problem_code k ON h.f_case_problem_code_sk = k.f_case_problem_code_sk
            INNER JOIN dw.t_dim_svc_resolution t ON h.f_case_resolution_desc_sk = t.f_case_resolution_desc_sk
            INNER JOIN dw.t_dim_svc_repair v ON h.f_case_repair_code_sk = v.f_case_repair_code_sk
            INNER JOIN dw.t_dim_svc_site w ON h.f_cust_site_id_sk = w.f_cust_site_id_sk
            INNER JOIN dw.t_dim_svc_contract x ON h.f_ctr_contract_key_sk = x.f_ctr_contract_key_sk
            INNER JOIN dw.t_dim_svc_sched_id y ON h.f_ctr_site_sched_id_sk = y.f_ctr_sched_id_sk
            INNER JOIN dw.t_dim_svc_spt_prog z ON h.f_ctr_site_spt_prog_sk = z.f_ctr_spt_prog_sk
            INNER JOIN dw.t_dim_svc_cust_ent c ON h.f_cust_ent_sk = c.f_cust_ent_sk
            INNER JOIN dw.t_dim_svc_part aa ON h.f_equip_model_sk = aa.f_equip_model_sk
            LEFT JOIN dw.t_dm_svc_fs_detail a ON
                a.f_case_key = h.f_case_sk
            AND
                a.f_source_type = 'CLOSED_CALLS'
            LEFT JOIN dw.t_bsm_case_data bms ON h.f_case_sk = bms.f_case_key
    ) a177
    LEFT JOIN (
        SELECT
            dw.t_clar_ods_case.f_case_created_d,
            dw.t_clar_ods_case.f_case_id,
            dw.t_clar_ods_case.f_cust_corp_id,
            dw.t_clar_demand_dtl.detail_number,
            dw.t_clar_demand_dtl.request_status,
            dw.t_clar_demand_dtl.x_action_type,
            dw.t_clar_part_num.s_part_number,
            dw.t_clar_part_num.s_description,
            dw.t_clar_demand_dtl.part_price
        FROM
            dw.t_clar_ods_case,
            dw.t_clar_demand_hdr,
            dw.t_clar_demand_dtl,
            dw.t_clar_mod_level,
            dw.t_clar_part_num
        WHERE
                dw.t_clar_ods_case.f_case_id = dw.t_clar_demand_hdr.header_case_no
            AND
                dw.t_clar_demand_dtl.demand_dtl2demand_hdr = dw.t_clar_demand_hdr.objid
            AND
                dw.t_clar_demand_dtl.demand_dtl2part_info = dw.t_clar_mod_level.objid
            AND
                dw.t_clar_mod_level.part_info2part_num = dw.t_clar_part_num.objid
    ) parts ON a177.case_id = parts.f_case_id
WHERE
    a177.call_category IN (
     'Annuity',
    'Projects',
    'IMAC'
        )
    AND
        a177.call_count IN (
            1
        )
    AND
        a177.client_name IN (
            ''
        )
    AND
        a177.closed_date BETWEEN TO_DATE('01-01-2019','dd-mm-yyyy') AND TO_DATE(sysdate,'dd-mm-yyyy');