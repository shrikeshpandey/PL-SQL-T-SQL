--MANUAL https://docs.oracle.com/cd/A58617_01/server.804/a58225/ch4a.htm#2006147
--Assignment group: CMPC - Oracle DBA
--\\sp099nas01r\applications\UNIX\applications\DW\DW_DATA

--Creating a temprary table
CREATE TEMPORARY TABLESPACE tbs_t1
    TEMPFILE 'tbs_t1.f' SIZE 50m REUSE AUTOEXTEND ON
    MAXSIZE UNLIMITED
    EXTENT MANAGEMENT LOCAL UNIFORM SIZE 64K;

CREATE GLOBAL TEMPORARY TABLE admin_work_area
        (startdate DATE,
         enddate DATE,
         class CHAR(20))
      ON COMMIT DELETE ROWS
      TABLESPACE tbs_t1;

--Information about indexes
SELECT ind.owner, ind.table_name, ind.index_name, indc.column_name, ind.index_type, ind.status, indc.column_position 
FROM ALL_INDEXES ind, ALL_IND_COLUMNS indc
WHERE ind.index_name = indc.index_name
 AND ind.table_name = UPPER('T_DM_PART_SHIPPED_DTL')

--Information for all objects
SELECT *
FROM ALL_OBJECTS

--Getting info froma Viewe
SELECT *--TEXT_V
FROM all_views
WHERE view_name = 'V_DM_PARTS_ON_HAND'

--Finding information about a T_CLAR_USER
SELECT * FROM USER_SYS_PRIVS;
SELECT * FROM USER_TAB_PRIVS;
SELECT * FROM USER_ROLE_PRIVS;

--DCL commands
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DM_REVENUE_STREAM TO TM1_ETL_ROLE;
GRANT ALL ON DW.T_DM_REVENUE_STREAM TO TM1_ETL_ROLE; --ALL PRIVILEGES

--Handling Errors https://docs.oracle.com/cd/B10501_01/appdev.920/a96624/07_errs.htm
DECLARE
   pe_ratio NUMBER(3,1);
BEGIN
   SELECT price / earnings INTO pe_ratio FROM stocks
      WHERE symbol = 'XYZ';  -- might cause division-by-zero error
   INSERT INTO stats (symbol, ratio) VALUES ('XYZ', pe_ratio);
   COMMIT;
EXCEPTION  -- exception handlers begin
   WHEN ZERO_DIVIDE THEN  -- handles 'division by zero' error
      INSERT INTO stats (symbol, ratio) VALUES ('XYZ', NULL);
      COMMIT;
   ...
   WHEN OTHERS THEN  -- handles all other errors
      ROLLBACK;
END;  -- exception handlers and block end here

begin
  -- Call the procedure
  dw.sp_rebuild_bitmap_indexes('DW','T_DM_START_STOP_CALCULATED');
end;

--Getting info of a table
SELECT *
FROM MD_LOAD_INFO
WHERE TARGET_TABLE_NAME LIKE '%REVENUE_STREAM%'

--when did I table was last updated
select /*+ RULE */ distinct mi.load_instance_seq, m.table_load_seq,M.PROCEDURE_NAME,
m.target_table_name,mi.load_total,round(((mi.load_end - mi.load_begin))*60*60*24,2)load_time_sec, mi.load_begin,mi.load_end,
MI.LOAD_EXCEPTION_MESSAGE,
me.line_exception_message,me.line_exception_date
 from md_load_info m, md_load_instance mi, md_load_exceptions me
where
m.table_load_seq  = mi.table_load_seq and
  mi.load_instance_seq = me.load_instance_seq  (+) and
mi.load_begin >= trunc(sysdate)  and--  mi.load_begin <= trunc(sysdate) -4 and
m.target_table_name in  ( 'T_CLAT_ODS_CASE')
order by load_begin

--Creating a table out of a query
CREATE TABLE suppliers
AS (SELECT *
    FROM companies
    WHERE company_id < 5000);
GRANT SELECT ON LF188653.T_VENDOR_INVENTORY_BK TO PUBLIC;

--
MERGE INTO dw.T_DM_SVC_FS_DETAIL DTL
USING (
  SELECT DISTINCT f_case_id, f_case_key,
         f_first_tech_res_id,
         f_first_tech_res_sk,
         f_first_tech_org,
         f_Txn_dt
  FROM dw.FS_DETAIL_RES_ID_UPD@dwdev.world
  WHERE f_Txn_dt >= '01-oct-2015' AND f_Txn_dt < '01-nov-2015'
) UPD
 ON (dtl.f_case_id = upd.f_case_id AND dtl.f_case_key = upd.f_case_key AND dtl.f_Txn_dt = upd.f_Txn_dt)
WHEN MATCHED
 THEN UPDATE
 SET  dtl.f_first_tech_res_id = upd.f_first_tech_res_id,
      dtl.f_first_tech_res_sk = upd.f_first_tech_res_sk ,
      dtl.f_first_tech_org    = upd.f_first_tech_org
WHERE dtl.f_Txn_dt >= '01-oct-2015' AND dtl.f_Txn_dt < '01-nov-2015'
AND DTL.f_source_type = 'CLOSED_CALLS';
COMMIT;

DELETE FROM DW.FS_DETAIL_RES_ID_UPD UPD
WHERE EXISTS
  (SELECT *
   FROM DW.FS_DETAIL_RES_ID_UPDD UPDD
   WHERE (UPD.f_case_id = UPDD.f_case_id AND UPD.f_case_key = UPDD.f_case_key AND UPD.f_first_tech_res_id = UPDD.f_first_tech_res_id
         AND UPD.f_first_tech_res_sk = UPDD.f_first_tech_res_sk AND UPD.f_first_tech_org = UPDD.f_first_tech_org AND UPD.f_txn_dt = UPDD.f_txn_dt)
    AND status like '%ele%');
COMMIT;

--Change password
ALTER USER lf188653 IDENTIFIED BY Password12;

--Change column
ALTER TABLE lf188653.T_DM_REVENUE_STREAM
MODIFY WHS_CODE CHAR(10) NULL;

--Exploring Packages
SELECT DISTINCT name, TYPE
 FROM sys.dba_source
WHERE OWNER in ( 'DW', 'IAAS') AND 
UPPER (text) LIKE '% FS_DTL_STG_CLA%';

-- Granting Access to user
begin
dw.sp_grants('grant select on DW.T_FCT_0131_SERVICE_SUM TO ja189145');
dw.sp_grants('grant select on DW.T_FCT_0131_SERVICE_SUM TO SERVICE_ROLE');
dw.sp_grants('grant select on DW.T_FCT_0131_SERVICE_SUM TO MSTR');
end;

begin
  -- copy and paste the iCommit under variable and then FLOAT 2000
  dw.SPW_T_VENDOR_INVENTORY(iCommit => :iCommit);
end;


-- For Executing a plan
EXPLAIN PLAN FOR 
SELECT * FROM TABLE;

SELECT * FROM table(DBMS_XPLAN.DISPLAY (FORMAT=>'ALL +OUTLINE')); --To get back the execution plan explain 
SELECT * FROM table(DBMS_XPLAN.DISPLAY_CURSOR(FORMAT=>'ALLSTATS LAST ALL +OUTLINE'));
SELECT plan_table_output FROM TABLE(DBMS_XPLAN.display());
------------------------------------------------------------------------------------
--SQL SERVER 

-- Find a a colum in a column value, code has to be debug
DECLARE @SearchStrTableName nvarchar(255), @SearchStrColumnName nvarchar(255), @SearchStrColumnValue nvarchar(255), @SearchStrInXML bit, @FullRowResult bit, @FullRowResultRows int
SET @SearchStrColumnValue = '%3PT-ABMIS%' /* use LIKE syntax */
SET @FullRowResult = 1
SET @FullRowResultRows = 3
SET @SearchStrTableName = NULL /* NULL for all tables, uses LIKE syntax */
SET @SearchStrColumnName = NULL /* NULL for all columns, uses LIKE syntax */
SET @SearchStrInXML = 0 /* Searching XML data may be slow */

IF OBJECT_ID('tempdb..#Results') IS NOT NULL DROP TABLE #Results
CREATE TABLE #Results (TableName nvarchar(128), ColumnName nvarchar(128), ColumnValue nvarchar(max),ColumnType nvarchar(20))

SET NOCOUNT ON

DECLARE @TableName nvarchar(256) = '',@ColumnName nvarchar(128),@ColumnType nvarchar(20), @QuotedSearchStrColumnValue nvarchar(110), @QuotedSearchStrColumnName nvarchar(110)
SET @QuotedSearchStrColumnValue = QUOTENAME(@SearchStrColumnValue,'''')
DECLARE @ColumnNameTable TABLE (COLUMN_NAME nvarchar(128),DATA_TYPE nvarchar(20))

WHILE @TableName IS NOT NULL
BEGIN
    SET @TableName = 
    (
        SELECT MIN(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME))
        FROM    INFORMATION_SCHEMA.TABLES
        WHERE       TABLE_TYPE = 'BASE TABLE'
            AND TABLE_NAME LIKE COALESCE(@SearchStrTableName,TABLE_NAME)
            AND QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) > @TableName
            AND OBJECTPROPERTY(OBJECT_ID(QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME)), 'IsMSShipped') = 0
    )
    IF @TableName IS NOT NULL
    BEGIN
        DECLARE @sql VARCHAR(MAX)
        SET @sql = 'SELECT QUOTENAME(COLUMN_NAME),DATA_TYPE
                FROM    INFORMATION_SCHEMA.COLUMNS
                WHERE       TABLE_SCHEMA    = PARSENAME(''' + @TableName + ''', 2)
                AND TABLE_NAME  = PARSENAME(''' + @TableName + ''', 1)
                AND DATA_TYPE IN (' + CASE WHEN ISNUMERIC(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(@SearchStrColumnValue,'%',''),'_',''),'[',''),']',''),'-','')) = 1 THEN '''tinyint'',''int'',''smallint'',''bigint'',''numeric'',''decimal'',''smallmoney'',''money'',' ELSE '' END + '''char'',''varchar'',''nchar'',''nvarchar'',''timestamp'',''uniqueidentifier''' + CASE @SearchStrInXML WHEN 1 THEN ',''xml''' ELSE '' END + ')
                AND COLUMN_NAME LIKE COALESCE(' + CASE WHEN @SearchStrColumnName IS NULL THEN 'NULL' ELSE '''' + @SearchStrColumnName + '''' END  + ',COLUMN_NAME)'
        INSERT INTO @ColumnNameTable
        EXEC (@sql)
        WHILE EXISTS (SELECT TOP 1 COLUMN_NAME FROM @ColumnNameTable)
        BEGIN
            PRINT @ColumnName
            SELECT TOP 1 @ColumnName = COLUMN_NAME,@ColumnType = DATA_TYPE FROM @ColumnNameTable
            SET @sql = 'SELECT ''' + @TableName + ''',''' + @ColumnName + ''',' + CASE @ColumnType WHEN 'xml' THEN 'LEFT(CAST(' + @ColumnName + ' AS nvarchar(MAX)), 4096),''' 
            WHEN 'timestamp' THEN 'master.dbo.fn_varbintohexstr('+ @ColumnName + '),'''
            ELSE 'LEFT(' + @ColumnName + ', 4096),''' END + @ColumnType + ''' 
                    FROM ' + @TableName + ' (NOLOCK) ' +
                    ' WHERE ' + CASE @ColumnType WHEN 'xml' THEN 'CAST(' + @ColumnName + ' AS nvarchar(MAX))' 
                    WHEN 'timestamp' THEN 'master.dbo.fn_varbintohexstr('+ @ColumnName + ')'
                    ELSE @ColumnName END + ' LIKE ' + @QuotedSearchStrColumnValue
            INSERT INTO #Results
            EXEC(@sql)
            IF @@ROWCOUNT > 0 IF @FullRowResult = 1 
            BEGIN
                SET @sql = 'SELECT TOP ' + CAST(@FullRowResultRows AS VARCHAR(3)) + ' ''' + @TableName + ''' AS [TableFound],''' + @ColumnName + ''' AS [ColumnFound],''FullRow>'' AS [FullRow>],*' +
                    ' FROM ' + @TableName + ' (NOLOCK) ' +
                    ' WHERE ' + CASE @ColumnType WHEN 'xml' THEN 'CAST(' + @ColumnName + ' AS nvarchar(MAX))' 
                    WHEN 'timestamp' THEN 'master.dbo.fn_varbintohexstr('+ @ColumnName + ')'
                    ELSE @ColumnName END + ' LIKE ' + @QuotedSearchStrColumnValue
                EXEC(@sql)
            END
            DELETE FROM @ColumnNameTable WHERE COLUMN_NAME = @ColumnName
        END 
    END
END
SET NOCOUNT OFF

SELECT TableName, ColumnName, ColumnValue, ColumnType, COUNT(*) AS Count FROM #Results
GROUP BY TableName, ColumnName, ColumnValue, ColumnType