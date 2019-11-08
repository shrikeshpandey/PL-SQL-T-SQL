--DW.T_VENDOR_INVENTORY ITEM_NO % COVERED 

WITH CTE1 AS (
  SELECT reportnameprovided, count(*) AS TotalNumber
  FROM DW.T_VENDOR_INVENTORY
  GROUP BY reportnameprovided
)
SELECT CTE1.reportnameprovided, 
       CASE 
         WHEN ACTUAL.reportnameprovided IS NOT NULL THEN ROUND(((ACTUAL.TOTALNOTNULL * 100)/CTE1.TotalNumber),2)||'%'
         ELSE '-100.00%'
       END AS T_LKP_VENDOR_SKU_PORCENTAGE
FROM CTE1
LEFT JOIN (
  SELECT reportnameprovided, COUNT(*) AS TOTALNOTNULL
  FROM DW.T_VENDOR_INVENTORY
  WHERE item_no IS NOT NULL
  GROUP BY reportnameprovided
) ACTUAL
 ON CTE1.reportnameprovided = ACTUAL.reportnameprovided
ORDER BY 1