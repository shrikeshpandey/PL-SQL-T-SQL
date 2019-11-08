CREATE OR REPLACE PROCEDURE DW.SPW_T_VENDOR_INVENTORY (iCommit IN NUMBER DEFAULT 2000
) is
/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Science & Innovation Lab
||   Programmer:     Luis Fuentes
||   Date:           04/17/2019
||   Category:       Table
||
||   Description:    Creates table DW.T_VENDOR_INVENTORY
||
||   Parameters:     None
||
||   Historic Info:
||    Name:           Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes     04/17/2019   Initial Creation
||   Luis Fuentes     04/19/2019   Adding Currency
||   Luis Fuentes     05/14/2019   item_no
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/
/*******************************************************************************************
*  Generated using sp_gen_bulk() jg 2006
*******************************************************************************************/

--Data to INSERT into DW.T_VENDOR_INVENTORY
CURSOR c IS
SELECT VC.*, LKP.COMPUCOM_SKU AS item_no
FROM (
SELECT V.partnerId AS partnerId,
       V.reportnameprovided AS reportnameprovided,
       CASE 
         WHEN V.reportnameprovided LIKE '%0007%' THEN TRIM(REGEXP_SUBSTR(V.customername,'[^,]+',1,1))
         ELSE V.customername
       END AS customername,
       CASE 
         WHEN V.reportnameprovided LIKE '%0007%' THEN TRIM(REGEXP_SUBSTR(V.forecastname,'[^,]+',1,2))
         ELSE V.forecastname
       END AS forecastname,
       V.mfgpartno AS mfgpartno,
       V.reservedquantity AS reservedquantity,
       V.availquantity AS availquantity,
       V.boqty AS boqty,
       V.age AS age,
       V.poeta AS poeta,
       V.oempo AS oempo,
       V.currency AS currency,
       V.dw_mod_date AS dw_mod_date,
       V.dw_load_date AS dw_load_date
FROM (SELECT UPPER(TRIM(partnerId)) AS partnerId,
             UPPER(TRIM(reportnameprovided)) AS reportnameprovided,
             UPPER(TRIM(customername)) AS customername,
             UPPER(TRIM(forecastname)) AS forecastname,
             UPPER(TRIM(mfgpartno)) AS mfgpartno,
             TO_NUMBER(TRIM(reservedquantity)) AS reservedquantity,
             TO_NUMBER(TRIM(availquantity)) AS availquantity,
             TO_NUMBER(TRIM(boqty)) AS boqty,
             TO_NUMBER(TRIM(age)) AS age,
             TO_DATE(TRIM(poeta), 'MM/DD/YYYY') AS poeta,
             REGEXP_REPLACE(TRIM(oempo), '\.[0-9]*', '') AS oempo,
             TRIM(currency) AS currency,
             dw_mod_date AS dw_mod_date,
             dw_load_date AS dw_load_date
      FROM DW.T_VENDOR_INVENTORY_STG) V
) VC
LEFT JOIN DW.T_LKP_VENDOR_SKU LKP
 ON VC.currency = LKP.currency_code AND VC.mfgpartno = LKP.mfg_part_no AND VC.customername = LKP.customer AND LKP.source = 'RESERVE'
;

CURSOR c_src_type IS
SELECT DISTINCT UPPER(TRIM(reportnameprovided)) AS reportnameprovided
FROM DW.T_VENDOR_INVENTORY_STG
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
partnerId_t           DBMS_SQL.VARCHAR2_table;
reportnameprovided_t DBMS_SQL.VARCHAR2_table;
customername_t       DBMS_SQL.VARCHAR2_table;
forecastname_t       DBMS_SQL.VARCHAR2_table;
mfgpartno_t          DBMS_SQL.VARCHAR2_table;
reservedquantity_t   DBMS_SQL.NUMBER_table;
availquantity_t      DBMS_SQL.NUMBER_table;
boqty_t              DBMS_SQL.NUMBER_table;
age_t                DBMS_SQL.NUMBER_table;
poeta_t              DBMS_SQL.DATE_table;
oempo_t              DBMS_SQL.VARCHAR2_table;
customerid_t         DBMS_SQL.VARCHAR2_table;
currency_t           DBMS_SQL.VARCHAR2_table;
dw_mod_date_t        DBMS_SQL.DATE_table;
dw_load_date_t       DBMS_SQL.DATE_table;
item_no_t            DBMS_SQL.VARCHAR2_table;

BEGIN --B1

-- Conditional Create of New Seq Number
dw.sp_md_get_next_seq('T_VENDOR_INVENTORY',
     'T_VENDOR_INVENTORY',
     'OBJID',
     1, --- ACTIVE CODE 1 OR 0 PRETTY MUCH ALWAYS ACTIVE '
     'T_VENDOR_INVENTORY',
     'ORACLE DB-LINK',
     'DW TABLE LOAD',
     'SPW_T_VENDOR_INVENTORY',
     iLoadSequence,
     'DW');

dw.pkg_load_verify.p_begin_load(iloadsequence,iloadinstanceseq);

--------------------------------------------------------------------
--Clean up transaction data base stage table dates by source and currency
-----------------------------------------------------------------
FOR i IN c_src_type
LOOP
    DELETE DW.T_VENDOR_INVENTORY
    WHERE reportnameprovided = i.reportnameprovided;
    COMMIT;
END LOOP;

-----------------------------------------------------------------
--Calculate and load new data
-----------------------------------------------------------------
OPEN c;
LOOP
     FETCH c BULK COLLECT INTO
        partnerId_t,
        reportnameprovided_t,
        customername_t,
        forecastname_t,
        mfgpartno_t,
        reservedquantity_t,
        availquantity_t,
        boqty_t,
        age_t,
        poeta_t,
        oempo_t,
        currency_t,
        dw_mod_date_t,
        dw_load_date_t,
        item_no_t
    LIMIT iCommit;
    FOR i IN 1 .. partnerId_t.COUNT 
    LOOP
        BEGIN --B2 insert
        INSERT INTO DW.T_VENDOR_INVENTORY (
            partnerId,
            reportnameprovided,
            customername,
            forecastname,
            mfgpartno,
            reservedquantity,
            availquantity,
            boqty,
            age,
            poeta,
            oempo,
            currency,
            dw_mod_date,
            dw_load_date,
            item_no
        )
        VALUES(
            partnerId_t(i),
            reportnameprovided_t(i),
            customername_t(i),
            forecastname_t(i),
            mfgpartno_t(i),
            reservedquantity_t(i),
            availquantity_t(i),
            boqty_t(i),
            age_t(i),
            poeta_t(i),
            oempo_t(i),
            currency_t(i),
            dw_mod_date_t(i),
            dw_load_date_t(i),
            item_no_t(i)
        );
        -- EXCEPTION -- B2
        -- WHEN dup_val_on_index THEN
        -- --UPDATE ERROR Information
        -- BEGIN--B3
        -- UPDATE DW.T_VENDOR_INVENTORY
        -- SET 
        -- WHERE ;
    --HADLE OTHER ERRORS
        EXCEPTION 
          WHEN OTHERS THEN
                 --INSERT ERROR INFORMATION
          BEGIN --B4
          itotalerrors := itotalerrors + 1;
          dw.pkg_load_verify.p_record_exception(iloadinstanceseq
          ,substr('DW.T_VENDOR_INVENTORY err:'||sqlerrm,1,256)
          ,SQLCODE
          ,SQLERRM
          ,'');
          END; --B4
    -- END;
    END;
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

--UPDATING RECORDS WITH �
UPDATE DW.T_VENDOR_INVENTORY V
SET V.forecastname = REPLACE(V.forecastname,'�', '-')
WHERE V.forecastname LIKE '%�%';
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
    ,substr('DW.T_VENDOR_INVENTORY err:'||sqlerrm,1,256)
    ,SQLCODE
    ,SQLERRM
    ,'');
 END; --B4
     ------------------------------------------------------
     -- END MAIN
     ------------------------------------------------------
END; --B1
/

GRANT EXECUTE ON DW.SPW_T_VENDOR_INVENTORY TO TM1_ETL_ROLE;
GRANT EXECUTE ON DW.SPW_T_VENDOR_INVENTORY TO LF188653;