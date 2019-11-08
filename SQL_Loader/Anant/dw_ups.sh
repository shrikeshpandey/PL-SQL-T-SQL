#!/usr/bin/ksh
#. ~/.profile
#################################################
#
#  dw_ups.sh
#
#  DW UPS File Mover process
#
#  Luis Fuentes
#  09/06/2019
#
#  This job is designed to move UPS
#  file from the CompuCom FTP site
#  (ftp2.compucom.com) over to the /xfer/DW/data
#  folder.
#
#  It faciliates users downloading files 
#  without having to have the credentials to their
#  site.
#
#  Change History
#  --------------------------------
#
#################################################

###
### Variables
### Directory Structure

BASE_DIR=/APPS/dw/base/dw_processes/ups
SRC_DIR=$BASE_DIR/src
DATA_DIR=$BASE_DIR/data
LOG_DIR=$BASE_DIR/log
CFG_DIR=$BASE_DIR/config
MSG_DIR=$BASE_DIR/msg

TRGT_DIR=/xfer/DW/data
TRGTFILE=t_ups_master_stg.dat
FNAME=UPS_MASTER_EXPORT_*.csv

DATE=`date '+%d%m%Y'`
RUN_HOUR=`date +"%I %p"`

TMP_FILE=/tmp/ups.log
FTP_LOG=UPS

CONFIGFILE=supply01.cfg

EMAIL="Luis.Fuentes@compucom.com"
EMAIL_CC="DL-099-ITDataWarehouseETL@compucom.com"

####
## Function Definitions
####

##
## Function : cleanup()
## Get credentials to connect to FTP server
##

cleanup()
{
 if [ -f ${DATA_DIR}/filesreceived.lst ]; then
       rm ${DATA_DIR}/filesreceived.lst
 fi

 if [ -f ${MSG_DIR}/mail.msg ]; then
       rm ${MSG_DIR}/mail.msg
 fi

 if [ -f ${TRGT_DIR}/${TRGTFILE} ]; then
       rm ${TRGT_DIR}/${TRGTFILE}
 fi

 LOGCOUNT=`find ${LOG_DIR} -type f -iname '*.log' | wc -l`
 if [ $LOGCOUNT -gt 0 ]; then
      rm ${LOG_DIR}/*.log
 fi 

 DATCOUNT=`find ${DATA_DIR} -type f -iname '*.csv' | wc -l`
 if [ $DATCOUNT -gt 0 ]; then
      rm ${DATA_DIR}/*.csv
 fi 
}

##
## Function : getcredentials
## Get credentials to connect to FTP server
##

getcredentials()
{
  FTP_CC=`cat $CFG_DIR/$CONFIGFILE | cut -d "|" -f1`
  FTP_CC_USER=`cat $CFG_DIR/$CONFIGFILE | cut -d "|" -f2`
  FTP_CC_PASS=`cat $CFG_DIR/$CONFIGFILE | cut -d "|" -f3`
  FTP_CC_MODE=`cat $CFG_DIR/$CONFIGFILE | cut -d "|" -f4`
  FTP_CC_DIR=`cat $CFG_DIR/$CONFIGFILE | cut -d "|" -f5`
}   

##
## Function : getfiles
## Get file from FTP server
##

getfiles()
{
 ##--Start FTP to the CC FTP site
 ( 
	/usr/bin/sftp ${FTP_CC_USER}@${FTP_CC} > ${TMP_FILE} 2>&1 <<-EOF
	cd ${FTP_CC_DIR}
	lcd ${DATA_DIR}
	mget ${FNAME} 
	bye
	EOF

 ) >> ${LOG_DIR}/${FTP_LOG}_ftp_$DATE.log
  
 mv ${TMP_FILE} ${LOG_DIR}/${FTP_LOG}_ftp_$DATE.log
}

##
## Function : listfilesreceived
## Create list of file received
##

listfilesreceived()
{
   cd ${DATA_DIR}
   for FILERCVD in `ls -l|awk '{print $9}'`
    do
     echo $FILERCVD >> ${DATA_DIR}/filesreceived.lst
    done
}

##
## Function : ftp2remove
## Remove file downloaded from remote server
##

ftp2remove()
{
   cd ${DATA_DIR}
   for FILENAME in `cat filesreceived.lst`
    do
     
     FNAME="${FILENAME%.*}"
     TMP_FILE=${BASE_DIR}/${FNAME}.log

     getcredentials

     ##--Start FTP to the CC FTP site
     ( 
	/usr/bin/sftp ${FTP_CC_USER}@${FTP_CC} > ${TMP_FILE} 2>&1 <<-EOF
	cd ${FTP_CC_DIR}
	rm ${FILENAME}
	bye
	EOF

     ) >> ${LOG_DIR}/${FNAME}_ftp_arc.log

     cd ${LOG_DIR}
     mv ${TMP_FILE} ${LOG_DIR}/${FNAME}_ftp_arc.log

    done
}

##
## Function : concatfiles
## Concat downloaded files to 1 single file
##

concatfiles()
{
    cd ${DATA_DIR}

    FILECNTR=0
    for FILE in `cat filesreceived.lst` 
     do
       FILECNTR=$((FILECNTR+1))
       if [ $FILECNTR -eq 1 ] ; then
            cat $FILE > ${DATA_DIR}/$TRGTFILE
       else
            sed '1'd $FILE >> ${DATA_DIR}/$TRGTFILE
       fi    
     done
}
  
##
## Function : checkdatfile
## Check if t_ups_master_stg.dat file is created 
## Move dat file to /xfer/DW/data directory
##

checkdatfile()
{
   cd ${DATA_DIR}

   if [ -f ${DATA_DIR}/${TRGTFILE} ]; then
      mv ${DATA_DIR}/${TRGTFILE} ${TRGT_DIR}/${TRGTFILE}
   else
      echo "There was an error generating the ' ${TRGTFILE} ' file." > ${MSG_DIR}/mail.msg
      echo "Please check." >> ${MSG_DIR}/mail.msg
      echo "" >> ${MSG_DIR}/mail.msg
      echo "" >> ${MSG_DIR}/mail.msg
      echo "Thank you." >> ${MSG_DIR}/mail.msg
      echo "CompuCom Systems, Inc." >> ${MSG_DIR}/mail.msg 
      mail -s "UPS: Master Export File: DAT File Error" -r "Report Distribution Services <DL-099-ITReporting@compucom.com>" $EMAIL $EMAIL_CC < ${MSG_DIR}/mail.msg
   fi
}

##
## Function : sendemail
## Send email for file received
##

sendemail()
{
   cd ${DATA_DIR}
   sed -i "1s/^/The following file(s) were received during the ${RUN_HOUR} run ...\n\n/" ${DATA_DIR}/filesreceived.lst
   echo "" >> ${DATA_DIR}/filesreceived.lst
   sed -i '$ a Thank you.' ${DATA_DIR}/filesreceived.lst
   sed -i '$ a CompuCom Systems, Inc.\n' ${DATA_DIR}/filesreceived.lst
   mail -s "UPS: Master Export File" -r "Report Distribution Services <DL-099-ITReporting@compucom.com>" $EMAIL $EMAIL_CC < ${DATA_DIR}/filesreceived.lst
}

#####
## Main Function
#####

cd ${BASE_DIR}

cleanup                  ## Remove temp files from previous run if any
getcredentials	         ## Get FTP2 server connection
getfiles	         ## Download file 

cd ${DATA_DIR}
FILECOUNT=`find ${DATA_DIR} -type f -iname '*.csv' | wc -l`

if [ $FILECOUNT -gt 0 ]; then
    listfilesreceived    ## Create list of files received
    ftp2remove           ## Remove downloaded files from remote server
    concatfiles   	 ## Create 1 single dat file
    checkdatfile         ## Check dat file created and move to /xfer/DW/data directory
    sendemail            ## Send email for file received
else
    echo "No files received"
    echo "There was NO data file received during the ${RUN_HOUR} run." > ${MSG_DIR}/mail.msg
    echo "" >> ${MSG_DIR}/mail.msg
    echo "" >> ${MSG_DIR}/mail.msg
    echo "Thank you." >> ${MSG_DIR}/mail.msg
    echo "CompuCom Systems, Inc." >> ${MSG_DIR}/mail.msg 
    mail -s "UPS: Master Export File" -r "Report Distribution Services <DL-099-ITReporting@compucom.com>" $EMAIL $EMAIL_CC < ${MSG_DIR}/mail.msg
fi
