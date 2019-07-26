#!/usr/bin/env bash
mvn clean package  || { echo "Could not download Sample dependency"; exit 23; }
rm target -Rf
rm *.jar
