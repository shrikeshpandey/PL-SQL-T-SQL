/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           04/03/2018
||   Category:       Table creation
||
||   Description:    Creates table T_DM_START_STOP_TIMES
||
||   Parameters:     None
||
||   Historic Info:
||    Name:              Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes        04/03/2018   Initial Creation
||   Luis Fuentes        04/05/2018   Adding indexes for query performance
||   Luis Fuentes        04/11/2018   changing table´s name and attributes
||   Luis Fuentes        04/21/2018   Deleting f_tech_srvc_city
||   Luis Fuentes        09/10/2018   Adding travel_start_time & travel_end_time
||   Luis Fuentes        09/24/2018   Adding unique index
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

-- BEGIN
--   DW.SP_TRUNCATE('DW.T_DM_START_STOP_TIMES');
-- END;

DROP TABLE DW.T_DM_START_STOP_TIMES cascade constraints;

CREATE TABLE DW.T_DM_START_STOP_TIMES
(
   service_date                 DATE
  ,f_tech_empl_key              NUMBER(22)
  ,work_start_time              FLOAT(20)
  ,onsite_start_time            FLOAT(20)
  ,onsite_end_time              FLOAT(20)
  ,work_end_time                FLOAT(20)
  --Begin Luis Fuentes  09/10/2018
  ,travel_start_time            FLOAT(20)
  ,travel_end_time              FLOAT(20)
  --End Luis Fuentes  09/10/2018
  ,dw_mod_date                  DATE DEFAULT ON NULL SYSDATE
  ,dw_load_date                 DATE DEFAULT ON NULL SYSDATE
)
TABLESPACE TS_MEDIUM
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MAXSIZE          UNLIMITED
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING
NOCOMPRESS
NOCACHE
MONITORING;

--Beging Luis Fuentes 09/24/2018
create unique index DW.T_DM_START_STOP_TIMES_I1 on DW.T_DM_START_STOP_TIMES (service_date, f_tech_empl_key)
  tablespace TS_MEDIUMX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  )
nologging;
--End Luis Fuentes 09/24/2018

create index DW.T_DM_START_STOP_TIMES_I2 ON DW.T_DM_START_STOP_TIMES (f_tech_empl_key)
  tablespace TS_MEDIUMX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
);

create index DW.T_DM_START_STOP_TIMES_I3 ON DW.T_DM_START_STOP_TIMES (service_date)
  tablespace TS_SMALLX
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 4M
    next 1M
    minextents 1
    maxextents unlimited
);

GRANT SELECT ON DW.T_DM_START_STOP_TIMES TO MSTR;
GRANT SELECT ON DW.T_DM_START_STOP_TIMES TO RPTGEN;
GRANT SELECT ON DW.T_DM_START_STOP_TIMES TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DM_START_STOP_TIMES TO lf188653;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DM_START_STOP_TIMES TO TM1_ETL_ROLE;
