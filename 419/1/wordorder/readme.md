https://hadoop.apache.org/docs/stable/hadoop-mapreduce-client/hadoop-mapreduce-client-core/MapReduceTutorial.html

required path variables:
export PATH=$PATH:~/hadoop-2.7.3/bin
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_CLASSPATH=$JAVA_HOME/lib/tools.jar

To Compile:
hadoop com.sun.tools.javac.Main WordOrder.java
jar cf wc.jar WordOrder*.class

To Run:
hadoop jar wc.jar WordOrder <input> <output>



