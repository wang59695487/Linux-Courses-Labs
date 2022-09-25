#!/bin/bash
#Traverse the files in the current directory and find the size which is greater 100KB
for Filename in $(ls -l |awk '$5 > 102400 {print $9}')
do
#remove the file to the ~/rmp
mv $Filename ~/tmp
done
#tell the user it is finished
echo "Done!"
