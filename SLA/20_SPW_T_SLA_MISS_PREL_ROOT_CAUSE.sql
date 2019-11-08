CREATE OR REPLACE PROCEDURE DW.SPW_T_SLA_MISS_PREL_ROOT_CAUSE (
  iCommit   IN INTEGER DEFAULT 2000
) is
/*************************************************************************************************
||   QUERY INFORMATION
||
||   Department:     Value Engineering
||   Programmer:     Luis Fuentes
||   Date:           09/16/2019
||   Category:       SQL Tuning 
||   Description:    This query delivers information about the technicians and SLA
||
||   Parameters:     None
||
||   Historic Info:
||   Name:           Date:         Brief Description:
||   ----------------------------------------------------------------------------------------------
||   Luis Fuentes    01/16/2019    Initial creation
||   Luis Fuentes    09/16/2019    Applying Tuning DO NOT DELETE COMMENTS SINCE IT IS FORCING THE DB ENGINE
||   ----------------------------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***************************************************************************************************/
--Data to be inserted into DW.SLA_MISS_PREL_ROOT_CAUSE
CURSOR c IS
SELECT * 
FROM (
  WITH 
  T_CLAR_ODS_CASE_TUNE AS ( 
    SELECT o.f_case_key,
          o.f_cust_corp_id,
          o.f_cust_corp_name,
          o.f_case_id,
          o.f_case_closed_dt, 
          o.f_sla_repair_sched_comp_dt,
          o.f_ttt_target,
          o.f_case_resolution_desc,
          o.f_case_severity,
          o.f_equip_class,
          o.x_service_type,
          o.x_cust_ent_code,
          o.f_ctr_site_spt_prog,
          o.f_cust_site_name,
          o.f_cust_site_city,
          o.f_cust_site_state,
          o.f_tech_dispatched_user_id,
          o.f_tech_dispatched_geo_code,
          o.f_case_closed_d,
          o.f_area,
          o.f_cust_reference_id,
          o.f_svc_tech_city,
          o.f_svc_tech_team,
          o.f_district_name
    FROM T_CLAR_ODS_CASE o
    WHERE o.f_case_closed_dt >= TRUNC(TRUNC(SYSDATE,'YEAR')-1, 'YEAR') AND o.f_case_closed_dt <= SYSDATE
    AND o.f_case_resolution_desc NOT IN ('CANCELLED', 'DUPLICATE CASE', 'CANCEL/WORK STARTED')
    AND (o.f_cust_corp_id NOT IN ('206739', '209833') OR o.f_cust_flex_tag_1 = 'Not Specified')
    AND o.f_sla_repair_committed = 1 
    AND o.f_sla_repair_made_miss = 0
  ),
  LOCAL_FIRST_PRS AS (
    SELECT /*+ MATERIALIZE */
          dtl.case_number,
          dtl.pr_number,
          dtl.case_create_date,
          dtl.pr_create_date,
          dtl.part_due_date,
          dtl.pr_type,
          dtl.part_number,
          dtl.tracking_number, 
          (SELECT min(tr.creation_date)
            FROM DW.T_CLAR_PART_TRANS tr
            WHERE dem.objid = tr.part_trans2demand_dtl
            AND tr.trans_type = 1) AS part_shipped_date,
          (SELECT min(tr.creation_date)
            FROM DW.T_CLAR_PART_TRANS tr
            WHERE dem.objid = tr.part_trans2demand_dtl
            AND tr.trans_type = 2) AS receipt_date,
          dem.shipped_qty,
          CASE WHEN instr((SELECT to_char(dw.clobagg(u.s_login_name || chr(13) || chr(10)))
                            FROM DW.T_CLAR_NOTES_LOG cl, DW.T_CLAR_MTM_NOTE_LOG20_RPT_TAG1 tag1, DW.T_CLAR_X_RPT_TAG r, DW.T_CLAR_USER u
                            WHERE o.f_case_key = cl.case_notes2case
                            AND cl.objid = tag1.x_notes_log2x_rpt_tag
                            AND tag1.x_rpt_tag2notes_log = r.objid(+)
                            AND cl.notes_owner2user = u.objid(+)
                            AND r.s_x_tag IN ('806', '807', 'CANL')
                            ),
                            (SELECT DISTINCT UPPER(u.login_name)
                            FROM DW.T_CLAR_ACT_ENTRY a, DW.T_CLAR_CASE b, DW.T_CLAR_GBST_ELM c, DW.T_CLAR_USER u
                            WHERE dtl.case_number = b.s_id_number
                              AND a.act_entry2case = b.objid
                              AND a.entry_name2gbst_elm = c.objid
                              AND a.act_entry2user = u.objid
                              AND c.s_title = 'CREATE PART REQUEST'
                              AND a.addnl_info LIKE '%'|| dtl.pr_number|| ',%')) > 0 THEN 1
                ELSE 0 END AS triage,
          CASE WHEN (
            SELECT count(act.addnl_info)
            FROM   dw.t_clar_act_entry act
            WHERE  dem.objid = act.act_entry2demand_dtl
            AND    act.act_code = 300
            AND    act.addnl_info LIKE '%CERT') > 0 THEN 1
          ELSE 0
          END AS not_certified   
    FROM T_CLAR_ODS_CASE_TUNE o, DW.T_DM_PART_SHIPPED_DTL dtl, DW.T_CLAR_DEMAND_DTL dem
    WHERE dtl.case_number = o.f_case_id
    AND dem.detail_number = dtl.pr_number
    AND dtl.pr_create_date < dtl.part_due_date
    AND dtl.pr_create_date < (
    SELECT /*+ INDEX (T_CLAR_TIME_LOG T_CLAR_TIME_LOG_TIMETYPE) */ 
            MIN(l.start_time)
    FROM T_CLAR_TIME_LOG l
    WHERE l.x_wo_number = dtl.case_number
      AND l.time_type = 'Work'
      AND (x_act_code IS NULL OR x_act_code <> 'FS Fix The Store')
      )
  )
  SELECT o.f_cust_corp_id,
        o.f_cust_corp_name,
        o.f_case_id,
        o.f_cust_reference_id AS Cust_Ref_No,
        o.f_area as area, 
        c.f_case_created_local_dttm AS create_date,
        c.f_closed_local_dt AS closed_date,
        c.f_repair_sla_due_local_date AS sla_due_date,
        dt.clndr_week_no as sla_due_week,
        o.f_case_closed_dt,
        bsm.f_kb AS kb, 
        CASE
          /* NO WAYBILL */
          WHEN (SELECT Count(dtl.pr_number)
                FROM LOCAL_FIRST_PRS dtl
                WHERE o.f_case_id = dtl.case_number
                AND dtl.triage = 1
                AND dtl.shipped_qty > 0 /* not canceled */
                AND dtl.tracking_number IS NULL
                /* received after the due date */
                AND dtl.receipt_date > dtl.part_due_date) > 0 THEN 'NO WAYBILL'
          /* NO WAYBILL END */
          /* TECH NOT CERTIFIED */
          WHEN (SELECT Count(dtl.pr_number)
                FROM LOCAL_FIRST_PRS dtl
                WHERE o.f_case_id = dtl.case_number
                AND not_certified = 1) > 1 THEN 'TECH NOT CERTIFIED'
          /* TECH NOT CERTIFIED END */
          /* INCOMPLETE OR WRONG INFO */
          WHEN (SELECT Count(dtl.pr_number)
                FROM LOCAL_FIRST_PRS dtl
                WHERE dtl.case_number = o.f_case_id
                  AND dtl.triage = 1
                  AND dtl.shipped_qty > 0 -- not canceled 
                  AND dtl.receipt_date > dtl.part_due_date --part was received after due date
                  /* incomplete or wrong info */
                  AND (SELECT Count(R.s_x_tag)
                      FROM DW.T_CLAR_NOTES_LOG cl, DW.T_CLAR_MTM_NOTE_LOG20_RPT_TAG1 tag1, DW.T_CLAR_X_RPT_TAG r
                      WHERE o.f_case_key = cl.case_notes2case
                        AND cl.objid = tag1.x_notes_log2x_rpt_tag
                        AND tag1.x_rpt_tag2notes_log = r.objid
                      --LEFT JOIN DW.T_CLAR_USER U ON CL.NOTES_OWNER2USER = U.OBJID
                        AND r.s_x_tag IN ('353','143')
                      ) = 1
                        /* Report date to PR Create date is greater than expected time */
                        AND ((dtl.pr_create_date - dtl.case_create_date) * 24 >= CASE
                                                                                  WHEN (dtl.part_due_date - dtl.case_create_date) * 24 <= 4 THEN .5
                                                                                  -- if due in 4 hours or less, must be shipped in .5 hours
                                                                                  WHEN (dtl.part_due_date - dtl.case_create_date) * 24 > 4 AND (dtl.part_due_date - dtl.case_create_date ) * 24 <= 12 THEN 1
                                                                                  -- if due between 4 and 12 hours, must be shipped in one hour
                                                                                  END
                              OR (
                              /* if part is due between 12 hours and 48 hours  */
                              /* and part was not ordered within 2 hours, part must be ordered before 4 PM eastern SAME DAY */
                                  (dtl.part_due_date - dtl.case_create_date) * 24 > 12
                                  AND (dtl.part_due_date - dtl.case_create_date) * 24 <= 48
                                  AND (dtl.pr_create_date - dtl.case_create_date) * 24 > 2
                                  AND dtl.pr_create_date > Trunc(case_create_date) + (16/24)
                                  -- 4PM
                                  )
                              OR (
                                  /* part is due in more than 48 hours, must be ordered by 4PM NEXT day */
                                  (dtl.part_due_date - dtl.case_create_date) *24/3600.0 > 48
                                  AND dtl.pr_create_date > Trunc(case_create_date) + (40/24)
                                  -- 4PM next day
                                  ) 
                              )
              ) > 0 THEN 'PART ORDERED LATE - INCOMPLETE OR WRONG INFO'
          /* INCOMPLETE OR WRONG INFO END */
          /* PART ORDERED LATE */
          WHEN (SELECT Count(dtl.pr_number)
                FROM LOCAL_FIRST_PRS dtl
                WHERE dtl.case_number = o.f_case_id
                AND triage = 1
                AND dtl.shipped_qty > 0 /* not canceled */
                  /* part was received after due date */
                AND dtl.receipt_date > dtl.part_due_date
                  /* Report date to PR Create date is greater than expected time */
                AND ((dtl.pr_create_date - dtl.case_create_date) * 24 >= CASE
                                                                            WHEN (dtl.part_due_date - dtl.case_create_date) * 24 <= 4 THEN .5
                                                                          -- if due in 4 hours or less, must be shipped in .5 hours
                                                                            WHEN (dtl.part_due_date - dtl.case_create_date) * 24 > 4 AND (dtl.part_due_date - dtl.case_create_date ) * 24 <= 12 THEN 1
                                                                          -- if due between 4 and 12 hours, must be shipped in one hour
                                                                          END
                              OR (
                              /* if part is due between 12 hours and 48 hours  */
                              /* and part was not ordered within 2 hours, part must be ordered before 4 PM eastern SAME DAY */
                                  (dtl.part_due_date - dtl.case_create_date ) * 24 > 12
                                  AND (dtl.part_due_date - dtl.case_create_date) * 24 <= 48
                                  AND (dtl.pr_create_date - dtl.case_create_date) * 24 > 2
                                  AND dtl.pr_create_date > Trunc(case_create_date) + (16/24)
                                  -- 4PM
                                  )
                              OR (
                                  /* part is due in more than 48 hours, must be ordered by 4PM NEXT day */
                                  ( dtl.part_due_date - dtl.case_create_date ) * 24/3600.0 > 48
                                  AND dtl.pr_create_date > Trunc(case_create_date) + (40/24)
                                  -- 4PM next day
                                  ) 
                      )
              ) > 0 THEN 'PART ORDERED LATE'
          /* PART ORDERED LATE END */
          /* PART SHIPPED LATE - SITE CLOSED */
          WHEN (SELECT Count(dtl.pr_number)
                FROM LOCAL_FIRST_PRS dtl
                WHERE dtl.case_number = o.f_case_id
                  /* part was received after due date */
                AND dtl.receipt_date > dtl.part_due_date
                AND dtl.shipped_qty > 0 /* not canceled */
                  /* 4 hour SLA */
                AND (dtl.part_due_date - dtl.pr_create_date) * 24 <= 4
                  /* Due date in local time is within hours when store is closed  between 11 PM and 5 AM local time - store is closed */
                AND (dtl.part_due_date + (c.f_closed_local_dt - c.f_closed_dt) > Trunc(dtl.part_due_date) + 23
                      OR dtl.part_due_date + (c.f_closed_local_dt - c.f_closed_dt) > Trunc(dtl.part_due_date) + 5)
                  /* Report date to PR Create date is greater than expected time */
                AND (dtl.part_shipped_date - dtl.pr_create_date ) * 24 >= .5) > 0 THEN 'PART SHIPPED LATE - SITE CLOSED'
          /* PART SHIPPED LATE - SITE CLOSED END */
          /* PART SHIPPED LATE */
          WHEN (SELECT Count(dtl.pr_number)
                FROM LOCAL_FIRST_PRS dtl
                WHERE dtl.case_number = o.f_case_id
                  AND dtl.shipped_qty > 0 /* not canceled */
                  AND dtl.part_shipped_date <> To_date('01/01/1753', 'mm/dd/yyyy')
                  -- null ship date - not sure why
                  /* part was received after due date */
                  AND dtl.receipt_date > dtl.part_due_date
                  /* ordered date to shipped date is greater than expected time */
                  AND ((dtl.part_shipped_date - dtl.pr_create_date ) * 24 >= CASE 
                                                                              WHEN ( dtl.part_due_date - dtl.pr_create_date ) * 24 <= 4 THEN .5
                                                                              WHEN ( dtl.part_due_date - dtl.pr_create_date ) * 24 > 4 AND ( dtl.part_due_date -dtl.pr_create_date ) * 24 <= 12 THEN 1
                                                                            END
                      OR ((dtl.part_due_date - dtl.pr_create_date ) * 24 > 12
                      /* was part shipped same day as ordered? */
                      AND Trunc(dtl.part_shipped_date) <> Trunc(dtl.pr_create_date)) 
                      )
              ) > 0 THEN 'PART SHIPPED LATE'
          /* PART SHIPPED LATE END*/
          /* WRONG PART ORDERED */
          WHEN (SELECT Count(dtl.pr_number)
                FROM LOCAL_FIRST_PRS dtl
                WHERE dtl.case_number = o.f_case_id
                  AND dtl.shipped_qty > 0 /* not canceled */
                  AND dtl.pr_type LIKE '%GNU%' -- GNU
                  /* part was not reordered (reorder implies lost) */
                  AND (SELECT Count(dtl2.pr_number)
                      FROM dw.t_dm_part_shipped_dtl dtl2
                      WHERE dtl.case_number = dtl2.case_number
                          AND dtl2.pr_number <> dtl.pr_number
                          AND dtl2.part_number = dtl.part_number
                          AND dtl2.pr_create_date > dtl.pr_create_date
                          AND dtl2.shipped_qty > 0) = 0
              /* other parts were ordered later and were used  and there was not a GNU of that same part */
              AND (SELECT Count(dtl3.pr_number)
                  FROM   dw.t_dm_part_shipped_dtl dtl3
                  WHERE  dtl.case_number = dtl3.case_number
                          AND dtl3.shipped_qty > 0
                          AND dtl3.part_number <> dtl.part_number
                          AND dtl3.pr_create_date > dtl.pr_create_date
                          --ordered later 
                          --and dtl3.pr_create_date >(select min(start_time) from t_clar_time_log where x_wo_number = o.f_Case_id and time_type = 'Work' and (x_Act_code is null or x_Act_code<> 'FS Fix The Store'))             
                          AND dtl3.pr_type NOT LIKE '%GNU%'
                          /* used part number was not previously DOA or GNU  (which would imply the part was lost) */
                          AND (SELECT Count(dtl4.pr_number)
                              FROM dw.t_dm_part_shipped_dtl dtl4
                              WHERE dtl4.case_number = dtl3.case_number
                                  AND dtl4.shipped_qty > 0
                                  AND dtl3.part_number = dtl4.part_number
                                  AND dtl4.pr_create_date < dtl3.pr_create_date
                                  AND (dtl4.pr_type LIKE '%GNU%' OR dtl4.pr_type LIKE '%DOA%')) =0
                  ) > 0
              ) > 0 THEN 'WRONG PART ORDERED'
          /* WRONG PART ORDERED END */
          /* PART LOST */
          WHEN (SELECT Count(dtl.pr_number)
                FROM LOCAL_FIRST_PRS dtl
                WHERE dtl.case_number = o.f_case_id
                  AND dtl.shipped_qty > 0 /* not canceled */
                  /* not DOA */
                  AND dtl.pr_type LIKE '%GNU%'
                  /* same part was reordered (reorder implies lost) */
                  AND (SELECT Count(dtl2.pr_number)
                      FROM dw.t_dm_part_shipped_dtl dtl2
                      WHERE dtl.case_number = dtl2.case_number
                          AND dtl2.pr_number <> dtl.pr_number
                          AND dtl2.part_number = dtl.part_number
                          AND dtl2.pr_create_date > dtl.pr_create_date
                          AND dtl2.shipped_qty > 0
                            /* and dtl2.pr_TYPE not like '%DOA%' and dtl2.pr_type not like '%GNU%'*/
                      ) > 0
              ) > 0 THEN 'PART LOST'
          /* PART LOST END*/
          /* TECH ARRIVED AFTER SLA */
          WHEN o.f_sla_repair_sched_comp_dt < (SELECT /*+ INDEX (T_CLAR_TIME_LOG T_CLAR_TIME_LOG_TIMETYPE) */ 
                                                      Min(start_time) /*  sla due date is before first time on site */
                                                FROM T_CLAR_TIME_LOG
                                                WHERE o.f_case_id = x_wo_number
                                                  AND time_type = 'Work'
                                                  AND (x_act_code IS NULL OR x_act_code <> 'FS Fix The Store' )) THEN 'TECH ARRIVED AFTER SLA'
          /* TECH ARRIVED AFTER SLA END*/
          /* TECH ARRIVED TOO LATE TO COMPLETE TASK IN TIME */
          --if there is a TTT goal then add it to tech's arrival time and see if that is after the SLA due date
          WHEN o.f_ttt_target IS NOT NULL /* there is a ttt goal for this case */
              AND o.f_sla_repair_sched_comp_dt <= (SELECT /*+ INDEX (T_CLAR_TIME_LOG T_CLAR_TIME_LOG_TIMETYPE) */
                                                          Min(start_time) /*  sla due date is before first time on site plus the TTT goal: did the tech get there early enough to finish the job before the SLA expired */
                                                  FROM T_CLAR_TIME_LOG
                                                  WHERE  x_wo_number = o.f_case_id
                                                    AND time_type = 'Work'
                                                    AND (x_act_code IS NULL OR x_act_code <> 'FS Fix The Store' )) + o.f_ttt_target / 24 THEN 'TECH DID NOT ARRIVE IN TIME TO MEET SLA'
          /* TECH ARRIVED TOO LATE TO COMPLETE TASK IN TIME END*/
          /* PART DOA */
          WHEN
        /* some parts ordered before tech went out were DOA */
        (SELECT Count(dtl.pr_number)
          FROM LOCAL_FIRST_PRS dtl
          WHERE dtl.case_number = o.f_case_id
              AND dtl.shipped_qty > 0 /* not canceled */
              AND dtl.pr_type LIKE '%DOA%'
              /* same part was reordered */
              AND (SELECT Count(dtl2.pr_number)
                  FROM dw.t_dm_part_shipped_dtl dtl2
                  WHERE dtl.case_number = dtl2.case_number
                      AND dtl2.pr_number <> dtl.pr_number
                      AND dtl2.part_number = dtl.part_number
                      AND dtl2.pr_create_date > dtl.pr_create_date
                      AND dtl2.shipped_qty > 0) > 0) > 0 THEN 'PART DOA'
          /* PART DOA END */
          /* NO PARTS ORDERED */
          WHEN (SELECT Count(dtl.pr_number)        /* no parts ordered before tech went out */
                FROM LOCAL_FIRST_PRS dtl
                WHERE dtl.case_number = o.f_case_id
                  AND dtl.shipped_qty > 0 /* not canceled */) = 0
                AND (SELECT Count(dtl.pr_number) /* parts were ordered by tech after going out */
                      FROM DW.T_DM_PART_SHIPPED_DTL dtl
                      WHERE o.f_case_id = dtl.case_number
                          AND dtl.shipped_qty > 0
                          /* Used  */
                          AND dtl.pr_type NOT LIKE '%GNU%'
                          AND dtl.pr_type NOT LIKE '%DOA%'
                          /* Ordered after tech went out */
                          AND dtl.pr_create_date > (SELECT /*+ INDEX (T_CLAR_TIME_LOG T_CLAR_TIME_LOG_TIMETYPE) */
                                                          Min(start_time)
                                                    FROM T_CLAR_TIME_LOG
                                                    WHERE x_wo_number = o.f_case_id
                                                      AND time_type = 'Work'
                                                      AND ( x_act_code IS NULL OR x_act_code <> 'FS Fix The Store' )))> 0 THEN 'NO PARTS ORDERED'
          /* NO PARTS ORDERED END*/
          /* ADDITIONAL PARTS REQUIRED */
          WHEN (SELECT Count(dtl.pr_number) /* some parts sent before tech went out were used */
                FROM LOCAL_FIRST_PRS dtl
                WHERE dtl.case_number = o.f_case_id
                  AND dtl.shipped_qty > 0 /* not canceled */
                  AND dtl.pr_type NOT LIKE '%GNU%' /* Used  */
                  AND dtl.pr_type NOT LIKE '%DOA%') > 0
              AND
              /* additional parts were ordered after tech went out and were used */
              (SELECT Count(dtl.pr_number)
              FROM DW.T_DM_PART_SHIPPED_DTL dtl
              WHERE dtl.case_number = o.f_case_id
                  AND dtl.shipped_qty > 0
                  AND dtl.pr_type NOT LIKE '%GNU%' /* Used  */
                  AND dtl.pr_type NOT LIKE '%DOA%'
                  /* Ordered after tech went out */
                  AND dtl.pr_create_date > (SELECT /*+ INDEX (T_CLAR_TIME_LOG T_CLAR_TIME_LOG_TIMETYPE) */
                                                  Min(start_time)
                                                  FROM T_CLAR_TIME_LOG
                                                  WHERE x_wo_number = o.f_case_id 
                                                  AND time_type = 'Work'
                                                  AND (x_act_code IS NULL OR x_act_code <> 'FS Fix The Store' ))) > 0 THEN 'ADDITIONAL PARTS REQUIRED'
          /* ADDITIONAL PARTS REQUIRED END */
          /* EXCESSIVE TTT */
          /* TECH arrived In TIme TO COMPLETE TASK but did not complete it in time */
          --if there is a TTT goal then add it to tech's arrival time and see if that is before the SLA due date
          WHEN o.f_ttt_target IS NOT NULL /* there is a ttt goal for this case */
              AND
              /*  sla due date is after first time on site plus the TTT goal: did the tech get there early enough to finish the job before the SLA expired 
              but did not finish in time*/
                  o.f_sla_repair_sched_comp_dt >= (SELECT /*+ INDEX (T_CLAR_TIME_LOG T_CLAR_TIME_LOG_TIMETYPE) */
                                                          Min(start_time)
                                                  FROM T_CLAR_TIME_LOG
                                                  WHERE x_wo_number = o.f_case_id
                                                      AND time_type = 'Work'
                                                      AND (x_act_code IS NULL OR x_act_code <> 'FS Fix The Store' )) + o.f_ttt_target / 24 THEN 'EXCESSIVE TTT'
          /* EXCESSIVE TTT END */
          ELSE 'TBD'
        END AS root_cause,
        o.f_case_resolution_desc,
        o.f_case_severity,
        o.f_equip_class,
        o.x_service_type,
        o.x_cust_ent_code,
        o.f_ctr_site_spt_prog,
        o.f_cust_site_name,
        o.f_cust_site_city,
        o.f_cust_site_state,
        o.f_tech_dispatched_user_id,
        o.f_tech_dispatched_geo_code,
        o.f_case_closed_d,
        bsm.f_rload,
        (SELECT TO_CHAR(dw.CLOBAGG(F_PART_NUMBER || '(' || COUNT(f_part_number) || ') '))
          FROM dw.t_dm_parts_usage_01 usg
          WHERE fct.f_case_sk = usg.f_case_objid
          GROUP BY f_Part_number) AS Parts_Used,
        round(fct.f_work_duration / 3600, 2) AS work_time,
        round(fct.f_Travel_duration / 3600, 2) AS travel_time,
        fct.f_trip_count AS trips,
        fct.f_tech_dispatched_name AS last_tech_name,
        fct.f_tech_dispatched_tech_org AS last_tech_org,
        fct.f_tech_dispatched_mgr_name AS last_tech_manager,
        firsttech.techid AS first_tech_id,
        firsttech.start_time + (c.f_closed_local_dt - c.f_closed_dt) AS first_start_time,
        o.f_svc_tech_city,
        o.f_svc_tech_team,
        o.f_district_name
  FROM T_CLAR_ODS_CASE_TUNE o, DW.T_DM_CASES_CLOSED c, DW.T_FCT_0050_CASE fct, DW.T_BSM_CASE_DATA bsm, DW.T_DIM_DATE dt, 
(SELECT /*+ INDEX (T_CLAR_TIME_LOG T_CLAR_TIME_LOG_TIMETYPE) */
        A.x_Wo_Number,
        upper(a.x_chg_userid) AS techid,
        a.start_time
        FROM DW.T_CLAR_TIME_LOG a
        WHERE a.time_type = 'Work'
AND (a.start_time, a.x_entry_date)= (SELECT /*+ INDEX (T_CLAR_TIME_LOG T_CLAR_TIME_LOG_TIMETYPE) */
                                             MIN(c.start_time), MIN(c.x_entry_date)
                                      FROM DW.T_CLAR_TIME_LOG c
                                      WHERE c.x_wo_number = a.x_wo_number
                                       AND c.time_type = 'Work')) firsttech
  WHERE o.f_case_key = c.f_source_key
  AND o.f_case_key = fct.f_case_sk
  AND o.f_case_key = bsm.f_case_key
  AND o.f_case_id = firsttech.x_Wo_Number
  AND trunc(c.F_REPAIR_SLA_DUE_LOCAL_DATE) = dt.day_dt /* to get week for sla due date */
);

--Standard Variables
dNow              Date := Sysdate;
iTotalRows        Integer := 0;
iTotalErrors      Integer := 0;
iLoadSequence     Integer := 999999;
iLoadInstanceSeq  Integer;
iExceptionCode    Integer;
vExceptionMessage Varchar2(256);
  ------------------------------------------------------
  -- END DECLARATIONS
  ------------------------------------------------------

  ------------------------------------------------------
  -- BEGIN MAIN
  ------------------------------------------------------
--bulk collect variables c CURSOR
f_cust_corp_id_t DBMS_SQL.VARCHAR2_TABLE;
f_cust_corp_name_t DBMS_SQL.VARCHAR2_TABLE;
f_case_id_t DBMS_SQL.VARCHAR2_TABLE;
cust_ref_no_t DBMS_SQL.VARCHAR2_TABLE;
area_t DBMS_SQL.VARCHAR2_TABLE;
create_date_t DBMS_SQL.DATE_TABLE;
closed_date_t DBMS_SQL.DATE_TABLE;
sla_due_date_t DBMS_SQL.DATE_TABLE;
sla_due_week_t DBMS_SQL.NUMBER_TABLE;
f_case_closed_dt_t DBMS_SQL.DATE_TABLE;
kb_t DBMS_SQL.VARCHAR2_TABLE;
root_cause_t DBMS_SQL.VARCHAR2_TABLE;
f_case_resolution_desc_t DBMS_SQL.VARCHAR2_TABLE;
f_case_severity_t DBMS_SQL.VARCHAR2_TABLE;
f_equip_class_t DBMS_SQL.VARCHAR2_TABLE;
x_service_type_t DBMS_SQL.VARCHAR2_TABLE; 
x_cust_ent_code_t DBMS_SQL.VARCHAR2_TABLE; 
f_ctr_site_spt_prog_t DBMS_SQL.VARCHAR2_TABLE; 
f_cust_site_name_t DBMS_SQL.VARCHAR2_TABLE;
f_cust_site_city_t DBMS_SQL.VARCHAR2_TABLE; 
f_cust_site_state_t DBMS_SQL.VARCHAR2_TABLE; 
f_tech_dispatched_user_id_t DBMS_SQL.VARCHAR2_TABLE;
f_tech_dispatched_geo_code_t DBMS_SQL.VARCHAR2_TABLE; 
f_case_closed_d_t DBMS_SQL.DATE_TABLE;
f_rload_t DBMS_SQL.NUMBER_TABLE;
parts_used_t DBMS_SQL.VARCHAR2_TABLE;
work_time_t DBMS_SQL.NUMBER_TABLE; 
travel_time_t DBMS_SQL.NUMBER_TABLE;
trips_t DBMS_SQL.NUMBER_TABLE;
last_tech_name_t DBMS_SQL.VARCHAR2_TABLE; 
last_tech_org_t DBMS_SQL.VARCHAR2_TABLE;  
last_tech_manager_t DBMS_SQL.VARCHAR2_TABLE; 
first_tech_id_t DBMS_SQL.VARCHAR2_TABLE; 
first_start_time_t DBMS_SQL.DATE_TABLE;
f_svc_tech_city_t DBMS_SQL.VARCHAR2_TABLE; 
f_svc_tech_team_t DBMS_SQL.VARCHAR2_TABLE; 
f_district_name_t DBMS_SQL.VARCHAR2_TABLE; 

BEGIN --B1

-- Conditional Create of New Seq Number
dw.sp_md_get_next_seq('T_SLA_MISS_PREL_ROOT_CAUSE',
     'T_SLA_MISS_PREL_ROOT_CAUSE',
     'OBJID',
     1, --- ACTIVE CODE 1 OR 0 PRETTY MUCH ALWAYS ACTIVE '
     'T_SLA_MISS_PREL_ROOT_CAUSE',
     'ORACLE DB-LINK',
     'DW TABLE LOAD',
     'SPW_T_SLA_MISS_PREL_ROOT_CAUSE',
     iLoadSequence,
     'DW');

dw.pkg_load_verify.p_begin_load(iloadsequence,iloadinstanceseq);
dw.sp_truncate('DW.T_SLA_MISS_PREL_ROOT_CAUSE');
-----------------------------------------------------------------
--Calculate and load new data
-----------------------------------------------------------------
OPEN c;
LOOP
     FETCH c BULK COLLECT INTO
          f_cust_corp_id_t,
          f_cust_corp_name_t,
          f_case_id_t,
          cust_ref_no_t,
          area_t,
          create_date_t,
          closed_date_t,
          sla_due_date_t,
          sla_due_week_t,
          f_case_closed_dt_t,
          kb_t,
          root_cause_t,
          f_case_resolution_desc_t,
          f_case_severity_t,
          f_equip_class_t,
          x_service_type_t, 
          x_cust_ent_code_t, 
          f_ctr_site_spt_prog_t, 
          f_cust_site_name_t,
          f_cust_site_city_t, 
          f_cust_site_state_t, 
          f_tech_dispatched_user_id_t,
          f_tech_dispatched_geo_code_t, 
          f_case_closed_d_t,
          f_rload_t,
          parts_used_t,
          work_time_t, 
          travel_time_t,
          trips_t,
          last_tech_name_t, 
          last_tech_org_t,  
          last_tech_manager_t, 
          first_tech_id_t, 
          first_start_time_t,     
          f_svc_tech_city_t,
          f_svc_tech_team_t, 
          f_district_name_t
     LIMIT iCommit;
     FOR i in 1 .. f_cust_corp_id_t.COUNT
     LOOP
          BEGIN --B2 insert
          INSERT INTO DW.T_SLA_MISS_PREL_ROOT_CAUSE (
            f_cust_corp_id,
            f_cust_corp_name,
            f_case_id,
            cust_ref_no,
            area,
            create_date,
            closed_date,
            sla_due_date,
            sla_due_week,
            f_case_closed_dt,
            kb,
            root_cause,
            f_case_resolution_desc,
            f_case_severity,
            f_equip_class,
            x_service_type,
            x_cust_ent_code,
            f_ctr_site_spt_prog,
            f_cust_site_name,
            f_cust_site_city,
            f_cust_site_state,
            f_tech_dispatched_user_id,
            f_tech_dispatched_geo_code,
            f_case_closed_d,
            f_rload,
            parts_used,
            work_time,
            travel_time,
            trips,
            last_tech_name,
            last_tech_org,
            last_tech_manager,
            first_tech_id,
            first_start_time,
            f_svc_tech_city,
            f_svc_tech_team, 
            f_district_name
          )
          VALUES (
            f_cust_corp_id_t(i),
            f_cust_corp_name_t(i),
            f_case_id_t(i),
            cust_ref_no_t(i),
            area_t(i),
            create_date_t(i),
            closed_date_t(i),
            sla_due_date_t(i),
            sla_due_week_t(i),
            f_case_closed_dt_t(i),
            kb_t(i),
            root_cause_t(i),
            f_case_resolution_desc_t(i),
            f_case_severity_t(i),
            f_equip_class_t(i),
            x_service_type_t(i), 
            x_cust_ent_code_t(i), 
            f_ctr_site_spt_prog_t(i), 
            f_cust_site_name_t(i),
            f_cust_site_city_t(i), 
            f_cust_site_state_t(i), 
            f_tech_dispatched_user_id_t(i),
            f_tech_dispatched_geo_code_t(i), 
            f_case_closed_d_t(i),
            f_rload_t(i),
            parts_used_t(i),
            work_time_t(i), 
            travel_time_t(i),
            trips_t(i),
            last_tech_name_t(i), 
            last_tech_org_t(i),  
            last_tech_manager_t(i), 
            first_tech_id_t(i), 
            first_start_time_t(i),
            f_svc_tech_city_t(i),
            f_svc_tech_team_t(i),
            f_district_name_t(i)
          );
EXCEPTION -- B2
  WHEN DUP_VAL_ON_INDEX THEN
  --UPDATE ERROR Information
  BEGIN--B3
  UPDATE DW.T_SLA_MISS_PREL_ROOT_CAUSE
  SET f_cust_corp_id = f_cust_corp_id_t(i),
      f_cust_corp_name = f_cust_corp_name_t(i),
      f_case_id = f_case_id_t(i),
      cust_ref_no = cust_ref_no_t(i),
      area = area_t(i),
      create_date = create_date_t(i),
      closed_date = closed_date_t(i),
      sla_due_date = sla_due_date_t(i),
      sla_due_week = sla_due_week_t(i),
      f_case_closed_dt = f_case_closed_dt_t(i),
      kb = kb_t(i),
      root_cause = root_cause_t(i),
      f_case_resolution_desc = f_case_resolution_desc_t(i),
      f_case_severity = f_case_severity_t(i),
      f_equip_class = f_equip_class_t(i),
      x_service_type = x_service_type_t(i), 
      x_cust_ent_code = x_cust_ent_code_t(i), 
      f_ctr_site_spt_prog = f_ctr_site_spt_prog_t(i), 
      f_cust_site_name = f_cust_site_name_t(i),
      f_cust_site_city = f_cust_site_city_t(i), 
      f_cust_site_state = f_cust_site_state_t(i), 
      f_tech_dispatched_user_id = f_tech_dispatched_user_id_t(i),
      f_tech_dispatched_geo_code = f_tech_dispatched_geo_code_t(i), 
      f_case_closed_d = f_case_closed_d_t(i),
      f_rload = f_rload_t(i),
      parts_used = parts_used_t(i),
      work_time = work_time_t(i), 
      travel_time = travel_time_t(i),
      trips = trips_t(i),
      last_tech_name = last_tech_name_t(i), 
      last_tech_org = last_tech_org_t(i),  
      last_tech_manager = last_tech_manager_t(i), 
      first_tech_id = first_tech_id_t(i), 
      first_start_time = first_start_time_t(i),
      f_svc_tech_city = f_svc_tech_city_t(i),
      f_svc_tech_team = f_svc_tech_team_t(i),
      f_district_name = f_district_name_t(i),
      dw_mod_date = sysdate
  WHERE f_cust_corp_id = f_cust_corp_id_t(i) 
    AND f_case_id = f_case_id_t(i)
    AND first_tech_id = first_tech_id_t(i)
;
--HADLE OTHER ERRORS
EXCEPTION --B2
     WHEN OTHERS THEN
     --INSERT ERROR INFORMATION
          BEGIN --B4
          itotalerrors := itotalerrors + 1;
          dw.pkg_load_verify.p_record_exception(iloadinstanceseq
          ,substr('DW.T_SLA_MISS_PREL_ROOT_CAUSE err:'||sqlerrm,1,256)
          ,SQLCODE
          ,SQLERRM
          ,'');
          END; --B4
     END; --B3 dup_val_on_index block
     END; --B2 insert exception block
     END LOOP;
     -- ASSIGN HOW MANY RECORDS PROCESSED
     itotalrows := c%ROWCOUNT;
     -- CONDITIONAL/INCREMENTAL TRANSACTION COMMIT
          dw.pkg_load_verify.p_commit_load(iloadinstanceseq
          ,itotalrows - itotalerrors
          ,itotalerrors);
     EXIT WHEN c%NOTFOUND;
END LOOP;
CLOSE c;
COMMIT;

-- FINAL COMMIT AND MD UPDATE
 dw.pkg_load_verify.p_commit_load(iloadinstanceseq
      ,itotalrows - itotalerrors
      ,itotalerrors);
 -- END LOAD AND UPDATE MD INFO
 dw.pkg_load_verify.p_end_load(iloadinstanceseq
      ,itotalrows - itotalerrors
      ,itotalerrors);
 EXCEPTION
 WHEN OTHERS THEN
 --GENERAL ERROR INFORMATION
BEGIN --B4
itotalerrors := itotalerrors + 1;
dw.pkg_load_verify.p_record_exception(iloadinstanceseq
,substr('DW.T_SLA_MISS_PREL_ROOT_CAUSE GENERAL err:'||sqlerrm,1,256)
,SQLCODE
,SQLERRM
,'');
END; --B4
     ------------------------------------------------------
     -- END MAIN
     ------------------------------------------------------
END; --B1
/

GRANT EXECUTE ON DW.SPW_T_SLA_MISS_PREL_ROOT_CAUSE TO TM1_ETL_ROLE;
GRANT EXECUTE ON DW.SPW_T_SLA_MISS_PREL_ROOT_CAUSE TO LF188653;