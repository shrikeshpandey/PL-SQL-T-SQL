
#!/bin/ksh
##  Script to Load Fieldglass Mileage Data
##  Process with 1) run SFTP process to get FG file 2) SQL Loader to post file
##  12/01/2018 
if [ -f /etc/oratab ]
then
     :
else
     echo "/etc/oratab doesn't exist" 1>&2
     exit 1
fi

ORACLE_SID=DW
ORACLE_HOME=`cat /etc/oratab | grep ^${ORACLE_SID}: | cut -d: -f2`
PATH=${ORACLE_HOME}/bin:$PATH
export ORACLE_SID ORACLE_HOME PATH
. ${ORACLE_HOME}/ccbin/ORAUSERS
DW_SYS=DW
###
scriptname=fgmileage.sh
runtype=fgmileage
sfilepre=FGMileage.20*
filename=T_FG_WORKER_MILEAGE_STG
runtime=`date +%m%d%H%M%S`
###F1eldglass
###
APPS=/APPS/dw/base
ctldir=$APPS/hr/sqlldr
BASE_DIR=/xfer/DW/data/hr/fieldgls
datadir=$BASE_DIR/in
logdir=$BASE_DIR/log
arcdir=$BASE_DIR/archive
###
logfile=$logdir/$runtype.run.$runtime
datain=$datadir/$filename.dat
ctllog=$logdir/$filename.log
ctlin=$ctldir/$filename.ctl
badout=$logdir/$filename.bad
# Function
# msg - print a message to the log file.
function msg {
         echo  "$scriptname: $*" >> $logfile 
}
touch $logfile
chmod 666 $logfile
msg  $(date +%x@%X) Start $filename load
################################
# SFTP PROCESS
SHOST='FTP2.compucom.com'
SUSER='fldgls'
(/usr/bin/sftp  $SUSER@$SHOST > $logdir/fgwsftp.log1.$runtime 2>&1 << EOF
lcd $datadir
mget $sfilepre
rm   $sfilepre
bye
EOF
) >> $logdir/fgwsftp.log2.$runtime
################################
# Check for data files in Input Dir with Naming Convention
filenames=nothing 
filenames=`ls $datadir/$sfilepre  2> /dev/null`

echo 'filenames' $filenames	

# Look for data
filecount=`echo $filenames | wc -w`
echo $filecount	
if [ $filecount -eq 0 ] ; then
   msg  $(date +%x@%X) No $sfilepre  found -- STOP
   exit 55
fi
if [ $filecount -gt 1 ] ; then
   msg  $(date +%x@%X) Too Many  $filenames Found -- STOP
   exit 66
fi

mv $datadir/$sfilepre* $datain 

sqlldr  ${DW_USER}/${DW_PWD}@${DW_SYS} data=$datain log=$ctllog control=$ctlin bad=$badout
echo "Sqlldr finished with status=" $?

## Move files to retain
mv $datain $arcdir/$runtype.dat.$runtime
gzip $arcdir/$runtype.dat.$runtime
mv $ctllog $logdir/$runtype.log.$runtime
mv $badout $logdir/$runtype.bad.$runtime  2> /dev/null

## Remove files  <<<<<<<<<<<<<<
find $logdir/$runtype.job.*   -mtime +22 -type f -exec rm -f {} \; 2> /dev/null
find $logdir/fgwsftp.log*     -mtime +22 -type f -exec rm -f {} \; 2> /dev/null
find $logdir/$runtype.run.*   -mtime +22 -type f -exec rm -f {} \;
find $logdir/$runtype.log.*   -mtime +22 -type f -exec rm -f {} \;
find $logdir/$runtype.bad.*  -mtime +22 -type f -exec rm -f {} \; 2> /dev/null
find $arcdir/$runtype.dat.*   -mtime +22 -type f -exec rm -f {} \;

msg  $(date +%x@%X) Process Complete -- End
### END

