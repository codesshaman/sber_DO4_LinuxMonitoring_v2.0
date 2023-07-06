#!/bin/bash
if [ "$#" -ne 1 ]; 
then
    echo "ERROR: The number of arguments corresponds to one"
    exit 1
fi
if [ $1 -eq 1 ]; then
    /bin/awk '{ print }' "access1.log" | sort -k 9
elif [ $1 -eq 2 ]; then
    /bin/awk '{ print $1 }' "access1.log" | uniq
elif [ $1 -eq 3 ]; then
    /bin/awk '/400|401|403|404|500|501|502|503/{ s = ""; for (i = 7; i <= 9; i++) s = s $i " "; print s }' "access1.log"
elif [ $1 -eq 4 ]; then
    /bin/awk '/400|401|403|404|500|501|502|503/{ print $1 " " $9 }' "access1.log" | sort | uniq
else
    echo "ERROR: unsupported argument type"
fi