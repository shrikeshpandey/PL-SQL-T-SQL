/*************************************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           10/26/2019
||   Category:       SQL Change
||
||   Description:    Change SQL
||   Parameters:     None
||
||   Historic Info:
||   Name:              Date:         Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes       10/26/2019    Commithing the inial query
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***************************************************************************************************/
SELECT w.*, (w.admin + w.travel + w.work) AS tottime
  FROM (
  SELECT z.F_CASE_TYPE,
         z.F_CASE_ID,
         z.SUB_CASE_ID,
         z.F_TECH_CREATOR_USER_ID,
         z.F_CASE_STATE,
         z.CREATED_DT,
         z.F_TECH_OWNER_USER_ID,
         z.F_CASE_STATUS,
         z.F_CASE_SEVERITY,
         z.F_CASE_PRIORITY,
         z.F_CASE_CONTACT_FIRST_NAME,
         z.F_CASE_CONTACT_LAST_NAME,
         z.F_CASE_CONTACT_PHONE,
         z.F_CUST_SITE_ADDRESS_1,
         z.F_CUST_SITE_CITY,
         z.F_CUST_SITE_STATE,
         z.F_CUST_SITE_ZIP,
         z.F_CUST_STORE_ID,
         z.F_CUST_SITE_NAME,
         z.F_CUST_CORP_NAME,
         z.F_CASE_TITLE,
         z.F_EQUIP_MODEL,
         z.F_CASE_PROBLEM_CODE_1,
         z.F_CASE_PROBLEM_CODE_2,
         z.F_CASE_PROBLEM_CODE_3,
         z.F_CASE_PROBLEM_CODE_4,
         z.F_CASE_PROBLEM_CODE_5,
         z.F_CUST_FLEX_1,
         z.F_CUST_FLEX_2,
         z.F_CUST_FLEX_3,
         z.F_CUST_FLEX_4,
         z.F_CUST_REFERENCE_ID,
         z.F_3RDP_REFERENCE_ID,
         z.F_CASE_QUEUE,
         z.CLOSED_DT,
         z.F_CASE_RESOLUTION_DESC,
         z.F_TECH_DISPATCHED_FIRST_NAME,
         z.F_TECH_DISPATCHED_LAST_NAME,
         z.F_CUST_FLEX_TAG_1,
         z.F_CUST_FLEX_TAG_2,
         z.F_CUST_FLEX_TAG_3,
         z.F_CUST_FLEX_TAG_4,
         z.F_CASE_TAG5,
         z.F_CASE_TAG6,
         z.F_CASE_TAG7,
         z.F_CASE_TAG8,
         z.X_SITE_TAG1,
         z.X_SITE_TAG2,
         z.X_SITE_TAG3,
         z.X_SITE_TAG4,
         z.X_SITE_TAG5,
         z.F_CTR_CONTRACT_TITLE,
         z.F_CTR_SITE_SCHED_ID,
         z.PO,
         z.X_IS_BILLED,
         z.X_SERVICE_TYPE,
         z.X_CUST_ENT_CODE,
         z.SCHEDULE_TYPE,
         z.BILLEXTPRICE,
         z.F_CUST_CORP_ID,
         z.F_BUSORG_FLEX1,
         z.F_BUSORG_FLEX2,
         z.F_BUSORG_FLEX3,
         z.F_BUSORG_FLEX4,
         z.F_BUSORG_FLEXDATE1,
         z.F_BUSORG_FLEXDATE2,
         z.F_BUSORG_FLEXDATE3,
         z.F_BUSORG_FLEXDATE4,
         z.F_CASE_CONTACT_FLEX_1,
         z.F_CASE_CONTACT_FLEX_2,
         z.F_CASE_CONTACT_FLEX_3,
         z.F_CASE_CONTACT_FLEX_4,
         z.F_SYMPTOM_CODE,
         z.DEOPT_SERVICE,
         z.PROJECT_ACCT,
         z.PROJECT_DESC,
         z.X_PROJECT_ID,
         z.F_EQUIP_SERIAL_NMBR,
         z.F_EQUIP_MODEL_DESC,
         z.X_GEO_CODE,
         z.F_LINE_BUS,
         DECODE(z.NUM_SUB_CASES, 0, z.admin, (z.admin/z.NUM_SUB_CASES)) AS admin,
         DECODE(z.NUM_SUB_CASES, 0, z.travel, (z.travel/z.NUM_SUB_CASES)) AS travel,
         DECODE(z.NUM_SUB_CASES, 0, z.work, (z.work/z.NUM_SUB_CASES)) AS work
    FROM (select o.f_case_type,
                 o.f_case_id,
                 sc.id_number AS sub_case_id,
                 o.f_tech_creator_user_id,
                 o.f_case_state,
                 to_char(o.f_case_created_dt, 'DD-MON-YYYY HH24:MI') as created_dt,
                 o.f_tech_owner_user_id,
                 o.f_case_status,
                 o.f_case_severity,
                 o.f_case_priority,
                 o.f_case_contact_first_name,
                 o.f_case_contact_last_name,
                 o.f_case_contact_phone,
                 o.f_cust_site_address_1,
                 o.f_cust_site_city,
                 o.f_cust_site_state,
                 o.f_cust_site_zip,
                 o.f_cust_store_id,
                 o.f_cust_site_name,
                 o.f_cust_corp_name,
                 o.f_case_title,
                 o.f_equip_model,
                 o.f_case_problem_code_1,
                 o.f_case_problem_code_2,
                 o.f_case_problem_code_3,
                 o.f_case_problem_code_4,
                 o.f_case_problem_code_5,
                 o.f_cust_flex_1,
                 o.f_cust_flex_2,
                 o.f_cust_flex_3,
                 o.f_cust_flex_4,
                 o.f_cust_reference_id,
                 o.f_3rdp_reference_id,
                 o.f_case_queue,
                 to_char(o.f_case_closed_dt, 'DD-MON-YYYY HH24:MI') as closed_dt,
                 o.f_case_resolution_desc,
                 o.f_tech_dispatched_first_name,
                 o.f_tech_dispatched_last_name,
                 o.f_cust_flex_tag_1,
                 o.f_cust_flex_tag_2,
                 o.f_cust_flex_tag_3,
                 o.f_cust_flex_tag_4,
                 o.f_case_tag5,
                 o.f_case_tag6,
                 o.f_case_tag7,
                 o.f_case_tag8,
                 s.x_site_tag1,
                 s.x_site_tag2,
                 s.x_site_tag3,
                 s.x_site_tag4,
                 s.x_site_tag5,
                 o.f_ctr_contract_title,
                 o.f_ctr_site_sched_id,
                 ' ' as po,
                 c.x_is_billed,
                 o.x_service_type,
                 o.x_cust_ent_code,
                 ' ' as schedule_type,
                 ' ' as billextprice,
                 o.f_cust_corp_id,
                 o.f_busorg_flex1,
                 o.f_busorg_flex2,
                 o.f_busorg_flex3,
                 o.f_busorg_flex4,
                 o.f_busorg_flexdate1,
                 o.f_busorg_flexdate2,
                 o.f_busorg_flexdate3,
                 o.f_busorg_flexdate4,
                 o.f_case_contact_flex_1,
                 o.f_case_contact_flex_2,
                 o.f_case_contact_flex_3,
                 o.f_case_contact_flex_4,
                 o.f_symptom_code,
                 ' ' as deopt_service,
                 ' ' as project_acct,
                 ' ' as project_desc,
                 o.x_project_id,
                 o.f_equip_serial_nmbr,
                 o.f_equip_model_desc,
                 c.x_geo_code,
                 NVL((select min(substr(e.x_duration,
                                       instr(e.x_duration, '/') + 1,
                                       4))
                       from t_clar_part_num                px1,
                            T_CLAR_HGBST_ELM               e,
                            T_CLAR_MTM_HGBSTELM0HGBSTSHOW1 m,
                            t_clar_hgbst_show              s,
                            T_CLAR_HGBST_LST               l
                      Where px1.s_part_number = o.F_CTR_SITE_SPT_PROG
                        AND px1.s_domain = 'SUPPORT PROGRAMS'
                        and px1.x_business_region = e.ref_id
                        and e.state = 'Active'
                        and e.objid = m.hgbst_elm2hgbst_show
                        AND m.HGBST_SHOW2HGBST_ELM = s.objid
                        and s.objid = l.HGBST_LST2HGBST_SHOW
                        and l.title = 'x_Business_Region'),
                     ' ') as f_line_bus,
                 NVL((select SUM(round(duration / 3600, 2))
                       from t_clar_onsite_log o, t_clar_time_log t
                      where o.CASE_ONSITE2CASE = f_case_key
                        and o.objid = t.TIME2ONSITE_LOG
                        and t.time_type = 'Admin'),
                     0) as admin,
                 NVL((select SUM(round(duration / 3600, 2))
                       from t_clar_onsite_log o, t_clar_time_log t
                      where o.CASE_ONSITE2CASE = f_case_key
                        and o.objid = t.TIME2ONSITE_LOG
                        and t.time_type = 'Travel'),
                     0) as travel,
                 NVL((select sum(round(duration / 3600, 2))
                       from t_clar_onsite_log o, t_clar_time_log t
                      where o.CASE_ONSITE2CASE = f_case_key
                        and o.objid = t.TIME2ONSITE_LOG
                        and t.time_type = 'Work'),
                     0) as work,
                 NVL((SELECT COUNT(*)
                       FROM t_clar_ods_case o1,
                            t_clar_employee e1,
                            t_clar_case     c1,
                            t_clar_site     s1,
                            t_clar_subcase  sc1
                      WHERE o1.f_case_key = o.f_case_key
                        AND o.f_case_closed_dt >= trunc(trunc(sysdate, 'MM') - 1, 'MM')
                        AND o.f_case_closed_dt < trunc(sysdate, 'MM')
                        and o1.f_tech_dispatched_empl_key = e1.objid
                        and e1.x_job_function = 'Third Party'
                        and o1.f_case_key = c1.objid
                        and o1.f_cust_site_key = s1.objid
                        and o1.f_case_key = sc1.subcase2case(+)),
                     0) AS NUM_SUB_CASES
            FROM t_clar_ods_case o, t_clar_employee e, t_clar_case c, t_clar_site s, t_clar_subcase sc
           WHERE o.f_case_closed_dt >= trunc(trunc(sysdate, 'MM') - 1, 'MM')
             AND o.f_case_closed_dt < trunc(sysdate, 'MM')
             and o.f_tech_dispatched_empl_key = e.objid
             and e.x_job_function = 'Third Party'
             and o.f_case_key = c.objid
             and o.f_cust_site_key = s.objid
             and o.f_case_key = sc.subcase2case(+)
          ) z 
) w;