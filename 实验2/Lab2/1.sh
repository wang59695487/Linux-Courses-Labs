#!/bin/bash
#To ensure  the input with one parameter
if test $# -ne 1; 
then
    echo "Please just input one parameter!!!"
    exit 1
fi

filename=$1
if test -f "$filename" #check the file 
then #if it is a normal file
    set -- $(ls -l $filename)
    echo "The filename is $filename." #print the filename
    echo "The owner is ${3}."   #print the owner
    echo "The last edit time is $6 $7 $8." #print the last edit time
    exit 0
fi

#if it is not a normal file
echo "$filename is not a normal file."
exit 1
