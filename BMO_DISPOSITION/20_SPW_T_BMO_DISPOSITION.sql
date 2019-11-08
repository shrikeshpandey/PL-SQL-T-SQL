CREATE OR REPLACE PROCEDURE DW.SPW_T_BMO_DISPOSITION (
  iCommit   IN INTEGER DEFAULT 2000
) is
/*************************************************************************************************
||   QUERY INFORMATION
||
||   Department:     Value Engineering
||   Programmer:     Luis Fuentes
||   Date:           10/12/2019
||   Category:       SQL Tunning Report 
||   Description:    This query loads data into DW.T_BMO_DISPOSITION
||
||   Parameters:     None
||
||   Historic Info:
||   Name:           Date:         Brief Description:
||   ----------------------------------------------------------------------------------------------
||   Luis Fuentes    10/12/2019    Initial creation
||   ----------------------------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***************************************************************************************************/
CURSOR c IS
SELECT stg.*,
       TRIM(o.f_cust_reference_id) AS poNum,
       CASE
         WHEN LENGTH(stg.redeploy) != 0 THEN 'Redeploy'
         WHEN LENGTH(stg.donate) != 0 THEN  'Donate'
         WHEN LENGTH(stg.recycle) !=0 THEN  'Recycle'
       END AS dispType,
       TRIM(o.f_cust_site_id) AS siteId,
       TRIM(o.f_cust_site_address_1) AS addr1,
       TRIM(o.f_cust_site_city) AS city2,
       TRIM(o.f_cust_site_state) AS prov,
       TRIM(o.f_cust_site_zip) AS postCd,
       TRIM(c.x_flex2) AS costCtr,
       UPPER(TRIM(o.f_cust_site_address_2)) AS floorNo,
       'MIDDLEFIELD' as warehouse
FROM DW.T_CLAR_ODS_CASE o
INNER JOIN DW.T_CLAR_CASE c
 ON o.f_case_key = c.objid
INNER JOIN (
      --1.- TRANSFORM DATA IN IN AN INNNERJOIN
  SELECT UPPER(TRIM(case_id)) AS case_id
        ,TO_DATE(TRIM(recv_date), 'mm/dd/yyyy') AS recv_date
        ,TRIM(store_address) AS store_address
        ,TRIM(floor_id) AS floor_id
        ,TRIM(city) AS city1
        ,TRIM(postal_code) AS postal_code
        ,TRIM(asset_tag) AS asset_tag
        ,TRIM(serial) AS serial
        ,TRIM(brand) AS brand
        ,TRIM(model) AS model
        ,TRIM(type_desc) AS type_desc
        ,TRIM(skid) AS skid
        ,TRIM(text) AS text
        ,TRIM(redeploy) AS redeploy
        ,TRIM(donate) AS donate
        ,TRIM(recycle) AS recycle
        ,TRIM(bmo_comments) AS bmo_comments
  FROM DW.T_BMO_DISPOSITION_STG) stg
 ON o.f_case_id = stg.case_id
INNER JOIN DW.T_DIM_DATE t
 ON stg.recv_date = t.day_dt
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
--bulk collect variables c CURSOR
case_id_t DBMS_SQL.VARCHAR2_TABLE;
recv_date_t DBMS_SQL.DATE_TABLE;
store_address_t DBMS_SQL.VARCHAR2_TABLE;
floor_id_t DBMS_SQL.VARCHAR2_TABLE;
city1_t DBMS_SQL.VARCHAR2_TABLE;
postal_code_t DBMS_SQL.VARCHAR2_TABLE;
asset_tag_t DBMS_SQL.VARCHAR2_TABLE;
serial_t DBMS_SQL.VARCHAR2_TABLE;
brand_t DBMS_SQL.VARCHAR2_TABLE;
model_t DBMS_SQL.VARCHAR2_TABLE;
type_desc_t DBMS_SQL.VARCHAR2_TABLE;
skid_t DBMS_SQL.VARCHAR2_TABLE;
text_t DBMS_SQL.VARCHAR2_TABLE;
redeploy_t DBMS_SQL.VARCHAR2_TABLE;
donate_t DBMS_SQL.VARCHAR2_TABLE;
recycle_t DBMS_SQL.VARCHAR2_TABLE;
bmo_comments_t DBMS_SQL.VARCHAR2_TABLE;
ponum_t DBMS_SQL.VARCHAR2_TABLE;
disptype_t DBMS_SQL.VARCHAR2_TABLE;
siteid_t DBMS_SQL.VARCHAR2_TABLE;
addr1_t DBMS_SQL.VARCHAR2_TABLE;
city2_t DBMS_SQL.VARCHAR2_TABLE;
prov_t DBMS_SQL.VARCHAR2_TABLE;
postcd_t DBMS_SQL.VARCHAR2_TABLE;
costctr_t DBMS_SQL.VARCHAR2_TABLE;
floorno_t DBMS_SQL.VARCHAR2_TABLE;
warehouse_t DBMS_SQL.VARCHAR2_TABLE;

BEGIN --B1

-- Conditional Create of New Seq Number
dw.sp_md_get_next_seq('T_BMO_DISPOSITION',
     'T_BMO_DISPOSITION',
     'OBJID',
     1, --- ACTIVE CODE 1 OR 0 PRETTY MUCH ALWAYS ACTIVE '
     'T_BMO_DISPOSITION',
     'ORACLE DB-LINK',
     'DW TABLE LOAD',
     'SPW_T_BMO_DISPOSITION',
     iLoadSequence,
     'DW');

dw.pkg_load_verify.p_begin_load(iloadsequence,iloadinstanceseq);
-----------------------------------------------------------------
--Calculate and load new data
-----------------------------------------------------------------
OPEN c;
LOOP
     FETCH c BULK COLLECT INTO
          case_id_t,
          recv_date_t,
          store_address_t,
          floor_id_t,
          city1_t,
          postal_code_t,
          asset_tag_t,
          serial_t,
          brand_t,
          model_t,
          type_desc_t,
          skid_t,
          text_t,
          redeploy_t,
          donate_t,
          recycle_t,
          bmo_comments_t,
          ponum_t,
          disptype_t,
          siteid_t,
          addr1_t,
          city2_t,
          prov_t,
          postcd_t,
          costctr_t,
          floorno_t,
          warehouse_t
     LIMIT iCommit;
     FOR i in 1 .. case_id_t.COUNT
     LOOP
          BEGIN --B2 insert
          INSERT INTO DW.T_BMO_DISPOSITION (
            case_id,
            recv_date,
            store_address,
            floor_id,
            city1,
            postal_code,
            asset_tag,
            serial,
            brand,
            model,
            type_desc,
            skid,
            text,
            redeploy,
            donate,
            recycle,
            bmo_comments,
            ponum,
            disptype,
            siteid,
            addr1,
            city2,
            prov,
            postcd,
            costctr,
            floorno,
            warehouse
          )
          VALUES (
            case_id_t(i),
            recv_date_t(i),
            store_address_t(i),
            floor_id_t(i),
            city1_t(i),
            postal_code_t(i),
            asset_tag_t(i),
            serial_t(i),
            brand_t(i),
            model_t(i),
            type_desc_t(i),
            skid_t(i),
            text_t(i),
            redeploy_t(i),
            donate_t(i),
            recycle_t(i),
            bmo_comments_t(i),
            ponum_t(i),
            disptype_t(i),
            siteid_t(i),
            addr1_t(i),
            city2_t(i),
            prov_t(i),
            postcd_t(i),
            costctr_t(i),
            floorno_t(i),
            warehouse_t(i)
          );
EXCEPTION -- B2
  WHEN DUP_VAL_ON_INDEX THEN
  --UPDATE ERROR Information
  BEGIN--B3
  UPDATE DW.T_BMO_DISPOSITION
  SET case_id = case_id_t(i),
      recv_date = recv_date_t(i),
      store_address = store_address_t(i),
      floor_id = floor_id_t(i),
      city1 = city1_t(i),
      postal_code = postal_code_t(i),
      asset_tag = asset_tag_t(i),
      serial = serial_t(i),
      brand = brand_t(i),
      model = model_t(i),
      type_desc = type_desc_t(i),
      skid = skid_t(i),
      text = text_t(i),
      redeploy = redeploy_t(i),
      donate = donate_t(i),
      recycle = recycle_t(i),
      bmo_comments = bmo_comments_t(i),
      ponum = ponum_t(i),
      disptype = disptype_t(i),
      siteid = siteid_t(i),
      addr1 = addr1_t(i),
      city2 = city2_t(i),
      prov = prov_t(i),
      postcd = postcd_t(i),
      costctr = costctr_t(i),
      floorno = floorno_t(i),
      warehouse = warehouse_t(i),
      dw_mod_date = sysdate
  WHERE case_id = case_id_t(i) 
    AND recv_date = recv_date_t(i)
    AND store_address = store_address_t(i)
    AND floor_id = floor_id_t(i)
    AND city1 = city1_t(i)
    AND postal_code = postal_code_t(i)
    AND asset_tag = asset_tag_t(i)
    AND serial = serial_t(i)
    AND brand = brand_t(i)
    AND model = model_t(i)
    AND type_desc = type_desc_t(i)
    AND skid = skid_t(i)
    AND text = text_t(i)
    AND redeploy = redeploy_t(i)
    AND donate = donate_t(i)
    AND recycle = recycle_t(i)
    AND bmo_comments = bmo_comments_t(i)
    AND ponum = ponum_t(i)
    AND disptype = disptype_t(i)
    AND siteid = siteid_t(i)
    AND addr1 = addr1_t(i)
    AND city2 = city2_t(i)
    AND prov = prov_t(i)
    AND postcd = postcd_t(i)
    AND costctr = costctr_t(i)
    AND floorno = floorno_t(i)
    AND warehouse = warehouse_t(i)
;
--HADLE OTHER ERRORS
EXCEPTION --B2
     WHEN OTHERS THEN
     --INSERT ERROR INFORMATION
          BEGIN --B4
          itotalerrors := itotalerrors + 1;
          dw.pkg_load_verify.p_record_exception(iloadinstanceseq
          ,substr('DW.T_BMO_DISPOSITION err:'||sqlerrm,1,256)
          ,SQLCODE
          ,SQLERRM
          ,'');
          END; --B4
     END; --B3 dup_val_on_index block
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
,substr('DW.T_BMO_DISPOSITION GENERAL err:'||sqlerrm,1,256)
,SQLCODE
,SQLERRM
,'');
END; --B4
     ------------------------------------------------------
     -- END MAIN
     ------------------------------------------------------
END; --B1
/

GRANT EXECUTE ON DW.SPW_T_BMO_DISPOSITION TO TM1_ETL_ROLE;
GRANT EXECUTE ON DW.SPW_T_BMO_DISPOSITION TO LF188653;