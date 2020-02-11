#!/bin/bash
export HADOOP_CLIENT_OPTS="-Djline.terminal=jline.UnsupportedTerminal"
DBS=digitalinsightsdatamart,digitalinsightsusermart
USR=svcdwhdpuserprod
PASS="R7BnNiW)wxd(7N)"
MIUX=sourceedgehostname


DESTHIVEJDBCKNOX="jdbc:hive2://DESTHIVEHOST.com:8443"

SOURCEKX=$DESTHIVEJDBCKNOX
DESTUX=$MIUX

echo "Source: $SOURCEKX Remote Server $DESTUX"

echo $DBS | sed "s/,/\\n/g" | while read DB
do
  echo "Processing DB = $DB"
  /home/hdfs/scripts/showtables.sh $DB > /tmp/$$.tables.txt
  ssh ${DESTUX} "/home/hdfs/scripts/showtables.sh $DB" 2>/dev/null > /tmp/$$.rtables.txt </dev/null
  diff /tmp/$$.rtables.txt /tmp/$$.tables.txt | grep "^< " | cut -c3- | while read LINE
  do
    echo "Generate DDL $DB - $LINE"
    ssh ${DESTUX} "/home/hdfs/scripts/showtableddl.sh $DB $LINE" 2>/dev/null > /tmp/$$.tableddl.txt </dev/null
    beeline --showHeader=false --headerInterval=0 --fastConnect=true -u "${SOURCEKX}/${DB};ssl=true?hive.server2.transport.mode=http;hive.server2.thrift.http.path=gateway/default/hive" --outputformat=tsv2 -n $USR -p "${PASS}" -f /tmp/$$.tableddl.txt  2>/dev/null
    ret=$?
    echo "Showing DDL $DB - $LINE"
    cat /tmp/$$.tableddl.txt
    /bin/rm /tmp/$$.tableddl.txt
    if [ $ret -ne 0 ] ; then
      echo "Create Failed $DB - $LINE"
      exit 1
    fi
  done
  /bin/rm /tmp/$$.tables.txt
  /bin/rm /tmp/$$.rtables.txt
done
exit 0