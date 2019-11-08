/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           04/03/2018
||   Category:       Table creation
||
||   Description:    Creates table T_DM_ENTDASH_SN_PROBLEM
||
||   Parameters:     None
||
||   Historic Info:
||    Name:              Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes        05/23/2018   Initial Creation
||   luis Fuentes        05/24/2018   Adding ci_name
||   luis Fuentes        05/24/2018   Adding sys_class_name
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

BEGIN
  DW.SP_TRUNCATE('DW.T_DM_ENTDASH_SN_PROBLEM');
END;

INSERT INTO DW.T_DM_ENTDASH_SN_PROBLEM@DWDEV.WORLD
(
   company_sk
  ,open_dt
  ,close_dt
  ,contact_type_sk
  ,group_sk
  ,ci_name
  ,NoOfInc
  ,sys_class_name
  ,resolvedSameDay
  ,IncLv1
  ,IncLv2
  ,IncLv3
  ,IncLv4
)
SELECT COALESCE(COMP.company_sk,-99999) AS company_sk
      ,COALESCE(DT_OP.dt_sk,-99999)  AS open_dt
      ,COALESCE(DT_C.dt_sk,-99999) AS close_dt
      ,COALESCE(C.contact_type_sk,-99999) AS contact_type_sk
      ,COALESCE(GRP.group_sk, -99999) AS group_sk
      ,PR.configuration_item AS ci_name
      ,COUNT(DISTINCT PR.snumber) AS NoOfInc
      ,'problem' AS sys_class_name
      ,SUM(CASE WHEN DT_OP.dt_sk = DT_C.dt_sk THEN 1 ELSE 0 END) AS resolvedSameDay
      ,SUM(CASE WHEN GRP.level_num = 1 THEN 1 ELSE 0 END) AS IncLv1
      ,SUM(CASE WHEN GRP.level_num = 2 THEN 1 ELSE 0 END) AS IncLv2
      ,SUM(CASE WHEN GRP.level_num = 3 THEN 1 ELSE 0 END) AS IncLv3
      ,SUM(CASE WHEN GRP.level_num = 4 THEN 1 ELSE 0 END) AS IncLv4
FROM DW.T_DM_SNOW_PROBLEM PR
LEFT JOIN DW.T_DIM_COMPANY COMP
 ON COMP.name = PR.company
LEFT JOIN DW.T_DIM_DATE DT_OP
 ON DT_OP.day_dt = To_date(PR.opened_date)
LEFT JOIN DW.T_DIM_DATE DT_C
 ON DT_C.day_dt = To_date(PR.closed_date)
LEFT JOIN DW.T_DIM_CONTACT_TYPE C
 ON LOWER(C.CONTACT_TYPE) = COALESCE(LOWER(PR.contact_type),'')
LEFT JOIN DW.T_DIM_GROUP GRP
 ON GRP.NAME = PR.assignment_group
 -- WHERE dt_op BETWEEN between To_Date('01-01-2017', 'dd-mm-yyyy') and To_Date(SYSDATE)
GROUP BY COALESCE(COMP.company_sk,-99999)
        ,COALESCE(DT_OP.dt_sk,-99999)
        ,COALESCE(DT_C.dt_sk,-99999)
        ,COALESCE(C.contact_type_sk,-99999)
        ,COALESCE(GRP.group_sk, -99999)
        ,PR.configuration_item;
COMMIT;
