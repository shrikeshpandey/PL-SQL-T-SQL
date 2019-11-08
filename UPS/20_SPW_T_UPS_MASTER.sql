CREATE OR REPLACE PROCEDURE DW.SPW_T_UPS_MASTER (iCommit IN NUMBER DEFAULT 2000
) is
/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Science & Innovation Lab
||   Programmer:     Luis Fuentes
||   Date:           05/03/2019
||   Category:       Table
||
||   Description:    Creates table DW.T_UPS_MASTER
||
||   Parameters:     None
||
||   Historic Info:
||    Name:           Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes     05/03/2019   Initial Creation
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/
/*******************************************************************************************
*  Generated using sp_gen_bulk() jg 2006
*******************************************************************************************/

--Data to INSERT into DW.T_UPS_MASTER
CURSOR c IS
SELECT * 
FROM (
  -- Getting the repeaded records and filtering
  SELECT UPPER(TRIM(A.trackingnumber)) AS trackingnumber      
        ,TO_DATE(TRIM(A.deliverydate), 'yy-mm-dd hh24:mi:ss') AS deliverydate
        ,UPPER(TRIM(A.deliverylocation)) AS deliverylocation
        ,UPPER(TRIM(A.signedforby)) AS signedforby
        ,TO_DATE(TRIM(A.exceptiondate), 'yy-mm-dd hh24:mi:ss') AS exceptiondate
        ,UPPER(TRIM(A.exceptionreason)) AS exceptionreason
        ,UPPER(TRIM(A.exceptionresolution)) AS exceptionresolution
        ,TO_DATE(TRIM(A.updatedate), 'yy-mm-dd hh24:mi:ss') AS updatedate
        ,UPPER(TRIM(A.status)) AS status
        ,TO_DATE(TRIM(A.scheduleddeliverydate), 'yy-mm-dd hh24:mi:ss') AS scheduleddeliverydate
        ,UPPER(TRIM(A.servicetype)) AS servicetype
        ,TO_DATE(TRIM(A.interfacemodifydate), 'yy-mm-dd hh24:mi:ss') AS interfacemodifydate
        ,UPPER(TRIM(A.source)) AS source  
  FROM (
    SELECT ROW_NUMBER() OVER (PARTITION BY A.trackingnumber ORDER BY A.interfacemodifydate DESC) AS ROW_N,A.*
    FROM DW.T_UPS_MASTER_STG A
    INNER JOIN (
      SELECT UPPER(TRIM(trackingnumber)) AS trackingnumber,   
             COUNT(*)
      FROM DW.T_UPS_MASTER_STG
      GROUP BY UPPER(TRIM(trackingnumber))
      HAVING COUNT(*)>1
    ) B 
     ON UPPER(TRIM(A.trackingnumber)) = B.trackingnumber
  ) A
  WHERE A.row_n = 1

  UNION ALL

  -- Getting the unrepeaded values records
  SELECT UPPER(TRIM(A.trackingnumber)) AS trackingnumber      
        ,TO_DATE(TRIM(A.deliverydate), 'yy-mm-dd hh24:mi:ss') AS deliverydate
        ,UPPER(TRIM(A.deliverylocation)) AS deliverylocation
        ,UPPER(TRIM(A.signedforby)) AS signedforby
        ,TO_DATE(TRIM(A.exceptiondate), 'yy-mm-dd hh24:mi:ss') AS exceptiondate
        ,UPPER(TRIM(A.exceptionreason)) AS exceptionreason
        ,UPPER(TRIM(A.exceptionresolution)) AS exceptionresolution
        ,TO_DATE(TRIM(A.updatedate), 'yy-mm-dd hh24:mi:ss') AS updatedate
        ,UPPER(TRIM(A.status)) AS status
        ,TO_DATE(TRIM(A.scheduleddeliverydate), 'yy-mm-dd hh24:mi:ss') AS scheduleddeliverydate
        ,UPPER(TRIM(A.servicetype)) AS servicetype
        ,TO_DATE(TRIM(A.interfacemodifydate), 'yy-mm-dd hh24:mi:ss') AS interfacemodifydate
        ,UPPER(TRIM(A.source)) AS source 
  FROM DW.T_UPS_MASTER_STG A
  LEFT JOIN (
    SELECT UPPER(TRIM(trackingnumber)) AS trackingnumber,   
           COUNT(*)
    FROM DW.T_UPS_MASTER_STG
    GROUP BY UPPER(TRIM(trackingnumber))
    HAVING COUNT(*)>1
  ) B 
   ON UPPER(TRIM(A.trackingnumber)) = B.trackingnumber
  WHERE B.trackingnumber IS NULL
)
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
trackingnumber_t            DBMS_SQL.VARCHAR2_table;
deliverydate_t              DBMS_SQL.DATE_table;
deliverylocation_t          DBMS_SQL.VARCHAR2_table;
signedforby_t               DBMS_SQL.VARCHAR2_table;
exceptiondate_t             DBMS_SQL.DATE_table;
exceptionreason_t           DBMS_SQL.VARCHAR2_table;
exceptionresolution_t       DBMS_SQL.VARCHAR2_table;
updatedate_t                DBMS_SQL.DATE_table;
status_t                    DBMS_SQL.VARCHAR2_table;
scheduleddeliverydate_t     DBMS_SQL.DATE_table;
servicetype_t               DBMS_SQL.VARCHAR2_table;
interfacemodifydate_t       DBMS_SQL.DATE_table;
source_t                    DBMS_SQL.VARCHAR2_table;

BEGIN --B1

-- Conditional Create of New Seq Number
dw.sp_md_get_next_seq('T_UPS_MASTER',
     'T_UPS_MASTER',
     'OBJID',
     1, --- ACTIVE CODE 1 OR 0 PRETTY MUCH ALWAYS ACTIVE '
     'T_UPS_MASTER',
     'ORACLE DB-LINK',
     'DW TABLE LOAD',
     'SPW_T_UPS_MASTER',
     iLoadSequence,
     'DW');

dw.pkg_load_verify.p_begin_load(iloadsequence,iloadinstanceseq);

-----------------------------------------------------------------
--Calculate and load new data
-----------------------------------------------------------------
OPEN c;
LOOP
     FETCH c BULK COLLECT INTO
        trackingnumber_t,
        deliverydate_t,
        deliverylocation_t,
        signedforby_t,
        exceptiondate_t,
        exceptionreason_t,
        exceptionresolution_t,
        updatedate_t,
        status_t,
        scheduleddeliverydate_t,
        servicetype_t,
        interfacemodifydate_t,
        source_t
    LIMIT iCommit;
    FOR i IN 1 .. trackingnumber_t.COUNT 
    LOOP
        BEGIN --B2 insert
        INSERT INTO DW.T_UPS_MASTER (
            trackingnumber,
            deliverydate,
            deliverylocation,
            signedforby,
            exceptiondate,
            exceptionreason,
            exceptionresolution,
            updatedate,
            status,
            scheduleddeliverydate,
            servicetype,
            interfacemodifydate,
            source,
            dw_load_date,
            dw_mod_date
        )
        VALUES(
            trackingnumber_t(i),
            deliverydate_t(i),
            deliverylocation_t(i),
            signedforby_t(i),
            exceptiondate_t(i),
            exceptionreason_t(i),
            exceptionresolution_t(i),
            updatedate_t(i),
            status_t(i),
            scheduleddeliverydate_t(i),
            servicetype_t(i),
            interfacemodifydate_t(i),
            source_t(i),
            SYSDATE,
            SYSDATE
        );
        EXCEPTION -- B2
        WHEN dup_val_on_index THEN
        --UPDATE ERROR Information
        BEGIN--B3
        UPDATE DW.T_UPS_MASTER
        SET deliverydate = deliverydate_t(i),
            deliverylocation = deliverylocation_t(i),
            signedforby = signedforby_t(i),
            exceptiondate = exceptiondate_t(i),
            exceptionreason = exceptionreason_t(i),
            exceptionresolution = exceptionresolution_t(i),
            updatedate = updatedate_t(i),
            status = status_t(i),
            scheduleddeliverydate = scheduleddeliverydate_t(i),
            servicetype = servicetype_t(i),
            interfacemodifydate = interfacemodifydate_t(i),
            source = source_t(i),
            dw_mod_date = SYSDATE
        WHERE trackingnumber = trackingnumber_t(i)
;
    --HADLE OTHER ERRORS
        EXCEPTION 
          WHEN OTHERS THEN
                 --INSERT ERROR INFORMATION
          BEGIN --B4
          itotalerrors := itotalerrors + 1;
          dw.pkg_load_verify.p_record_exception(iloadinstanceseq
          ,substr('DW.T_UPS_MASTER err:'||sqlerrm,1,256)
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
    ,substr('DW.T_UPS_MASTER err:'||sqlerrm,1,256)
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