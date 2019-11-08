/***********************************************************************************
||   QUERY INFORMATION
||
||   Description: LOADS TABLE T_DM_EUE_INVENTORY
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

SELECT --distinct
       UPPER (poh.F_PART_NUMBER) AS F_PART_NUMBER,
       poh.F_PART_DESCRIPTION AS F_PART_DESCRIPTION,
       poh.F_REPAIR_TYPE AS F_REPAIR_TYPE,
       CASE WHEN poh.CUST_OWN = 'Y' THEN 1 ELSE 0 END AS F_CUST_OWN,
       poh.F_PART_GOOD_QTY AS F_PART_GOOD_QTY,
       poh.F_PART_BAD_QTY AS F_PART_BAD_QTY,
       poh.F_PART_GOOD_QTY + poh.F_PART_BAD_QTY AS F_TOTAL_QTY,
       poh.F_FIXED_AMT AS F_PART_COST,
       (poh.F_FIXED_AMT * (poh.F_PART_GOOD_QTY + poh.F_PART_BAD_QTY))
          AS F_TOTAL_COST,
       CASE
          WHEN poh.F_PRICE_PROG_NAME = 'Canadian Dollar' THEN (poh.F_FIXED_AMT * flex_number)
          ELSE poh.F_FIXED_AMT
       END
          AS F_CONVERTED_PART_COST,
       CASE
          WHEN poh.F_PRICE_PROG_NAME = 'Canadian Dollar'
          THEN
             (  (poh.F_FIXED_AMT * cad.flex_number)
              * (poh.F_PART_GOOD_QTY + poh.F_PART_BAD_QTY))
          ELSE
             ( (poh.F_PART_GOOD_QTY + poh.F_PART_BAD_QTY) * poh.F_FIXED_AMT)
       END
          AS F_CONVERTED_TOTAL_COST,
       poh.F_PRICE_PROG_NAME,
       poh.F_X_PART_CLASS_GROUP AS F_PART_CLASS_GROUP,
       poh.F_LOCATION_NAME AS F_LOCATION_NAME,
       poh.F_S_LOCATION_TYPE AS F_LOCATION_TYPE,
       upper(poh.F_X_LOC_CLASS) AS F_LOCATION_CLASS,
       case when fru.CUST_OWN = 'Y' then  fru.CUST_NAME else '' end  F_CUST_NAME,
       fru.PLANNER_CODE AS F_PLANNER_CODE,
       Case when crit_part.F_PART_NUMBER is not null then 1 else 0 end as F_Critical_Ind,
       FRU.F_Exclusion_Ind as F_Exclusion_Ind ,
      cad.flex_number as F_EXCHANGE_RATE,
       trunc(sysdate)-1 as F_BUSINESS_DATE,
       SYSDATE AS DW_LOAD_DATE,
       SYSDATE AS DW_MOD_DATE,
       nvl(fru.CUST_VALUE,0) as F_CUST_VALUE,
       nvl(crncy.F_SURROGATE_FK, -99999) as F_CURRENCY_SK,
       nvl(locgrp.F_LOC_CLASS_GROUP_SK, -99999) as F_LOC_CLASS_GROUP_SK,
       NVL (fru.partnum_objid, -99999) F_PARTNUM_OBJID
  FROM dw.T_DM_PARTS_ON_HAND poh, dw.T_DM_CLAR_FRU_PARTS fru,
       (SELECT F_SURROGATE_FK,
               CASE
                WHEN F_CURRENCY_ID = 'US DOLLAR' THEN 'United States Dollar'
                WHEN F_CURRENCY_ID = 'CANADIAN DOLLAR' THEN 'Canadian Dollar'
               END F_CURRENCY_CD
        FROM dw.T_DIM_CURRENCY
        WHERE F_CURRENCY_ID IN ('CANADIAN DOLLAR', 'US DOLLAR')
       ) crncy,
       (SELECT A.F_PART_NUMBER,
               CASE
                WHEN a.F_SET_OF_BOOKS = 'US' THEN 'United States Dollar'
                WHEN a.F_SET_OF_BOOKS = 'CA' THEN 'Canadian Dollar'
               END F_CURRENCY_CD
        FROM DW.T_LIST_PART_CRITICAL a
        WHERE f_end_date > trunc(sysdate) OR f_end_date is null
       ) crit_part,
       (SELECT trim(upper(F_CLARIFY_LOC_CLASS)) F_CLARIFY_LOC_CLASS,
               F_LOC_CLASS_GROUP_SK
        FROM dw.T_DIM_SVC_LOC_CLASS_GROUP
       ) locgrp,
       (SELECT flex_number
        FROM dw.MD_FLEX_XREF
        WHERE flex_area = 'PART_CONVERSION_RATE'
       ) cad
 WHERE poh.F_PART_NUMBER = fru.PART_NO(+)
 AND trim(poh.F_PRICE_PROG_NAME) = crncy.F_CURRENCY_CD(+)
 AND trim(upper(poh.F_X_LOC_CLASS)) = locgrp.F_CLARIFY_LOC_CLASS(+)
 AND poh.F_PART_NUMBER = crit_part.F_PART_NUMBER(+)
 AND trim(poh.F_PRICE_PROG_NAME) = crit_part.F_CURRENCY_CD(+);
