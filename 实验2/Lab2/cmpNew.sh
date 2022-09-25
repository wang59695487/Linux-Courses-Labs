#!/bin/bash
#test which file is newer
echo "$1: " 
cat $1
echo "$2: "
cat $2
newerFile=`find $1 -newer $2`
if [ "$newerFile" == "$1" ] ; then
    echo "$1 is newer than $2"
else
    echo "$2 is newer than $1"
fi

