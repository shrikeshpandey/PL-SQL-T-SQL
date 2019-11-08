CREATE OR REPLACE PROCEDURE DW.SPW_T_DM_PR_AGING_HIST_DATA (iCommit IN NUMBER DEFAULT 2000
) is
   /***********************************************************************************
   ||   PROCEDURE INFORMATION
   ||
   ||   Department:     Data Warehouse
   ||   Programmer:     Luis Fuentes
   ||   Date:           09/11/2017
   ||   Category:       Load Procedure to load TARGET data from SOURCE
   ||
   ||   Description:    LOAD T_DM_PR_AGING_HISTORICAL_DATA
   ||
   ||
   ||   Parameters:     iCommit:   is batch size used to commit record changes.
   ||
   ||   Load Sequence Number:  NNN
   ||
   ||   Historic Info:
   ||    Name:                                  Date:        Brief Description:
   ||   -----------------------------------------------------------------------------
   ||     Luis Fuentes                          09/11/2017   Initial Creation
   ||     Luis Fuentes   Steve Novorolsky       09/13/2017   Adding grouping, TEAM and cost formula, using new function
   ||     Luis Fuentes                          09/21/2017   Adding where cluse, adding empty fields from sales_region
   ||     Luis Fuentes                          09/27/2017   Getting rid off age and getting only two years
   ||     Luis Fuentes                          09/28/2017   Adding the actual day and fixing S_TITLE
   ||   -----------------------------------------------------------------------------
   ||
   ||   CURRENT REVISION STANDARD:  v1.50
   ||
   ***********************************************************************************/
/*******************************************************************************************
*  Generated using sp_gen_bulk() jg 2006
*******************************************************************************************/
CURSOR c is
SELECT  W.INSERT_DATE                                             AS INSERT_DATE
       ,W.F_CURRENCY_NAME                                         AS CURRENCY_NAME
       ,W.X_LOC_CLASS                                             AS LOC_CLASS
       ,W.TEAM                                                    AS TEAM
       ,CASE
          WHEN W.AGE < 0 THEN 'Past Due'
          WHEN (W.AGE >= 0 AND W.AGE < 3) THEN 'Active'
          WHEN (W.AGE > 2 AND W.AGE <= 10) THEN 'Current'
          ELSE 'Ten Plus'
        END                                                       AS CTGY_AGE
       ,SUM(W.DEMAND_QTY)                                         AS CTGY_QTY
       ,SUM(COST)                                                 AS COST
       ,W.INSERT_DATE                                             AS DW_LOAD_DT
       ,W.INSERT_DATE                                             AS DW_MOD_DT
FROM (
  SELECT  T.INSERT_DATE
         ,F.F_CURRENCY_NAME
         ,F.X_LOC_CLASS
         ,F.TEAM
         ,CASE
           WHEN X_ETA = TO_DATE('17530101', 'yyyymmdd') OR X_ETA IS NULL THEN
             CASE
               WHEN T.NOW_DATE = F.X_ETA THEN 0
               WHEN T.NOW_DATE > F.DETAILS_DATE THEN (FUNC_GET_BUS_DAYS_BETWEEN(F.DETAILS_DATE, T.NOW_DATE) * -1)+1
               ELSE FUNC_GET_BUS_DAYS_BETWEEN(F.DETAILS_DATE, T.NOW_DATE)-1
             END
           ELSE
             CASE
               WHEN T.NOW_DATE = X_ETA THEN 0
               WHEN T.NOW_DATE > X_ETA THEN (FUNC_GET_BUS_DAYS_BETWEEN(X_ETA, T.NOW_DATE) * -1)+1
               ELSE FUNC_GET_BUS_DAYS_BETWEEN(X_ETA, T.NOW_DATE)-1
             END
           END AS AGE
         ,F.DEMAND_QTY
         ,F.COST
  FROM (
  SELECT   1 AS F_DATE_KEY
          ,TRUNC(B.DETAILS_DATE) AS DETAILS_DATE
          ,TRUNC(B.X_ETA) AS X_ETA
          ,I.X_LOC_CLASS
          ,C.F_CURRENCY_NAME
          , case when B.ORIG_ID like 'P%' then 'BUYER'
                 when D.S_TITLE Like 'V%' then 'BUYER'
                 when D.S_TITLE Like 'ON HOLD%'then 'BUYER'
                 when D.S_TITLE ='OPEN' then 'BUYER'
                 when D.S_TITLE  In ('OPEN','REJ - AWAIT INFO') And A.HEADER_CASE_NO is Null then 'PLANNER'
                 when D.S_TITLE Like 'ON PO%' And B.X_INBOUND_WAYBILL Is Null then 'BUYER'
                 when D.S_TITLE In ('OPEN','REJ - AWAIT INFO') And A.HEADER_CASE_NO Like 'C%'  THEN 'LA'
                 when D.S_TITLE = 'ON PO'then 'LA'
                 when D.S_TITLE = 'OPEN' And A.HEADER_CASE_NO Is Null then 'BUYER'
                 else 'TBD'
             END as Team
           ,B.DEMAND_QTY AS DEMAND_QTY
           ,CASE
             WHEN H.F_USX_COST >= 0.01 THEN (H.F_USX_COST * B.DEMAND_QTY)
             WHEN H.F_USX_COST IS NULL AND B.X_PO_COST > 0 THEN (B.X_PO_COST * B.DEMAND_QTY)
             ELSE (B.X_PART_COST*B.DEMAND_QTY)
            END AS COST
            FROM DW.T_CLAR_DEMAND_HDR A
            INNER JOIN DW.T_CLAR_DEMAND_DTL B
             ON A.OBJID = B.DEMAND_DTL2DEMAND_HDR
            INNER JOIN DW.T_CLAR_CURRENCY C
             ON A.DEMAND_HDR2CURRENCY = C.OBJID
            LEFT JOIN DW.T_CLAR_GBST_ELM D
             ON B.DMND_DTL_STS2GBST_ELM = D.OBJID
            LEFT JOIN DW.T_DM_CLAR_FRU_PARTS E
             ON B.DEMAND_DTL2PART_INFO = E.MODLEVEL_OBJID
            LEFT JOIN DW.T_CLAR_X_PARTNUM_SKU F
             ON E.PARTNUM_OBJID = F.X_WIMS_SKU2PART_NUM
            INNER JOIN DW.T_CLAR_CONDITION G
             ON B.DEMAND_DTL2CONDITION = G.OBJID
            LEFT JOIN DW.T_DM_CLAR_PO H
             ON B.DETAIL_NUMBER = H.PO_REQ_NUM_SEGMENT
            LEFT JOIN DW.T_CLAR_INV_LOCATN I
             ON A.X_DEM_HDR_LOC2INV_LOCATN = I.OBJID
            LEFT JOIN (
              SELECT B.S_LOCATION_NAME, (A.S_LAST_NAME || ',' || A.S_FIRST_NAME) as "LA", C.X_STR_ROLE_NAME, C.X_STR_POSITION, B.X_GEOGRAPHY_CODE, B.S_SITE_ID, DW.B.ACTIVE
              FROM DW.T_CLAR_EMPLOYEE A
              INNER JOIN (DW.T_CLAR_LOCATN_VIEW B INNER JOIN DW.T_CLAR_X_EMP_INV_ROLE C ON B.LOC_OBJID = C.X_INV_ROLE2INV_LOC)
                    ON A.OBJID = C.X_INV_ROLE2EMPLOYEE
              WHERE (((B.ACTIVE)=1) AND ((DW.B.ROLE_NAME)='located at') AND ((C.X_STR_ROLE_NAME)='Primary') AND ((C.X_STR_POSITION)='Analyst'))
                        ) LA_QUERY
             ON (I.S_LOCATION_NAME = LA_QUERY.S_LOCATION_NAME)
             WHERE TRUNC(B.DETAILS_DATE) >= TRUNC(add_months(sysdate,-24)) AND (B.REQUEST_TYPE)='Purchase'
              AND G.S_TITLE NOT IN ('RECEIVED','CLOSED')
              AND (SUBSTR(C.F_CURRENCY_NAME,1,1) = SUBSTR(F.S_X_SET_OF_BOOKS,1,1)
              OR F.S_X_SET_OF_BOOKS IS NULL)
  ) F
  INNER JOIN (
        SELECT 1 AS F_DATE_KEY, TRUNC(SYSDATE) AS NOW_DATE, TRUNC(SYSDATE) AS INSERT_DATE
        FROM DUAL
  ) T
   ON F.F_DATE_KEY = T.F_DATE_KEY
) W
GROUP BY W.F_CURRENCY_NAME
        ,W.X_LOC_CLASS
        ,W.TEAM
        ,CASE
            WHEN W.AGE < 0 THEN 'Past Due'
            WHEN (W.AGE >= 0 AND W.AGE < 3) THEN 'Active'
            WHEN (W.AGE > 2 AND W.AGE <= 10) THEN 'Current'
            ELSE 'Ten Plus'
          END
         ,W.INSERT_DATE
         ,W.INSERT_DATE;

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
INSERT_DATE_t       dbms_sql.DATE_table;
CURRENCY_NAME_t     dbms_sql.VARCHAR2_table;
LOC_CLASS_t         dbms_sql.VARCHAR2_table;
TEAM_t              dbms_sql.VARCHAR2_table;
CTGY_AGE_t          dbms_sql.VARCHAR2_table;
CTGY_QTY_t          dbms_sql.NUMBER_table;
COST_t              dbms_sql.NUMBER_table;
DW_LOAD_DT_t        dbms_sql.DATE_table;
DW_MOD_DT_t         dbms_sql.DATE_table;

BEGIN --B1

  -- Conditional Create of New Seq Number

dw.sp_md_get_next_seq('T_DM_PR_AGING_HISTORICAL_DATA',
     'T_DM_PR_AGING_HISTORICAL_DATA',
     'OBJID',
     1, --- ACTIVE CODE 1 OR 0 PRETTY MUCH ALWAYS ACTIVE '
     'T_DM_PR_AGING_HISTORICAL_DATA',
     'ORACLE DB-LINK',
     'DW TABLE LOAD',
     'SPW_T_DM_PR_AGING_HISTORICAL_DATA',
     iLoadSequence,
     'DW');

dw.pkg_load_verify.p_begin_load(iloadsequence,iloadinstanceseq);

OPEN c;
LOOP
     FETCH c BULK COLLECT INTO
         INSERT_DATE_t,
         CURRENCY_NAME_t,
         LOC_CLASS_t,
         TEAM_t,
         CTGY_AGE_t,
         CTGY_QTY_t,
         COST_t,
         DW_LOAD_DT_t,
         DW_MOD_DT_t
     LIMIT iCommit;
     FOR i in 1..CURRENCY_NAME_t.COUNT
     LOOP
          BEGIN --B2 insert
          INSERT INTO DW.T_DM_PR_AGING_HISTORICAL_DATA (
              INSERT_DATE,
              CURRENCY_NAME,
              LOC_CLASS,
              TEAM,
              CTGY_AGE,
              CTGY_QTY,
              COST,
              DW_LOAD_DT,
              DW_MOD_DT
          )
          VALUES (
            INSERT_DATE_t(i),
            CURRENCY_NAME_t(i),
            LOC_CLASS_t(i),
            TEAM_t(i),
            CTGY_AGE_t(i),
            CTGY_QTY_t(i),
            COST_t(i),
            DW_LOAD_DT_t(i),
            DW_MOD_DT_t(i)
          );
EXCEPTION --B2
     WHEN OTHERS THEN
     --INSERT ERROR INFORMATION
          BEGIN --B4
          itotalerrors := itotalerrors + 1;
          dw.pkg_load_verify.p_record_exception(iloadinstanceseq
          ,substr('DW.T_DM_PR_AGING_HISTORICAL_DATA err:'||sqlerrm,1,256)
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
          ,substr('DW.T_DM_PR_AGING_HISTORICAL_DATA err:'||sqlerrm,1,256)
          ,SQLCODE
          ,SQLERRM
          ,'');
          END; --B4
     ------------------------------------------------------
     -- END MAIN
     ------------------------------------------------------
END; --B1
/

GRANT EXECUTE ON DW.SPW_T_DM_PR_AGING_HIST_DATA TO TM1_ETL_ROLE;
GRANT EXECUTE ON DW.SPW_T_DM_PR_AGING_HIST_DATA TO MSTR;
GRANT EXECUTE ON DW.SPW_T_DM_PR_AGING_HIST_DATA TO SNOVOROL;
GRANT EXECUTE ON DW.SPW_T_DM_PR_AGING_HIST_DATA TO SERVICE_ROLE;
