#!/bin/bash
#To ensure  the input with one parameter
if test $# -gt 1; 
then
    echo "Please just input one parameter!!!"
    exit 1
fi


directory=$1

#If the parameter is empty, the parameter is current directory
echo -en "Directroy: "
if test $# -lt 1; then
    pwd
else
    echo $directory
fi

#Count the number of different types of files in the directory, including hidden files.
#the first character is the file type,'-' is a normal file, and'd' is a directory.
echo -en "Normal files: "
ls -Al $directory | grep -c "^-"
echo -en "Sub-directory: "
ls -Al $directory | grep -c "^d"

#If there is x or s in the file permissions, the file is executable.
echo -en "Executable: "
ls -Al $directory | grep -c "^-[rw-]*[sx]"

# Count the total number of bytes of all ordinary files in this directory.
#initialize the sum
declare -i sum=0
#Enter the directory and calculate
cd $directory
for x in $(ls) 
do
  if test -f "$x"
  then
        set -- $(ls -Al $x)
        ((sum=sum +"$5"))

  fi
done
echo "Total size (in byte): $sum" 

#exit the program
exit 0

