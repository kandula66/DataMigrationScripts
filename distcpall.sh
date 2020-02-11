#!/bin/bash
#NOTE
#
#Script is written to be run on destination
#If wanting to update DR run from a DR server and PROD will be source and DR will be destination
#
DIRS=/apps/hive/warehouse/digitalinsightsdatamart.db/,/prod/archive/,/apps/hive/warehouse/edwarchive.db/,/prod/staging/,/apps/hive/warehouse/digitalinsightsusermart.db/

PRODNN="hdfs://PROD0057-01:8020"
DRNN="hdfs://DR0057-01:8020"
QUEUE="dba"
# KERBEROS PRINCIPAL FOR TARGET CLUSTER
VAKP="hdfs-PROD2@US.TEST.COM"

if [ $(whoami) != "hdfs" ] ; then
  echo "user is not hdfs"
 exit 1
fi

SOURCENN=$PRODNN
DESTNN=$DRNN
KP=$VAKP

kinit -kt /etc/security/keytabs/hdfs.headless.keytab $KP
ret=$?
if [ $ret -ne 0 ] ; then
   echo "kinit failed $KP"
   exit 1
fi

echo "Source: $SOURCENN - Destination: $DESTNN"

echo $DIRS | sed "s/,/\\n/g" | while read DIR
do
  echo "Running distcp"
  echo "hadoop distcp -Dmapred.job.queue.name=$QUEUE -pb -m 2 -update -strategy dynamic -delete  ${SOURCENN}${DIR} ${DESTNN}${DIR}"
  hadoop distcp -Dmapred.job.queue.name=$QUEUE -pb -m 2 -update -strategy dynamic -delete  ${SOURCENN}${DIR} ${DESTNN}${DIR}
  ret=$?
  if [ $ret -ne 0 ] ; then
     echo "distcp failed ${SOURCENN}${DIR} ${DESTNN}${DIR}"
     exit 1
  fi
done
exit 0