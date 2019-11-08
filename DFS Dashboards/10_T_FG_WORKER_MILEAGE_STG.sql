/***********************************************************************************
||   QUERY INFORMATION
||
||   Department:     Data Warehouse
||   Programmer:     Luis Fuentes
||   Date:           07/14/2018
||   Category:       Table creation
||
||   Description:    Creates table DW.T_FG_WORKER_MILEAGE_STG
||
||   Parameters:     None
||
||   Historic Info:
||    Name:              Date:        Brief Description:
||   -----------------------------------------------------------------------------
||   Luis Fuentes        07/14/2018   Initial Creation
||   Luis Fuentes        08/01/2018   ADDING THE REST OF THE FIELDS
||   -----------------------------------------------------------------------------
||
||   CURRENT REVISION STANDARD:  v1.50
||
***********************************************************************************/

BEGIN
  DW.SP_TRUNCATE('DW.T_FG_WORKER_MILEAGE_STG');
END;

DROP TABLE DW.T_FG_WORKER_MILEAGE_STG cascade constraints;

CREATE TABLE DW.T_FG_WORKER_MILEAGE_STG
(
  buyer_name                   VARCHAR2(255)
 ,buyer_code                   VARCHAR2(255)
 ,vendor_name                  VARCHAR2(255)
 ,vendor_code                  VARCHAR2(255)
 ,account_name                 VARCHAR2(255)
 ,account_code                 VARCHAR2(255)
 ,remit_to_address_code        VARCHAR2(255)
 ,requisition_owner            VARCHAR2(255)
 ,work_order_id                VARCHAR2(255)
 ,worker_id                    VARCHAR2(255)
 ,candidate_id                 VARCHAR2(255)
 ,worker_last_name             VARCHAR2(255)
 ,worker_first_name            VARCHAR2(255)
 ,site_code                    VARCHAR2(255)
 ,site_name                    VARCHAR2(255)
 ,department_cost_center_code  VARCHAR2(255)
 ,department_cost_center_name  VARCHAR2(255)
 ,final_approver_first_name    VARCHAR2(255)
 ,final_approver_last_name     VARCHAR2(255)
 ,final_approver_employee_id   VARCHAR2(255)
 ,final_approver_email         VARCHAR2(255)
 ,expense_sheet_id             VARCHAR2(255)
 ,expense_sheet_status         VARCHAR2(255)
 ,expense_sheet_submit_date    VARCHAR2(255)
 ,expense_sheet_approved_date  VARCHAR2(255)
 ,expense_entry_date           VARCHAR2(255)
 ,geo_branch_code              VARCHAR2(255)
 ,geo_branch_name              VARCHAR2(255)
 ,expense_code                 VARCHAR2(255)
 ,expense_name                 VARCHAR2(255)
 ,general_ledger_account_code  VARCHAR2(255)
 ,merchant                     VARCHAR2(255)
 ,description                  VARCHAR2(500)
 ,units                        VARCHAR2(255)
 ,rate                         VARCHAR2(255)
 ,billable_amount              VARCHAR2(255)
 ,non_billable_amount          VARCHAR2(255)
 ,currency                     VARCHAR2(255)
 ,id                           VARCHAR2(255)
 ,msp_percentage               VARCHAR2(255)
 ,compucom_user_id             VARCHAR2(255)
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

GRANT SELECT ON DW.T_FG_WORKER_MILEAGE_STG TO MSTR;
GRANT SELECT ON DW.T_FG_WORKER_MILEAGE_STG TO RPTGEN;
GRANT SELECT ON DW.T_FG_WORKER_MILEAGE_STG TO SERVICE_ROLE;
GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON DW.T_FG_WORKER_MILEAGE_STG TO TM1_ETL_ROLE;
