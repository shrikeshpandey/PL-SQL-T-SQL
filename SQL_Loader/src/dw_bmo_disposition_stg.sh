#!/usr/bin/ksh -x
#. ~/.profile
#################################################
#
#  dw_bmo_disposition_stg.sh
#
#  Change History
#  2fx-h$6Q~3^w=2F
#
#  Historic Info:
#  Name:              Date:        Brief Description:
#  -----------------------------------------------------------------------------
#  Luis Fuentes       10/22/2019   Initial Creation
#  -----------------------------------------------------------------------------
#
#################################################
# Declaring variables
BASE_DIR=/APPS/dw/base/dw_processes/pidgeon
DATA_DIR_TMP=$BASE_DIR/tmp
DATA_DIR=$BASE_DIR/data
CFG_DIR=$BASE_DIR/config
FNAME=BMO_Disposition_*.csv
TMP_FILE=/tmp/t_bmo_disposition_stg.log
CONFIGFILE=supply01.cfg

TRGT_DIR=/xfer/DW/data
TRGTFILE=t_bmo_disposition_stg.dat

# This funtion gets the credentials that connect to the ftp server
getcredentials()
{
    FTP_CC=`cat $CFG_DIR/$CONFIGFILE | cut -d "|" -f1`
    FTP_CC_USER=`cat $CFG_DIR/$CONFIGFILE | cut -d "|" -f2`
    FTP_CC_PASS=`cat $CFG_DIR/$CONFIGFILE | cut -d "|" -f3`
    FTP_CC_MODE=`cat $CFG_DIR/$CONFIGFILE | cut -d "|" -f4`
    FTP_CC_DIR='Inbound/appusma206_apps/BMO_Disposition'
}
# Start FTP to the CC FTP site
getfiles()
{
 ( 
	/usr/bin/sftp ${FTP_CC_USER}@${FTP_CC} > ${TMP_FILE} 2>&1 <<-EOF
	cd ${FTP_CC_DIR}
	lcd ${DATA_DIR_TMP}
	mget ${FNAME}
    rm ${FNAME}
	bye
	EOF
    #rm ${FNAME}
 ) 
  
}
# Creates a .dat file and puts it in the DATA_DIR dir
transform_data()
{
    cd ${DATA_DIR_TMP}

    FILECNTR=0
    for FILE in `ls BMO_Disposition_*.csv`
    do
        FILECNTR=$((FILECNTR+1))
        if [ $FILECNTR -eq 1 ] ; then
            cat $FILE > ${DATA_DIR}/$TRGTFILE
            rm $FILE
        else
            sed '1'd $FILE >> ${DATA_DIR}/$TRGTFILE
            rm $FILE
       fi    
    done
}
#Send .dat file to xfer/DW
move_datafile()
{
    cd ${DATA_DIR}

    if [ -f ${TRGTFILE} ]; then
        mv ${TRGTFILE} ${TRGT_DIR}
        chmod 777 ${TRGT_DIR}/${TRGTFILE}
    fi 
}

# Main Function
cd $BASE_DIR
getcredentials
getfiles
transform_data
move_datafile