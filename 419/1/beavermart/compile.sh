#! /bin/bash
echo "removing old output directory"
rm output -rf

echo "compiling java for hadoopi"
hadoop com.sun.tools.javac.Main BeaverMart.java

echo "exporting jar"
jar cf wc.jar BeaverMart*.class

echo "running hadoop program"
hadoop jar wc.jar BeaverMart input output

echo "cat output/*"
cat output/*
