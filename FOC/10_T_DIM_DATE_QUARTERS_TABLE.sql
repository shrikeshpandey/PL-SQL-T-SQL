
/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           07/10/2018
||   Category:       Table creation
||
||   Description:    Creates table T_DIM_DATE_QUARTERS
||
||   Parameters:     None
||
||   Historic Info:
||    Name:              Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes        04/03/2018   Initial Creation
||
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

DROP TABLE DW.T_DIM_DATE_QUARTERS cascade constraints;

create table DW.T_DIM_DATE_QUARTERS
(
  clndr_year_no               NUMBER(22)   not null,
  clndr_qtr_year_no           NUMBER(22)   not null,
  clndr_qtr_year_desc         VARCHAR2(30) not null,
  clndr_13prior_qtr_year_no   NUMBER(22)   not null,
  clndr_13prior_qtr_year_desc VARCHAR2(30) not null,
  dw_mod_date                 DATE null,
  dw_load_date                DATE null
)
tablespace TS_SMALL
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 32M
    next 1M
    minextents 1
    maxextents unlimited
  )
nologging;
create bitmap index DW.T_DIM_DATE_QUARTERS_I1 on DW.T_DIM_DATE_QUARTERS (CLNDR_QTR_YEAR_NO)
  tablespace TS_SMALLX
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

GRANT SELECT ON DW.T_DIM_DATE_QUARTERS TO MSTR;
GRANT SELECT ON DW.T_DIM_DATE_QUARTERS TO RPTGEN;
GRANT SELECT ON DW.T_DIM_DATE_QUARTERS TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DIM_DATE_QUARTERS TO lf188653;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_DIM_DATE_QUARTERS TO TM1_ETL_ROLE;
