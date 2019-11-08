/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           08/01/2018
||   Category:       Table creation
||
||   Description:    Creates table DW.T_FG_WORKER_MILEAGE
||
||   Parameters:     None
||
||   Historic Info:
||    Name:              Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes        08/31/2018   Initial Creation
||   Luis Fuentes        12/17/2018   Changing ddl for couple columns and adding a fild to the indexes
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

BEGIN
  DW.SP_TRUNCATE('DW.T_FG_WORKER_MILEAGE');
END;

DROP TABLE DW.T_FG_WORKER_MILEAGE cascade constraints;

CREATE TABLE DW.T_FG_WORKER_MILEAGE
(
  --Fildglass file, metadata of FROM DW.T_DM_SVC_FS_DETAIL_STG
  buyer_name                   VARCHAR2(100) --100
 ,buyer_code                   VARCHAR2(100) --4
 ,vendor_name                  VARCHAR2(100) --100
 ,vendor_code                  VARCHAR2(100) --4
 ,account_name                 VARCHAR2(100) --100
 ,account_code                 VARCHAR2(100) --100
 ,remit_to_address_code        VARCHAR2(100) --100
 ,requisition_owner            VARCHAR2(100) --100
 ,work_order_id                VARCHAR2(100) --14
 ,worker_id                    VARCHAR2(100) --14
 ,candidate_id                 VARCHAR2(100) --14
 ,worker_last_name             VARCHAR2(100) --200
 ,worker_first_name            VARCHAR2(100) --200
 ,site_code                    VARCHAR2(100) --100
 ,site_name                    VARCHAR2(100) --100
 ,department_cost_center_code  VARCHAR2(100) --100
 ,department_cost_center_name  VARCHAR2(100) --100
 ,final_approver_first_name    VARCHAR2(100) --200
 ,final_approver_last_name     VARCHAR2(100) --200
 ,final_approver_employee_id   VARCHAR2(100) --50
 ,final_approver_email         VARCHAR2(100) --100
 ,expense_sheet_id             VARCHAR2(20)  --14 Unique -- varchar2(240)**
 ,expense_sheet_status         VARCHAR2(100) --12
 ,expense_sheet_submit_date    DATE          --Date
 ,expense_sheet_approved_date  DATE          --Date -- Date **
 ,expense_entry_date           DATE          --Unique Date -- Date **
 ,geo_branch_code              VARCHAR2(25)  --200 -- varchar2(25) **
 ,geo_branch_name              VARCHAR2(100) --200
 ,expense_code                 VARCHAR2(100) --Unique 100 
 ,expense_name                 VARCHAR2(240) --100 -- varchar2(240)**
 ,general_ledger_account_code  VARCHAR2(100) --100
 ,merchant                     VARCHAR2(200) --100
 ,description                  VARCHAR2(500) --500
 ,units                        FLOAT(22)     --Number 
 ,rate                         FLOAT(22)     --Decimal
 ,billable_amount              FLOAT(22)     --Decimal -- number(22)
 ,non_billable_amount          FLOAT(22)     --Decimal 
 ,currency                     VARCHAR2(100) --100 -- varchar2(150) **
 ,id                           VARCHAR2(50)  --14
 ,msp_percentage               FLOAT(22)     --Number
 ,compucom_user_id             VARCHAR2(50)  --100
 ,fieldglass_id                VARCHAR2(50)  --Comming from query
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

create unique index DW.T_FG_WORKER_MILEAGE_UX on DW.T_FG_WORKER_MILEAGE (expense_sheet_id, expense_entry_date, compucom_user_id, expense_code, merchant, description)
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
create index DW.T_FG_WORKER_MILEAGE_X1 on DW.T_FG_WORKER_MILEAGE (expense_sheet_id)
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
  )
  nologging;
create index DW.T_FG_WORKER_MILEAGE_X2 on DW.T_FG_WORKER_MILEAGE (compucom_user_id)
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
  )
  nologging;
create index DW.T_FG_WORKER_MILEAGE_X3 on DW.T_FG_WORKER_MILEAGE (expense_entry_date)
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
  )
nologging;

GRANT SELECT ON DW.T_FG_WORKER_MILEAGE TO MSTR;
GRANT SELECT ON DW.T_FG_WORKER_MILEAGE TO RPTGEN;
GRANT SELECT ON DW.T_FG_WORKER_MILEAGE TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_FG_WORKER_MILEAGE TO TM1_ETL_ROLE;