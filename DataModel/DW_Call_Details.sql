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
   ||    Luis Fuentes        27/08/2019   Initial Creation
   ||   -----------------------------------------------------------------------------
   ||
   ||   CURRENT REVISION STANDARD:  v1.50
   ||
   ***********************************************************************************/
/*******************************************************************************************
*  Generated using sp_gen_bulk() jg 2006
*******************************************************************************************/

--Call details Section
SELECT    cll.*, ( 
          CASE 
                    WHEN cll.talk_hold_time <= 60 THEN '<60 Sec' 
                    WHEN cll.talk_hold_time <= 300 THEN '01 - 05 Mins' 
                    WHEN cll.talk_hold_time <= 600 THEN '06 - 10 Mins' 
                    WHEN cll.talk_hold_time <= 900 THEN '11 - 15 Mins' 
                    WHEN cll.talk_hold_time <= 1800 THEN '16 - 30 Mins' 
                    WHEN cll.talk_hold_time <= 2700 THEN '31 - 45 Mins' 
                    WHEN cll.talk_hold_time <= 3600 THEN '46 - 60 Mins' 
                    ELSE '>60 Mins' 
          END)                                                                         talk_time_range,
          (cll.hangup_valid_abandon + cll.handled)     ||                                total_contacts,
          dates.weeknum_2                                                              week, 
          dates.weeknum_15                                                             week_fri_thru_thu,
          cast(trunc(add_months(last_day(cll.route_call_dtl_dt - 1/24)+1,-1)) AS DATE) month 
FROM      ( 
                 SELECT cll.ipcc_sk, 
                        cll.call_type_sk, 
                        cll.script_sk, 
                        cll.mediaclass_sk, 
                        cll.mrdomain_sk, 
                        cll.agent_sk, 
                        cll.route_call_dtl_dt-1  /24    route_call_dtl_dt, 
                        cll.beganroutingdatetime - 1/24 beganroutingdatetime, 
                        cll.dbdatetime-1         /24    dbdatetime, 
                        cll.targettype_desc, 
                        cll.calldisposition_desc, 
                        cll.rona_desc, 
                        cll.language_desc, 
                        cll.calltypeid, 
                        cll.dialednumberstring, 
                        cll.timezone, 
                        cll.enterprisename, 
                        cll.description, 
                        cll.servicelevelthreshold, 
                        cll.offer, 
                        cll.inbound, 
                        cll.handled, 
                        cll.handled_agent, 
                        cll.handled_ext_voicemail, 
                        cll.time_to_abandoned, 
                        cll.abandoned_all, 
                        cll.abandoned_hangup, 
                        cll.abandoned_valid, 
                        cll.errorcalls, 
                        cll.delaytime, 
                        cll.ringtime, 
                        cll.netqtime, 
                        cll.duration, 
                        cll.holdtime, 
                        cll.talktime, 
                        cll.handletime, 
                        cll.worktime, 
                        cll.time_to_answer, 
                        cll.handled_meeting_sla, 
                        cll.handled_meeting_180_sla, 
                        cll.analyst, 
                        cll.route_type, 
                        cll.ani, 
                        cll.caller_sk, 
                        (cll.holdtime                + cll.talktime)       talk_hold_time, 
                        (cll.abandoned_hangup        +cll.abandoned_valid) hangup_valid_abandon,
                        trunc(cll.route_call_dtl_dt-1/24)                  day, ( 
                        CASE 
                               WHEN cll.mediaclass_sk = 4 THEN 'Voice' 
                               WHEN cll.mediaclass_sk = 14923 THEN 'Chat' 
                               ELSE 'Email' 
                        END) TYPE, ( 
                        CASE 
                               WHEN cll.time_to_abandoned <=15 THEN '0-15 Seconds' 
                               WHEN cll.time_to_abandoned <=30 THEN '16-30 Seconds' 
                               WHEN cll.time_to_abandoned <=60 THEN '31-60 Seconds' 
                               WHEN cll.time_to_abandoned <=360 THEN '01-05 Mins' 
                               WHEN cll.time_to_abandoned <=600 THEN '06-10 Mins' 
                               ELSE '10+ Mins' 
                        END) abandon_time_range, ( 
                        CASE 
                               WHEN cll.enterprisename LIKE '%Gmestp_%' THEN 'GameStop, Inc' 
                               WHEN cll.enterprisename LIKE '%GTO_PTOC_Gen_En%' THEN 'ATANDT IN' 
                               WHEN cll.enterprisename LIKE '%GTO_NOC_Install_En%' THEN '7-Eleven Implementation' 
                               WHEN cll.enterprisename LIKE '%GTO_NOC_RNG6_En%' THEN '7-Eleven'
                               WHEN cll.enterprisename LIKE '%GTO_NOC_RNG5_En%' THEN 'CVS' 
                               WHEN cll.enterprisename LIKE '%GTO_NOC_PrjA_En%' THEN 'CVS BB Project'
                        END) enterprise_category, ( 
                        CASE 
                               WHEN cll.enterprisename LIKE '%Gmestp_%' THEN 'GameStop, Inc' 
                               WHEN cll.enterprisename LIKE '%GTO_PTOC_Gen_En%' THEN 'ATANDT IN' 
                               WHEN cll.enterprisename LIKE '%GTO_NOC_Install_En%' THEN '7-Eleven' 
                               WHEN cll.enterprisename LIKE '%GTO_NOC_RNG6_En%' THEN '7-Eleven'
                               WHEN cll.enterprisename LIKE '%GTO_NOC_RNG5_En%' THEN 'CVS' 
                               WHEN cll.enterprisename LIKE '%GTO_NOC_PrjA_En%' THEN 'CVS' 
                        END) company,
                        AGT.country, 
                        AGT.location
                 FROM DW.T_FCT_0030_IPCC_CALLDETAIL cll
                 LEFT JOIN DW.T_DIM_AGENT AG
                  ON cll.AGENT_SK = AG.AGENT_SK
                 LEFT JOIN DW.T_DIM_AGENT_TEAM AGT
                  ON AGT.AGENT_TEAM_SK = AG.AGENT_TEAM_SK 
                 WHERE  cll.route_call_dtl_dt > SYSDATE - 420 
                 AND    ( 
                               cll.enterprisename LIKE '%Gmestp_%' 
                        OR     cll.enterprisename LIKE '%GTO_PTOC_Gen_En%' 
                        OR     cll.enterprisename LIKE '%GTO_NOC_Install_E%' 
                        OR     cll.enterprisename LIKE '%GTO_NOC_RNG6_En%' 
                        OR     cll.enterprisename LIKE '%GTO_NOC_RNG5_En%' 
                        OR     cll.enterprisename LIKE '%GTO_NOC_PrjA_En%')) cll 
LEFT JOIN xfoinc01.dates 
ON cll.day = dates.dates;