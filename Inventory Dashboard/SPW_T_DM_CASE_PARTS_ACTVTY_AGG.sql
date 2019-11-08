/***********************************************************************************
||   QUERY INFORMATION
||
||   Description: LOADS TABLE T_DM_CASE_PARTS_ACTIVITY_AGG
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

SELECT all_parts.F_SET_OF_BOOKS,
       all_parts.F_PART_NUMBER,
       all_parts.F_USAGE_QTY_13_WK,
       all_parts.F_USAGE_QTY_1_YR,
       all_parts.f_business_date,
       all_parts.F_USAGE_QTY_2_WK,
       all_parts.F_PART_GOOD_QTY,
       all_parts.F_PART_BAD_QTY,
       all_parts.F_INVENTORY_DATE,
       NVL (crncy.F_SURROGATE_FK, -99999) F_CURRENCY_SK,
       NVL (fru.partnum_objid, -99999) F_PARTNUM_OBJID
  FROM (
--BLOCK2
        SELECT NVL2 (usage_qty.F_SET_OF_BOOKS, usage_qty.F_SET_OF_BOOKS, eue_inv.F_SET_OF_BOOKS) F_SET_OF_BOOKS, --NVL2(string1, value_if_not_null, value_if_null)
               NVL2 (usage_qty.F_PART_NUMBER, usage_qty.F_PART_NUMBER, eue_inv.F_PART_NUMBER) F_PART_NUMBER,
               --NVL (wk.f_installed_qty, 0)
               NVL (usage_qty.F_USAGE_QTY_13_WK, 0) F_USAGE_QTY_13_WK,
               --NVL (yr.f_installed_qty, 0)
               NVL (usage_qty.F_USAGE_QTY_1_YR, 0) F_USAGE_QTY_1_YR,
               TRUNC (SYSDATE - 1) f_business_date,
               --NVL (wk_2.f_installed_qty, 0)
               NVL (usage_qty.F_USAGE_QTY_2_WK, 0) F_USAGE_QTY_2_WK,
               NVL (eue_inv.F_PART_GOOD_QTY, 0) F_PART_GOOD_QTY,
               NVL (eue_inv.F_PART_BAD_QTY, 0) F_PART_BAD_QTY,
               eue_inv.F_INVENTORY_DATE
          FROM (
--BLOCK1
            SELECT NVL2(YR.F_SET_OF_BOOKS, YR.F_SET_OF_BOOKS, WK.F_SET_OF_BOOKS) F_SET_OF_BOOKS,
                   NVL2(YR.F_PART_NUMBER, YR.F_PART_NUMBER, WK.F_PART_NUMBER) F_PART_NUMBER,
                   NVL(wk.f_installed_qty, 0) F_USAGE_QTY_13_WK,
                   NVL(yr.f_installed_qty, 0) F_USAGE_QTY_1_YR,
                   TRUNC (SYSDATE - 1) f_business_date,
                   NVL (wk_2.f_installed_qty, 0) F_USAGE_QTY_2_WK
            FROM (
                  SELECT F_SET_OF_BOOKS,
                         UPPER (TRIM (F_PART_NUMBER)) F_PART_NUMBER,
                         SUM (f_installed_qty) f_installed_qty
                  FROM dw.T_DM_CASE_PARTS_SUMMARY_WK --Data is restated on every Saturday early hours for previous 6 months
                  WHERE F_WEEKEND_DATE > (SELECT MAX (F_WEEKEND_DATE) - 91 FROM dw.T_DM_CASE_PARTS_SUMMARY_WK) --91 days, 13 weeks(13*7)
                   AND F_PART_NUMBER IS NOT NULL
                  GROUP BY F_SET_OF_BOOKS, UPPER (TRIM (F_PART_NUMBER))
                 ) wk
             FULL OUTER JOIN (
                    SELECT F_SET_OF_BOOKS,
                           UPPER (TRIM (F_PART_NUMBER)) F_PART_NUMBER,
                           SUM (f_installed_qty) f_installed_qty
                    FROM dw.T_DM_CASE_PARTS_ACTIVITY
                    WHERE f_used_date >= TRUNC (ADD_MONTHS (SYSDATE, -12), 'mm')
                     AND f_used_date <= LAST_DAY (ADD_MONTHS (SYSDATE, -1))
                     AND F_PART_NUMBER IS NOT NULL
                    GROUP BY F_SET_OF_BOOKS, UPPER (TRIM (F_PART_NUMBER))
                  ) yr
              ON WK.F_SET_OF_BOOKS = YR.F_SET_OF_BOOKS AND WK.F_PART_NUMBER = YR.F_PART_NUMBER
              LEFT OUTER JOIN(
                    SELECT F_SET_OF_BOOKS,
                           UPPER (TRIM (F_PART_NUMBER)) F_PART_NUMBER,
                           SUM (f_installed_qty) f_installed_qty
                    FROM dw.T_DM_CASE_PARTS_SUMMARY_WK --Data is restated on every Saturday early hours for previous 6 months
                    WHERE F_WEEKEND_DATE > (SELECT MAX (F_WEEKEND_DATE) - 14 FROM dw.T_DM_CASE_PARTS_SUMMARY_WK) --14 days, 2 weeks(2*7)
                    GROUP BY F_SET_OF_BOOKS, UPPER (TRIM (F_PART_NUMBER))
                  ) wk_2
              ON WK.F_SET_OF_BOOKS = wk_2.F_SET_OF_BOOKS AND WK.F_PART_NUMBER = wk_2.F_PART_NUMBER
            ) usage_qty
--BLOCK1
         FULL OUTER JOIN
         ( SELECT UPPER (TRIM (F_PART_NUMBER)) F_PART_NUMBER,
                  CASE
                   WHEN F_PRICE_PROG_NAME = 'Canadian Dollar' THEN 'CA Customer'
                   WHEN F_PRICE_PROG_NAME = 'United States Dollar' THEN 'US Customer'
                  END F_SET_OF_BOOKS,
                  SUM (F_PART_GOOD_QTY) F_PART_GOOD_QTY,
                  SUM (F_PART_BAD_QTY) F_PART_BAD_QTY,
                  MAX (F_BUSINESS_DATE) F_INVENTORY_DATE
             FROM dw.T_DM_EUE_INVENTORY@dwpro eue_inv
             WHERE F_BUSINESS_DATE = (SELECT MAX (F_BUSINESS_DATE) FROM dw.T_DM_EUE_INVENTORY@dwpro)
             GROUP BY UPPER (TRIM (F_PART_NUMBER)), F_PRICE_PROG_NAME
           ) eue_inv
          ON usage_qty.F_PART_NUMBER = eue_inv.F_PART_NUMBER AND usage_qty.F_SET_OF_BOOKS = eue_inv.F_SET_OF_BOOKS
        ) all_parts,
       (SELECT F_SURROGATE_FK,
               CASE
                  WHEN F_CURRENCY_ID = 'US DOLLAR' THEN 'US Customer'
                  WHEN F_CURRENCY_ID = 'CANADIAN DOLLAR' THEN 'CA Customer'
               END
                  F_CURRENCY_CD
          FROM dw.T_DIM_CURRENCY
         WHERE F_CURRENCY_ID IN ('CANADIAN DOLLAR', 'US DOLLAR')) crncy,
       (SELECT  part_no, partnum_objid
          FROM (  select trim(upper(part_no)) part_no, MAX (partnum_objid) partnum_objid
                    FROM dw.T_DM_CLAR_FRU_PARTS@dwpro
                GROUP BY PART_No
                  HAVING COUNT (*) = 1
                UNION
                  SELECT part_no, MAX (partnum_objid) partnum_objid
                    FROM (SELECT part_no, part_status, partnum_objid
                            FROM dw.T_DM_CLAR_FRU_PARTS@dwpro
                           WHERE part_no IN
                                    (  SELECT part_no
                                         FROM dw.T_DM_CLAR_FRU_PARTS@dwpro
                                     GROUP BY PART_No
                                       HAVING COUNT (*) > 1))
                   WHERE part_status = 'Active'
                GROUP BY part_no       -- Active parts even when in duplicates
                UNION
                  SELECT part_no, MAX (partnum_objid) partnum_objid
                    FROM dw.T_DM_CLAR_FRU_PARTS@dwpro
                   WHERE part_no IN (  SELECT part_no
                                         FROM dw.T_DM_CLAR_FRU_PARTS@dwpro
                                     GROUP BY PART_No
                                       HAVING COUNT (*) > 1
                                     MINUS
                                     SELECT part_no
                                       FROM dw.T_DM_CLAR_FRU_PARTS@dwpro
                                      WHERE part_status = 'Active')
                GROUP BY part_no     -- only InActive parts when in duplicates
                                )) fru
 WHERE     all_parts.F_SET_OF_BOOKS = crncy.F_CURRENCY_CD(+)
       AND trim(upper(all_parts.F_PART_NUMBER)) = fru.part_no(+);
