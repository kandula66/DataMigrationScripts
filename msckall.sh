#!/bin/bash
export HADOOP_CLIENT_OPTS="-Djline.terminal=jline.UnsupportedTerminal"
DBS=digitalinsightsdatamart,digitalinsightsusermart
USR=svcdwhdpuserprod
PASS="R7BnNiW)wxd(7N)"

TARGETKX="jdbc:hive2://destKNOXHOST:8443"
SOURCEKX=$TARGETKX

echo "Source: $SOURCEKX"

echo $DBS | sed "s/,/\\n/g" | while read DB
do
  echo "Processing DB = $DB"
  beeline --showHeader=false --headerInterval=0 --fastConnect=true -u "${SOURCEKX}/${DB};ssl=true?hive.server2.transport.mode=http;hive.server2.thrift.http.path=gateway/default/hive" --outputformat=tsv2 -n $USR -p "${PASS}" -e "show tables;" 2>/dev/null | grep -v "^tab_name" | while read LINE
  do
    echo "MSCK $DB - $LINE"
    beeline --showHeader=false --headerInterval=0 --fastConnect=true -u "${SOURCEKX}/${DB};ssl=true?hive.server2.transport.mode=http;hive.server2.thrift.http.path=gateway/default/hive" --outputformat=tsv2 -n $USR -p "${PASS}" -e "msck repair table $LINE;" 2>/dev/null
    ret=$?
    if [ $ret -ne 0 ] ; then
      echo "MSCK Failed $DB - $LINE"
     #exit 1
    fi
  done
done
exit 0