--CHECK DATA

MERGE INTO DW.T_DM_START_STOP_TIMES@DWDEV.WORLD TARG
USING(
  SELECT *
  FROM LF188653.T_DM_START_STOP_TIMES
) DEST
 ON (
      TARG.SERVICE_DATE = DEST.SERVICE_DATE
  AND TARG.F_TECH_EMPL_KEY = DEST.F_TECH_EMPL_KEY
  )
WHEN MATCHED THEN
  UPDATE SET TARG.WORK_START_TIME = DEST.WORK_START_TIME,
             TARG.ONSITE_START_TIME = DEST.ONSITE_START_TIME,
             TARG.ONSITE_END_TIME = DEST.ONSITE_END_TIME,
             TARG.WORK_END_TIME = DEST.WORK_END_TIME
WHEN NOT MATCHED THEN
  INSERT (TARG.SERVICE_DATE,
          TARG.F_TECH_EMPL_KEY,
          TARG.WORK_START_TIME,
          TARG.ONSITE_START_TIME,
          TARG.ONSITE_END_TIME,
          TARG.WORK_END_TIME
          )
  VALUES (DEST.SERVICE_DATE,
          DEST.F_TECH_EMPL_KEY,
          DEST.WORK_START_TIME,
          DEST.ONSITE_START_TIME,
          DEST.ONSITE_END_TIME,
          DEST.WORK_END_TIME
);
COMMIT;

SELECT count(*)
FROM DW.T_DM_START_STOP_TIMES
WHERE service_date >= TO_DATE('4/1/2018','mm/dd/yyyy')
 AND service_date < TO_DATE('5/1/2018','mm/dd/yyyy');

--DELETE DATA
DELETE DW.T_DM_START_STOP_TIMES
WHERE service_date in (
  SELECT DISTINCT service_date
  FROM DW.T_DM_START_STOP_TIMES
  WHERE service_date >= TO_DATE('4/1/2018','mm/dd/yyyy')
   AND service_date < TO_DATE('5/1/2018','mm/dd/yyyy')
);
COMMIT;

--Reloading the table

SELECT *
FROM DW.T_DM_START_STOP_TIMES_STG

SELECT SUM(work_start_time), SUM(onsite_start_time), SUM(onsite_end_time), SUM(work_end_time)
FROM (
SELECT TO_DATE(TRIM(service_date),'mm/dd/yyyy') AS service_date,
       CAST(f_tech_empl_key AS NUMBER) AS f_tech_empl_key,
       CAST(work_start_time AS NUMBER) AS work_start_time,
       CAST(onsite_start_time AS NUMBER) AS onsite_start_time,
       CAST(onsite_end_time AS NUMBER) AS onsite_end_time,
       CAST(SUBSTR(work_end_time,1,LENGTH(work_end_time)-1) AS NUMBER) AS work_end_time
FROM DW.T_DM_START_STOP_TIMES_STG
)

--INSERT
INSERT INTO DW.T_DM_START_STOP_TIMES--@DWDEV.WORLD
SELECT TO_DATE(TRIM(service_date),'mm/dd/yyyy') AS service_date,
       CAST(f_tech_empl_key AS NUMBER) AS f_tech_empl_key,
       CAST(work_start_time AS NUMBER) AS work_start_time,
       CAST(onsite_start_time AS NUMBER) AS onsite_start_time,
       CAST(onsite_end_time AS NUMBER) AS onsite_end_time,
       CAST(SUBSTR(work_end_time,1,LENGTH(work_end_time)-1) AS NUMBER) AS work_end_time,
       SYSDATE,
       SYSDATE
FROM DW.T_DM_START_STOP_TIMES_STG;
COMMIT;

--VALIDATE VALUES
SELECT to_char(service_date,'yy') as short_year, to_char(service_date,'mm') as short_month, COUNT(*)
FROM DW.T_DM_START_STOP_TIMES
WHERE F_TECH_EMPL_KEY IN ('1342187341', '1073746706',  '1073747375')
GROUP BY to_char(service_date,'yy'),to_char(service_date,'mm')
ORDER BY 1,2;

INSERT INTO DW.T_DM_START_STOP_TIMES@DWDEV.WORLD
SELECT *
FROM DW.T_DM_START_STOP_TIMES;
--WHERE service_date >= TO_DATE('5/1/2018','mm/dd/yyyy');
COMMIT;
