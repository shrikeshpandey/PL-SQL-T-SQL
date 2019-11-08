#!/usr/bin/ksh -x
#################################################
#
#  dw_cp_bms_replicon_timesheet.sh
#
#  Change History
#  --------------------------------
#  Luis Fuentes initial
#################################################
#. ~/.profile

DATA_DIR=/xfer/DW/data
#NFS_DIR=/nfs/nas/DW/DW_DATA
NFS_DIR=/xfer/DW/data
#TGT_DIR=/xfer/DW/data/Freight_Cost/
#MSG_DIR=$TGT_DIR/email

EMAIL="lf188653@compucom.com"

src_file=t_bms_penalty_tracker.csv
tgt_file=t_bms_penalty_tracker_stg.dat

perl -p00e 's/\n;/;/g' ${NFS_DIR}/${src_file} | perl -p00e 's/ \n/ /g' > ${DATA_DIR}/${tgt_file}

chmod 777 ${DATA_DIR}/${tgt_file}