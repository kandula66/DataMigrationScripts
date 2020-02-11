#!/bin/bash
export HADOOP_CLIENT_OPTS="-Djline.terminal=jline.UnsupportedTerminal"
DB=$1
#update the USR ,PASS AND HIVEJDBC SPECIFIC TO THE ENVIRONMENT WHERE THIS SCRIPT IS RUNNING
USR=svcdwhdpuserprod
PASS="R7BnNiW)wxd(7N)"
HIVEJDBCKNOX="jdbc:hive2://xxxx.test.com:8443"


SOURCEKX=$HIVEJDBCKNOX


beeline --showHeader=false --headerInterval=0 --fastConnect=true -u "${SOURCEKX}/${DB};ssl=true?hive.server2.transport.mode=http;hive.server2.thrift.http.path=gateway/default/hive" --outputformat=tsv2 -n $USR -p "${PASS}" -e "show tables;" 2>/dev/null | grep -v "^tab_name"
ret=$?
if [ $ret -ne 0 ] ; then
   echo "MSCK Failed $DB - $LINE"
   exit 1
fi
exit 0