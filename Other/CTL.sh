sh /APPS/dw/base/dw_processes/src/dw_t_bms_penalty_tracker_stg.sh
pbrun dw_run.sh -A logistics -R incr -T t_bms_penalty_tracker_stg -D YES < ~/cc/loadyes
pbrun dw_run.sh -A logistics -D NO -R incr -T t_dim_client_employee -S "DW.SPW_T_DIM_CLIENT_EMPLOYEE" < ~/cc/loadyes

t_bms_penalty_tracker_stg
-------------------------------------------------------------------------------------------

sh /APPS/dw/base/bin/fgmileage.sh --from the server!!
sh /APPS/dw/base/dw_processes/src/dw_t_fg_worker_mileage_stg.sh
pbrun dw_run.sh -A logistics -R incr -T t_fg_worker_mileage_stg -D YES < ~/cc/loadyes
pbrun dw_run.sh -A logistics -D NO -R incr -T t_fg_worker_mileage -S "DW.SPW_T_FG_WORKER_MILEAGE" < ~/cc/loadyes
pbrun dw_run.sh -A logistics -D NO -R incr -T t_dm_svc_fs_detail_stg -S "DW.SPW_T_FG_WORKER_MILES" < ~/cc/loadyes

t_fg_worker_mileage_stg
-------------------------------------------------------------------------------------------

sh /APPS/dw/base/dw_processes/src/dw_t_dm_start_stop_times_stg.sh
pbrun dw_run.sh -A logistics -R incr -T t_dm_start_stop_times_stg -D YES < ~/cc/loadyes

t_dm_start_stop_times_stg
-------------------------------------------------------------------------------------------

sh /APPS/dw/base/dw_processes/src/dw_t_dim_client_employee_stg.sh --perhaps job = dw_cp_dim_client_employee
pbrun dw_run.sh -A logistics -R incr -T t_dim_client_employee_stg -D YES < ~/cc/loadyes --perhaps job = t_dim_client_employee_stg
pbrun dw_run.sh -A logistics -D NO -R incr -T t_dim_client_employee -S "DW.SPW_T_DIM_CLIENT_EMPLOYEE" < ~/cc/loadyes --perhaps job = t_dim_client_employee

t_dim_client_employee_stg
-------------------------------------------------------------------------------------------

sh /APPS/dw/base/dw_processes/src/dw_cp_target_code_values.sh
pbrun dw_run.sh -A logistics -R incr -T t_dm_target_code_values_stg -D YES < ~/cc/loadyes
pbrun dw_run.sh -A logistics -D NO -R incr -T t_dm_target_code_values -S "DW.SPW_T_DM_TARGET_CODE_VALUES" < ~/cc/loadyes

t_dm_target_code_values
-------------------------------------------------------------------------------------------

pbrun dw_run.sh -A logistics -D NO -R incr -T t_dm_revenue_stream -S "DW.SPW_T_DM_REVENUE_STREAM" < ~/cc/loadyes

t_dm_revenue_stream
-------------------------------------------------------------------------------------------

sh /APPS/dw/base/dw_processes/src/dw_t_vendor_inventory_stg.sh DBI_LOAD_*.csv
sh /APPS/dw/base/dw_processes/pidgeon/src/dw_pidgeon.sh
pbrun dw_run.sh -A logistics -R incr -T t_vendor_inventory_stg -D YES < ~/cc/loadyes
pbrun dw_run.sh -A logistics -D NO -R incr -T t_vendor_inventory -S "DW.SPW_T_VENDOR_INVENTORY" < ~/cc/loadyes

t_vendor_inventory_stg
-------------------------------------------------------------------------------------------
# Anant part
sh /APPS/dw/base/dw_processes/ups/src/dw_ups.sh

# My process
sh /APPS/dw/base/dw_processes/src/dw_t_ups_master_stg.sh [fileName]

pbrun dw_run.sh -A logistics -R incr -T t_ups_master_stg -D YES < ~/cc/loadyes
pbrun dw_run.sh -A logistics -D NO -R incr -T t_ups_master -S "DW.SPW_T_UPS_MASTER" < ~/cc/loadyes

dw_t_ups_master_stg.sh
-------------------------------------------------------------------------------------------

sh /APPS/dw/base/dw_processes/src/dw_t_sccm_stg.sh examplefile.txt
pbrun dw_run.sh -A logistics -R incr -T t_sccm_stg -D YES < ~/cc/loadyes

t_sccm_stg
-------------------------------------------------------------------------------------------

sh /APPS/dw/base/dw_processes/src/dw_cp_bms_replicon_timesheet.sh REPLICON_TIMESHEET.csv
pbrun dw_run.sh -A logistics -R incr -T t_bms_replicon_timesheet_stg -D YES < ~/cc/loadyes
pbrun dw_run.sh -A logistics -D NO -R incr -T t_bms_replicon_timesheet -S "DW.SPW_T_BMS_REPLICON_TIMESHEET" < ~/cc/loadyes

t_bms_replicon_timesheet_stg
-------------------------------------------------------------------------------------------

pbrun dw_run.sh -A logistics -D NO -R incr -T t_odts_sku_counts -S "DW.SPW_T_ODTS_SKU_COUNTS" < ~/cc/loadyes

t_odts_sku_counts
-------------------------------------------------------------------------------------------

pbrun dw_run.sh -A logistics -D NO -R incr -T t_sla_miss_prel_root_cause -S "DW.SPW_T_SLA_MISS_PREL_ROOT_CAUSE" < ~/cc/loadyes

t_sla_miss_prel_root_cause
-------------------------------------------------------------------------------------------

# Loads transfer data from FTP to
sh /APPS/dw/base/dw_processes/src/dw_bmo_disposition_stg.sh
# Loads the .dat file to the stg table
pbrun dw_run.sh -A logistics -R incr -T t_bmo_disposition_stg -D YES < ~/cc/loadyes
# Runs stored procedure
pbrun dw_run.sh -A logistics -D NO -R incr -T t_bmo_disposition -S "DW.SPW_T_BMO_DISPOSITION" < ~/cc/loadyes

t_bmo_disposition