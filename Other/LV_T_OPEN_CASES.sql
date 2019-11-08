Select O.F_SVC_SITE_TEAM As SITE_TEAM,
       FCT.F_TECH_DISPATCHED_MGR_NAME As FIELD_SERVICE_MANAGER,
       O.F_SVC_SITE_CITY As SITE_SERVICE_CITY,
       O.X_CUST_ENT_CODE As SKU_ID,
       Upper(E.X_DESCRIPTION) As SKU_DESCRIPTION,
       Case
         When Upper(O.F_CASE_STATE) In ('OPEN-DISPATCH', 'OPEN') Then
          'OPEN'
         Else
          'CLOSED'
       End As CASE_STATE,
       Case
         When O.F_CASE_STATE Not Like 'CLOSED' Then
          'OPEN'
         When O.F_CASE_RESOLUTION_DESC In
              ('CANCEL/WORK STARTED', 'CANCELLED', 'DUPLICATE CASE') Then
          'CANCELED'
         Else
          'NOT CANCELED'
       End As Canceled,
       O.F_CASE_CREATED_DT As CASE_CRE_DT,
       O.F_SLA_ONSITE_SCHED_COMP_DT As SCHED_COMP_DT,
       O.F_CASE_CLOSED_D As CLOSE_DATE,
       Upper(O.F_CASE_ID) As CASE_ID,
       O.F_CUST_REFERENCE_ID As CUST_REF_NUMBER,
       Case
         When Upper(O.F_CASE_STATE) In ('OPEN-DISPATCH', 'OPEN') Then
          Trunc(SysDate - O.F_CASE_CREATED_D)
         Else
          O.F_CASE_CLOSED_D - O.F_CASE_CREATED_D
       End As DAYS_OPEN,
       Upper(O.F_CASE_STATUS) As CASE_STATUS,
       Case
         When O.F_X_EARLY_START = To_Date('01/01/1753', 'mm/dd/yyyy') Then
          Null
         Else
          O.F_X_EARLY_START
       End As APPT_WINDOW_START,
       Case
         When O.F_X_LATE_START = To_Date('01/01/1753', 'mm/dd/yyyy') Then
          Null
         Else
          O.F_X_LATE_START
       End As APPT_WINDOW_END,
       NVL(CL.F_FIRST_ETA_LOCAL, OP.F_FIRST_ETA_LOCAL) As FIRST_ETA,
       Case
         When O.F_X_LATE_START Is Null Or
              O.F_X_LATE_START = To_Date('01/01/1753', 'mm/dd/yyyy') Then
          Null
         When NVL(CL.F_FIRST_ETA_LOCAL, OP.F_FIRST_ETA_LOCAL) Is Null Then
          Null
         When NVL(CL.F_FIRST_ETA_LOCAL, OP.F_FIRST_ETA_LOCAL) <
              O.F_X_EARLY_START Then
          'Before'
         When NVL(CL.F_FIRST_ETA_LOCAL, OP.F_FIRST_ETA_LOCAL) >
              O.F_X_LATE_START Then
          'After'
         Else
          'Yes'
       End As ETA_in_Window,
       NVL(CL.F_FIRST_ONSITE_LOCAL, OP.F_FIRST_ONSITE_LOCAL) As FIRST_ONSITE_TIME,
       Case
         When O.F_X_LATE_START Is Null Or
              O.F_X_LATE_START = To_Date('01/01/1753', 'mm/dd/yyyy') Then
          Null
         When NVL(CL.F_FIRST_ONSITE_LOCAL, OP.F_FIRST_ONSITE_LOCAL) Is Null Then
          Null
         When NVL(CL.F_FIRST_ONSITE_LOCAL, OP.F_FIRST_ONSITE_LOCAL) <
              O.F_X_EARLY_START Then
          'Before'
         When NVL(CL.F_FIRST_ONSITE_LOCAL, OP.F_FIRST_ONSITE_LOCAL) >
              O.F_X_LATE_START Then
          'After'
         Else
          'Yes'
       End As Onsite_Time_in_Window,
       NVL(CL.F_LAST_ETA, OP.F_LAST_ETA) As LAST_ETA,
       O.F_CASE_LAST_MODIFIED_DT As LAST_MODIFIED_DT,
       Round(FCT.F_WORK_DURATION / 3600, 2) As WORK,
       Round(FCT.F_TRAVEL_DURATION / 3600, 2) As TRAVEL_TIME,
       FCT.F_MILEAGE As MILES,
       (Select Sum(DT.F_CLOSE_FTF)
          From t_dm_svc_fs_Detail DT
         Where DT.F_CASE_ID = O.F_CASE_ID) As FTF,
       FCT.F_TECH_DISPATCHED_NAME As F_RESOURCE_NAME,
       O.F_TECH_DISPATCHED_USER_ID As TECH_ID,
       O.F_CASE_SITE_CONTACT_NAME As CONTACT_NAME,
       O.F_CUST_SITE_CITY As CITY,
       O.F_CUST_SITE_STATE As STATE,
       O.F_CUST_SITE_ZIP As ZIP,
       O.F_CUST_SITE_ADDRESS_1 As ADDRESS,
       O.F_CASE_CONTACT_PHONE As CONTACT_PHONE,
       Upper((Select dbms_lob.substr(L.DESCRIPTION,
                                    (Instr(dbms_lob.substr(L.DESCRIPTION,
                                                           3000,
                                                           1),
                                           'Primary Contact Telephone Number:',
                                           1,
                                           1)) - (Instr(dbms_lob.substr(L.DESCRIPTION,
                                                                        3000,
                                                                        1),
                                                        'Email:',
                                                        1,
                                                        1) + 7),
                                    Instr(dbms_lob.substr(L.DESCRIPTION,
                                                          3000,
                                                          1),
                                          'Email:',
                                          1,
                                          1) + 7)
               From DW.T_CLAR_NOTES_LOG L
              Where L.CASE_NOTES2CASE = O.F_CASE_KEY
                And L.ACTION_TYPE = 'Inbound Prob Desc and Extra - ESR'
                And L.DESCRIPTION Like '%SKU%')) As EMAIL_ADDRESS,
       O.F_SVC_TECH_CITY As TECH_SERVICE_CITY,
       Upper(O.X_SERVICE_TYPE) As SVC_TYPE,
       Upper(O.F_CASE_REPAIR_CODE) As REPAIR_CODE,
       Upper(O.F_CAUSE_TTT_MISS) As CAUSE_TTT_MISS,
       Upper(O.F_DETAIL_TTT_MISS) As DETAIL_TTT_MISS,
       O.F_CUST_CORP_ID As CORP_ID,
       Upper(O.F_CASE_REPAIR_DESC) As CLOSING_REMARKS,
       (Select Sum(A3.X_QUANTITY)
          From DW.T_CLAR_INVOICE_HDR A2
         Inner Join DW.T_CLAR_INVOICE_DTL A3
            On A3.X_INV_DTL2X_INV_HDR = A2.OBJID
          Left Join DW.T_CLAR_X_INT_AR_HEADER A4
            On A2.X_ARHDROBJID = A4.OBJID
         Where O.F_CASE_KEY = A2.X_CASEOBJID
           And A3.X_LINETYPE = 'ACTIVITY'
           And A3.X_BILLABLE = 'Billable'
           And A2.X_SITEID Not Like 'TEMP_%'
           And A3.X_SUPPORT_PROG Not Like 'ODTS CANCEL'
           And A4.S_X_STATUS = 'CREATED') As SKU_COUNT
  From DW.T_CLAR_ODS_CASE O
  Left Join DW.T_CLAR_X_CUST_ENT_CODES E
    On O.X_CUST_ENT_CODE = E.X_CODE
 Inner Join DW.T_FCT_0050_CASE FCT
    On FCT.F_CASE_SK = O.F_CASE_KEY
  Left Join t_dm_cases_closed CL
    On CL.F_SOURCE_KEY = O.F_CASE_KEY
  Left Join t_dm_cases_open OP
    On OP.F_SOURCE_KEY = O.F_CASE_KEY
 Where O.F_CUST_CORP_ID = '243741'
   And O.F_CASE_RESOLUTION_DESC <> 'TRAINING CLASS'
   And (O.F_CASE_CLOSED_D Is Null Or O.F_CASE_CLOSED_D Is Not Null)
   And O.F_CASE_ID <> 'C180502-14213981'
   And (O.X_CUST_ENT_CODE <> '9361598' Or
       (Select Case When To_Char(SubStr(L.DESCRIPTION, 
                                      Instr(L.DESCRIPTION, 'SKU', 1, 1) + 5,
                                      Instr(SubStr(L.DESCRIPTION,
                                                   Instr(L.DESCRIPTION,
                                                         'SKU',
                                                         1,
                                                         1) + 5),
                                            ' ') - 1)) In
                       (Select DW.T_CLAR_X_CUST_ENT_CODES.X_CODE
                          From DW.T_CLAR_X_CUST_ENT_CODES
                         Where DW.T_CLAR_X_CUST_ENT_CODES.X_FLEX_FIELD Like
                               '243741%'
                           And DW.T_CLAR_X_CUST_ENT_CODES.X_CODE <> '9361598') Then
                   1
                  When To_Char(SubStr(L.DESCRIPTION,
                                      Instr(L.DESCRIPTION, 'SKU', 1, 2) + 5,
                                      Instr(SubStr(L.DESCRIPTION,
                                                   Instr(L.DESCRIPTION,
                                                         'SKU',
                                                         1,
                                                         2) + 5),
                                            ' ') - 1)) In
                       (Select DW.T_CLAR_X_CUST_ENT_CODES.X_CODE
                          From DW.T_CLAR_X_CUST_ENT_CODES
                         Where DW.T_CLAR_X_CUST_ENT_CODES.X_FLEX_FIELD Like
                               '243741%'
                           And DW.T_CLAR_X_CUST_ENT_CODES.X_CODE <> '9361598') Then
                   1
                  When To_Char(SubStr(L.DESCRIPTION,
                                      Instr(L.DESCRIPTION, 'SKU', 1, 3) + 5,
                                      Instr(SubStr(L.DESCRIPTION,
                                                   Instr(L.DESCRIPTION,
                                                         'SKU',
                                                         1,
                                                         3) + 5),
                                            ' ') - 1)) In
                       (Select DW.T_CLAR_X_CUST_ENT_CODES.X_CODE
                          From DW.T_CLAR_X_CUST_ENT_CODES
                         Where DW.T_CLAR_X_CUST_ENT_CODES.X_FLEX_FIELD Like
                               '243741%'
                           And DW.T_CLAR_X_CUST_ENT_CODES.X_CODE <> '9361598') Then
                   1
                  Else
                   0
                End
           From DW.T_CLAR_NOTES_LOG L
          Where L.ACTION_TYPE = 'Inbound Prob Desc and Extra - ESR'
            And L.DESCRIPTION Like '%SKU%'
            And L.CASE_NOTES2CASE = O.F_CASE_KEY) > 1)

-------------------------------------------------------------- new logic adding with 
--using a with 
--using a regex example
--select instr('SSSRNNSRSSR','R', 1, level) from dual connect by level <= 3--regexp_count('SSSRNNSRSSR', 'R')
--do an analysis of the date range we are using and from that cut off the table scan including a where clouse 

WITH cte AS
(
  Select DW.T_CLAR_X_CUST_ENT_CODES.X_CODE AS col1
  From DW.T_CLAR_X_CUST_ENT_CODES
  Where DW.T_CLAR_X_CUST_ENT_CODES.X_FLEX_FIELD Like '243741%'
   And DW.T_CLAR_X_CUST_ENT_CODES.X_CODE <> '9361598'
)
SELECT O.F_CUST_CORP_ID As CORP_ID,
     Upper(O.F_CASE_REPAIR_DESC) As CLOSING_REMARKS
From DW.T_CLAR_ODS_CASE O
  Left Join DW.T_CLAR_X_CUST_ENT_CODES E
    On O.X_CUST_ENT_CODE = E.X_CODE
 Inner Join DW.T_FCT_0050_CASE FCT
    On FCT.F_CASE_SK = O.F_CASE_KEY
  Left Join t_dm_cases_closed CL
    On CL.F_SOURCE_KEY = O.F_CASE_KEY
  Left Join t_dm_cases_open OP
    On OP.F_SOURCE_KEY = O.F_CASE_KEY
 Where O.F_CUST_CORP_ID = '243741'
   And O.F_CASE_RESOLUTION_DESC <> 'TRAINING CLASS'
   And (O.F_CASE_CLOSED_D Is Null Or O.F_CASE_CLOSED_D Is Not Null)
   And O.F_CASE_ID <> 'C180502-14213981'
   And (O.X_CUST_ENT_CODE <> '9361598' Or
       (
     --dbms_lob.substr(L.DESCRIPTION,32767)
     --instr('SSSRNNSRSSR','R', 1, level) from dual connect by level <= 3--regexp_count('SSSRNNSRSSR', 'R')
       Select Case When To_Char(SubStr(L.DESCRIPTION, 
                                      Instr(L.DESCRIPTION, 'SKU', 1, level) + 5,
                                      Instr(SubStr(L.DESCRIPTION,
                                                   Instr(L.DESCRIPTION,'SKU',1, level) + 5),
                                            ' ') - 1)) In
                       (Select col1 from cte) Then
                   1

       /*Select Case When To_Char(SubStr(L.DESCRIPTION, 
                                      Instr(L.DESCRIPTION, 'SKU', 1, 1) + 5,
                                      Instr(SubStr(L.DESCRIPTION,
                                                   Instr(L.DESCRIPTION,'SKU',1, 1) + 5),
                                            ' ') - 1)) In
                       (Select col1 from cte) Then
                   1
                  When To_Char(SubStr(L.DESCRIPTION,
                                      Instr(L.DESCRIPTION, 'SKU', 1, 2) + 5,
                                      Instr(SubStr(L.DESCRIPTION,
                                                   Instr(L.DESCRIPTION,'SKU',1, 2) + 5),
                                            ' ') - 1)) In
                       (Select col1 from cte) Then
                   1
                  When To_Char(SubStr(L.DESCRIPTION,
                                      Instr(L.DESCRIPTION, 'SKU', 1, 3) + 5,
                                      Instr(SubStr(L.DESCRIPTION,
                                                   Instr(L.DESCRIPTION,'SKU',1, 3) + 5),
                                            ' ') - 1)) In
                       (Select col1 from cte) Then
                   1*/
                  Else
                   0
                End
           From DW.T_CLAR_NOTES_LOG L
          Where L.ACTION_TYPE = 'Inbound Prob Desc and Extra - ESR'
            And L.DESCRIPTION Like '%SKU%'
            And L.CASE_NOTES2CASE = O.F_CASE_KEY
      CONNECT BY LEVEL <= 3) > 1)