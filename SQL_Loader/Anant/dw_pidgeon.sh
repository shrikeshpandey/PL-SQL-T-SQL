#!/usr/bin/ksh
#. ~/.profile
#################################################
#
#  dw_pidgeon.sh
#
#  DW Vendor File Mover process
#
#  Anant Wagle
#  04/20/2019
#
#  This job is designed to move vendor
#  files from the CompuCom FTP site
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

BASE_DIR=/APPS/dw/base/dw_processes/pidgeon
SRC_DIR=$BASE_DIR/src
DATA_DIR=$BASE_DIR/data
ARC_DIR=$BASE_DIR/archive
CFG_DIR=$BASE_DIR/config
PRM_DIR=$BASE_DIR/param
MSG_DIR=$BASE_DIR/msg
LOG_DIR=$BASE_DIR/log
TMP_DIR=$BASE_DIR/tmp

TRGT_DIR=/xfer/DW/data
TRGTFILE=t_vendor_inventory_stg.dat

TMP_FILE=/tmp/pidgeon.log
FTP_LOG=VNDR_INV

CONFIGFILE=supply01.cfg

DATE=`date -d "-1 days" +%F`
FNAME=DBI_LOAD_0*.csv

RUN_HOUR=`date +%H:%M`
CNTR=0

EMAIL="DL-099-ITDataWarehouseETL@compucom.com"
EMAIL_CC="Scott.Ertel@compucom.com, Luis.Fuentes@compucom.com"

####
## Function Definitions
####

##
## Function : cleanup()
## Get credentials to connect to FTP server
##

cleanup()
{
 if [ -f ${PRM_DIR}/files_received_today.lst ]; then
       rm ${PRM_DIR}/files_received_today.lst
 fi

 if [ -f ${MSG_DIR}/mail.html ]; then
       rm ${MSG_DIR}/mail.html
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
## Get files from FTP server
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
## Create list of files received
##

listfilesreceived()
{
   cd ${DATA_DIR}
   for FILERCVD in `ls ${DATA_DIR}`
    do
     echo $FILERCVD >> ${PRM_DIR}/files_received_today.lst
    done
}

##
## Function : ftp2archive
## Archive files received on remote server
## Move downloaded files to archive folder on remote server
##

ftp2archive()
{
   cd ${PRM_DIR}
   for FILENAME in `cat files_received_today.lst`
    do
     
     FNAME="${FILENAME%.*}"
     ARC_FILE=${TMP_DIR}/${FNAME}.log

     getcredentials

     ##--Start FTP to the CC FTP site
     ( 
	/usr/bin/sftp ${FTP_CC_USER}@${FTP_CC} > ${ARC_FILE} 2>&1 <<-EOF
	cd ${FTP_CC_DIR}
	rename ${FILENAME} ../../Archive/${FILENAME} 
	bye
	EOF

     ) >> ${LOG_DIR}/${FNAME}_ftp_arc.log

     cd ${TMP_DIR}
     mv ${ARC_FILE} ${LOG_DIR}/${FNAME}_ftp_arc.log

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
    for FILE in `find ${DATA_DIR} -type f -iname '*.csv'` 
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
## Check if t_vendor_inventory_stg.dat file is created 
## Move dat file to /xfer/DW/data directory
##

checkdatfile()
{
 cd ${DATA_FIR}
 
 if [ -f ${DATA_DIR}/$TRGTFILE ]; then
      mv ${DATA_DIR}/$TRGTFILE ${TRGT_DIR}
 else
      echo '        There was an error generating the "t_vendor_inventory_stg.dat" file.
        Please check.


        Thank you.
        CompuCom Systems, Inc.' | mail -s "Pidgeon: Vendor Inventory Data Files: DAT File Error" -r "Report Distribution Services <DL-099-ITReporting@compucom.com>" aw80410@compucom.com
 fi
}

##
## Function : archivelocal
## Archive processed csv files to archive directory
##

archivelocal()
{
  cd ${DATA_DIR}
  
  for FILEPRCSD in `cat ${PRM_DIR}/files_received_today.lst`
   do
      if [ -f ${DATA_DIR}/$FILEPRCSD ]; then
           mv ${DATA_DIR}/$FILEPRCSD ${ARC_DIR}/$FILEPRCSD
      fi
   done
}

##
## Function : filesprocessedmsg
## Generate files processed message
##

filesprocessedmsg()
{
  echo '<html>' > ${MSG_DIR}/mail.html
  echo '<body bgcolor="white">' >> ${MSG_DIR}/mail.html
  echo '<h4><font face="Arial">The following Vendor Inventory data file(s) was/were received during '${RUN_HOUR}' run.</font></h4>'>> ${MSG_DIR}/mail.html
  for i in `cat ${PRM_DIR}/files_received_today.lst`
   do
    echo '<br>' >> ${MSG_DIR}/mail.html
    echo '<font face="Arial">'"$i"'</font>' >> ${MSG_DIR}/mail.html
   done
  echo '<br>' >> ${MSG_DIR}/mail.html
  echo '<br>' >> ${MSG_DIR}/mail.html
  echo 'Thank you.' >> ${MSG_DIR}/mail.html
  echo '<br>' >> ${MSG_DIR}/mail.html
  echo '<font face="Arial"> CompuCom Systems, Inc.</font>' >> ${MSG_DIR}/mail.html
  echo '</font>' >> ${MSG_DIR}/mail.html
  echo '</body>' >> ${MSG_DIR}/mail.html
  echo '</html>' >> ${MSG_DIR}/mail.html
}

##
## Function : filesnotrcvdmsg
## Generate files processed message
##

filesnotrcvdmsg()
{
  echo '<html>' > ${MSG_DIR}/mail.html
  echo '<body bgcolor="white">' >> ${MSG_DIR}/mail.html
  echo '<h4><font face="Arial">There were NO Vendor Inventory data file(s) for download/processing during '${RUN_HOUR}' run.</font></h4>'>> ${MSG_DIR}/mail.html
  echo '<br>' >> ${MSG_DIR}/mail.html
  echo '<br>' >> ${MSG_DIR}/mail.html
  echo 'Thank you.' >> ${MSG_DIR}/mail.html
  echo '<br>' >> ${MSG_DIR}/mail.html
  echo '<font face="Arial"> CompuCom Systems, Inc.</font>' >> ${MSG_DIR}/mail.html
  echo '</font>' >> ${MSG_DIR}/mail.html
  echo '</body>' >> ${MSG_DIR}/mail.html
  echo '</html>' >> ${MSG_DIR}/mail.html
}

##
## Function : send_email
## Send email if files processed/not received
##

send_email()
{
 
 	SUBJECT="Pidgeon: Vendor Inventory Data Files"
 	BODY="${MSG_DIR}/mail.html"
 	MAIL_TO="Anant.Wagle@compucom.com"
 	MAIL_CC="Anant.Wagle@compucom.com"
 	ATTACH="${MSG_DIR}/mail.html"
 
 	SENDMAIL=/usr/sbin/sendmail
 
 	${SENDMAIL} -i -- ${CONTACT_EMAIL} ${MAIL_TO}  ${MAIL_CC}  <<-EOF
 	From: "Report Distribution Services <DL-099-ITReporting@compucom.com>"
 	Subject: $SUBJECT
 	To: ${MAIL_TO}
 	Cc: ${MAIL_CC}
 	MIME-Version: 1.0
 	Content-Type: multipart/mixed; boundary="-q1w2e3r4t5"
 
 	---q1w2e3r4t5
 	Content-Type: text/html
 	Content-Disposition: inline
 
 	`cat "$BODY"`
 	---q1w2e3r4t5
 	`echo 'Content-Type: application; name="'$(basename $ATTACH)'"'`
 	`echo "Content-Transfer-Encoding: base64"`
 	`echo 'Content-Disposition: attachment; filename="'$(basename $ATTACH)'"'`
 	uuencode --base64 $ATTACH $(basename $ATTACH)
 	---q1w2e3r4t5--
	EOF
}

##
## Function : generatingdumyfile
## Generates a dummy file if no files are recived, this will prevent control-m jobs to crash
##

generatingdummyfile()
{
 echo '"parnerId","reportNameProvided","customerName","forecastName","mfgPartno","reservedQuantity","availQuantity","boQty","age","poEta","oemPo","customerId","currency"' | cat - > ${DATA_DIR}/$TRGTFILE
}

#####
## Main Function
#####

cd $BASE_DIR

cleanup                  ## Remove temp files from previous run if any
getcredentials	         ## Get FTP2 server connection
getfiles		 ## Download files 

cd ${DATA_DIR}
FILECOUNT=`find ${DATA_DIR} -type f -iname '*.csv' | wc -l`

if [ $FILECOUNT -gt 0 ]; then
    listfilesreceived    ## Create list of files received
    ftp2archive          ## Move downloaded files to Archive directory on remote server
    concatfiles          ## Concat multiple files into 1 file - t_vendor_inventory_stg.dat
    checkdatfile         ## Check dat file created and move to /xfer/DW/data directory
    archivelocal         ## Move processed CSV files to archive directory
    filesprocessedmsg    ## Generate email message for files processed
    send_email           ## Send email message for files processed
else
    echo "No files received"
    generatingdummyfile  ## Creates a dummy file t_vendor_inventory_stg.dat
    checkdatfile         ## Moves the dummy file to the /xfer/DW/data directory
    filesnotrcvdmsg      ## Generate email message for NO data files for download/processing
    send_email           ## Send email message for NO Files for download/processing
fi
#!/usr/bin/ksh
#. ~/.profile
#################################################
#
#  dw_pidgeon.sh
#
#  DW Vendor File Mover process
#
#  Anant Wagle
#  04/20/2019
#
#  This job is designed to move vendor
#  files from the CompuCom FTP site
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

BASE_DIR=/APPS/dw/base/dw_processes/pidgeon
SRC_DIR=$BASE_DIR/src
DATA_DIR=$BASE_DIR/data
ARC_DIR=$BASE_DIR/archive
CFG_DIR=$BASE_DIR/config
PRM_DIR=$BASE_DIR/param
MSG_DIR=$BASE_DIR/msg
LOG_DIR=$BASE_DIR/log
TMP_DIR=$BASE_DIR/tmp

TRGT_DIR=/xfer/DW/data
TRGTFILE=t_vendor_inventory_stg.dat

TMP_FILE=/tmp/pidgeon.log
FTP_LOG=VNDR_INV

CONFIGFILE=supply01.cfg

DATE=`date -d "-1 days" +%F`
FNAME=DBI_LOAD_0*.csv

RUN_HOUR=`date +%H:%M`
CNTR=0

EMAIL="DL-099-ITDataWarehouseETL@compucom.com"
EMAIL_CC="Scott.Ertel@compucom.com, Luis.Fuentes@compucom.com"

####
## Function Definitions
####

##
## Function : cleanup()
## Get credentials to connect to FTP server
##

cleanup()
{
 if [ -f ${PRM_DIR}/files_received_today.lst ]; then
       rm ${PRM_DIR}/files_received_today.lst
 fi

 if [ -f ${MSG_DIR}/mail.html ]; then
       rm ${MSG_DIR}/mail.html
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
## Get files from FTP server
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
## Create list of files received
##

listfilesreceived()
{
   cd ${DATA_DIR}
   for FILERCVD in `ls ${DATA_DIR}`
    do
     echo $FILERCVD >> ${PRM_DIR}/files_received_today.lst
    done
}

##
## Function : ftp2archive
## Archive files received on remote server
## Move downloaded files to archive folder on remote server
##

ftp2archive()
{
   cd ${PRM_DIR}
   for FILENAME in `cat files_received_today.lst`
    do
     
     FNAME="${FILENAME%.*}"
     ARC_FILE=${TMP_DIR}/${FNAME}.log

     getcredentials

     ##--Start FTP to the CC FTP site
     ( 
	/usr/bin/sftp ${FTP_CC_USER}@${FTP_CC} > ${ARC_FILE} 2>&1 <<-EOF
	cd ${FTP_CC_DIR}
	rename ${FILENAME} ../../Archive/${FILENAME} 
	bye
	EOF

     ) >> ${LOG_DIR}/${FNAME}_ftp_arc.log

     cd ${TMP_DIR}
     mv ${ARC_FILE} ${LOG_DIR}/${FNAME}_ftp_arc.log

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
    for FILE in `find ${DATA_DIR} -type f -iname '*.csv'` 
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
## Check if t_vendor_inventory_stg.dat file is created 
## Move dat file to /xfer/DW/data directory
##

checkdatfile()
{
 cd ${DATA_FIR}
 
 if [ -f ${DATA_DIR}/$TRGTFILE ]; then
      mv ${DATA_DIR}/$TRGTFILE ${TRGT_DIR}
 else
      echo '        There was an error generating the "t_vendor_inventory_stg.dat" file.
        Please check.


        Thank you.
        CompuCom Systems, Inc.' | mail -s "Pidgeon: Vendor Inventory Data Files: DAT File Error" -r "Report Distribution Services <DL-099-ITReporting@compucom.com>" aw80410@compucom.com
 fi
}

##
## Function : archivelocal
## Archive processed csv files to archive directory
##

archivelocal()
{
  cd ${DATA_DIR}
  
  for FILEPRCSD in `cat ${PRM_DIR}/files_received_today.lst`
   do
      if [ -f ${DATA_DIR}/$FILEPRCSD ]; then
           mv ${DATA_DIR}/$FILEPRCSD ${ARC_DIR}/$FILEPRCSD
      fi
   done
}

##
## Function : filesprocessedmsg
## Generate files processed message
##

filesprocessedmsg()
{
  echo '<html>' > ${MSG_DIR}/mail.html
  echo '<body bgcolor="white">' >> ${MSG_DIR}/mail.html
  echo '<h4><font face="Arial">The following Vendor Inventory data file(s) was/were received during '${RUN_HOUR}' run.</font></h4>'>> ${MSG_DIR}/mail.html
  for i in `cat ${PRM_DIR}/files_received_today.lst`
   do
    echo '<br>' >> ${MSG_DIR}/mail.html
    echo '<font face="Arial">'"$i"'</font>' >> ${MSG_DIR}/mail.html
   done
  echo '<br>' >> ${MSG_DIR}/mail.html
  echo '<br>' >> ${MSG_DIR}/mail.html
  echo 'Thank you.' >> ${MSG_DIR}/mail.html
  echo '<br>' >> ${MSG_DIR}/mail.html
  echo '<font face="Arial"> CompuCom Systems, Inc.</font>' >> ${MSG_DIR}/mail.html
  echo '</font>' >> ${MSG_DIR}/mail.html
  echo '</body>' >> ${MSG_DIR}/mail.html
  echo '</html>' >> ${MSG_DIR}/mail.html
}

##
## Function : filesnotrcvdmsg
## Generate files processed message
##

filesnotrcvdmsg()
{
  echo '<html>' > ${MSG_DIR}/mail.html
  echo '<body bgcolor="white">' >> ${MSG_DIR}/mail.html
  echo '<h4><font face="Arial">There were NO Vendor Inventory data file(s) for download/processing during '${RUN_HOUR}' run.</font></h4>'>> ${MSG_DIR}/mail.html
  echo '<br>' >> ${MSG_DIR}/mail.html
  echo '<br>' >> ${MSG_DIR}/mail.html
  echo 'Thank you.' >> ${MSG_DIR}/mail.html
  echo '<br>' >> ${MSG_DIR}/mail.html
  echo '<font face="Arial"> CompuCom Systems, Inc.</font>' >> ${MSG_DIR}/mail.html
  echo '</font>' >> ${MSG_DIR}/mail.html
  echo '</body>' >> ${MSG_DIR}/mail.html
  echo '</html>' >> ${MSG_DIR}/mail.html
}

##
## Function : send_email
## Send email if files processed/not received
##

send_email()
{
 
 	SUBJECT="Pidgeon: Vendor Inventory Data Files"
 	BODY="${MSG_DIR}/mail.html"
 	MAIL_TO="Anant.Wagle@compucom.com"
 	MAIL_CC="Anant.Wagle@compucom.com"
 	ATTACH="${MSG_DIR}/mail.html"
 
 	SENDMAIL=/usr/sbin/sendmail
 
 	${SENDMAIL} -i -- ${CONTACT_EMAIL} ${MAIL_TO}  ${MAIL_CC}  <<-EOF
 	From: "Report Distribution Services <DL-099-ITReporting@compucom.com>"
 	Subject: $SUBJECT
 	To: ${MAIL_TO}
 	Cc: ${MAIL_CC}
 	MIME-Version: 1.0
 	Content-Type: multipart/mixed; boundary="-q1w2e3r4t5"
 
 	---q1w2e3r4t5
 	Content-Type: text/html
 	Content-Disposition: inline
 
 	`cat "$BODY"`
 	---q1w2e3r4t5
 	`echo 'Content-Type: application; name="'$(basename $ATTACH)'"'`
 	`echo "Content-Transfer-Encoding: base64"`
 	`echo 'Content-Disposition: attachment; filename="'$(basename $ATTACH)'"'`
 	uuencode --base64 $ATTACH $(basename $ATTACH)
 	---q1w2e3r4t5--
	EOF
}

##
## Function : generatingdumyfile
## Generates a dummy file if no files are recived, this will prevent control-m jobs to crash
##

generatingdummyfile()
{
 echo '"parnerId","reportNameProvided","customerName","forecastName","mfgPartno","reservedQuantity","availQuantity","boQty","age","poEta","oemPo","currency"' | cat - > ${DATA_DIR}/$TRGTFILE
}

#####
## Main Function
#####

cd $BASE_DIR

cleanup                  ## Remove temp files from previous run if any
getcredentials	         ## Get FTP2 server connection
getfiles		 ## Download files 

cd ${DATA_DIR}
FILECOUNT=`find ${DATA_DIR} -type f -iname '*.csv' | wc -l`

if [ $FILECOUNT -gt 0 ]; then
    listfilesreceived    ## Create list of files received
    ftp2archive          ## Move downloaded files to Archive directory on remote server
    concatfiles          ## Concat multiple files into 1 file - t_vendor_inventory_stg.dat
    checkdatfile         ## Check dat file created and move to /xfer/DW/data directory
    archivelocal         ## Move processed CSV files to archive directory
    filesprocessedmsg    ## Generate email message for files processed
    send_email           ## Send email message for files processed
else
    echo "No files received"
    generatingdummyfile  ## Creates a dummy file t_vendor_inventory_stg.dat
    checkdatfile         ## Moves the dummy file to the /xfer/DW/data directory
    filesnotrcvdmsg      ## Generate email message for NO data files for download/processing
    send_email           ## Send email message for NO Files for download/processing
fi
