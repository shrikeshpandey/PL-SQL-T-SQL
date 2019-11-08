/***********************************************************************************
||   QUERY INFORMATION
||
||   Description: LOADS TABLE T_DM_EUE_CSP_BOH
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

SELECT inv.WHS_CODE F_WHS_CODE,
     pi.MANUF_CODE F_MANUF_CODE,
     TRIM (pi.MAN_PART_NO) F_MAN_PART_NO,
     pi.ITEM_NO F_ITEM_NO,
     pi.DESCRIPTION F_DESCRIPTION,
     pi.EXTENDED_DESC F_EXTENDED_DESC,
     pi.INV_GROUP F_INV_GROUP,
     pi.VENDOR_CODE F_VENDOR_CODE,
     SUM (inv.QTY_ON_HAND) F_QTY_ON_HAND,
     SUM (pi.MRSP) F_MSRP,
     SUM (pi.LOADED_AVERAGE_COST) F_LOADED_AVG_COST,
     (SUM (pi.MRSP) * SUM (inv.QTY_ON_HAND)) F_EXTENDED_MSRP,
     TRUNC (SYSDATE) - 1 AS F_BUSINESS_DATE,
     SYSDATE AS DW_LOAD_DATE,
     SYSDATE AS DW_MOD_DATE,
     case when crncy_cc.F_SURROGATE_FK is not null then crncy_cc.F_SURROGATE_FK
     when crncy_vc.F_SURROGATE_FK is not null then crncy_vc.F_SURROGATE_FK
     else -99999 end F_CURRENCY_SK
FROM DW.PRODUCT_ITEM pi,
     DW.INVENTORY inv,
       (SELECT F_SURROGATE_FK,
             CASE
                WHEN F_CURRENCY_ID = 'US DOLLAR' THEN 'USD'
                WHEN F_CURRENCY_ID = 'CANADIAN DOLLAR' THEN 'CAD'
             END
                F_CURRENCY_CD
        FROM dw.T_DIM_CURRENCY
       WHERE F_CURRENCY_ID IN ('CANADIAN DOLLAR', 'US DOLLAR')) crncy_cc,
     (SELECT F_SURROGATE_FK,
             CASE
                WHEN F_CURRENCY_ID = 'US DOLLAR' THEN 'CSP'
                WHEN F_CURRENCY_ID = 'CANADIAN DOLLAR' THEN 'CSPC'
             END
                F_CURRENCY_CD
        FROM dw.T_DIM_CURRENCY
       WHERE F_CURRENCY_ID IN ('CANADIAN DOLLAR', 'US DOLLAR')) crncy_vc
WHERE     (pi.ITEM_NO = inv.ITEM_NO)
   --  AND pi.VENDOR_CODE IN ('CSP', 'CSPC')
     AND inv.QTY_ON_HAND != 0
     AND TRIM(pi.CURRENCY_CODE) = crncy_cc.F_CURRENCY_CD(+)
     AND TRIM(pi.VENDOR_CODE) = crncy_vc.F_CURRENCY_CD(+)
GROUP BY pi.DESCRIPTION,
     pi.EXTENDED_DESC,
     pi.INV_GROUP,
     pi.ITEM_NO,
     pi.MAN_PART_NO,
     pi.MANUF_CODE,
     pi.VENDOR_CODE,
     inv.WHS_CODE,
     crncy_cc.F_SURROGATE_FK,
     crncy_vc.F_SURROGATE_FK;
