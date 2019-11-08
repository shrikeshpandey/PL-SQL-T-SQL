CREATE OR REPLACE PROCEDURE DW.SPW_T_DM_REVENUE_STREAM (iCommit IN NUMBER DEFAULT 2000
) is
   /***********************************************************************************
   ||   PROCEDURE INFORMATION
   ||
   ||   Department:     Data Warehouse
   ||   Programmer:     Luis Fuentes
   ||   Date:           09/26/2017
   ||   Category:       Load Procedure to load TARGET data from SOURCE
   ||
   ||   Description:    LOAD T_DM_REVENUE_STREAM
   ||
   ||
   ||   Parameters:     iCommit:   is batch size used to commit record changes.
   ||
   ||   Load Sequence Number:  NNN
   ||
   ||   Historic Info:
   ||    Name:               Date:        Brief Description:
   ||   -----------------------------------------------------------------------------
   ||   Luis Fuentes       09/13/2017   Adding a grup by operation and fixing WHS_CODE
   ||   Luis Fuentes       09/18/2017   Adding ADJ_REVENUE, ENT_FLAG, OEM, REP_NAME
   ||   Luis Fuentes       09/25/2017   Adding LCAM data
   ||   Luis Fuentes       01/22/2018   Matching SalesForce
   ||   Luis Fuentes       11/09/2018   Adding WHS_CODE
   ||   -----------------------------------------------------------------------------
   ||
   ||   CURRENT REVISION STANDARD:  v1.50
   ||
   ***********************************************************************************/
/*******************************************************************************************
*  Generated using sp_gen_bulk() jg 2006
*******************************************************************************************/
CURSOR c is
SELECT   Z.ORDER_NO AS ORDER_NO
        ,Z.ORDER_DATE AS ORDER_DATE
        ,Z.INVOICE_NO AS INVOICE_NO
        ,Z.INVOICE_DATE AS INVOICE_DATE
        ,Z.CUST_NO AS CUST_NO
        ,Z.CURRENCY_CODE AS CURRENCY_CODE
        ,Z.REP_CODE AS REP_CODE
        ,Z.VBRANCH AS VBRANCH
        ,Z.ORA_NAME AS ORA_NAME
        ,Z.ORA_CORP_ID AS ORA_CORP_ID
        ,Z.LOB AS LOB
        ,Z.ORDER_STATUS AS ORDER_STATUS
        ,Z.EXPECTED_DATE AS EXPECTED_DATE
        ,Z.PROMISE_DATE AS PROMISE_DATE
        ,Z.REVISED_PROMISE_DATE AS REVISED_PROMISE_DATE
        ,Z.ANTICIPATED_ARRIVAL_DATE AS ANTICIPATED_ARRIVAL_DATE
        ,Z.ANTICIPATED_SHIP_DATE AS ANTICIPATED_SHIP_DATE
        ,Z.ESTIMATED_SHIP_DATE AS ESTIMATED_SHIP_DATE
        ,Z.REQUEST_DATE AS REQUEST_DATE
        ,Z.SHIP_NOT_INV_FLAG AS SHIP_NOT_INV_FLAG
        ,Z.EXT_REVENUE AS EXT_REVENUE
        ,Z.EXT_COST AS EXT_COST
        ,Z.QTY AS QTY
        ,Z.QTY_BO AS QTY_BO
        ,Z.MARGIN AS MARGIN
        ,(Z.EXT_REVENUE - Z.CRAD - Z.SHIPPED_NOT_INVOICED - Z.UNCOMMITED) AS ADJ_REVENUE
        ,Z.WHS_TYPE AS WHS_TYPE
        ,Z.ORD_GROUP AS ORD_GROUP
        ,Z.VEND_DT AS VEND_DT
        ,Z.MEASURE_DATE AS MEASURE_DATE
        ,Z.CRAD AS CRAD
        ,Z.SALES_REGION AS SALES_REGION
        ,Z.TVP AS TVP
        ,Z.UNCOMMITED AS UNCOMMITED
        ,Z.CATEGORY AS CATEGORY
        ,Z.IS_FROM AS IS_FROM
        ,Z.REP_NAME AS REP_NAME
        ,TRIM(Z.OEM) AS OEM
        ,CASE
          WHEN UPPER(V.F_MAP_VALUE2) = 'HP' AND (Z.ENT_FLAG = 'EUC' OR Z.ENT_FLAG = 'N') THEN 'HPI'
          WHEN UPPER(V.F_MAP_VALUE2) = 'HP' AND (Z.ENT_FLAG = 'ENT' OR Z.ENT_FLAG = 'Y') THEN 'HPE'
          WHEN V.F_MAP_VALUE2 IS NULL THEN 'MISC'
          ELSE TRIM(UPPER(V.F_MAP_VALUE2))
        END AS OEM_GROUP
        ,Z.ENT_FLAG AS ENT_FLAG
        ,Z.REB_EXT_PRICE AS REB_EXT_PRICE
        ,Z.REB_EXT_COST AS REB_EXT_COST
        ,Z.DW_MOD_DATE AS DW_MOD_DATE
        ,Z.DW_LOAD_DATE AS DW_LOAD_DATE
        --Begin 11/09/2018
        ,Z.WHS_CODE
        --End 11/09/2018
FROM  (
  SELECT   W.ORDER_NO                    AS ORDER_NO
          ,W.ORDER_DATE                  AS ORDER_DATE
          ,W.INVOICE_NO                  AS INVOICE_NO
          ,W.INVOICE_DATE                AS INVOICE_DATE
          ,W.CUST_NO                     AS CUST_NO
          ,W.CURRENCY_CODE               AS CURRENCY_CODE
          ,W.REP_CODE                    AS REP_CODE
          ,W.VBRANCH                     AS VBRANCH
          ,W.ORA_NAME                    AS ORA_NAME
          ,W.ORA_CORP_ID                 AS ORA_CORP_ID
          ,W.LOB                         AS LOB
          ,W.ORDER_STATUS                AS ORDER_STATUS
          ,W.EXPECTED_DATE               AS EXPECTED_DATE
          ,W.PROMISE_DATE                AS PROMISE_DATE
          ,W.REVISED_PROMISE_DATE        AS REVISED_PROMISE_DATE
          ,W.ANTICIPATED_ARRIVAL_DATE    AS ANTICIPATED_ARRIVAL_DATE
          ,W.ANTICIPATED_SHIP_DATE       AS ANTICIPATED_SHIP_DATE
          ,W.ESTIMATED_SHIP_DATE         AS ESTIMATED_SHIP_DATE
          ,W.REQUEST_DATE                AS REQUEST_DATE
          ,W.SHIP_NOT_INV_FLAG           AS SHIP_NOT_INV_FLAG
          ,SUM(W.EXT_REVENUE)            AS EXT_REVENUE
          ,SUM(W.EXT_COST)               AS EXT_COST
          ,SUM(W.QTY)                    AS QTY
          ,SUM(W.QTY_BO)                 AS QTY_BO
          ,SUM(W.MARGIN)                 AS MARGIN
          ,SUM(W.SHIPPED_NOT_INVOICED)   AS SHIPPED_NOT_INVOICED
          ,W.WHS_TYPE                    AS WHS_TYPE
          ,W.ORD_GROUP                   AS ORD_GROUP
          ,W.VEND_DT                     AS VEND_DT
          ,W.MEASURE_DATE                AS MEASURE_DATE
          ,SUM(W.CRAD)                   AS CRAD
          ,W.SALES_REGION                AS SALES_REGION
          ,W.TVP                         AS TVP
          ,SUM(W.UNCOMMITED)             AS UNCOMMITED
          ,W.CATEGORY                    AS CATEGORY
          ,W.IS_FROM                     AS IS_FROM
          ,W.REP_NAME                    AS REP_NAME
          ,W.OEM                         AS OEM
          ,W.ENT_FLAG                    AS ENT_FLAG
          ,SUM(REB_EXT_PRICE)            AS REB_EXT_PRICE
          ,SUM(REB_EXT_COST)             AS REB_EXT_COST
          ,W.DW_MOD_DATE                 AS DW_MOD_DATE
          ,W.DW_LOAD_DATE                AS DW_LOAD_DATE
          --Beging 11/09/2018
          ,W.WHS_CODE                    AS WHS_CODE
          --End 11/09/2018
  FROM (
    SELECT  F.ORDER_NO                    AS ORDER_NO,
            F.ORDER_DATE                  AS ORDER_DATE,
            F.INVOICE_NO                  AS INVOICE_NO,
            F.INVOICE_DATE                AS INVOICE_DATE,
            F.CUST_NO                     AS CUST_NO,
            F.CURRENCY_CODE               AS CURRENCY_CODE,
            F.REP_CODE                    AS REP_CODE,
            F.VBRANCH                     AS VBRANCH,
            F.ORA_NAME                    AS ORA_NAME,
            F.ORA_CORP_ID                 AS ORA_CORP_ID,
            F.LOB                         AS LOB,
            F.ORDER_STATUS                AS ORDER_STATUS,
            F.EXPECTED_DATE               AS EXPECTED_DATE,
            F.PROMISE_DATE                AS PROMISE_DATE,
            F.REVISED_PROMISE_DATE        AS REVISED_PROMISE_DATE,
            F.ANTICIPATED_ARRIVAL_DATE    AS ANTICIPATED_ARRIVAL_DATE,
            F.ANTICIPATED_SHIP_DATE       AS ANTICIPATED_SHIP_DATE,
            F.ESTIMATED_SHIP_DATE         AS ESTIMATED_SHIP_DATE,
            F.REQUEST_DATE                AS REQUEST_DATE,
            F.SHIP_NOT_INV_FLAG           AS SHIP_NOT_INV_FLAG,
            F.EXT_REVENEU                 AS EXT_REVENUE,
            F.EXT_COST                    AS EXT_COST,
            F.QTY                         AS QTY,
            F.QTY_BO                      AS QTY_BO,
            F.MARGIN                      AS MARGIN,
            F.WHS_TYPE                    AS WHS_TYPE,
            F.ORD_GROUP                   AS ORD_GROUP,
            F.VEND_DT                     AS VEND_DT,
            F.MEASURE_DATE                AS MEASURE_DATE,
            F.CRAD                        AS CRAD,
            F.SALES_REGION                AS SALES_REGION,
            F.TVP                         AS TVP,
            CASE
            WHEN F.IS_FROM = 'PENDING_ORDERS' THEN (
              CASE
                WHEN F.CRAD > 0 THEN 0
                WHEN F.MEASURE_DATE > QTR.CURRENT_QTR_END_DATE+1 THEN F.EXT_REVENEU
                WHEN F.ORD_GROUP = 'Pend' THEN F.EXT_REVENEU
                ELSE 0
               END)
            ELSE NULL
            END                           AS UNCOMMITED,
            CASE
              WHEN F.IS_FROM = 'INVOICE_ORDERS' THEN (
                CONCAT(CONCAT('Q', TO_CHAR(trunc(F.INVOICE_DATE),'Q ')),TO_CHAR(EXTRACT(year from trunc(F.INVOICE_DATE))))
              )
              WHEN F.IS_FROM = 'PENDING_ORDERS' THEN (
                CASE
                  WHEN (trunc(SYSDATE)-F.MEASURE_DATE) > 0 THEN 'Past Due'
                  WHEN concat(QTR.CURRENT_QTR,QTR.CURRENT_YEAR) <> concat(TO_CHAR(CASE WHEN F.MEASURE_DATE IS NULL THEN SYSDATE+3 ELSE F.MEASURE_DATE END,'Q'),TO_CHAR(EXTRACT(YEAR FROM CASE WHEN F.MEASURE_DATE IS NULL THEN SYSDATE+3 ELSE F.MEASURE_DATE END))) THEN ('Q' || TO_CHAR(CASE WHEN F.MEASURE_DATE IS NULL THEN SYSDATE+3 ELSE F.MEASURE_DATE END,'Q') || ' ' || TO_CHAR(EXTRACT(YEAR FROM CASE WHEN F.MEASURE_DATE IS NULL THEN SYSDATE+3 ELSE F.MEASURE_DATE END)))
                  WHEN concat(QTR.CURRENT_QTR,QTR.CURRENT_YEAR) = concat(TO_CHAR(CASE WHEN F.MEASURE_DATE IS NULL THEN SYSDATE+3 ELSE F.MEASURE_DATE END,'Q'),TO_CHAR(EXTRACT(YEAR FROM CASE WHEN F.MEASURE_DATE IS NULL THEN SYSDATE+3 ELSE F.MEASURE_DATE END))) THEN (TO_CHAR(EXTRACT(MONTH FROM CASE WHEN F.MEASURE_DATE IS NULL THEN SYSDATE+3 ELSE F.MEASURE_DATE  END)) || ' ' || TO_CHAR(EXTRACT(YEAR FROM CASE WHEN F.MEASURE_DATE IS NULL THEN SYSDATE+3 ELSE F.MEASURE_DATE END)))
                END
              )
            END                           AS CATEGORY,
            CASE
             WHEN F.IS_FROM = 'PENDING_ORDERS' AND F.SHIP_NOT_INV_FLAG = 'Y' THEN F.EXT_REVENEU
             ELSE 0
            END                           AS SHIPPED_NOT_INVOICED,
            F.REP_NAME                    AS REP_NAME,
            F.OEM                         AS OEM,
            F.ENT_FLAG                    AS ENT_FLAG,
            F.REB_EXT_PRICE               AS REB_EXT_PRICE,
            F.REB_EXT_COST                AS REB_EXT_COST,
            F.IS_FROM                     AS IS_FROM,
            QTR.DW_MOD_DATE               AS DW_MOD_DATE,
            QTR.DW_LOAD_DATE              AS DW_LOAD_DATE,
            --Begin 11/09/2018
            F.WHS_CODE                    AS WHS_CODE
            --End 11/09/2018
    FROM  (
      SELECT si.ORDER_NO AS ORDER_NO,
             NULL AS ORDER_DATE,
             si.INVOICE_NO AS INVOICE_NO,
             si.INVOICE_DATE AS INVOICE_DATE,
             si.CUST_NO AS CUST_NO, --rtrim(cc.cust_no) as DIMS_Customer_No = It is coming from DW.CUSTOMER and its right triming
             si.CURRENCY_CODE AS CURRENCY_CODE,
             si.REP_CODE AS REP_CODE,
             sil.VBRANCH AS VBRANCH,
             TRIM(cc.ORA_NAME) AS ORA_NAME,  --rtrim(cc.ora_name) as Oracle_Name = It is right triming both are coming from DW.CUSTOMER
             TRIM(cc.ORA_CUSTOMER_NUMBER) AS ORA_CORP_ID, --rtrim(cc.ora_customer_number) as Ora_Corp_ID = It is right triming
             decode(rtrim(ft.f_flex_value_level_4_desc),'Software Revenue','Software','Total Hardware Revenue','Hardware','Product Related Services Revenue','PRS','ITO Revenue','SVC','Other') AS LOB,
             NULL AS ORDER_STATUS,
             NULL AS EXPECTED_DATE,
             NULL AS PROMISE_DATE,
             NULL AS REVISED_PROMISE_DATE,
             NULL AS ANTICIPATED_ARRIVAL_DATE,
             NULL AS ANTICIPATED_SHIP_DATE,
             NULL AS ESTIMATED_SHIP_DATE,
             NULL AS REQUEST_DATE,
             NULL AS SHIP_NOT_INV_FLAG,
             sil.EXTENDED_PRICE AS EXT_REVENEU,
             sil.EXTENDED_COST AS EXT_COST,
             sil.QTY_SHIPPED AS QTY,
             NULL AS QTY_BO,
             NULL AS MARGIN,
             NULL AS WHS_TYPE,
             NULL AS ORD_GROUP,
             NULL AS VEND_DT,
             NULL AS MEASURE_DATE,
             NULL AS CRAD,
             NVL(bm.SALES_REGION,'Corporate') AS SALES_REGION, --rtrim(bm.sales_region) as Sales_Region we match but this could affect us in the near future
             NVL(bm.MANAGER_LEVEL1,'CORPORATE') AS TVP,
             rtrim(sr.REP_NAME) AS REP_NAME, --rtrim(sr.rep_name) as Rep_Name
             rtrim(vm.NAME) AS OEM, --rtrim(vm.name) as Manuf_Name
             decode(nvl(trim(pi.enterprise), 'N'), 'N', 'EUC', 'ENT') AS ENT_FLAG, --decode(rtrim(pi.enterprise),null,'EUE','Y','CTS','EUE') as Ent_Code
             1 AS CURRENT_QTR_END_DATE_PK,
             NVL(rb.Reb_Ext_Price,0) AS REB_EXT_PRICE,
             NVL(rb.Reb_Ext_Cost,0) AS REB_EXT_COST,
             'INVOICE_ORDERS' AS IS_FROM,
             --Begin 11/09/2018
             sil.whs_code AS WHS_CODE
             --End 11/09/2018
      FROM DW.SALES_INVOICE si
      LEFT JOIN DW.SALES_INVOICE_LINE sil
       ON si.invoice_no = sil.invoice_no
      LEFT JOIN DW.PRODUCT_ITEM pi
       ON sil.item_no = pi.item_no
      LEFT JOIN DW.PRODUCT_GROUP pg
       ON pi.prod_group = pg.prod_group
      LEFT JOIN DW.T_DM_FIN_TREES_001 ft
       ON ft.f_flex_value_id = pg.gl_revenue_code
      INNER JOIN DW.CUSTOMER cc
       ON si.cust_no = cc.cust_no
      LEFT JOIN DW.BRANCH_MASTER bm
       ON RTRIM(sil.vbranch) = RTRIM(bm.branch_code)
      LEFT JOIN DW.VENDOR vm
       ON RTRIM(sil.manuf_code) = RTRIM(vm.vendor_code)
      LEFT JOIN DW.SALES_REP sr
       ON RTRIM(sil.vrep_code) = RTRIM(sr.rep_code)
      LEFT JOIN (
        SELECT si.invoice_no AS INV_NO, sil.autosku_line AS Autoskuline,
               SUM(sil.extended_cost) AS Reb_Ext_Cost,
               SUM(sil.extended_price) AS Reb_Ext_Price
        FROM DW.PRODUCT_GROUP pg,
             DW.SALES_INVOICE si,
             DW.SALES_INVOICE_LINE sil,
             DW.PRODUCT_ITEM pi
        WHERE (pi.prod_group = pg.prod_group(+))
         AND (sil.invoice_no(+) = si.invoice_no)
         AND (sil.item_no = pi.item_no(+))
         --Begin 11/09/2018
         AND (si.invoice_date >= ADD_MONTHS(TRUNC(SYSDATE,'YEAR'),-24))
         --End 11/09/2018
         AND (pg.gl_revenue_code = '148001001000' )
         AND (sil.autosku_line != 0 )
        GROUP BY si.invoice_no, sil.autosku_line
      ) rb
       ON sil.invoice_no = rb.inv_no AND sil.line_no = rb.autoskuline
      --Begin 11/09/2018
      WHERE (si.invoice_date >= ADD_MONTHS(TRUNC(SYSDATE,'YEAR'),-24))
      --End 11/09/2018
       AND (si.cust_no BETWEEN '000000101' AND '799999999')
       AND (RTRIM(ft.f_flex_value_level_4_desc) IN ('Software Revenue','Total Hardware Revenue','Product Related Services Revenue')
       OR RTRIM(pg.gl_revenue_code) = '522001001540')
       AND ( pg.gl_revenue_code != '148001001000' or sil.autosku_line = 0)

       UNION ALL

       SELECT A.ORDER_NO AS ORDER_NO,
              A.ORDER_DATE AS ORDER_DATE,
              A.INVOICE_NO AS INVOICE_NO,
              NULL AS INVOICE_DATE,
              A.CUST_NO as CUST_NO,
              A.CURRENCY_CODE AS CURRENCY_CODE,
              B.VREP_CODE AS REP_CODE,
              B.VBRANCH AS VBRANCH,
              TRIM(K.ORA_NAME) AS ORA_NAME,
              TRIM(K.ORA_CUSTOMER_NUMBER) AS ORA_CORP_ID,
              decode(rtrim(E.f_flex_value_level_4_desc),'Software Revenue','Software','Total Hardware Revenue','Hardware','Product Related Services Revenue','PRS','ITO Revenue','SVC','Other') AS LOB,
              A.ORDER_STATUS AS ORDER_STATUS,
              F.EXPECTED_DATE AS EXPECTED_DATE,
              F.PROMISE_DATE AS PROMISE_DATE,
              DECODE(F.PROMISE_DATE,NULL,TRUNC(SYSDATE)+3,F.PROMISE_DATE) AS REVISED_PROMISE_DATE,
              A.ANTICIPATED_ARRIVAL_DATE AS ANTICIPATED_ARRIVAL_DATE,
              A.ANTICIPATED_SHIP_DATE AS ANTICIPATED_SHIP_DATE,
              A.ESTIMATED_SHIP_DATE AS ESTIMATED_SHIP_DATE,
              A.REQUEST_DATE AS REQUEST_DATE,
              CASE
               WHEN RTRIM(F.PROMISE_CODE) IN ('1', '8','9') THEN 'Y'
               ELSE 'N'
              END AS SHIP_NOT_INV_FLAG,
              (B.GROSS_PRICE * B.QTY_OPEN_ORD) AS EXT_REVENUE,
              (B.COST * B.QTY_OPEN_ORD) AS EXT_COST,
              B.QTY_OPEN_ORD AS QTY,
              (B.QTY_OPEN_ORD-(B.QTY_ALLOC + B.QTY_ON_PPS)) AS QTY_BO,
              (B.GROSS_PRICE - B.COST) * B.QTY_OPEN_ORD AS MARGIN,
               CASE B.WHS_CODE
                 WHEN '143' THEN 'Vend'
                 WHEN '888' THEN 'EDI'
                 WHEN '776' THEN 'DOA'
                 WHEN '102' THEN 'DC'
                 WHEN '120' THEN 'DC'
                 ELSE  'Oth'
               END AS WHS_TYPE,

                CASE
                  WHEN B.WHS_CODE = '143' THEN 'Vend'
                  WHEN SUBSTR(ORDER_STATUS,1,1) IN ('0','1','2','3') THEN 'Pend'
                  ELSE 'Alloc'
                END AS ORD_GROUP,

                CASE
                  WHEN B.WHS_CODE = '143' AND M.SALES_REGION = 'Canada' AND B.REQUEST_DATE > F.PROMISE_DATE THEN B.REQUEST_DATE
                  WHEN B.WHS_CODE = '143' AND M.SALES_REGION = 'Canada' AND B.REQUEST_DATE < F.PROMISE_DATE THEN F.PROMISE_DATE
                  WHEN B.WHS_CODE = '143' AND M.SALES_REGION = 'Canada' AND B.REQUEST_DATE < TRUNC(SYSDATE) THEN (TRUNC(add_months(SYSDATE,3),'Q')-1)+1
                  WHEN B.WHS_CODE = '143' AND F.PROMISE_DATE IS NULL THEN (TRUNC(add_months(SYSDATE,3),'Q')-1)+1
                  ELSE F.PROMISE_DATE
                END AS VEND_DT,
              CASE
             --MEASURE_DATE
              WHEN B.WHS_CODE = '143' THEN (CASE WHEN B.WHS_CODE = '143' and M.SALES_REGION = 'Canada' and B.REQUEST_DATE > F.PROMISE_DATE then B.REQUEST_DATE
                                     WHEN B.WHS_CODE = '143' and M.SALES_REGION = 'Canada' and B.REQUEST_DATE < F.PROMISE_DATE then F.PROMISE_DATE
                                   WHEN B.WHS_CODE = '143' and M.SALES_REGION = 'Canada' and B.REQUEST_DATE < TRUNC(SYSDATE) then (TRUNC(add_months(SYSDATE,3),'Q')-1)+1
                                   WHEN B.WHS_CODE = '143' and F.PROMISE_DATE is null then (TRUNC(add_months(SYSDATE,3),'Q')-1)+1
                                   else F.PROMISE_DATE
                                end)
                  WHEN B.WHS_CODE in ('102','120') AND SUBSTR(ORDER_STATUS,1,1) IN ('0','1','2','3') THEN (TRUNC(add_months(SYSDATE,3),'Q')-1)+1
                  WHEN B.WHS_CODE in ('102','120') AND SUBSTR(ORDER_STATUS,1,1) NOT IN ('0','1','2','3')  THEN TRUNC(add_months(SYSDATE,3),'Q')-1
                  ELSE (TRUNC(add_months(SYSDATE,3),'Q')-1)+1
               END AS MEASURE_DATE,

              CASE
               WHEN M.SALES_REGION = 'Canada' AND A.REQUEST_DATE > TRUNC(ADD_MONTHS(SYSDATE,3),'Q') THEN (B.GROSS_PRICE * B.QTY_OPEN_ORD)
               WHEN M.SALES_REGION != 'Canada' AND ANTICIPATED_SHIP_DATE > TRUNC(ADD_MONTHS(SYSDATE,3),'Q')-1 THEN (B.GROSS_PRICE * B.QTY_OPEN_ORD)
               ELSE 0
              END AS CRAD,
              NVL(M.SALES_REGION,'Corporate') AS SALES_REGION,
              NVL(M.MANAGER_LEVEL1,'CORPORATE') AS TVP,
              rtrim(SR.REP_NAME) AS REP_NAME,
              rtrim(v.name)  AS OEM,
              decode(nvl(trim(C.enterprise), 'N'), 'N', 'EUC', 'ENT') AS ENT_FLAG,
              1 AS CURRENT_QTR_END_DATE_PK,
              0 AS REB_EXT_PRICE,
              0 AS REB_EXT_COST,
              'PENDING_ORDERS' AS IS_FROM,
              --Begin 11/09/2018
              B.WHS_CODE AS WHS_CODE
              --End 11/09/2018
       FROM DW.SALES_ORDER A
       INNER JOIN DW.SALES_ORDER_LINE B
         ON A.ORDER_NO = B.ORDER_NO
       LEFT JOIN DW.BRANCH_MASTER M
         ON rtrim(b.vbranch) = rtrim(M.branch_code)
       INNER JOIN DW.PRODUCT_ITEM C
         ON B.item_no = C.item_no
       INNER JOIN DW.PRODUCT_GROUP D
         ON C.prod_group = D.prod_group
       LEFT JOIN DW.T_DM_FIN_TREES_001 E
         ON D.gl_revenue_code = E.f_flex_value_id
       LEFT JOIN DW.PURCHASE_ORDER_LINE F
         ON (rtrim(B.po_no) = rtrim(F.po_no) AND B.po_line = F.line_no)
       LEFT JOIN DW.VENDOR V
         ON (rtrim(C.manuf_code) = rtrim(V.vendor_code))
       LEFT JOIN DW.SALES_REP SR
         ON (rtrim(B.VREP_CODE) = rtrim(SR.REP_CODE))
       INNER JOIN DW.CUSTOMER K
       ON A.CUST_NO = K.CUST_NO
       WHERE order_status NOT IN ('01', '04', '80')
        AND A.cust_no BETWEEN '000000101' AND '799999999'
        --Begin 11/09/2018
        AND order_date >= ADD_MONTHS(TRUNC(SYSDATE,'YEAR'),-24)--order_date >= to_Date('20170101','yyyymmdd') and order_date <= to_Date('20170828','yyyymmdd')
        --End 11/09/2018
        AND qty_open_ord > 0
    ) F
    INNER JOIN (
      SELECT 1 AS CURRENT_QTR_END_DATE_PK,
            TRUNC(add_months(SYSDATE,3),'Q')-1 AS CURRENT_QTR_END_DATE,
            TO_CHAR(trunc(sysdate),'Q') AS CURRENT_QTR,
            TO_CHAR(EXTRACT(year from trunc(sysdate))) AS CURRENT_YEAR,
            trunc(sysdate) AS DW_MOD_DATE,
            trunc(sysdate) AS DW_LOAD_DATE
      FROM DUAL
    ) QTR
     ON F.CURRENT_QTR_END_DATE_PK = QTR.CURRENT_QTR_END_DATE_PK

    UNION ALL

    SELECT lc.ORDER_NO,
           lc.ORDER_DATE,
           lc.INVOICE_NO,
           lc.INVOICE_DATE,
           lc.CUST_NO,
           lc.CURRENCY_CODE,
           lc.REP_CODE,
           lc.VBRANCH,
           lc.ORA_NAME,
           lc.ORA_CORP_ID,
           lc.LOB,
           lc.ORDER_STATUS,
           lc.EXPECTED_DATE,
           lc.PROMISE_DATE,
           lc.REVISED_PROMISE_DATE,
           lc.ANTICIPATED_ARRIVAL_DATE,
           lc.ANTICIPATED_SHIP_DATE,
           lc.ESTIMATED_SHIP_DATE,
           lc.REQUEST_DATE,
           lc.SHIP_NOT_INV_FLAG,
           lc.EXT_REVENUE,
           lc.EXT_COST,
           lc.QTY,
           lc.QTY_BO,
           lc.MARGIN,
           lc.WHS_TYPE,
           lc.ORD_GROUP,
           lc.VEND_DATE,
           lc.MEASURE_DATE,
           lc.CRAD,
           lc.SALES_REGION,
           lc.TVP,
           lc.UNCOMMITTED,
           CONCAT(CONCAT('Q', TO_CHAR(trunc(INVOICE_DATE),'Q ')),TO_CHAR(EXTRACT(year from trunc(INVOICE_DATE)))) AS CATEGORY,
           NULL AS SHIPPED_NOT_INVOICED,
           lc.REP_NAME,
           lc.OEM,
           lc.ENT_FLAG,
           0 AS REB_EXT_PRICE,
           0 AS REB_EXT_COST,
           lc.IS_FROM,
           trunc(DW_MOD_DATE)  AS DW_MOD_DATE,
           trunc(DW_LOAD_DATE) AS DW_LOAD_DATE,
           --Begin 11/09/2018
           NULL AS WHS_CODE
           --End 11/09/2018
      FROM DW.T_BMS_LCAM_DEPLOY lc
  ) w
  GROUP BY  W.ORDER_NO,
            W.ORDER_DATE,
            W.INVOICE_NO,
            W.INVOICE_DATE,
            W.CUST_NO,
            W.CURRENCY_CODE,
            W.REP_CODE,
            W.VBRANCH,
            W.ORA_NAME,
            W.ORA_CORP_ID,
            W.LOB,
            W.ORDER_STATUS,
            W.EXPECTED_DATE,
            W.PROMISE_DATE,
            W.REVISED_PROMISE_DATE,
            W.ANTICIPATED_ARRIVAL_DATE,
            W.ANTICIPATED_SHIP_DATE,
            W.ESTIMATED_SHIP_DATE,
            W.REQUEST_DATE,
            W.SHIP_NOT_INV_FLAG,
            W.WHS_TYPE,
            W.ORD_GROUP,
            W.VEND_DT,
            W.MEASURE_DATE,
            W.SALES_REGION,
            W.TVP,
            W.CATEGORY,
            W.REP_NAME,
            W.OEM,
            W.ENT_FLAG,
            W.IS_FROM,
            W.DW_MOD_DATE,
            W.DW_LOAD_DATE,
            --Begin 11/09/2018
            W.WHS_CODE
            --End 11/09/2018
) Z
LEFT JOIN DW.T_BSM_CODE_VALUES V
 ON TRIM(UPPER(Z.OEM)) = TRIM(UPPER(V.F_CODE_VALUE1)) AND V.F_CODE_TYPE = 'OEM_GROUP'
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
ORDER_NO_t dbms_sql.NUMBER_table;
ORDER_DATE_t dbms_sql.DATE_table;
INVOICE_NO_t dbms_sql.NUMBER_table;
INVOICE_DATE_t dbms_sql.DATE_table;
CUST_NO_t dbms_sql.VARCHAR2_table;
CURRENCY_CODE_t dbms_sql.VARCHAR2_table;
REP_CODE_t dbms_sql.VARCHAR2_table;
VBRANCH_t dbms_sql.VARCHAR2_table;
ORA_NAME_t dbms_sql.VARCHAR2_table;
ORA_CORP_ID_t dbms_sql.VARCHAR2_table;
LOB_t dbms_sql.VARCHAR2_table;
ORDER_STATUS_t dbms_sql.VARCHAR2_table;
EXPECTED_DATE_t dbms_sql.DATE_table;
PROMISE_DATE_t dbms_sql.DATE_table;
REVISED_PROMISE_DATE_t dbms_sql.DATE_table;
ANTICIPATED_ARRIVAL_DATE_t dbms_sql.DATE_table;
ANTICIPATED_SHIP_DATE_t dbms_sql.DATE_table;
ESTIMATED_SHIP_DATE_t dbms_sql.DATE_table;
REQUEST_DATE_t dbms_sql.DATE_table;
SHIP_NOT_INV_FLAG_t dbms_sql.VARCHAR2_table;
EXT_REVENUE_t dbms_sql.NUMBER_table;
EXT_COST_t dbms_sql.NUMBER_table;
QTY_t dbms_sql.NUMBER_table;
QTY_BO_t dbms_sql.NUMBER_table;
MARGIN_t dbms_sql.NUMBER_table;
ADJ_REVENUE_t dbms_sql.NUMBER_table;
WHS_TYPE_t dbms_sql.VARCHAR2_table;
ORD_GROUP_t dbms_sql.VARCHAR2_table;
VEND_DATE_t dbms_sql.DATE_table;
MEASURE_DATE_t dbms_sql.DATE_table;
CRAD_t dbms_sql.NUMBER_table;
SALES_REGION_t dbms_sql.VARCHAR2_table;
TVP_t dbms_sql.VARCHAR2_table;
UNCOMMITTED_t dbms_sql.NUMBER_table;
CATEGORY_t dbms_sql.VARCHAR2_table;
IS_FROM_t dbms_sql.VARCHAR2_table;
REP_NAME_t dbms_sql.VARCHAR2_table;
OEM_t dbms_sql.VARCHAR2_table;
OEM_GROUP_t dbms_sql.VARCHAR2_table;
ENT_FLAG_t dbms_sql.VARCHAR2_table;
REB_EXT_PRICE_t dbms_sql.NUMBER_table;
REB_EXT_COST_t dbms_sql.NUMBER_table;
DW_MOD_DATE_t dbms_sql.DATE_table;
DW_LOAD_DATE_t dbms_sql.DATE_table;
--Begin 11/09/2018
WHS_CODE_t dbms_sql.VARCHAR2_table;
--End 11/09/2018

BEGIN --B1

  -- Conditional Create of New Seq Number

dw.sp_md_get_next_seq('T_DM_REVENUE_STREAM',
     'T_DM_REVENUE_STREAM',
     'OBJID',
     1, --- ACTIVE CODE 1 OR 0 PRETTY MUCH ALWAYS ACTIVE '
     'T_DM_REVENUE_STREAM',
     'ORACLE DB-LINK',
     'DW TABLE LOAD',
     'SPW_T_DM_REVENUE_STREAM',
     iLoadSequence,
     'DW');

dw.pkg_load_verify.p_begin_load(iloadsequence,iloadinstanceseq);
dw.sp_truncate('DW.T_DM_REVENUE_STREAM');

OPEN c;
LOOP
     FETCH c BULK COLLECT INTO
          ORDER_NO_t,
          ORDER_DATE_t,
          INVOICE_NO_t,
          INVOICE_DATE_t,
          CUST_NO_t,
          CURRENCY_CODE_t,
          REP_CODE_t,
          VBRANCH_t,
          ORA_NAME_t,
          ORA_CORP_ID_t,
          LOB_t,
          ORDER_STATUS_t,
          EXPECTED_DATE_t,
          PROMISE_DATE_t,
          REVISED_PROMISE_DATE_t,
          ANTICIPATED_ARRIVAL_DATE_t,
          ANTICIPATED_SHIP_DATE_t,
          ESTIMATED_SHIP_DATE_t,
          REQUEST_DATE_t,
          SHIP_NOT_INV_FLAG_t,
          EXT_REVENUE_t,
          EXT_COST_t,
          QTY_t,
          QTY_BO_t,
          MARGIN_t,
          ADJ_REVENUE_t,
          WHS_TYPE_t,
          ORD_GROUP_t,
          VEND_DATE_t,
          MEASURE_DATE_t,
          CRAD_t,
          SALES_REGION_t,
          TVP_t,
          UNCOMMITTED_t,
          CATEGORY_t,
          IS_FROM_t,
          REP_NAME_t,
          OEM_t,
          OEM_GROUP_t,
          ENT_FLAG_t,
          REB_EXT_PRICE_t,
          REB_EXT_COST_t,
          DW_MOD_DATE_t,
          DW_LOAD_DATE_t,
          --Begin 11/09/2018
          WHS_CODE_t
          --End 11/09/2018
     LIMIT iCommit;
     FOR i in 1..ORDER_NO_t.COUNT
     LOOP
          BEGIN --B2 insert
          INSERT INTO DW.T_DM_REVENUE_STREAM (
               ORDER_NO,
               ORDER_DATE,
               INVOICE_NO,
               INVOICE_DATE,
               CUST_NO,
               CURRENCY_CODE,
               REP_CODE,
               VBRANCH,
               ORA_NAME,
               ORA_CORP_ID,
               LOB,
               ORDER_STATUS,
               EXPECTED_DATE,
               PROMISE_DATE,
               REVISED_PROMISE_DATE,
               ANTICIPATED_ARRIVAL_DATE,
               ANTICIPATED_SHIP_DATE,
               ESTIMATED_SHIP_DATE,
               REQUEST_DATE,
               SHIP_NOT_INV_FLAG,
               EXT_REVENUE,
               EXT_COST,
               QTY,
               QTY_BO,
               MARGIN,
               ADJ_REVENUE,
               WHS_TYPE,
               ORD_GROUP,
               VEND_DATE,
               MEASURE_DATE,
               CRAD,
               SALES_REGION,
               TVP,
               UNCOMMITTED,
               CATEGORY,
               IS_FROM,
               REP_NAME,
               OEM,
               OEM_GROUP,
               ENT_FLAG,
               REB_EXT_PRICE,
               REB_EXT_COST,
               DW_MOD_DATE,
               DW_LOAD_DATE,
               --Begin 11/09/2018
               WHS_CODE
               --End 11/09/2018
          )
          VALUES (
               ORDER_NO_t(i),
               ORDER_DATE_t(i),
               INVOICE_NO_t(i),
               INVOICE_DATE_t(i),
               CUST_NO_t(i),
               CURRENCY_CODE_t(i),
               REP_CODE_t(i),
               VBRANCH_t(i),
               ORA_NAME_t(i),
               ORA_CORP_ID_t(i),
               LOB_t(i),
               ORDER_STATUS_t(i),
               EXPECTED_DATE_t(i),
               PROMISE_DATE_t(i),
               REVISED_PROMISE_DATE_t(i),
               ANTICIPATED_ARRIVAL_DATE_t(i),
               ANTICIPATED_SHIP_DATE_t(i),
               ESTIMATED_SHIP_DATE_t(i),
               REQUEST_DATE_t(i),
               SHIP_NOT_INV_FLAG_t(i),
               EXT_REVENUE_t(i),
               EXT_COST_t(i),
               QTY_t(i),
               QTY_BO_t(i),
               MARGIN_t(i),
               ADJ_REVENUE_t(i),
               WHS_TYPE_t(i),
               ORD_GROUP_t(i),
               VEND_DATE_t(i),
               MEASURE_DATE_t(i),
               CRAD_t(i),
               SALES_REGION_t(i),
               TVP_t(i),
               UNCOMMITTED_t(i),
               CATEGORY_t(i),
               IS_FROM_t(i),
               REP_NAME_t(i),
               OEM_t(i),
               OEM_GROUP_t(i),
               ENT_FLAG_t(i),
               REB_EXT_PRICE_t(i),
               REB_EXT_COST_t(i),
               DW_MOD_DATE_t(i),
               DW_LOAD_DATE_t(i),
               --Begin 11/09/2018
               WHS_CODE_t(i)
               --End 11/09/2018
          );
EXCEPTION --B2
     WHEN OTHERS THEN
     --INSERT ERROR INFORMATION
          BEGIN --B4
          itotalerrors := itotalerrors + 1;
          dw.pkg_load_verify.p_record_exception(iloadinstanceseq
          ,substr('DW.T_DM_REVENUE_STREAM err:'||sqlerrm,1,256)
          ,SQLCODE
          ,SQLERRM
          ,'');
          END; --B4
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
          ,substr('DW.T_DM_REVENUE_STREAM GENERAL err:'||sqlerrm,1,256)
          ,SQLCODE
          ,SQLERRM
          ,'');
          END; --B4
     ------------------------------------------------------
     -- END MAIN
     ------------------------------------------------------
END; --B1
/

GRANT EXECUTE ON DW.SPW_T_DM_REVENUE_STREAM TO TM1_ETL_ROLE;
GRANT EXECUTE ON DW.SPW_T_DM_REVENUE_STREAM TO MSTR;
GRANT EXECUTE ON DW.SPW_T_DM_REVENUE_STREAM TO LF188653;
GRANT EXECUTE ON DW.SPW_T_DM_REVENUE_STREAM TO SERVICE_ROLE;
