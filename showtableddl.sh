#!/bin/bash
export HADOOP_CLIENT_OPTS="-Djline.terminal=jline.UnsupportedTerminal"
DB=$1
LINE=$2
USR=svcdwhdpuserprod
PASS="R7BnNiW)wxd(7N)"
HIVEJDBCKNOX="jdbc:hive2://XXX.test.com:8443"

SOURCEKX=$HIVEJDBCKNOX
HDFSS=prodDefaultFS
HDFSD=destDefaultFS


beeline --showHeader=false --headerInterval=0 --fastConnect=true -u "${SOURCEKX}/${DB};ssl=true?hive.server2.transport.mode=http;hive.server2.thrift.http.path=gateway/default/hive" --outputformat=tsv2 -n $USR -p "${PASS}" -e "show create table $LINE;" 2>/dev/null | sed "s/$HDFSS/$HDFSD/g" | grep -v "^createtab_stmt"
ret=$?
if [ $ret -ne 0 ] ; then
   echo "SHOW DDL Failed $DB - $LINE"
   exit 1
fi
echo ";"
exit 0