

select o.f_case_type, o.f_case_id, o.f_tech_creator_user_id, o.f_case_state, 
       to_char(o.f_case_created_dt, 'DD-MON-YYYY HH24:MI') as created_dt, o.f_tech_owner_user_id,
       o.f_case_status, o.f_case_severity, o.f_case_priority, o.f_case_contact_first_name, o.f_case_contact_last_name,
       o.f_case_contact_phone, o.f_cust_site_address_1, o.f_cust_site_city, o.f_cust_site_state,o.f_cust_site_zip,
       o.f_cust_store_id, o.f_cust_site_name, o.f_cust_corp_name, o.f_case_title, o.f_equip_model,
       o.f_case_problem_code_1, o.f_case_problem_code_2, o.f_case_problem_code_3, o.f_case_problem_code_4,
       o.f_case_problem_code_5, o.f_cust_flex_1, o.f_cust_flex_2, o.f_cust_flex_3, o.f_cust_flex_4,
       o.f_cust_reference_id, o.f_3rdp_reference_id, o.f_case_queue, 
       to_char(o.f_case_closed_dt, 'DD-MON-YYYY HH24:MI') as closed_dt, o.f_case_resolution_desc,
       o.f_tech_dispatched_first_name, o.f_tech_dispatched_last_name, o.f_cust_flex_tag_1,
       o.f_cust_flex_tag_2, o.f_cust_flex_tag_3, o.f_cust_flex_tag_4, o.f_case_tag5, o.f_case_tag6,
       o.f_case_tag7, o.f_case_tag8, s.x_site_tag1, s.x_site_tag2, s.x_site_tag3, s.x_site_tag4,
       s.x_site_tag5, o.f_ctr_contract_title, o.f_ctr_site_sched_id, ' ' as po, c.x_is_billed,
       o.x_service_type, o.x_cust_ent_code, ' ' as schedule_type, ' ' as billextprice,
       o.f_cust_corp_id, o.f_busorg_flex1, o.f_busorg_flex2, o.f_busorg_flex3,
       o.f_busorg_flex4, o.f_busorg_flexdate1, o.f_busorg_flexdate2, o.f_busorg_flexdate3,
       o.f_busorg_flexdate4, o.f_case_contact_flex_1, o.f_case_contact_flex_2, o.f_case_contact_flex_3,
       o.f_case_contact_flex_4, o.f_symptom_code, ' ' as deopt_service, ' ' as project_acct, ' ' as project_desc,
       o.x_project_id, o.f_equip_model, o.f_equip_serial_nmbr, o.f_equip_model_desc,
       c.x_geo_code, 
       NVL((select min(substr(e.x_duration, instr(e.x_duration, '/') + 1, 4)) 
            from t_clar_part_num px1, T_CLAR_HGBST_ELM e, T_CLAR_MTM_HGBSTELM0HGBSTSHOW1 m, t_clar_hgbst_show s, T_CLAR_HGBST_LST l 
            Where px1.s_part_number = o.F_CTR_SITE_SPT_PROG 
            AND px1.s_domain = 'SUPPORT PROGRAMS' 
            and px1.x_business_region = e.ref_id 
            and e.state = 'Active' 
            and e.objid = m.hgbst_elm2hgbst_show 
            AND m.HGBST_SHOW2HGBST_ELM = s.objid 
            and s.objid = l.HGBST_LST2HGBST_SHOW  
            and l.title = 'x_Business_Region'), ' ') as f_line_bus, 
       NVL((select sum(round(duration / 3600, 2)) 
            from t_clar_onsite_log o, t_clar_time_log t 
            where o.CASE_ONSITE2CASE = f_case_key
            and o.objid = t.TIME2ONSITE_LOG 
            and t.time_type = 'Admin'), 0) as admin,
       NVL((select sum(round(duration / 3600, 2)) 
            from t_clar_onsite_log o, t_clar_time_log t
            where o.CASE_ONSITE2CASE = f_case_key
            and o.objid = t.TIME2ONSITE_LOG
            and t.time_type = 'Travel'), 0) as travel,
       NVL((select sum(round(duration / 3600, 2)) 
            from t_clar_onsite_log o, t_clar_time_log t 
            where o.CASE_ONSITE2CASE = f_case_key 
            and o.objid = t.TIME2ONSITE_LOG 
            and t.time_type = 'Work'), 0) as work,
       NVL((select sum(round(duration / 3600, 2)) 
            from t_clar_onsite_log o, t_clar_time_log t 
            where o.CASE_ONSITE2CASE = f_case_key 
            and o.objid = t.TIME2ONSITE_LOG 
            and t.time_type in ('Admin', 'Travel', 'Work')), 0) as tottime 
FROM t_clar_ods_case o, t_clar_employee e, t_clar_case c, t_clar_site s
WHERE o.f_case_closed_dt >= trunc(sysdate, 'MM')
AND o.f_case_closed_dt < sysdate
AND o.f_tech_dispatched_empl_key = e.objid
and e.x_job_function = 'Third Party'
and o.f_case_key = c.objid
and o.f_cust_site_key = s.objid


SELECT * 
FROM t_clar_ods_case o
where o.f_case_closed_dt >= trunc(sysdate, 'MM')



--SELECT trunc(trunc(sysdate, 'MM') - 1, 'MM'), trunc(sysdate, 'MM') FROM dual 