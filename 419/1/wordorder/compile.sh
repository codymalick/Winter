#! /bin/bash
echo "removing old output directory"
rm output -rf

echo "compiling java for hadoopi"
hadoop com.sun.tools.javac.Main WordOrder.java

echo "exporting jar"
jar cf wc.jar WordOrder*.class

echo "running hadoop program"
hadoop jar wc.jar WordOrder input output

echo "cat output/*"
cat output/*
