
hdfs dfs -rm /output/*
hdfs dfs -rmdir /output
spark-submit --class WordCount --master spark://cobalt:7077 wc.jar
