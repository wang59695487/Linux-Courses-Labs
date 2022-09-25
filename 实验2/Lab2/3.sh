#!/bin/bash
# To ensure the input with one parameter
if test $# -ne 1
then
    if test $# -lt 1 ; then
        echo -n "Missing argument! "
    elif test $# -gt 1 ; then
        echo -n "Too many arguments! "
    fi
    exit 1
fi

str=${1//[!a-zA-Z]}         # Only keep alphabetic characters
revstr=`echo $str | rev`    # Generate the reversed string of the string

# If the original string = reversed string, output "Yes", otherwise output "No"
if [[ "$str" = "$revstr" ]]
then  
    echo "Word \"$str\" is a palindrome."
else 
    echo "Word \"$str\" is not a palindrome."
fi

#exit the program
exit 0

