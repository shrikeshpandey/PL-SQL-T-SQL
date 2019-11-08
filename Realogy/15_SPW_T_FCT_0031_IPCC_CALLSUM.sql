CREATE OR REPLACE PROCEDURE DW.SPW_T_FCT_0031_IPCC_CALLSUM (iCommit IN NUMBER DEFAULT 2000
,pdBegin IN DATE DEFAULT TRUNC(SYSDATE-3)
,pdEnd IN DATE DEFAULT TRUNC(SYSDATE+1)
) is
   /***********************************************************************************
   ||   PROCEDURE INFORMATION
   ||
   ||   Department:     Data Warehouse
   ||   Programmer:     Raj Atluri
   ||   Date:           06/21/2016
   ||   Category:       Load Procedure to load TARGET data from SOURCE
   ||
   ||   Description:    This is a Summary table from IPCC Call Detail Fact table
   ||
   ||
   ||   Parameters:     iCommit:   is batch size used to commit record changes.
   ||
   ||                   pdBegin:   is the Start Date that will be used in the
   ||                              cursors WHERE clause in order to get the data
   ||                              that we need from the source system.
   ||
   ||                   pdEnd:     is the Stop Date that will be used in the cursors
   ||                              WHERE clause in order to get the data that we need
   ||                              from the source system.
   ||   Load Sequence Number:  NNN
   ||
   ||   Historic Info:
   ||    Name:               Date:        Brief Description:
   ||   -----------------------------------------------------------------------------
   ||    Raj Atluri          06/21/2016   Initial Creation
   ||    Raj Atluri          12/04/2016   Added Email and Chat columns.
   ||    Luis Fuentes        07/24/2019   Adding a11.caller_sk, a12.Call_Type_Sk   
   ||   -----------------------------------------------------------------------------
   ||
   ||   CURRENT REVISION STANDARD:  v1.50
   ||
   ***********************************************************************************/
d_begin DATE;
d_end DATE;
CURSOR c is
select
    a13.DAY_DT  DAY_DT,
    a12.CORP_ID  CORP_ID,
    a13.CLNDR_MO_YEAR_NO  CLNDR_MO_YEAR_NO,
    a13.CLNDR_MO_YEAR_SHRT_DESC  CLNDR_MO_YEAR_SHRT_DESC,
    a13.CLNDR_YEAR_NO  CLNDR_YEAR_NO,
    COUNT(distinct ( Case when a11.MRDOMAIN_SK =  (5) THEN  (Case when a11.INBOUND in (1) then a11.IPCC_SK else NULL end) END))  CALLSAVAILABLE,
    max((Case when a11.INBOUND in (1) then 1 else 0 end))  GODWFLAG14_1,
    count(distinct (Case when a11.MRDOMAIN_SK =  (5) THEN (Case when a11.HANDLED_AGENT in (1) then a11.IPCC_SK else NULL end)END))  CALLSHANDLED,
(sum(CASE WHEN a11.MRDOMAIN_SK =  5 THEN ((Case when a11.HANDLED_AGENT in (1) then a11.HOLDTIME else NULL end) +  (Case when a11.HANDLED_AGENT in (1) then a11.WORKTIME else NULL end)
            + (Case when a11.HANDLED_AGENT in (1) then a11.TALKTIME else NULL end))END))  TOTALHANDLETIME,
    count(distinct(Case when a11.MRDOMAIN_SK =  (5) THEN (Case when a11.HANDLED_AGENT in (1) then a11.IPCC_SK else NULL end)END))  CALLSHANDLEDNOTDISTINCT,
    sum(Case when a11.MRDOMAIN_SK =  (5) THEN(Case when a11.HANDLED_AGENT in (1) then (CASE WHEN a11.TIME_TO_ANSWER=0 THEN NULL ELSE a11.TIME_TO_ANSWER END) else NULL end)END)  TIMETOANSWER,
    max((Case when a11.HANDLED_AGENT in (1) then a11.TALKTIME else NULL end))  MAXTALKTIME,
    max((Case when a11.HANDLED_AGENT in (1) then 1 else 0 end))  GODWFLAG15_1,
    count(distinct (Case when a11.HANDLED_EXT_VOICEMAIL in (1) then a11.IPCC_SK else NULL end))  CALLSHANDLEDVOICEMAIL,
    max((Case when a11.HANDLED_EXT_VOICEMAIL in (1) then 1 else 0 end))  GODWFLAG1b_1,
    count(distinct (Case when a11.MRDOMAIN_SK =  (5) THEN (Case when a11.OFFER in (1) then a11.IPCC_SK else NULL end)END))  CALLSOFFERED,
    max((Case when a11.OFFER in (1) then 1 else 0 end))  GODWFLAG1c_1,
    count(distinct (Case when a11.MRDOMAIN_SK =  (5) THEN(Case when a11.ABANDONED_VALID in (1) then a11.IPCC_SK else NULL end)END))  TRUEABANDONS,
    max((Case when a11.ABANDONED_VALID in (1) then 1 else 0 end))  GODWFLAG1d_1,
    -- changed WJXBFS1 calculations as per Miguel
    COUNT(DISTINCT(CASE WHEN a11.MRDOMAIN_SK =  (5) THEN (CASE WHEN HANDLED_MEETING_SLA = 1 and handled_agent = 1 THEN A11.IPCC_SK ELSE NULL END ) END))WJXBFS1,
    --     (Case when max(Case when a11.MRDOMAIN_SK =  (5) THEN(Case when (a11.HANDLED_MEETING_SLA in (1) and a11.HANDLED_AGENT in (1)) then 1 else 0 end)end ) = 1 then count(distinct (Case when (a11.HANDLED_MEETING_SLA in (1) and    a11.HANDLED_AGENT in (1)) then a11.IPCC_SK else NULL end)) else NULL end)  WJXBFS1,
    count(distinct (CASE WHEN a11.MRDOMAIN_SK =  (13752) THEN (Case when  a11.INBOUND in (1) then a11.IPCC_SK else NULL end) END ))   EMAIL_HANDLED,
    count(distinct (CASE WHEN a11.MRDOMAIN_SK =  (13754) THEN (Case when  a11.INBOUND in (1)
                                                                          then a11.IPCC_SK else NULL end) END))   CHAT_HANDLED,
--Chat information Raj Atluri             12/04/2016   Added Email and Chat columns.
count(distinct  CASE WHEN a11.MRDOMAIN_SK =  (13754) THEN (Case when a11.offer in (1) then a11.IPCC_SK else NULL end) END ) CHAT_CALLS_OFFERED,
Count(distinct CASE WHEN a11.MRDOMAIN_SK =  (13754) THEN   (Case when a11.Abandoned_Hangup in (1) then a11.IPCC_SK else NULL end) END) CHAT_CALLS_ABANDON_HANG_UP,
COUNT(CASE WHEN a11.MRDOMAIN_SK =  (13754) THEN  (Case when a11.INBOUND in (1) then a11.IPCC_SK else NULL end) END)  CHAT_CALLS_INBOUND,
count(distinct(CASE WHEN a11.MRDOMAIN_SK =  (13754) THEN   (Case when a11.ABANDONED_VALID in (1) then a11.IPCC_SK else NULL end) END )) CHAT_TRUE_ABANDONS,
ROUND(Count(distinct(
    (CASE WHEN a11.MRDOMAIN_SK =  (13754) THEN   (Case when a11.ABANDONED_VALID in (1) then a11.IPCC_SK else NULL end)END)/
          (CASE WHEN a11.MRDOMAIN_SK =  (13754) THEN  (Case when a11.ABANDONED_VALID in (1) then a11.IPCC_SK else NULL end) END) +
       (CASE WHEN a11.MRDOMAIN_SK =  (13754) THEN (case when a11.handled in (1) then 1 else 0 end) END )
      ))
     )CHAT_ABANDON_RATE,
max(Case when a11.MRDOMAIN_SK =  (13754) THEN (time_to_answer) END )    CHAT_MAX_TIME_TO_ANSWER,
ROUND( SUM(NVL(
         (case when a11.MRDOMAIN_SK =  (13754) THEN (case when a11.time_to_abandoned in (1) then 1 else 0 END ) END),0)/
      Nullif((CASE WHEN a11.MRDOMAIN_SK =  (13754) THEN  (Case when a11.ABANDONED_VALID in (1) then a11.IPCC_SK else NULL end) END) ,0)
      ),2)
      CHAT_AVERAGE_TIME_TO_ABANDON,
MAX(case when a11.MRDOMAIN_SK =  (13754) THEN (CASE WHEN A11.TIME_TO_ABANDONED IN (1) THEN 1 ELSE 0 END) END) AS CHAT_MAX_TIME_TO_ABANDON,
ROUND(sum(
       (case when a11.MRDOMAIN_SK =  (13754) THEN (time_to_answer) END)/
       (Nullif((case when a11.MRDOMAIN_SK =  (13754) THEN  (Case when a11.handled_Agent in (1) then a11.IPCC_SK else NULL end) END) ,0)
       )),2) AS CHAT_ASA_SECONDS,
count(distinct(CASE WHEN a11.MRDOMAIN_SK =  (13754) THEN  (Case when a11.handled_Agent in (1) then a11.IPCC_SK else NULL end) END)) AS CHAT_CALLS_HANDLED_AGENT,
count(distinct (CASE WHEN a11.MRDOMAIN_SK =  (13754) THEN  (Case when a11.HANDLED_EXT_VOICEMAIL in (1) then a11.IPCC_SK else NULL end) END)) CHAT_CALLS_HANDLED_VOICEMAIL,
ROUND(SUM(
       (CASE WHEN a11.MRDOMAIN_SK =  (13754) THEN (HOLDTIME) +  (TALKTIME) + (WORKTIME)  END )/
       (nullif((CASE WHEN a11.MRDOMAIN_SK =  (13754) THEN  (Case when a11.HANDLED_AGENT in (1) then a11.IPCC_SK else NULL end) END),0)
       )),2) AS CHAT_AHT_SECONDS,
(sum(CASE WHEN a11.MRDOMAIN_SK =  (13754) THEN ((Case when a11.HANDLED_AGENT in (1) then a11.HOLDTIME else NULL end) + (Case when a11.HANDLED_AGENT in (1) then a11.WORKTIME else NULL end)
              + (Case when a11.HANDLED_AGENT in (1) then a11.TALKTIME else NULL end))END))  CHAT_TOTAL_HANDLED_TIME,
COUNT(DISTINCT(CASE WHEN a11.MRDOMAIN_SK =  (13754) THEN (CASE WHEN HANDLED_MEETING_SLA = 1 and handled_agent = 1 THEN A11.IPCC_SK ELSE NULL END ) END))  CHAT_CALLS_ANS_MEETING_SLA,
ROUND(COUNT(DISTINCT(
                 (case when a11.MRDOMAIN_SK =  (13754) THEN (case when a11.handled_meeting_sla in (1) ThEN 1 else 0 END) END))/
                      ( nullif((case when  a11.MRDOMAIN_SK =  (13754) THEN (Case when a11.handled_Agent in (1) then a11.IPCC_SK else NULL end) END),0))
                      ),2)CHAT_CAP,
--Email information Raj Atluri             12/04/2016   Added Email and Chat columns.
count(distinct (CASE WHEN a11.MRDOMAIN_SK =  (13752) THEN (Case when a11.offer in (1) then a11.IPCC_SK else NULL end) END )) EMAIL_CALLS_OFFERED,
count(distinct (CASE WHEN a11.MRDOMAIN_SK =  (13752) THEN   (Case when a11.Abandoned_Hangup in (1) then a11.IPCC_SK else NULL end) END)) EMAIL_CALLS_ABANDON_HANG_UP,
COUNT(distinct (CASE WHEN a11.MRDOMAIN_SK =  (13752) THEN  (Case when a11.INBOUND in (1) then a11.IPCC_SK else NULL end) END))  EMAIL_CALLS_INBOUND,
count(distinct (CASE WHEN a11.MRDOMAIN_SK =  (13752) THEN   (Case when a11.ABANDONED_VALID in (1) then a11.IPCC_SK else NULL end) END )) EMAIL_TRUE_ABANDONS,
ROUND(Count(distinct(
    (CASE WHEN a11.MRDOMAIN_SK =  (13752) THEN   (Case when a11.ABANDONED_VALID in (1) then a11.IPCC_SK else NULL end)END)/
          (CASE WHEN a11.MRDOMAIN_SK =  (13752) THEN  (Case when a11.ABANDONED_VALID in (1) then a11.IPCC_SK else NULL end) END) +
       (CASE WHEN a11.MRDOMAIN_SK =  (13752) THEN (case when a11.handled in (1) then 1 else 0 end) END )
      )
     ),2)EMAIL_ABANDON_RATE,
max(Case when a11.MRDOMAIN_SK =  (13752) THEN (time_to_answer) END )    EMAIL_MAX_TIME_TO_ANSWER,
ROUND(SUM(NVL(
         (case when a11.MRDOMAIN_SK =  (13752) THEN (case when a11.time_to_abandoned in (1) then 1 else 0 END ) END),0)/
      Nullif((CASE WHEN a11.MRDOMAIN_SK =  (13752) THEN  (Case when a11.ABANDONED_VALID in (1) then a11.IPCC_SK else NULL end) END) ,0)
      ),2)
      EMAIL_AVERAGE_TIME_TO_ABANDON,
MAX(case when a11.MRDOMAIN_SK =  (13752) THEN (CASE WHEN A11.TIME_TO_ABANDONED IN (1) THEN 1 ELSE 0 END) END) AS EMAIL_MAX_TIME_TO_ABANDON,
ROUND(sum(
       (case when a11.MRDOMAIN_SK =  (13752) THEN (time_to_answer) END)/
   (Nullif((case when a11.MRDOMAIN_SK =  (13752) THEN  (Case when a11.handled_Agent in (1) then a11.IPCC_SK else NULL end) END) ,0)
   )),2) AS EMAIL_ASA_SECONDS,
count(distinct(CASE WHEN a11.MRDOMAIN_SK =  (13752) THEN  (Case when a11.handled_Agent in (1) then a11.IPCC_SK else NULL end) END)) AS EMAIL_CALLS_HANDLED_AGENT,
count(distinct (CASE WHEN a11.MRDOMAIN_SK =  (13752) THEN  (Case when a11.HANDLED_EXT_VOICEMAIL in (1) then a11.IPCC_SK else NULL end) END)) EMAIL_CALLS_HANDLED_VOICEMAIL,
ROUND(SUM(
       (CASE WHEN a11.MRDOMAIN_SK =  (13752) THEN (HOLDTIME) +  (TALKTIME) + (WORKTIME)  END )/
       (nullif((CASE WHEN a11.MRDOMAIN_SK =  (13752) THEN  (Case when a11.HANDLED_AGENT in (1) then a11.IPCC_SK else NULL end) END),0)
       )),2) AS EMAIL_AHT_SECONDS,
(sum(CASE WHEN a11.MRDOMAIN_SK =  (13752) THEN (
          ( Case when a11.HANDLED_AGENT in (1) then a11.HOLDTIME else NULL end) +
           (Case when a11.HANDLED_AGENT in (1) then a11.WORKTIME else NULL end) +
           (Case when a11.HANDLED_AGENT in (1) then a11.TALKTIME else NULL end)
           )
           END
                 ))  EMAIL_TOTAL_HANDLED_TIME,
COUNT(DISTINCT(CASE WHEN a11.MRDOMAIN_SK =  (13752) THEN (CASE WHEN HANDLED_MEETING_SLA = 1 and handled_agent = 1 THEN A11.IPCC_SK ELSE NULL END ) END))  EMAIL_CALLS_ANS_MEETING_SLA,
ROUND(COUNT(DISTINCT(
               (case when a11.MRDOMAIN_SK =  (13752) THEN (case when a11.handled_meeting_sla in (1) ThEN 1 else 0 END) END))/
                    ( nullif((case when  a11.MRDOMAIN_SK =  (13752) THEN (Case when a11.handled_Agent in (1) then a11.IPCC_SK else NULL end) END),0))
                    ),2)
                    EMAIL_CAP,
sum(CASE WHEN a11.MRDOMAIN_SK =  (13754) THEN(Case when a11.HANDLED_AGENT in (1) then (CASE WHEN a11.TIME_TO_ANSWER=0 THEN NULL ELSE a11.TIME_TO_ANSWER END) else NULL end)END)  CHAT_TIMETOANSWER,
sum(CASE WHEN a11.MRDOMAIN_SK =  (13752) THEN(Case when a11.HANDLED_AGENT in (1) then (CASE WHEN a11.TIME_TO_ANSWER=0 THEN NULL ELSE a11.TIME_TO_ANSWER END) else NULL end)end)  EMAIL_TIMETOANSWER,
--3/12/2017 added new Columns - Ran Atluri
SUM(case when a12.enterprisename LIKE '%SSvc%' then  (A11.HANDLED_AGENT) end) AS Self_Service_Handled,
SUM(case when a12.enterprisename LIKE '%SSvc%' then (a11.handled_meeting_sla) end) as Self_Service_Meeting_sla,
SUM(case when a12.enterprisename LIKE '%SSvc%' and a11.handled_agent = 1 then (a11.time_to_answer) end) as Self_Service_time_asnwer,
SUM(case when a12.enterprisename LIKE '%SSvc%' and a11.handled_agent = 1 then (a11.holdtime + a11.worktime + a11.talktime) end) as Self_Service_handled_time,
    --CHANGE 07/24/2019 
    a11.caller_sk AS caller_sk,
    a12.CALL_TYPE_SK AS call_type_sk
    --CHANGE 07/24/2019  
from    DW.T_FCT_0030_IPCC_CALLDETAIL    a11 --a11.caller_sk
    join    DW.T_DIM_CALL_TYPE    a12 --a12.CALL_TYPE_SK
          on     (a11.CALL_TYPE_SK = a12.CALL_TYPE_SK)
    join    DW.T_DIM_DATE    a13
      on     (a11.BEGANROUTINGDATETIME_SK = a13.DT_SK)
where    a12.ENTERPRISENAME not like '%Slv%'
 and a12.ENTERPRISENAME not like '%Ons%'
 and a13.DAY_DT >= d_begin
 and a11.IN_OUT_SK in (1)
-- and a11.MRDOMAIN_SK in (5,13754,13752)
 and (a11.INBOUND in (1)  or a11.HANDLED_AGENT in (1) or a11.HANDLED_EXT_VOICEMAIL in (1)
 or a11.OFFER in (1) or a11.ABANDONED_VALID in (1))
group by
    a13.DAY_DT,
    a12.CORP_ID,
    a13.CLNDR_MO_YEAR_NO,
    a13.CLNDR_MO_YEAR_SHRT_DESC,
    a13.CLNDR_YEAR_NO,
    --CHANGE 07/24/2019 
    a11.caller_sk,
    a12.CALL_TYPE_SK
    --CHANGE 07/24/2019 
;
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
--bulk collect variables
DAY_DT_t dbms_sql.DATE_table;
CORP_ID_t dbms_sql.VARCHAR2_table;
CLNDR_MO_YEAR_NO_t dbms_sql.NUMBER_table;
CLNDR_MO_YEAR_SHRT_DESC_t dbms_sql.VARCHAR2_table;
CLNDR_YEAR_NO_t dbms_sql.NUMBER_table;
CALLSAVAILABLE_t dbms_sql.NUMBER_table;
GODWFLAG14_1_t dbms_sql.NUMBER_table;
CALLSHANDLED_t dbms_sql.NUMBER_table;
TOTALHANDLETIME_t dbms_sql.NUMBER_table;
CALLSHANDLEDNOTDISTINCT_t dbms_sql.NUMBER_table;
TIMETOANSWER_t dbms_sql.NUMBER_table;
MAXTALKTIME_t dbms_sql.NUMBER_table;
GODWFLAG15_1_t dbms_sql.NUMBER_table;
CALLSHANDLEDVOICEMAIL_t dbms_sql.NUMBER_table;
GODWFLAG1B_1_t dbms_sql.NUMBER_table;
CALLSOFFERED_t dbms_sql.NUMBER_table;
GODWFLAG1C_1_t dbms_sql.NUMBER_table;
TRUEABANDONS_t dbms_sql.NUMBER_table;
GODWFLAG1D_1_t dbms_sql.NUMBER_table;
WJXBFS1_t dbms_sql.NUMBER_table;
EMAIL_HANDLED_t dbms_sql.NUMBER_table;
CHAT_HANDLED_t dbms_sql.NUMBER_table;
CHAT_CALLS_OFFERED_t dbms_sql.NUMBER_table;
CHAT_CALLS_ABANDON_HANG_UP_t dbms_sql.NUMBER_table;
CHAT_CALLS_INBOUND_t dbms_sql.NUMBER_table;
CHAT_TRUE_ABANDONS_t dbms_sql.NUMBER_table;
CHAT_ABANDON_RATE_t dbms_sql.NUMBER_table;
CHAT_MAX_TIME_TO_ANSWER_t dbms_sql.NUMBER_table;
CHAT_AVERAGE_TIME_TO_ABANDON_t dbms_sql.NUMBER_table;
CHAT_MAX_TIME_TO_ABANDON_t dbms_sql.NUMBER_table;
CHAT_ASA_SECONDS_t dbms_sql.NUMBER_table;
CHAT_CALLS_HANDLED_AGENT_t dbms_sql.NUMBER_table;
CHAT_CALLS_HANDLED_VOICEMAIL_t dbms_sql.NUMBER_table;
CHAT_AHT_SECONDS_t dbms_sql.NUMBER_table;
CHAT_TOTAL_HANDLED_TIME_t dbms_sql.NUMBER_table;
CHAT_CALLS_ANS_MEETING_SLA_t dbms_sql.NUMBER_table;
CHAT_CAP_t dbms_sql.NUMBER_table;
EMAIL_CALLS_OFFERED_t dbms_sql.NUMBER_table;
EMAIL_CALLS_ABANDON_HANG_UP_t dbms_sql.NUMBER_table;
EMAIL_CALLS_INBOUND_t dbms_sql.NUMBER_table;
EMAIL_TRUE_ABANDONS_t dbms_sql.NUMBER_table;
EMAIL_ABANDON_RATE_t dbms_sql.NUMBER_table;
EMAIL_MAX_TIME_TO_ANSWER_t dbms_sql.NUMBER_table;
EMAIL_AVG_TIME_TO_ABANDON_t dbms_sql.NUMBER_table;
EMAIL_MAX_TIME_TO_ABANDON_t dbms_sql.NUMBER_table;
EMAIL_ASA_SECONDS_t dbms_sql.NUMBER_table;
EMAIL_CALLS_HANDLED_AGENT_t dbms_sql.NUMBER_table;
EMAIL_HANDLED_VOICEMAIL_t dbms_sql.NUMBER_table;
EMAIL_AHT_SECONDS_t dbms_sql.NUMBER_table;
EMAIL_TOTAL_HANDLED_TIME_t dbms_sql.NUMBER_table;
EMAIL_CALLS_ANS_MEETING_SLA_t dbms_sql.NUMBER_table;
EMAIL_CAP_t dbms_sql.NUMBER_table;
CHAT_TIMETOANSWER_t dbms_sql.NUMBER_table;
EMAIL_TIMETOANSWER_t dbms_sql.NUMBER_table;
--3/12/2017 added new Columns - Ran Atluri
Self_Service_Handled_t dbms_sql.NUMBER_table;
Self_Service_Meeting_sla_t dbms_sql.NUMBER_table;
Self_Service_time_asnwer_t dbms_sql.NUMBER_table;
Self_Service_handled_time_t dbms_sql.NUMBER_table;
--CHANGE 07/24/2019 
CALLER_SK_t dbms_sql.NUMBER_table;
CALL_TYPE_SK_t dbms_sql.NUMBER_table;
--CHANGE 07/24/2019 

BEGIN --B1

  -- Conditional Create of New Seq Number

dw.sp_md_get_next_seq('T_FCT_0031_IPCC_CALLSUM',
     'T_FCT_0031_IPCC_CALLSUM',
     'OBJID',
     1, --- ACTIVE CODE 1 OR 0 PRETTY MUCH ALWAYS ACTIVE '
     'T_FCT_0031_IPCC_CALLSUM',
     'ORACLE DB-LINK',
     'DW TABLE LOAD',
     'SPW_T_FCT_0031_IPCC_CALLSUM',
     iLoadSequence,
     'T_FCT_0030_IPCC_CALLDETAIL');

dw.pkg_load_verify.p_begin_load(iloadsequence,iloadinstanceseq);

IF iCommit = 1100 THEN
   d_begin := pdBegin;
   d_end := pdEnd;
ELSE
 SELECT TRUNC(MAX(lins.load_begin)) -7
 INTO d_Begin
 FROM MD_LOAD_INSTANCE lins, MD_LOAD_INFO linf
 WHERE linf.table_load_seq = lins.table_load_seq
 AND linf.table_load_seq = iLoadSequence
 AND load_end IS NOT NULL;
 d_end := TRUNC(SYSDATE+1);
END IF;

DELETE FROM DW.T_FCT_0031_IPCC_CALLSUM  WHERE DAY_DT >= D_BEGIN -1;
COMMIT;


OPEN c;
LOOP
     FETCH c BULK COLLECT INTO
          DAY_DT_t,
          CORP_ID_t,
          CLNDR_MO_YEAR_NO_t,
          CLNDR_MO_YEAR_SHRT_DESC_t,
          CLNDR_YEAR_NO_t,
          CALLSAVAILABLE_t,
          GODWFLAG14_1_t,
          CALLSHANDLED_t,
          TOTALHANDLETIME_t,
          CALLSHANDLEDNOTDISTINCT_t,
          TIMETOANSWER_t,
          MAXTALKTIME_t,
          GODWFLAG15_1_t,
          CALLSHANDLEDVOICEMAIL_t,
          GODWFLAG1B_1_t,
          CALLSOFFERED_t,
          GODWFLAG1C_1_t,
          TRUEABANDONS_t,
          GODWFLAG1D_1_t,
          WJXBFS1_t,
          EMAIL_HANDLED_t,
          CHAT_HANDLED_t,
          CHAT_CALLS_OFFERED_t,
          CHAT_CALLS_ABANDON_HANG_UP_t,
          CHAT_CALLS_INBOUND_t,
          CHAT_TRUE_ABANDONS_t,
          CHAT_ABANDON_RATE_t,
          CHAT_MAX_TIME_TO_ANSWER_t,
          CHAT_AVERAGE_TIME_TO_ABANDON_t,
          CHAT_MAX_TIME_TO_ABANDON_t,
          CHAT_ASA_SECONDS_t,
          CHAT_CALLS_HANDLED_AGENT_t,
          CHAT_CALLS_HANDLED_VOICEMAIL_t,
          CHAT_AHT_SECONDS_t,
          CHAT_TOTAL_HANDLED_TIME_t,
          CHAT_CALLS_ANS_MEETING_SLA_t,
          CHAT_CAP_t,
          EMAIL_CALLS_OFFERED_t,
          EMAIL_CALLS_ABANDON_HANG_UP_t,
          EMAIL_CALLS_INBOUND_t,
          EMAIL_TRUE_ABANDONS_t,
          EMAIL_ABANDON_RATE_t,
          EMAIL_MAX_TIME_TO_ANSWER_t,
          EMAIL_AVG_TIME_TO_ABANDON_t,
          EMAIL_MAX_TIME_TO_ABANDON_t,
          EMAIL_ASA_SECONDS_t,
          EMAIL_CALLS_HANDLED_AGENT_t,
          EMAIL_HANDLED_VOICEMAIL_t,
          EMAIL_AHT_SECONDS_t,
          EMAIL_TOTAL_HANDLED_TIME_t,
          EMAIL_CALLS_ANS_MEETING_SLA_t,
          EMAIL_CAP_t,
          CHAT_TIMETOANSWER_t,
          EMAIL_TIMETOANSWER_t,
          Self_Service_Handled_t,
          Self_Service_Meeting_sla_t,
          Self_Service_time_asnwer_t,
          Self_Service_handled_time_t,
          --CHANGE 07/24/2019 
          CALLER_SK_t,
          CALL_TYPE_SK_t
          --CHANGE 07/24/2019 
     LIMIT iCommit;
     FOR i in 1..DAY_DT_t.COUNT
     LOOP
          BEGIN --B2 insert
          INSERT INTO DW.T_FCT_0031_IPCC_CALLSUM (
               DAY_DT,
               CORP_ID,
               CLNDR_MO_YEAR_NO,
               CLNDR_MO_YEAR_SHRT_DESC,
               CLNDR_YEAR_NO,
               CALLSAVAILABLE,
               GODWFLAG14_1,
               CALLSHANDLED,
               TOTALHANDLETIME,
               CALLSHANDLEDNOTDISTINCT,
               TIMETOANSWER,
               MAXTALKTIME,
               GODWFLAG15_1,
               CALLSHANDLEDVOICEMAIL,
               GODWFLAG1B_1,
               CALLSOFFERED,
               GODWFLAG1C_1,
               TRUEABANDONS,
               GODWFLAG1D_1,
               WJXBFS1,
               EMAIL_HANDLED,
               CHAT_HANDLED,
               CHAT_CALLS_OFFERED,
               CHAT_CALLS_ABANDON_HANG_UP,
               CHAT_CALLS_INBOUND,
               CHAT_TRUE_ABANDONS,
               CHAT_ABANDON_RATE,
               CHAT_MAX_TIME_TO_ANSWER,
               CHAT_AVERAGE_TIME_TO_ABANDON,
               CHAT_MAX_TIME_TO_ABANDON,
               CHAT_ASA_SECONDS,
               CHAT_CALLS_HANDLED_AGENT,
               CHAT_CALLS_HANDLED_VOICEMAIL,
               CHAT_AHT_SECONDS,
               CHAT_TOTAL_HANDLED_TIME,
               CHAT_CALLS_ANS_MEETING_SLA,
               CHAT_CAP,
               EMAIL_CALLS_OFFERED,
               EMAIL_CALLS_ABANDON_HANG_UP,
               EMAIL_CALLS_INBOUND,
               EMAIL_TRUE_ABANDONS,
               EMAIL_ABANDON_RATE,
               EMAIL_MAX_TIME_TO_ANSWER,
               EMAIL_AVERAGE_TIME_TO_ABANDON,
               EMAIL_MAX_TIME_TO_ABANDON,
               EMAIL_ASA_SECONDS,
               EMAIL_CALLS_HANDLED_AGENT,
               EMAIL_CALLS_HANDLED_VOICEMAIL,
               EMAIL_AHT_SECONDS,
               EMAIL_TOTAL_HANDLED_TIME,
               EMAIL_CALLS_ANS_MEETING_SLA,
               EMAIL_CAP,
               CHAT_TIMETOANSWER,
               EMAIL_TIMETOANSWER,
               --3/12/2017 added new Columns - Ran Atluri
               Self_Service_Handled,
               Self_Service_Meeting_sla,
               Self_Service_time_asnwer,
               Self_Service_handled_time,
               --CHANGE 07/24/2019 
               caller_sk,
               call_type_sk
               --CHANGE 07/24/2019 
          )
          VALUES (
               DAY_DT_t(i),
               CORP_ID_t(i),
               CLNDR_MO_YEAR_NO_t(i),
               CLNDR_MO_YEAR_SHRT_DESC_t(i),
               CLNDR_YEAR_NO_t(i),
               CALLSAVAILABLE_t(i),
               GODWFLAG14_1_t(i),
               CALLSHANDLED_t(i),
               TOTALHANDLETIME_t(i),
               CALLSHANDLEDNOTDISTINCT_t(i),
               TIMETOANSWER_t(i),
               MAXTALKTIME_t(i),
               GODWFLAG15_1_t(i),
               CALLSHANDLEDVOICEMAIL_t(i),
               GODWFLAG1B_1_t(i),
               CALLSOFFERED_t(i),
               GODWFLAG1C_1_t(i),
               TRUEABANDONS_t(i),
               GODWFLAG1D_1_t(i),
               WJXBFS1_t(i),
               EMAIL_HANDLED_t(i),
               CHAT_HANDLED_t(i),
               CHAT_CALLS_OFFERED_t(i),
               CHAT_CALLS_ABANDON_HANG_UP_t(i),
               CHAT_CALLS_INBOUND_t(i),
               CHAT_TRUE_ABANDONS_t(i),
               CHAT_ABANDON_RATE_t(i),
               CHAT_MAX_TIME_TO_ANSWER_t(i),
               CHAT_AVERAGE_TIME_TO_ABANDON_t(i),
               CHAT_MAX_TIME_TO_ABANDON_t(i),
               CHAT_ASA_SECONDS_t(i),
               CHAT_CALLS_HANDLED_AGENT_t(i),
               CHAT_CALLS_HANDLED_VOICEMAIL_t(i),
               CHAT_AHT_SECONDS_t(i),
               CHAT_TOTAL_HANDLED_TIME_t(i),
               CHAT_CALLS_ANS_MEETING_SLA_t(i),
               CHAT_CAP_t(i),
               EMAIL_CALLS_OFFERED_t(i),
               EMAIL_CALLS_ABANDON_HANG_UP_t(i),
               EMAIL_CALLS_INBOUND_t(i),
               EMAIL_TRUE_ABANDONS_t(i),
               EMAIL_ABANDON_RATE_t(i),
               EMAIL_MAX_TIME_TO_ANSWER_t(i),
               EMAIL_AVG_TIME_TO_ABANDON_t(i),
               EMAIL_MAX_TIME_TO_ABANDON_t(i),
               EMAIL_ASA_SECONDS_t(i),
               EMAIL_CALLS_HANDLED_AGENT_t(i),
               EMAIL_HANDLED_VOICEMAIL_t(i),
               EMAIL_AHT_SECONDS_t(i),
               EMAIL_TOTAL_HANDLED_TIME_t(i),
               EMAIL_CALLS_ANS_MEETING_SLA_t(i),
               EMAIL_CAP_t(i),
               CHAT_TIMETOANSWER_t(i),
               EMAIL_TIMETOANSWER_t(i),
               --3/12/2017 added new Columns - Ran Atluri
               Self_Service_Handled_t(i),
               Self_Service_Meeting_sla_t(i),
               Self_Service_time_asnwer_t(i),
               Self_Service_handled_time_t(i),
               --CHANGE 07/24/2019 
               CALLER_SK_t(i),
               CALL_TYPE_SK_t(i)
               --CHANGE 07/24/2019 

);
commit;
EXCEPTION --B2
     WHEN OTHERS THEN
     --INSERT ERROR INFORMATION
          BEGIN --B4
          itotalerrors := itotalerrors + 1;
          dw.pkg_load_verify.p_record_exception(iloadinstanceseq,substr('DW.T_FCT_0031_IPCC_CALLSUM err:'||sqlerrm,1,256),SQLCODE,SQLERRM,'');
          END; --B4
     END; --B2 insert exception block
     END LOOP;
     -- ASSIGN HOW MANY RECORDS PROCESSED
     itotalrows := c%ROWCOUNT;
     -- CONDITIONAL/INCREMENTAL TRANSACTION COMMIT
          dw.pkg_load_verify.p_commit_load(iloadinstanceseq,itotalrows - itotalerrors,itotalerrors);
     EXIT WHEN c%NOTFOUND;
END LOOP;

CLOSE c;
     -- FINAL COMMIT AND MD UPDATE
     dw.pkg_load_verify.p_commit_load(iloadinstanceseq,itotalrows - itotalerrors,itotalerrors);
     -- END LOAD AND UPDATE MD INFO
     dw.pkg_load_verify.p_end_load(iloadinstanceseq,itotalrows - itotalerrors,itotalerrors);
     EXCEPTION
     WHEN OTHERS THEN
     --GENERAL ERROR INFORMATION
          BEGIN --B4
          itotalerrors := itotalerrors + 1;
          dw.pkg_load_verify.p_record_exception(iloadinstanceseq
          ,substr('DW.T_FCT_0031_IPCC_CALLSUM GENERAL err:'||sqlerrm,1,256)
          ,SQLCODE,SQLERRM,'');
          END; --B4
     ------------------------------------------------------
     -- END MAIN
     ------------------------------------------------------
END; --B1
/

GRANT EXECUTE ON DW.SPW_T_VENDOR_INVENTORY TO TM1_ETL_ROLE;
GRANT EXECUTE ON DW.SPW_T_VENDOR_INVENTORY TO LF188653;