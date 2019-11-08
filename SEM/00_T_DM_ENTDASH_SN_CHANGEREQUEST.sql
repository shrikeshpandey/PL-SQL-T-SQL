/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           29/05/2018
||   Category:       Table creation
||
||   Description:    Creates table DW.T_DM_ENTDASH_SN_CHANGEREQUEST
||
||   Parameters:     None
||
||   Historic Info:
||    Name:              Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes        05/23/2018   Initial Creation
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

BEGIN
  DW.SP_TRUNCATE('DW.T_DM_ENTDASH_SN_CHANGEREQUEST');
END;

INSERT INTO DW.T_DM_ENTDASH_SN_CHANGEREQUEST@DWDEV.WORLD
(
   company_sk
  ,open_dt_sk
  ,close_dt_sk
  ,contact_type_sk
  ,group_sk
  ,ci_name
  ,phase_state
  ,no_of_inc
  ,sys_class_name
  ,resolved_same_day
  ,inc_lv1
  ,inc_lv2
  ,inc_lv3
  ,inc_lv4
)
SELECT COALESCE(CMP.company_sk,-99999)                            AS company_sk
      ,COALESCE(DT_OP.dt_sk,-99999)                               AS open_dt_sk
      ,COALESCE(DT_C.dt_sk,-99999)                                AS close_dt_sk
      ,COALESCE(C.contact_type_sk,-99999)                         AS contact_type_sk
      ,COALESCE(GRP.group_sk, -99999)                             AS group_sk
      ,COALESCE(CHG.configuration_item, '')                       AS ci_name
      ,COALESCE(CHG.phase_state,'')                               AS phase_state
      ,COUNT(DISTINCT CHG.snumber)                                AS no_of_inc
      ,'change_request'                                           AS sys_class_name
      ,SUM(CASE WHEN DT_OP.dt_sk = DT_C.dt_sk THEN 1 ELSE 0 END)  AS resolved_same_day
      ,SUM(CASE WHEN GRP.level_num = 1 THEN 1 ELSE 0 END)         AS inc_lv1
      ,SUM(CASE WHEN GRP.level_num = 2 THEN 1 ELSE 0 END)         AS inc_lv2
      ,SUM(CASE WHEN GRP.level_num = 3 THEN 1 ELSE 0 END)         AS inc_lv3
      ,SUM(CASE WHEN GRP.level_num = 4 THEN 1 ELSE 0 END)         AS inc_lv4
FROM DW.T_DM_SNOW_CHANGE_REQUEST CHG
LEFT JOIN DW.T_DIM_COMPANY CMP
 ON CMP.name = CHG.company
LEFT JOIN DW.T_DIM_DATE DT_OP
 ON DT_OP.day_dt = To_date(CHG.created_date)
LEFT JOIN DW.T_DIM_DATE DT_C
 ON DT_C.day_dt = To_date( CHG.closed_date)
LEFT JOIN DW.T_DIM_CONTACT_TYPE C
 ON LOWER(C.contact_type) = COALESCE(LOWER(CHG.contact_type),'')
LEFT JOIN DW.T_DIM_GROUP GRP
 ON GRP.name = CHG.closed_by_group
GROUP BY COALESCE(CMP.company_sk,-99999)
        ,COALESCE(DT_OP.dt_sk,-99999)
        ,COALESCE(DT_C.dt_sk,-99999)
        ,COALESCE(C.contact_type_sk,-99999)
        ,COALESCE(GRP.group_sk, -99999)
        ,COALESCE(CHG.configuration_item, '')
        ,COALESCE(CHG.phase_state,'');

COMMIT;
