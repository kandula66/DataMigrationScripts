Data Migration Scripts

HDFS data and Hive Database transfer automation between two  clusters Primary and DR scenario 

Synopsis:
For this to work user needs to have
1. Permission to connect to the hive server using beeline.(both source and target)
2. Permission to copy data from source cluster to warehouse location of target cluster.


Code location:
Checkout the scripts here in both source and target cluster  edge nodes and update necessary params.
Execution steps:
Copy Scripts to location: /home/hdfs/scripts/ 

hadoopsync.sh is the main script,It has three steps
Note:use hftp:// with port 50070 on source url instead of hdfs:// ,if both clusters are in diff versions.
Step1.execute distcpall.sh (This script need to be run on the target cluster to copy both internal and external table data)
Update the DIR paths,PRODNN ,DRNN(Target cluster),QUEUE and kerberos principal

Step2.execute mktablesall.sh (This internally calls showtables.sh and showtableddl.sh scripts) ,this will create ddl scripts and run the final ddls in target cluster.
Update the user,password,HIVEJDBCKNOX ENDPOINTS specific to edge node 
Step3.msckall.sh (this will call the msck repair on the target hive tables to create necessary partitions)
Update the user,password,HIVEJDBCKNOX ENDPOINTS specific to edge node .

