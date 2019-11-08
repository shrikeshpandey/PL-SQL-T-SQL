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
||    Luis Fuentes        27/08/2019   Adding country, location
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/
/*******************************************************************************************
*  Generated using sp_gen_bulk() jg 2006
*******************************************************************************************/
SELECT D_DATE.DAY_DT,
       IPCCCD.BEGANROUTINGDATETIME,
       IPCCCD.ANALYST,
       IPCCCD.IPCC_SK,
       count(distinct(Case
                        when IPCCCD.OFFER in (1) then
                         IPCCCD.IPCC_SK
                        else
                         NULL
                      end)) CALLSOFFERED,
       count(distinct(Case
                        when IPCCCD.ABANDONED_HANGUP in (1) then
                         IPCCCD.IPCC_SK
                        else
                         NULL
                      end)) CALLSABANDONHANGUP,
       count(distinct(Case
                        when IPCCCD.INBOUND in (1) then
                         IPCCCD.IPCC_SK
                        else
                         NULL
                      end)) CALLSINBOUND,
       count((Case
               when IPCCCD.HANDLED_AGENT in (1) then
                IPCCCD.IPCC_SK
               else
                NULL
             end)) CALLSHANDLEDNOTDISTINCT,
       
       count(distinct(Case
                        when IPCCCD.INBOUND in (1) then
                         IPCCCD.IPCC_SK
                        else
                         NULL
                      end)) -
       (count((Case
                when IPCCCD.HANDLED_AGENT in (1) then
                 IPCCCD.IPCC_SK
                else
                 NULL
              end)) + count(distinct(Case
                                       when IPCCCD.HANDLED_EXT_VOICEMAIL in (1) then
                                        IPCCCD.IPCC_SK
                                       else
                                        NULL
                                     end))) TRUE_ABANDONS,
       max((Case
             when IPCCCD.HANDLED_AGENT in (1) then
              (CASE
                WHEN IPCCCD.TIME_TO_ANSWER = 0 THEN
                 NULL
                ELSE
                 IPCCCD.TIME_TO_ANSWER
              END)
             else
              NULL
           end)) MAXTIMETOANSWER,
       sum((Case
             when IPCCCD.ABANDONED_ALL in (1) then
              IPCCCD.TIME_TO_ABANDONED
             else
              NULL
           end)) TIMETOABANDONST,
       
       CASE
         WHEN count(distinct(Case
                               when IPCCCD.INBOUND in (1) then
                                IPCCCD.IPCC_SK
                               else
                                NULL
                             end)) = '0' THEN
          NULL
         ELSE
          sum((Case
                when IPCCCD.ABANDONED_ALL in (1) then
                 IPCCCD.TIME_TO_ABANDONED
                else
                 NULL
              end))
       END AVG_TIME_TO_ABANDON,

       TRUNC(CASE
               WHEN IPCCCD.ANALYST = '-99999 ' THEN
                NULL
               ELSE
                AVG(IPCCCD.TIME_TO_ANSWER)
             END,
             9) ASA,
       TRUNC(CASE
               WHEN IPCCCD.ANALYST = '-99999 ' THEN
                NULL
               ELSE
                AVG(IPCCCD.TIME_TO_ANSWER / 86400)
             END,
             9) ASA_MM_SS,
       count((Case
               when IPCCCD.HANDLED_AGENT in (1) then
                IPCCCD.IPCC_SK
               else
                NULL
             end)) CALLSHANDLEDAGENT,
       count(distinct(Case
                        when IPCCCD.HANDLED_EXT_VOICEMAIL in (1) then
                         IPCCCD.IPCC_SK
                        else
                         NULL
                      end)) CALLSHANDLEDVOICEMAIL,
       CASE
         WHEN IPCCCD.HANDLETIME = '0' THEN
          NULL
         ELSE
          (IPCCCD.HANDLETIME)
       END HANDLETIME,
       CASE
         WHEN IPCCCD.HANDLETIME = '0' THEN
          NULL
         ELSE
          (IPCCCD.HANDLETIME / 86400)
       END HANDLETIME,
       IPCCCD.HANDLED_MEETING_SLA,
       (IPCCCD.HANDLEtime) HANDLE_TIME,
       (IPCCCD.HANDLEtime / 86400) HANDLE_TIME_HH_MM,
       (IPCCCD.HOLDTIME / 86400) HOLD_TIME,
       AGT.COUNTRY, 
       AGT.LOCATION
  FROM T_FCT_0030_IPCC_CALLDETAIL IPCCCD
  JOIN DW.T_DIM_DATE D_DATE
   ON (IPCCCD.BEGANROUTINGDATETIME_SK = D_DATE.DT_SK)
  JOIN DW.T_DIM_CALL_TYPE C_TYPE
   ON (IPCCCD.CALL_TYPE_SK = C_TYPE.CALL_TYPE_SK)
  JOIN DW.T_DIM_MEDIA_ROUTINE_DOMAIN DMRD
   ON (IPCCCD.MRDOMAIN_SK = DMRD.MRDOMAIN_SK)
  JOIN DW.T_DIM_IN_OUT DIO
   ON (IPCCCD.IN_OUT_SK = DIO.IN_OUT_SK)
  LEFT JOIN DW.T_DIM_AGENT AG
   ON IPCCCD.AGENT_SK = AG.AGENT_SK
  LEFT JOIN DW.T_DIM_AGENT_TEAM AGT
   ON AGT.AGENT_TEAM_SK = AG.AGENT_TEAM_SK
 WHERE D_DATE.DAY_DT between To_Date('01-01-2018', 'dd-mm-yyyy') and
       sysdate --To_Date('', 'dd-mm-yyyy') -- There is a variable that is being pass here
   AND C_TYPE.CORP_ID in ('') -- Variable here as well 
   AND (IPCCCD.OFFER in (1) OR IPCCCD.ABANDONED_HANGUP in (1) OR
       IPCCCD.INBOUND in (1) OR IPCCCD.HANDLED_AGENT in (1) OR
       IPCCCD.HANDLED_EXT_VOICEMAIL in (1) OR
       IPCCCD.F_OUTBOUND_CALL in (1) OR IPCCCD.F_RETURN_CALL in (1) OR
       IPCCCD.ABANDONED_ALL in (1) and
       DMRD.MEDIA_TYPE in ('Voice', 'Chat', 'Email') and
       DIO.IN_OUT_VALUE in ('INBOUND') and IPCCCD.ABANDONED_VALID in (1))
   and DMRD.MEDIA_TYPE in ('Voice')
 GROUP BY DAY_DT,
          BEGANROUTINGDATETIME,
          ANALYST,
          IPCC_SK,
          TIME_TO_ANSWER,
          HANDLETIME,
          IPCCCD.HANDLED_MEETING_SLA,
          HOLDTIME,
          AGT.COUNTRY, 
          AGT.LOCATION
 ORDER BY DAY_DT ASC, ANALYST ASC
