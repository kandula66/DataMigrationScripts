#!/bin/bash
/home/hdfs/scripts/distcpall.sh > /home/hdfs/scripts/distcpall.out 2>&1
ret=$?
if [ $ret -ne 0 ] ; then
 echo "discpall failed"
 exit 1
fi
/home/hdfs/scripts/mktablesall.sh > /home/hdfs/scripts/mktablesall.out 2>&1
ret=$?
if [ $ret -ne 0 ] ; then
 echo "mktablesall failed"
 exit 1
fi
/home/hdfs/scripts/msckall.sh > /home/hdfs/scripts/msckall.out 2>&1
ret=$?
if [ $ret -ne 0 ] ; then
 echo "msckall failed"
 exit 1
fi