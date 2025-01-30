
rm -rf /tmp/hadoop*
ssh poe rm -rf /tmp/hadoop*
ssh sand rm -rf /tmp/hadoop*

hdfs namenode -format

start-dfs.sh

start-master.sh
start-slaves.sh

