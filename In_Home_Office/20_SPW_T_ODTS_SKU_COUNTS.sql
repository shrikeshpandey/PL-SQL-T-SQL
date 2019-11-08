CREATE OR REPLACE PROCEDURE DW.SPW_T_ODTS_SKU_COUNTS (iCommit IN NUMBER DEFAULT 2000
) is
   /***********************************************************************************
   ||   PROCEDURE INFORMATION
   ||
   ||   Department:     Data Warehouse
   ||   Programmer:     Luis Fuentes
   ||   Date:           06/19/2019
   ||   Category:       Load Procedure to load TARGET data from SOURCE
   ||
   ||   Description:    LOAD T_DM_ T_ODTS_SKU_COUNTS
   ||
   ||
   ||   Parameters:     iCommit: is batch size used to commit record changes.
   ||
   ||   Load Sequence Number:  NNN
   ||
   ||   Historic Info:
   ||    Name:               Date:        Brief Description:
   ||   -----------------------------------------------------------------------------
   ||    Luis Fuentes        06/19/2019   Adding a grup by operation and fixing WHS_CODE
   ||    Luis Fuentes        06/23/2019   Adding f_case_closed_d
   ||    Luis Fuentes        08/06/2019   Rebuilding table with new fields
   ||   -----------------------------------------------------------------------------
   ||
   ||   CURRENT REVISION STANDARD:  v1.50
   ||
   ***********************************************************************************/
/*******************************************************************************************
*  Generated using sp_gen_bulk() jg 2006
*******************************************************************************************/
CURSOR c is
SELECT skulist.f_case_id,
       skulist.sku,
       -- extract SKU no
       TO_CHAR(substr(skulist.sku,6,nvl(instr(upper(skulist.sku), '-'),14) - 6)) As SKU_NO,
       -- extract SKU description
       CASE
         WHEN instr(upper(skulist.sku), 'TION') = '21' OR instr(upper(skulist.sku), 'TION') = '22' -- find the end of 'Selection:' on SKU: line
              THEN TRIM(substr(upper(skulist.sku), instr(upper(skulist.sku), 'TION:') + 6, 50))
         WHEN instr(upper(skulist.sku), 'DESCRIPTION') = 7 
              THEN TRIM(substr(upper(skulist.sku), instr(upper(skulist.sku), 'DESCRIPTION:') + 20, 50))
         WHEN instr(upper(skulist.sku), '-') = 14  -- catch SKU lines that do not have 'Selection' after SKU:
              THEN TRIM(substr(upper(skulist.sku), instr(upper(skulist.sku), '-') + 1, 50))  
         WHEN instr(upper(skulist.sku), '36513849') = 6 -- RECON SENTINEL
              THEN TRIM(substr(upper(skulist.sku), instr(upper(skulist.sku), '36513849') + 11, 50))
         WHEN instr(upper(skulist.sku), '57605171') = 6 -- RECON SENTINEL
              THEN TRIM(substr(upper(skulist.sku), instr(upper(skulist.sku), '57605171') + 11, 50))
         WHEN instr(upper(skulist.sku), '9361598') = 6  -- REMOTE PRINTER SETUP
              THEN TRIM(substr(upper(skulist.sku), instr(upper(skulist.sku), '9361598') + 10, 50))
         WHEN instr(upper(skulist.sku), '182451') = 6  -- SOFTWARE INSTALL NON ESD
              THEN TRIM(substr(upper(skulist.sku), instr(upper(skulist.sku), '182451') + 9, 50))
         ELSE
          'THROW OUT'
       END AS SKU_DESC,
       skulist.qty,
       skulist.f_case_closed_d
  
  FROM (
           -- find 'Customer Entitlement Code' and Quantity if no 'SKU'
           (SELECT dw.t_clar_ods_case.f_case_id,
                'SKU: ' ||  
                TO_CHAR(substr(dw.t_clar_notes_log.description,
                               -- starting pos
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Customer Entitlement Code:',1,1) + 27,
                               -- length
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(10),
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Customer Entitlement Code:',1,1),1) 
                                     - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Customer Entitlement Code:',1,1)- 28))
                || ' - Selection: ' ||                    
                TO_CHAR(substr(dw.t_clar_notes_log.description,
                               -- starting pos
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Description:',1,1) + 13,
                               -- length
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(10),
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Description:',1,1),1) 
                                     - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Description:',1,1)- 14)) AS sku,
                nvl(to_number(substr(dw.t_clar_notes_log.description,
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,1) + 10,
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(10),
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,1),1) 
                                     - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,1) - 10)),1) AS qty,
                dw.t_clar_ods_case.F_CASE_CLOSED_D AS f_case_closed_d
           
           FROM dw.t_clar_notes_log, dw.t_clar_case, dw.t_clar_ods_case
           WHERE dw.t_clar_notes_log.case_notes2case = dw.t_clar_case.objid
              AND dw.t_clar_case.s_id_number = dw.t_clar_ods_case.f_case_id
              AND dw.t_clar_ods_case.f_case_id <> 'C181106-14726851'
              AND dw.t_clar_ods_case.f_case_id <> 'C181001-14627708'
              AND TO_CHAR(substr(dw.t_clar_notes_log.description,
                                 instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Description:',1,1),
                                 instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(10),
                                       instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Description:',1,1),1) 
                                       - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Description:',1,1))) IS NOT NULL
              AND dw.t_clar_ods_case.f_cust_corp_id = '243741'
              AND dw.t_clar_notes_log.action_type = 'Inbound Prob Desc and Extra - ESR'
              AND dw.t_clar_notes_log.description NOT LIKE '%SKU:%'
              AND dw.t_clar_notes_log.description LIKE '%Description:%'
              AND dw.t_clar_notes_log.description LIKE '%Partner ID: TSE%'
              -- 'SKU:' does not exist
              AND instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:', 1,1) = 0) 
                      
       UNION ALL
       -- Get SKU info for TOGa if ESR has additional SKUs
           (SELECT dw.t_clar_ods_case.f_case_id,
                'SKU: ' ||  
                TO_CHAR(substr(dw.t_clar_notes_log.description,
                               -- starting pos
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Customer Entitlement Code:',1,1) + 27,
                               -- length
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(10),
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Customer Entitlement Code:',1,1),1) 
                                     - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Customer Entitlement Code:',1,1)- 28))
                || ' - Selection: ' ||                    
                TO_CHAR(substr(dw.t_clar_notes_log.description,
                               -- starting pos
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Description:',1,1) + 13,
                               -- length
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(10),
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Description:',1,1),1) 
                                     - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Description:',1,1)- 14)) AS sku,
                nvl(to_number(substr(dw.t_clar_notes_log.description,
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,1) + 10,
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(10),
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,1),1) 
                                     - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,1) - 10)),1) AS qty,
                dw.t_clar_ods_case.F_CASE_CLOSED_D AS f_case_closed_d
           
           FROM dw.t_clar_notes_log, dw.t_clar_case, dw.t_clar_ods_case
           WHERE dw.t_clar_notes_log.case_notes2case = dw.t_clar_case.objid
              AND dw.t_clar_case.s_id_number = dw.t_clar_ods_case.f_case_id
              AND dw.t_clar_ods_case.f_case_id <> 'C181106-14726851'
              AND dw.t_clar_ods_case.f_case_id <> 'C181001-14627708'
              AND TO_CHAR(substr(dw.t_clar_notes_log.description,
                                 instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Description:',1,1),
                                 instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(10),
                                       instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Description:',1,1),1) 
                                       - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Description:',1,1))) IS NOT NULL
              AND dw.t_clar_ods_case.f_cust_corp_id = '243741'
              AND dw.t_clar_notes_log.action_type = 'Inbound Prob Desc and Extra - ESR'
              AND dw.t_clar_notes_log.description LIKE '%ADDITIONAL SKUS:%'
              AND dw.t_clar_notes_log.description LIKE '%Partner ID: TSE%'
              AND instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:', 1,1) > 0) 
                      
       UNION ALL
         -- Find first occurance of 'SKU:'
        (
        
        SELECT dw.t_clar_ods_case.f_case_id,
        
                TO_CHAR(substr(dw.t_clar_notes_log.description,
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992), 'SKU:', 1, 1),  
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992), CHR(13), instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992), 'SKU:', 1, 1), 1) 
                               - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:', 1,1))) AS sku,
                               
                nvl(to_number(substr(dw.t_clar_notes_log.description,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:', 1, 1) + 10,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992), CHR(13),
                                           instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992), 'Quantity:', 1, 1), 1) 
                                           - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:', 1, 1) - 10)), '1') AS qty,
                                           
                    dw.t_clar_ods_case.F_CASE_CLOSED_D AS f_case_closed_d
          
          FROM dw.t_clar_notes_log, dw.t_clar_case, dw.t_clar_ods_case
          WHERE dw.t_clar_notes_log.case_notes2case = dw.t_clar_case.objid
            AND dw.t_clar_case.s_id_number = dw.t_clar_ods_case.f_case_id
            AND dw.t_clar_ods_case.f_case_id <> 'C181106-14726851'
            AND dw.t_clar_ods_case.f_case_id <> 'C181001-14627708'
            AND dw.t_clar_ods_case.f_cust_corp_id = '243741'
            AND dw.t_clar_notes_log.action_type = 'Inbound Prob Desc and Extra - ESR'
            AND dw.t_clar_notes_log.description LIKE '%SKU%'
            AND dw.t_clar_notes_log.description LIKE '%Partner ID: TSE%'
            AND dw.t_clar_ods_case.f_case_created_d >= '09mar2018'
            AND instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992), 'SKU:', 1, 1) > '0') 
         
       UNION ALL
         -- Find second occurance of 'SKU:'
        (SELECT dw.t_clar_ods_case.f_case_id,
                TO_CHAR(substr(dw.t_clar_notes_log.description,
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,2),
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(13),
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,2),1) 
                                     - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,2))) AS sku,
                nvl(to_number(substr(dw.t_clar_notes_log.description,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,2) + 10,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(13),
                                           instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',2,1),1) 
                                           - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,2) - 10)),'1') AS qty,
                    dw.t_clar_ods_case.F_CASE_CLOSED_D AS f_case_closed_d
           
           FROM dw.t_clar_notes_log, dw.t_clar_case, dw.t_clar_ods_case
          WHERE dw.t_clar_notes_log.case_notes2case = dw.t_clar_case.objid
            AND dw.t_clar_case.s_id_number = dw.t_clar_ods_case.f_case_id
            AND dw.t_clar_ods_case.f_case_id <> 'C181106-14726851'
            AND dw.t_clar_ods_case.f_case_id <> 'C181001-14627708'
            AND dw.t_clar_ods_case.f_cust_corp_id = '243741'
            AND dw.t_clar_notes_log.action_type = 'Inbound Prob Desc and Extra - ESR'
            AND dw.t_clar_notes_log.description LIKE '%SKU%'
            AND dw.t_clar_notes_log.description LIKE '%Partner ID: TSE%'
            AND dw.t_clar_ods_case.f_case_created_d >= '09mar2018'
            AND instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,2) > '0') 
        
      UNION ALL
        -- Find third occurance of 'SKU:'
        (SELECT dw.t_clar_ods_case.f_case_id,
                TO_CHAR(substr(dw.t_clar_notes_log.description,
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,3),
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(13),
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,3),1) 
                                     - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,3))) AS sku,
                nvl(to_number(substr(dw.t_clar_notes_log.description,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,3) + 10,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(13),
                                           instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,3),1) 
                                           - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,3) - 10)),'1') AS qty,
                    dw.t_clar_ods_case.F_CASE_CLOSED_D AS f_case_closed_d
           
           FROM dw.t_clar_notes_log, dw.t_clar_case, dw.t_clar_ods_case
          WHERE dw.t_clar_notes_log.case_notes2case = dw.t_clar_case.objid
            AND dw.t_clar_case.s_id_number = dw.t_clar_ods_case.f_case_id
            AND dw.t_clar_ods_case.f_case_id <> 'C181106-14726851'
            AND dw.t_clar_ods_case.f_case_id <> 'C181001-14627708'
            AND dw.t_clar_ods_case.f_cust_corp_id = '243741'
            AND dw.t_clar_notes_log.action_type ='Inbound Prob Desc and Extra - ESR'
            AND dw.t_clar_notes_log.description LIKE '%SKU%'
            AND dw.t_clar_notes_log.description LIKE '%Partner ID: TSE%'
            AND dw.t_clar_ods_case.f_case_created_d >= '09mar2018'
            AND instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,3) > '0') 
                      
      UNION ALL
        -- Find forth occurance of 'SKU:' -----------------------------------------PROBLEM
        (SELECT dw.t_clar_ods_case.f_case_id,
                TO_CHAR(substr(dw.t_clar_notes_log.description,
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,4),
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(13),
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,4),1) 
                                     - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,4))) AS sku,
                nvl(to_number(substr(dw.t_clar_notes_log.description,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,4) + 10,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(13),
                                           instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,4),1) 
                                           - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,4) - 10)),'1') AS qty,
                    dw.t_clar_ods_case.F_CASE_CLOSED_D AS f_case_closed_d
           
           FROM dw.t_clar_notes_log, dw.t_clar_case, dw.t_clar_ods_case
          WHERE dw.t_clar_notes_log.case_notes2case = dw.t_clar_case.objid
            AND dw.t_clar_case.s_id_number = dw.t_clar_ods_case.f_case_id
            AND dw.t_clar_ods_case.f_case_id <> 'C181106-14726851'
            AND dw.t_clar_ods_case.f_case_id <> 'C181001-14627708'
            AND dw.t_clar_ods_case.f_cust_corp_id = '243741'
            AND dw.t_clar_notes_log.action_type =
                'Inbound Prob Desc and Extra - ESR'
            AND dw.t_clar_notes_log.description LIKE '%SKU%'
            AND dw.t_clar_notes_log.description LIKE '%Partner ID: TSE%'
            AND dw.t_clar_ods_case.f_case_created_d >= '09mar2018'
            AND INSTR(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:', 1, 4) > '0') 
         
     UNION ALL
         -- Find fifth occurance of 'SKU:' -----------------------------------------PROBLEM
        (SELECT dw.t_clar_ods_case.f_case_id,
                TO_CHAR(substr(dw.t_clar_notes_log.description,
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,5),
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(13),
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,5),1) 
                                     - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,5))) AS sku,
                nvl(to_number(substr(dw.t_clar_notes_log.description,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,5) + 10,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(13),
                                           instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,5),1) 
                                           - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,5) - 10)),'1') AS qty,
                    dw.t_clar_ods_case.F_CASE_CLOSED_D AS f_case_closed_d
           
           FROM dw.t_clar_notes_log, dw.t_clar_case, dw.t_clar_ods_case
          WHERE dw.t_clar_notes_log.case_notes2case = dw.t_clar_case.objid
            AND dw.t_clar_case.s_id_number = dw.t_clar_ods_case.f_case_id
            AND dw.t_clar_ods_case.f_case_id <> 'C181106-14726851'
            AND dw.t_clar_ods_case.f_case_id <> 'C181001-14627708'
            AND dw.t_clar_ods_case.f_cust_corp_id = '243741'
            AND dw.t_clar_notes_log.action_type = 'Inbound Prob Desc and Extra - ESR'
            AND dw.t_clar_notes_log.description LIKE '%SKU%'
            AND dw.t_clar_notes_log.description LIKE '%Partner ID: TSE%'
            AND dw.t_clar_ods_case.f_case_created_d >= '09mar2018'
            AND instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,5) > '0') 
        
     UNION ALL
        -- Find sixth occurance of 'SKU:' -----------------------------------------PROBLEM
        (SELECT dw.t_clar_ods_case.f_case_id,
                TO_CHAR(substr(dw.t_clar_notes_log.description,
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,6),
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(13),
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,6),1) 
                                     - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,6))) AS sku,
                nvl(to_number(substr(dw.t_clar_notes_log.description,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,6) + 10,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(13),
                                           instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,6),1) 
                                           - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,6) - 10)),'1') AS qty,
                    dw.t_clar_ods_case.F_CASE_CLOSED_D AS f_case_closed_d
           
           FROM dw.t_clar_notes_log, dw.t_clar_case, dw.t_clar_ods_case
          WHERE dw.t_clar_notes_log.case_notes2case = dw.t_clar_case.objid
            AND dw.t_clar_case.s_id_number = dw.t_clar_ods_case.f_case_id
            AND dw.t_clar_ods_case.f_case_id <> 'C181106-14726851'
            AND dw.t_clar_ods_case.f_case_id <> 'C181001-14627708'
            AND dw.t_clar_ods_case.f_cust_corp_id = '243741'
            AND dw.t_clar_notes_log.action_type = 'Inbound Prob Desc and Extra - ESR'
            AND dw.t_clar_notes_log.description LIKE '%SKU%'
            AND dw.t_clar_notes_log.description LIKE '%Partner ID: TSE%'
            AND dw.t_clar_ods_case.f_case_created_d >= '09mar2018'
            AND instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,6) > '0') 
         
      UNION ALL
         -- Find seventh occurance of 'SKU:' -----------------------------------------PROBLEM
        (SELECT dw.t_clar_ods_case.f_case_id,
                TO_CHAR(substr(dw.t_clar_notes_log.description,
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,7),
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(13),
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,7),1) 
                                     - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,7))) AS sku,
                nvl(to_number(substr(dw.t_clar_notes_log.description,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,7) + 10,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(13),
                                           instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,7),1) 
                                           - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,7) - 10)),'1') AS qty,
                    dw.t_clar_ods_case.F_CASE_CLOSED_D AS f_case_closed_d
           
           FROM dw.t_clar_notes_log, dw.t_clar_case, dw.t_clar_ods_case
          WHERE dw.t_clar_notes_log.case_notes2case = dw.t_clar_case.objid
            AND dw.t_clar_case.s_id_number = dw.t_clar_ods_case.f_case_id
            AND dw.t_clar_ods_case.f_case_id <> 'C181106-14726851'
            AND dw.t_clar_ods_case.f_case_id <> 'C181001-14627708'
            AND dw.t_clar_ods_case.f_cust_corp_id = '243741'
            AND dw.t_clar_notes_log.action_type ='Inbound Prob Desc and Extra - ESR'
            AND dw.t_clar_notes_log.description LIKE '%SKU%'
            AND dw.t_clar_notes_log.description LIKE '%Partner ID: TSE%'
            AND dw.t_clar_ods_case.f_case_created_d >= '09mar2018'
            AND instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,7) > '0') 
         
      UNION ALL
         -- Find eithth occurance of 'SKU:' -----------------------------------------PROBLEM
        (SELECT dw.t_clar_ods_case.f_case_id,
                TO_CHAR(substr(dw.t_clar_notes_log.description,
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,8),
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(13),
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,8),1) 
                                     - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,8))) AS sku,
                nvl(to_number(substr(dw.t_clar_notes_log.description,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,8) + 10,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(13),
                                           instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,8),1) 
                                           - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,8) - 10)),'1') AS qty,
                    dw.t_clar_ods_case.F_CASE_CLOSED_D AS f_case_closed_d
           
           FROM dw.t_clar_notes_log, dw.t_clar_case, dw.t_clar_ods_case
          WHERE dw.t_clar_notes_log.case_notes2case = dw.t_clar_case.objid
            AND dw.t_clar_case.s_id_number = dw.t_clar_ods_case.f_case_id
            AND dw.t_clar_ods_case.f_case_id <> 'C181106-14726851'
            AND dw.t_clar_ods_case.f_case_id <> 'C181001-14627708'
            AND dw.t_clar_ods_case.f_cust_corp_id = '243741'
            AND dw.t_clar_notes_log.action_type = 'Inbound Prob Desc and Extra - ESR'
            AND dw.t_clar_notes_log.description LIKE '%SKU%'
            AND dw.t_clar_notes_log.description LIKE '%Partner ID: TSE%'
            AND dw.t_clar_ods_case.f_case_created_d >= '09mar2018'
            AND instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,8) > '0') 
         
     UNION ALL
         -- Find ninth occurance of 'SKU:' -----------------------------------------PROBLEM
        (SELECT dw.t_clar_ods_case.f_case_id,
                TO_CHAR(substr(dw.t_clar_notes_log.description,
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,9),
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(13),
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,9),1) 
                                     - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,9))) AS sku,
                nvl(to_number(substr(dw.t_clar_notes_log.description,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,9) + 10,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(13),
                                           instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,9),1) 
                                           - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,9) - 10)),'1') AS qty,
                    dw.t_clar_ods_case.F_CASE_CLOSED_D AS f_case_closed_d
           
           FROM dw.t_clar_notes_log, dw.t_clar_case, dw.t_clar_ods_case
          WHERE dw.t_clar_notes_log.case_notes2case = dw.t_clar_case.objid
            AND dw.t_clar_case.s_id_number = dw.t_clar_ods_case.f_case_id
            AND dw.t_clar_ods_case.f_case_id <> 'C181106-14726851'
            AND dw.t_clar_ods_case.f_case_id <> 'C181001-14627708'
            AND dw.t_clar_ods_case.f_cust_corp_id = '243741'
            AND dw.t_clar_notes_log.action_type ='Inbound Prob Desc and Extra - ESR'
            AND dw.t_clar_notes_log.description LIKE '%SKU%'
            AND dw.t_clar_notes_log.description LIKE '%Partner ID: TSE%'
            AND dw.t_clar_ods_case.f_case_created_d >= '09mar2018'
            AND instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,9) > '0') 
        
    UNION ALL
        -- Find tenth occurance of 'SKU:' -----------------------------------------PROBLEM
        (SELECT dw.t_clar_ods_case.f_case_id,
                TO_CHAR(substr(dw.t_clar_notes_log.description,
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,10),
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(13),
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,10),1) 
                                     - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,10))) AS sku,
                nvl(to_number(substr(dw.t_clar_notes_log.description,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,10) + 10,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(13),
                                           instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',10,1),1) 
                                           - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,10) - 10)),'1') AS qty,
                    dw.t_clar_ods_case.F_CASE_CLOSED_D AS f_case_closed_d
           
           FROM dw.t_clar_notes_log, dw.t_clar_case, dw.t_clar_ods_case
          WHERE dw.t_clar_notes_log.case_notes2case = dw.t_clar_case.objid
            AND dw.t_clar_case.s_id_number = dw.t_clar_ods_case.f_case_id
            AND dw.t_clar_ods_case.f_case_id <> 'C181106-14726851'
            AND dw.t_clar_ods_case.f_case_id <> 'C181001-14627708'
            AND dw.t_clar_ods_case.f_cust_corp_id = '243741'
            AND dw.t_clar_notes_log.action_type = 'Inbound Prob Desc and Extra - ESR'
            AND dw.t_clar_notes_log.description LIKE '%SKU%'
            AND dw.t_clar_notes_log.description LIKE '%Partner ID: TSE%'
            AND dw.t_clar_ods_case.f_case_created_d >= '09mar2018'
            AND instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,10) > '0') 
        
     UNION ALL
        -- Find eleventh occurance of 'SKU:' -----------------------------------------PROBLEM
        (SELECT dw.t_clar_ods_case.f_case_id,
                TO_CHAR(substr(dw.t_clar_notes_log.description,
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,11),
                               instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(13),
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,11),1) 
                                     - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,11))) AS sku,
                nvl(to_number(substr(dw.t_clar_notes_log.description,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,11) + 10,
                                     instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),CHR(13),
                                           instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,11),1) 
                                           - instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'Quantity:',1,11) - 10)),'1') AS qty,
                    dw.t_clar_ods_case.F_CASE_CLOSED_D AS f_case_closed_d
           
           FROM dw.t_clar_notes_log, dw.t_clar_case, dw.t_clar_ods_case
          WHERE dw.t_clar_notes_log.case_notes2case = dw.t_clar_case.objid
            AND dw.t_clar_case.s_id_number = dw.t_clar_ods_case.f_case_id
            AND dw.t_clar_ods_case.f_case_id <> 'C181106-14726851'
            AND dw.t_clar_ods_case.f_case_id <> 'C181001-14627708'
            AND dw.t_clar_ods_case.f_cust_corp_id = '243741'
            AND dw.t_clar_notes_log.action_type ='Inbound Prob Desc and Extra - ESR'
            AND dw.t_clar_notes_log.description LIKE '%SKU%'
            AND dw.t_clar_notes_log.description LIKE '%Partner ID: TSE%'
            AND dw.t_clar_ods_case.f_case_created_d >= '09mar2018'
            AND instr(SUBSTR(dw.t_clar_notes_log.description, 1, 3992),'SKU:',1,11) > '0') 
            
            ORDER BY 1) skulist
            
       --exclude cases with SKU_Description of "THROW OUT"     
       where       
        (CASE
         WHEN instr(upper(skulist.sku), 'TION') = '21' OR instr(upper(skulist.sku), 'TION') = '22' -- find the end of 'Selection:' on SKU: line
              THEN TRIM(substr(upper(skulist.sku), instr(upper(skulist.sku), 'TION:') + 6, 50))
         WHEN instr(upper(skulist.sku), 'DESCRIPTION') = 7 
              THEN TRIM(substr(upper(skulist.sku), instr(upper(skulist.sku), 'DESCRIPTION:') + 20, 50))
         WHEN instr(upper(skulist.sku), '-') = 14  -- catch SKU lines that do not have 'Selection' after SKU:
              THEN TRIM(substr(upper(skulist.sku), instr(upper(skulist.sku), '-') + 1, 50))  
         WHEN instr(upper(skulist.sku), '36513849') = 6 -- RECON SENTINEL
              THEN TRIM(substr(upper(skulist.sku), instr(upper(skulist.sku), '36513849') + 11, 50))
         WHEN instr(upper(skulist.sku), '57605171') = 6 -- RECON SENTINEL
              THEN TRIM(substr(upper(skulist.sku), instr(upper(skulist.sku), '57605171') + 11, 50))
         WHEN instr(upper(skulist.sku), '9361598') = 6  -- REMOTE PRINTER SETUP
              THEN TRIM(substr(upper(skulist.sku), instr(upper(skulist.sku), '9361598') + 10, 50))
         WHEN instr(upper(skulist.sku), '182451') = 6  -- SOFTWARE INSTALL NON ESD
              THEN TRIM(substr(upper(skulist.sku), instr(upper(skulist.sku), '182451') + 9, 50))
         ELSE
          'THROW OUT'
       END) <> 'THROW OUT'
      --and skulist.f_case_id in ('C190706-15322921','C190630-15310098', 'C190629-15309755','C190708-15325036','C190630-15310088')
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
f_case_id_t           dbms_sql.VARCHAR2_table;        
sku_t                 dbms_sql.VARCHAR2_table;
sku_no_t              dbms_sql.VARCHAR2_table;
sku_desc_t            dbms_sql.VARCHAR2_table;
qty_t                 dbms_sql.NUMBER_table; 
f_case_closed_d_t     dbms_sql.DATE_table; 

-- DW_MOD_DATE_t dbms_sql.DATE_table;
-- DW_LOAD_DATE_t dbms_sql.DATE_table;

BEGIN --B1

  -- Conditional Create of New Seq Number

dw.sp_md_get_next_seq('T_ODTS_SKU_COUNTS',
     'T_ODTS_SKU_COUNTS',
     'OBJID',
     1, --- ACTIVE CODE 1 OR 0 PRETTY MUCH ALWAYS ACTIVE '
     'T_ODTS_SKU_COUNTS',
     'ORACLE DB-LINK',
     'DW TABLE LOAD',
     'SPW_T_ODTS_SKU_COUNTS',
     iLoadSequence,
     'DW');

dw.pkg_load_verify.p_begin_load(iloadsequence,iloadinstanceseq);
dw.sp_truncate('DW.T_ODTS_SKU_COUNTS');

OPEN c;
LOOP
     FETCH c BULK COLLECT INTO
            f_case_id_t,        
            sku_t,
            sku_no_t,
            sku_desc_t,
            qty_t, 
            f_case_closed_d_t 
     LIMIT iCommit;
     FOR i in 1..F_CASE_ID_t.COUNT
     LOOP
          BEGIN --B2 insert
          INSERT INTO DW.T_ODTS_SKU_COUNTS(
                   f_case_id,
                   sku,
                   sku_no,
                   sku_desc,
                   qty,
                   f_case_closed_d
          )
          VALUES (
            f_case_id_t(i),        
            sku_t(i),
            sku_no_t(i),
            sku_desc_t(i),
            qty_t(i), 
            f_case_closed_d_t(i) 
          );
EXCEPTION --B2
     WHEN OTHERS THEN
     --INSERT ERROR INFORMATION
          BEGIN --B4
          itotalerrors := itotalerrors + 1;
          dw.pkg_load_verify.p_record_exception(iloadinstanceseq
          ,substr('DW.T_ODTS_SKU_COUNTS err:'||sqlerrm,1,256)
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
          ,substr('DW.T_ODTS_SKU_COUNTS GENERAL err:'||sqlerrm,1,256)
          ,SQLCODE
          ,SQLERRM
          ,'');
          END; --B4
     ------------------------------------------------------
     -- END MAIN
     ------------------------------------------------------
END; --B1
/

GRANT EXECUTE ON DW.SPW_T_ODTS_SKU_COUNTS TO TM1_ETL_ROLE;
GRANT EXECUTE ON DW.SPW_T_ODTS_SKU_COUNTS TO SERVICE_ROLE;
GRANT EXECUTE ON DW.SPW_T_ODTS_SKU_COUNTS TO LF188653;
