/***********************************************************************************
||   QUERY INFORMATION
||
||   Description: LOADS TABLE T_DM_CLAR_FRU_PARTS
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

Select
-->>>>>>
PARTNUM.S_PART_NUMBER                     AS "PART_NO",
PARTNUM.OBJID                             AS PARTNUM_OBJID,
PARTNUM.S_DESCRIPTION                     AS "PART_DESC",
PARTNUM.S_DOMAIN                          AS "DOMAIN",
--SOSYST.S_X_SOURCE_SYSTEM                  AS "SRCE_SYST",
--SOSYST.X_LOAD_DATE                        AS "SRCE_SYST_LOAD_DATE",
PARTNUM.S_MODEL_NUM                       AS "PART_MODEL_NO" ,
PARTNUM.ACTIVE                            AS "PART_STATUS",
PARTNUM.STD_WARRANTY                      AS "PART_WTY",
PARTNUM.WARR_START_KEY                    AS "WTY_START", /* 0=SHIP DATE or 1=INSTALL DATE to description (which way?) - Indicates whether warranty starts from shipment or installation */
PARTNUM.UNIT_MEASURE                      AS "UOM",
DECODE(PARTNUM.SN_TRACK,'0','BY QTY','1','BY SERIAL') AS TRACK_BY /*remap to description - all appear=0 - Track part for serialization; i.e., 0=by quantity, 1=by serial number */,
PARTNUM.S_FAMILY                          AS "PROD_FAM",
PARTNUM.S_LINE                            AS "PROD_LINE",
PARTNUM.REPAIR_TYPE,
PARTNUM.PART_TYPE,
PARTNUM.WEIGHT                            AS "WGHT", /*convert to Numeric field*/ ---PARTNUM.DIMENSION,
PARTNUM.DOM_SERIALNO, --0=no SN, 1=Unique, 2=Unique for Part, 3=not unique
PARTNUM.X_OEM ,  -- yes ok
PARTNUM.X_KIT, -- yes ok
DECODE(PARTNUM.X_CONSUMABLE,'1','Y','0','N') AS "OEM_CUST_REPLACE" /*remap 1=Yes, 0=No description*/,
PARTNUM.S_X_FRENCH_PART_DESC                 as "PART_DESC2",
PARTNUM.PART_NUM2PART_CLASS                  AS "PART_CLASS_OBJID",
DECODE(PARTNUM.X_WHOLE_UNIT,'1','Y','0','N') AS WHOLE_UNIT        /*remap 1=Yes, 0=No description*/,
PARTNUM.X_PREF_ORDER_TYPE                    as PREF_ORDER_TYPE,
PARTNUM.X_PRIMARY_USE                        as PRIMARY_USE,
PARTNUM.X_CREATION_DATE                      as "PN_CREATE_DT",
PARTNUM.X_LAST_MODIFIED_DT                   as "PN_LAST_MOD_DT",
DECODE(PARTNUM.IS_DOM_AT_BUS_ORG,'1','Y','0','N') AS IS_DOM_AT_BUS_ORG,   -- ok 0=no, 1=yes
DECODE(PARTNUM.X_INTANGIBLE,'1','Y','0','N')      AS INTANGIBLE     /*remap to description - Indicates whether the part is intangible or not; 0=no, 1=yes */,
DECODE(PARTNUM.X_CUSTOMER_OWNED,'1','Y','0','N', 'N')  AS CUST_OWN,      /*remap 1=Yes, 0=No description*/
PARTNUM.X_CUSTOMER_VALUE                          AS "CUST_VALUE",  /* remap to number(11,2)*/
PARTNUM.CUSTOMER                                  as "CUST_NAME",
PARTNUM.S_X_planner_code                          as PLANNER_CODE,
PARTNUM.x_manufacturer                            as "CUST_MFG",
PARTNUM.S_X_SERVICE_TYPE                          as SERVICE_TYPE,
PARTCLS.F_PART_CLASS_ID                           as "PART_CLASS",
PARTCLS.F_PART_CLASS_DESCR                        as PART_CLASS_DESCR ,
PARTCLS.F_X_PART_CLASS_GROUP                      as PART_CLASS_GROUP,
PARTCLS.F_NAME                                    as "PART_CLASS_NAME",
PARTCLS.X_SIMSG_BRAND_CODE                        AS SIMSG_CODE,
--two new PARTCLS fields  >>>>
PARTCLS.X_US_DIMS_VENDOR_ID                       AS US_DIMS_VEND,
PARTCLS.X_CA_DIMS_VENDOR_ID                       AS CA_DIMS_VEND,
-----  Price List Logic
UPPER(COP11.F_PRICE_PROG_NAME) AS PROG_NAME_US_AVG_COST,   UPPER(COP11.F_CURRENCY_NAME) AS CURRENCY_US_AVG_COST,   COP11.F_PRICE_INST_EFF_DT AS EFFECT_DT_US_AVG_COST,    COP11.F_PRICE_INST_EXP_DT AS EXPIRE_DT_US_AVG_COST,    COP11.F_PRICE AS US_AVG_COST,
UPPER(COP21.F_PRICE_PROG_NAME) AS PROG_NAME_US_PRICE,      UPPER(COP21.F_CURRENCY_NAME) AS CURRENCY_US_PRICE,      COP21.F_PRICE_INST_EFF_DT AS EFFECT_DT_US_PRICE,       COP21.F_PRICE_INST_EXP_DT AS EXPIRE_DT_US_PRICE,       COP21.F_PRICE AS US_PRICE,
UPPER(COP31.F_PRICE_PROG_NAME) AS PROG_NAME_US_EXCH_COST,  UPPER(COP31.F_CURRENCY_NAME) AS CURRENCY_US_EXCH_COST,  COP31.F_PRICE_INST_EFF_DT AS EFFECT_DT_US_EXCH_COST,   COP31.F_PRICE_INST_EXP_DT AS EXPIRE_DT_US_EXCH_COST,   COP31.F_PRICE AS US_EXCH_COST,
UPPER(COP41.F_PRICE_PROG_NAME) AS PROG_NAME_US_EXCH_PRICE, UPPER(COP41.F_CURRENCY_NAME) AS CURRENCY_US_EXCH_PRICE, COP41.F_PRICE_INST_EFF_DT AS EFFECT_DT_US_EXCH_PRICE,  COP41.F_PRICE_INST_EXP_DT AS EXPIRE_DT_US_EXCH_PRICE,  COP41.F_PRICE AS US_EXCH_PRICE,
UPPER(COP51.F_PRICE_PROG_NAME) AS PROG_NAME_CA_AVG_COST,   UPPER(COP51.F_CURRENCY_NAME) AS CURRENCY_CA_AVG_COST,   COP51.F_PRICE_INST_EFF_DT AS EFFECT_DT_CA_AVG_COST,    COP51.F_PRICE_INST_EXP_DT AS EXPIRE_DT_CA_AVG_COST,    COP51.F_PRICE AS CA_AVG_COST,
UPPER(COP61.F_PRICE_PROG_NAME) AS PROG_NAME_CA_PRICE,      UPPER(COP61.F_CURRENCY_NAME) AS CURRENCY_CA_PRICE,      COP61.F_PRICE_INST_EFF_DT AS EFFECT_DT_CA_PRICE,       COP61.F_PRICE_INST_EXP_DT AS EXPIRE_DT_CA_PRICE,       COP61.F_PRICE AS CA_PRICE,
UPPER(COP71.F_PRICE_PROG_NAME) AS PROG_NAME_CA_EXCH_COST,  UPPER(COP71.F_CURRENCY_NAME) AS CURRENCY_CA_EXCH_COST,  COP71.F_PRICE_INST_EFF_DT AS EFFECT_DT_CA_EXCH_COST,   COP71.F_PRICE_INST_EXP_DT AS EXPIRE_DT_CA_EXCH_COST,   COP71.F_PRICE AS CA_EXCH_COST,
UPPER(COP81.F_PRICE_PROG_NAME) AS PROG_NAME_CA_EXCH_PRICE, UPPER(COP81.F_CURRENCY_NAME) AS CURRENCY_CA_EXCH_PRICE, COP81.F_PRICE_INST_EFF_DT AS EFFECT_DT_CA_EXCH_PRICE,  COP81.F_PRICE_INST_EXP_DT AS EXPIRE_DT_CA_EXCH_PRICE,  COP81.F_PRICE AS CA_EXCH_PRICE,
UPPER(COP91.F_PRICE_PROG_NAME) AS PROG_NAME_US_REP_COST,   UPPER(COP91.F_CURRENCY_NAME) AS CURRENCY_US_REP_COST,   COP91.F_PRICE_INST_EFF_DT AS EFFECT_DT_US_REP_COST,    COP91.F_PRICE_INST_EXP_DT AS EXPIRE_DT_US_REP_COST,    COP91.F_PRICE AS US_REP_COST,
UPPER(COP101.F_PRICE_PROG_NAME) AS PROG_NAME_US_REP_PRICE, UPPER(COP101.F_CURRENCY_NAME) AS CURRENCY_US_REP_PRICE, COP101.F_PRICE_INST_EFF_DT AS EFFECT_DT_US_REP_PRICE,  COP101.F_PRICE_INST_EXP_DT AS EXPIRE_DT_US_REP_PRICE,  COP101.F_PRICE AS US_REP_PRICE,
UPPER(COP111.F_PRICE_PROG_NAME) AS PROG_NAME_CA_REP_COST,  UPPER(COP111.F_CURRENCY_NAME) AS CURRENCY_CA_REP_COST,  COP111.F_PRICE_INST_EFF_DT AS EFFECT_DT_CA_REP_COST,   COP111.F_PRICE_INST_EXP_DT AS EXPIRE_DT_CA_REP_COST,   COP111.F_PRICE AS CA_REP_COST,
UPPER(COP121.F_PRICE_PROG_NAME) AS PROG_NAME_CA_REP_PRICE, UPPER(COP121.F_CURRENCY_NAME) AS CURRENCY_CA_REP_PRICE, COP121.F_PRICE_INST_EFF_DT AS EFFECT_DT_CA_REP_PRICE,  COP121.F_PRICE_INST_EXP_DT AS EXPIRE_DT_CA_REP_PRICE,  COP121.F_PRICE AS CA_REP_PRICE,
Sysdate AS DW_LOAD_DATE,
Sysdate DW_MOD_DATE,
-- Add new Column for T_DM_CLAR_FRU_PARTS table, 3/22 CJ
MODLEV.OBJID AS MODLEVEL_OBJID, --
--- Add new columns in T_DM_CLAR_FRU_PARTS table for BAXTER, 09/15/2014 AW
PARTNUM.X_BAXTER_PLAN				AS X_BAXTER_PLAN,
PARTNUM.X_PRIME_FLAG				AS X_PRIME_FLAG,
--- Add new columns in T_DM_CLAR_FRU_PARTS table per INC13206238 by Cathy Allen, 08/06/2015
PARTNUM.S_FAMILY				AS S_FAMILY,
PARTNUM.S_LINE					AS S_LINE,
--Added 4/1/16 for EUE reporting, Mahender
--Case when CR_IND.F_PART_NUMBER is not null then 1 else 0 end as F_Critical_Ind,
Case when exl_ind.F_PART_NUMBER is not null then 1 else 0 end as F_Exclusion_Ind,
PARTNUM.X_COMPONENT_FLAG   AS X_COMPONENT_FLAG

FROM 	  DW.T_CLAR_PART_NUM	PARTNUM, DW.T_CLAR_MOD_LEVEL MODLEV, DW.T_CLAR_PART_CLASS PARTCLS, dw.T_LIST_PART_EXCLUSION exl_ind
 -- ,(select distinct F_PART_NUMBER from dw.T_LIST_PART_CRITICAL) cr_ind --6/1/2016 Mahender
--  ,DW.T_CLAR_X_PN_SOURCE_SYS	SOSYST
,(SELECT COP12.F_PRICE_INST_EXP_DT, COP12.F_PART_NUMBER,F_PRICE, COP12.F_CURRENCY_NAME, COP12.F_PRICE_INST_EFF_DT, COP12.F_PART_NUM_OBJID, COP12.F_PRICE_PROG_NAME
       FROM DW.T_DM_CLAR_OPTIONS COP12
            ,  (SELECT MAX(F_PRICE_INST_EXP_DT) as F_PRICE_INST_EXP_DT, F_PART_NUM_OBJID, F_PRICE_PROG_NAME, F_PART_NUMBER
                  FROM DW.T_DM_CLAR_OPTIONS
                WHERE F_PRICE_PROG_NAME = 'US Standard Cost' AND F_PART_DOMAIN = 'FRU' AND F_ACTIVE = 'Active'
                  AND F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
                GROUP BY F_PART_NUM_OBJID, F_PRICE_PROG_NAME,F_PART_NUMBER) COP13
        WHERE COP12.F_PRICE_INST_EXP_DT  = COP13.F_PRICE_INST_EXP_DT
          AND COP12.F_PART_NUM_OBJID     = COP13.F_PART_NUM_OBJID
          AND COP12.F_PRICE_PROG_NAME    = COP13.F_PRICE_PROG_NAME
        --AND COP12.F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
   ) COP11
,(SELECT COP22.F_PRICE_INST_EXP_DT, COP22.F_PART_NUMBER,F_PRICE, COP22.F_CURRENCY_NAME, COP22.F_PRICE_INST_EFF_DT, COP22.F_PART_NUM_OBJID, COP22.F_PRICE_PROG_NAME
       FROM DW.T_DM_CLAR_OPTIONS COP22
            ,  (SELECT MAX(F_PRICE_INST_EXP_DT) as F_PRICE_INST_EXP_DT, F_PART_NUM_OBJID, F_PRICE_PROG_NAME, F_PART_NUMBER
                  FROM DW.T_DM_CLAR_OPTIONS
                WHERE F_PRICE_PROG_NAME = 'US Std Price' AND F_PART_DOMAIN = 'FRU' AND F_ACTIVE = 'Active'
                  AND F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
                GROUP BY F_PART_NUM_OBJID, F_PRICE_PROG_NAME,F_PART_NUMBER) COP23
        WHERE COP22.F_PRICE_INST_EXP_DT  = COP23.F_PRICE_INST_EXP_DT
          AND COP22.F_PART_NUM_OBJID     = COP23.F_PART_NUM_OBJID
          AND COP22.F_PRICE_PROG_NAME    = COP23.F_PRICE_PROG_NAME
        --AND COP22.F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
   ) COP21
,(SELECT COP32.F_PRICE_INST_EXP_DT, COP32.F_PART_NUMBER,F_PRICE, COP32.F_CURRENCY_NAME, COP32.F_PRICE_INST_EFF_DT, COP32.F_PART_NUM_OBJID, COP32.F_PRICE_PROG_NAME
       FROM DW.T_DM_CLAR_OPTIONS COP32
            ,  (SELECT MAX(F_PRICE_INST_EXP_DT) as F_PRICE_INST_EXP_DT, F_PART_NUM_OBJID, F_PRICE_PROG_NAME, F_PART_NUMBER
                FROM DW.T_DM_CLAR_OPTIONS
                WHERE F_PRICE_PROG_NAME = 'US Exchange Cost' AND F_PART_DOMAIN = 'FRU' AND F_ACTIVE = 'Active'
                 AND F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
                GROUP BY F_PART_NUM_OBJID, F_PRICE_PROG_NAME,F_PART_NUMBER
							  ) COP33
        WHERE COP32.F_PRICE_INST_EXP_DT  = COP33.F_PRICE_INST_EXP_DT
          AND COP32.F_PART_NUM_OBJID     = COP33.F_PART_NUM_OBJID
          AND COP32.F_PRICE_PROG_NAME    = COP33.F_PRICE_PROG_NAME
        --AND COP32.F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
   ) COP31
,(SELECT COP42.F_PRICE_INST_EXP_DT, COP42.F_PART_NUMBER,F_PRICE, COP42.F_CURRENCY_NAME, COP42.F_PRICE_INST_EFF_DT, COP42.F_PART_NUM_OBJID, COP42.F_PRICE_PROG_NAME
       FROM DW.T_DM_CLAR_OPTIONS COP42
            ,  (SELECT MAX(F_PRICE_INST_EXP_DT) as F_PRICE_INST_EXP_DT, F_PART_NUM_OBJID, F_PRICE_PROG_NAME, F_PART_NUMBER
                  FROM DW.T_DM_CLAR_OPTIONS
                WHERE F_PRICE_PROG_NAME = 'US Exchange Price' AND F_PART_DOMAIN = 'FRU' AND F_ACTIVE = 'Active'
                  AND F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
                GROUP BY F_PART_NUM_OBJID, F_PRICE_PROG_NAME,F_PART_NUMBER) COP43
        WHERE COP42.F_PRICE_INST_EXP_DT  = COP43.F_PRICE_INST_EXP_DT
          AND COP42.F_PART_NUM_OBJID     = COP43.F_PART_NUM_OBJID
          AND COP42.F_PRICE_PROG_NAME    = COP43.F_PRICE_PROG_NAME
        --AND COP42.F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
   ) COP41
,(SELECT COP52.F_PRICE_INST_EXP_DT, COP52.F_PART_NUMBER,F_PRICE, COP52.F_CURRENCY_NAME, COP52.F_PRICE_INST_EFF_DT, COP52.F_PART_NUM_OBJID, COP52.F_PRICE_PROG_NAME
       FROM DW.T_DM_CLAR_OPTIONS COP52
            ,  (SELECT MAX(F_PRICE_INST_EXP_DT) as F_PRICE_INST_EXP_DT, F_PART_NUM_OBJID, F_PRICE_PROG_NAME, F_PART_NUMBER
                  FROM DW.T_DM_CLAR_OPTIONS
                WHERE F_PRICE_PROG_NAME = 'CA Standard Cost' AND F_PART_DOMAIN = 'FRU' AND F_ACTIVE = 'Active'
                  AND F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
                GROUP BY F_PART_NUM_OBJID, F_PRICE_PROG_NAME,F_PART_NUMBER) COP53
        WHERE COP52.F_PRICE_INST_EXP_DT  = COP53.F_PRICE_INST_EXP_DT
          AND COP52.F_PART_NUM_OBJID     = COP53.F_PART_NUM_OBJID
          AND COP52.F_PRICE_PROG_NAME    = COP53.F_PRICE_PROG_NAME
        --AND COP52.F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
   ) COP51
,(SELECT COP62.F_PRICE_INST_EXP_DT, COP62.F_PART_NUMBER,F_PRICE, COP62.F_CURRENCY_NAME, COP62.F_PRICE_INST_EFF_DT, COP62.F_PART_NUM_OBJID, COP62.F_PRICE_PROG_NAME
       FROM DW.T_DM_CLAR_OPTIONS COP62
            ,  (SELECT MAX(F_PRICE_INST_EXP_DT) as F_PRICE_INST_EXP_DT, F_PART_NUM_OBJID, F_PRICE_PROG_NAME, F_PART_NUMBER
                  FROM DW.T_DM_CLAR_OPTIONS
                WHERE F_PRICE_PROG_NAME = 'CA Std Price' AND F_PART_DOMAIN = 'FRU' AND F_ACTIVE = 'Active'
                  AND F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
                GROUP BY F_PART_NUM_OBJID, F_PRICE_PROG_NAME,F_PART_NUMBER) COP63
        WHERE COP62.F_PRICE_INST_EXP_DT  = COP63.F_PRICE_INST_EXP_DT
          AND COP62.F_PART_NUM_OBJID     = COP63.F_PART_NUM_OBJID
          AND COP62.F_PRICE_PROG_NAME    = COP63.F_PRICE_PROG_NAME
        --AND COP62.F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
   ) COP61
,(SELECT COP72.F_PRICE_INST_EXP_DT, COP72.F_PART_NUMBER,F_PRICE, COP72.F_CURRENCY_NAME, COP72.F_PRICE_INST_EFF_DT, COP72.F_PART_NUM_OBJID, COP72.F_PRICE_PROG_NAME
       FROM DW.T_DM_CLAR_OPTIONS COP72
            ,  (SELECT MAX(F_PRICE_INST_EXP_DT) as F_PRICE_INST_EXP_DT, F_PART_NUM_OBJID, F_PRICE_PROG_NAME, F_PART_NUMBER
                  FROM DW.T_DM_CLAR_OPTIONS
                WHERE F_PRICE_PROG_NAME = 'CA Exchange Cost' AND F_PART_DOMAIN = 'FRU' AND F_ACTIVE = 'Active'
                  AND F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
                GROUP BY F_PART_NUM_OBJID, F_PRICE_PROG_NAME,F_PART_NUMBER) COP73
        WHERE COP72.F_PRICE_INST_EXP_DT  = COP73.F_PRICE_INST_EXP_DT
          AND COP72.F_PART_NUM_OBJID     = COP73.F_PART_NUM_OBJID
          AND COP72.F_PRICE_PROG_NAME    = COP73.F_PRICE_PROG_NAME
        --AND COP72.F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
   ) COP71
,(SELECT COP82.F_PRICE_INST_EXP_DT, COP82.F_PART_NUMBER,F_PRICE, COP82.F_CURRENCY_NAME, COP82.F_PRICE_INST_EFF_DT, COP82.F_PART_NUM_OBJID, COP82.F_PRICE_PROG_NAME
       FROM DW.T_DM_CLAR_OPTIONS COP82
            ,  (SELECT MAX(F_PRICE_INST_EXP_DT) as F_PRICE_INST_EXP_DT, F_PART_NUM_OBJID, F_PRICE_PROG_NAME, F_PART_NUMBER
                  FROM DW.T_DM_CLAR_OPTIONS
                WHERE F_PRICE_PROG_NAME = 'CA Exchange Price' AND F_PART_DOMAIN = 'FRU' AND F_ACTIVE = 'Active'
                  AND F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
                GROUP BY F_PART_NUM_OBJID, F_PRICE_PROG_NAME,F_PART_NUMBER) COP83
        WHERE COP82.F_PRICE_INST_EXP_DT  = COP83.F_PRICE_INST_EXP_DT
          AND COP82.F_PART_NUM_OBJID     = COP83.F_PART_NUM_OBJID
          AND COP82.F_PRICE_PROG_NAME    = COP83.F_PRICE_PROG_NAME
        --AND COP82.F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
   ) COP81
,(SELECT COP92.F_PRICE_INST_EXP_DT, COP92.F_PART_NUMBER,F_PRICE, COP92.F_CURRENCY_NAME, COP92.F_PRICE_INST_EFF_DT, COP92.F_PART_NUM_OBJID, COP92.F_PRICE_PROG_NAME
       FROM DW.T_DM_CLAR_OPTIONS COP92
            ,  (SELECT MAX(F_PRICE_INST_EXP_DT) as F_PRICE_INST_EXP_DT, F_PART_NUM_OBJID, F_PRICE_PROG_NAME, F_PART_NUMBER
                  FROM DW.T_DM_CLAR_OPTIONS
                WHERE F_PRICE_PROG_NAME = 'US Repair Cost' AND F_PART_DOMAIN = 'FRU' AND F_ACTIVE = 'Active'
                  AND F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
                GROUP BY F_PART_NUM_OBJID, F_PRICE_PROG_NAME,F_PART_NUMBER) COP93
        WHERE COP92.F_PRICE_INST_EXP_DT  = COP93.F_PRICE_INST_EXP_DT
          AND COP92.F_PART_NUM_OBJID     = COP93.F_PART_NUM_OBJID
          AND COP92.F_PRICE_PROG_NAME    = COP93.F_PRICE_PROG_NAME
        --AND COP92.F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
   ) COP91
,(SELECT COP102.F_PRICE_INST_EXP_DT, COP102.F_PART_NUMBER,F_PRICE, COP102.F_CURRENCY_NAME, COP102.F_PRICE_INST_EFF_DT, COP102.F_PART_NUM_OBJID, COP102.F_PRICE_PROG_NAME
       FROM DW.T_DM_CLAR_OPTIONS COP102
            ,  (SELECT MAX(F_PRICE_INST_EXP_DT) as F_PRICE_INST_EXP_DT, F_PART_NUM_OBJID, F_PRICE_PROG_NAME, F_PART_NUMBER
                  FROM DW.T_DM_CLAR_OPTIONS
                WHERE F_PRICE_PROG_NAME = 'US Repair Price' AND F_PART_DOMAIN = 'FRU' AND F_ACTIVE = 'Active'
                  AND F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
                GROUP BY F_PART_NUM_OBJID, F_PRICE_PROG_NAME,F_PART_NUMBER) COP103
        WHERE COP102.F_PRICE_INST_EXP_DT  = COP103.F_PRICE_INST_EXP_DT
          AND COP102.F_PART_NUM_OBJID     = COP103.F_PART_NUM_OBJID
          AND COP102.F_PRICE_PROG_NAME    = COP103.F_PRICE_PROG_NAME
        --AND COP102.F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
   ) COP101
,(SELECT COP112.F_PRICE_INST_EXP_DT, COP112.F_PART_NUMBER,F_PRICE, COP112.F_CURRENCY_NAME, COP112.F_PRICE_INST_EFF_DT, COP112.F_PART_NUM_OBJID, COP112.F_PRICE_PROG_NAME
       FROM DW.T_DM_CLAR_OPTIONS COP112
            ,  (SELECT MAX(F_PRICE_INST_EXP_DT) as F_PRICE_INST_EXP_DT, F_PART_NUM_OBJID, F_PRICE_PROG_NAME, F_PART_NUMBER
                  FROM DW.T_DM_CLAR_OPTIONS
                WHERE F_PRICE_PROG_NAME = 'CA Repair Cost' AND F_PART_DOMAIN = 'FRU' AND F_ACTIVE = 'Active'
                  AND F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
                GROUP BY F_PART_NUM_OBJID, F_PRICE_PROG_NAME,F_PART_NUMBER) COP113
        WHERE COP112.F_PRICE_INST_EXP_DT  = COP113.F_PRICE_INST_EXP_DT
          AND COP112.F_PART_NUM_OBJID     = COP113.F_PART_NUM_OBJID
          AND COP112.F_PRICE_PROG_NAME    = COP113.F_PRICE_PROG_NAME
        --AND COP112.F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
   ) COP111
,(SELECT COP122.F_PRICE_INST_EXP_DT, COP122.F_PART_NUMBER,F_PRICE, COP122.F_CURRENCY_NAME, COP122.F_PRICE_INST_EFF_DT, COP122.F_PART_NUM_OBJID, COP122.F_PRICE_PROG_NAME
       FROM DW.T_DM_CLAR_OPTIONS COP122
            ,  (SELECT MAX(F_PRICE_INST_EXP_DT) as F_PRICE_INST_EXP_DT, F_PART_NUM_OBJID, F_PRICE_PROG_NAME, F_PART_NUMBER
                  FROM DW.T_DM_CLAR_OPTIONS
                WHERE F_PRICE_PROG_NAME = 'CA Repair Price' AND F_PART_DOMAIN = 'FRU' AND F_ACTIVE = 'Active'
                  AND F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
                GROUP BY F_PART_NUM_OBJID, F_PRICE_PROG_NAME,F_PART_NUMBER) COP123
        WHERE COP122.F_PRICE_INST_EXP_DT  = COP123.F_PRICE_INST_EXP_DT
          AND COP122.F_PART_NUM_OBJID     = COP123.F_PART_NUM_OBJID
          AND COP122.F_PRICE_PROG_NAME    = COP123.F_PRICE_PROG_NAME
        --AND COP122.F_PRICE_INST_EXP_DT > (TRUNC(Sysdate)-1)
   ) COP121
Where
    PARTNUM.PART_NUMBER = COP11.F_PART_NUMBER(+) --and COP11.F_PRICE_PROG_NAME(+) = 'US Standard Cost'
 AND PARTNUM.PART_NUMBER = COP21.F_PART_NUMBER(+) --and COP12.F_PRICE_PROG_NAME(+) = 'US Std Price'
 AND PARTNUM.PART_NUMBER = COP31.F_PART_NUMBER(+) --and COP13.F_PRICE_PROG_NAME(+) = 'US Exchange Cost'
 AND PARTNUM.PART_NUMBER = COP41.F_PART_NUMBER(+) --and COP14.F_PRICE_PROG_NAME(+) = 'US Exchange Price'
 AND PARTNUM.PART_NUMBER = COP51.F_PART_NUMBER(+) --and COP15.F_PRICE_PROG_NAME(+) = 'CA Standard Cost'
 AND PARTNUM.PART_NUMBER = COP61.F_PART_NUMBER(+) --and COP16.F_PRICE_PROG_NAME(+) = 'CA Std Price'
 AND PARTNUM.PART_NUMBER = COP71.F_PART_NUMBER(+) --and COP17.F_PRICE_PROG_NAME(+) = 'CA Exchange Cost'
 AND PARTNUM.PART_NUMBER = COP81.F_PART_NUMBER(+) --and COP18.F_PRICE_PROG_NAME(+) = 'CA Exchange Price'
 AND PARTNUM.PART_NUMBER = COP91.F_PART_NUMBER(+) --and COP91.F_PRICE_PROG_NAME(+) = 'US Repair Cost'
 AND PARTNUM.PART_NUMBER = COP101.F_PART_NUMBER(+) --and COP101.F_PRICE_PROG_NAME(+) = 'US Repair Price'
 AND PARTNUM.PART_NUMBER = COP111.F_PART_NUMBER(+) --and COP111.F_PRICE_PROG_NAME(+) = 'CA Repair Cost'
 AND PARTNUM.PART_NUMBER = COP121.F_PART_NUMBER(+) --and COP121.F_PRICE_PROG_NAME(+) = 'US Repair Price'
--Added 4/1/16 Mahender
--AND   PARTNUM.PART_NUMBER               = cr_ind.F_PART_NUMBER(+)
 AND   PARTNUM.PART_NUMBER               = exl_ind.F_PART_NUMBER(+)
 AND   PARTNUM.OBJID               = MODLEV.PART_INFO2PART_NUM(+)
 AND   MODLEV.ACTIVE(+)            = 'Active'
 AND   PARTNUM.PART_NUM2PART_CLASS = PARTCLS.OBJID(+)
--AND   PARTNUM.OBJID               = SOSYST.X_SRCSYS2PART_NUM(+)
 AND   PARTNUM.S_DOMAIN            = 'FRU';
