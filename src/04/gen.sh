#!/bin/bash

name_sim=$1
size_sim=${#name_sim}
caunter_gen=$2
count_sim_1=1
count_sim_2=1
count_sim_3=1
count_sim_4=1
count_sim_5=1
count_sim_6=1
count_sim_7=1
if [[ $size_sim -eq 1 ]]; 
then
    name=$name_sim
    for (( i=-2; i<$caunter_gen; i++ )) do
        name+=$name_sim
    done
elif [[ $size_sim -eq 2 ]]; 
then
    count_sim_1=2
    count_sim_2=3
    for (( i=1; i<$caunter_gen; i++ )) do
        if [ $count_sim_1 -gt $count_sim_2 ];
        then
            let count_sim_2++
            count_sim_1=1
        else
            let count_sim_1++
        fi
    done
    for (( i=0; i<$( expr $count_sim_1 + $count_sim_2 ); i++ )) do
        if [ $i -lt $count_sim_1 ];
        then
            name+="${name_sim:0:1}"
        else
            name+="${name_sim:1:1}"
        fi
    done
elif [[ $size_sim -eq 3 ]];
then
    count_sim_1=2
    count_sim_3=2
    for (( i=1; i<$caunter_gen; i++ )) do
        if [ $count_sim_2 -gt $count_sim_3 ];
        then
            let count_sim_3++
            count_sim_2=1
            count_sim_1=1
        elif [ $count_sim_1 -gt $count_sim_2 ];
        then
            let count_sim_2++
            count_sim_1=1
        else
            let count_sim_1++
        fi
    done
    for (( i=0; i<$( expr $count_sim_1 + $count_sim_2 + $count_sim_3 ); i++ )) do
        if [ $i -lt $count_sim_1 ];
        then
            name+="${name_sim:0:1}"
        elif [ $i -lt $( expr $count_sim_1 + $count_sim_2 ) ];
        then
            name+="${name_sim:1:1}"
        else
            name+="${name_sim:2:1}"
        fi
    done
elif [[ $size_sim -eq 4 ]];
then
    count_sim_1=2
    for (( i=1; i<$caunter_gen; i++ )) do
        if [ $count_sim_3 -gt $count_sim_4 ];
        then
            let count_sim_4++
            count_sim_3=1
            count_sim_2=1
            count_sim_1=1
        elif [ $count_sim_2 -gt $count_sim_3 ];
        then
            let count_sim_3++
            count_sim_2=1
            count_sim_1=1
        elif [ $count_sim_1 -gt $count_sim_2 ];
        then
            let count_sim_2++
            count_sim_1=1
        else
            let count_sim_1++
        fi
    done
    for (( i=0; i<$( expr $count_sim_1 + $count_sim_2 + $count_sim_3 + $count_sim_4 ); i++ )) do
        if [ $i -lt $count_sim_1 ];
        then
            name+="${name_sim:0:1}"
        elif [ $i -lt $( expr $count_sim_1 + $count_sim_2 ) ];
        then
            name+="${name_sim:1:1}"
        elif [ $i -lt $( expr $count_sim_1 + $count_sim_2 + $count_sim_3 ) ];
        then
            name+="${name_sim:2:1}"
        else
            name+="${name_sim:3:1}"
        fi
    done
else
    if [ $size_sim -eq 5 ]
    then
        count_sim_6=0
        count_sim_7=0
    elif [ $size_sim -eq 6 ]
    then
        count_sim_7=0
    fi
    for (( i=1; i<$caunter_gen; i++ )) do
        if [ $size_sim -eq 7 ] && [ $count_sim_6 -gt $count_sim_7 ];
        then
            let count_sim_7++
            count_sim_6=1
            count_sim_5=1
            count_sim_4=1
            count_sim_3=1
            count_sim_2=1
            count_sim_1=1
        elif [ $size_sim -gt 5 ] && [ $count_sim_5 -gt $count_sim_6 ];
        then
            let count_sim_6++
            count_sim_5=1
            count_sim_4=1
            count_sim_3=1
            count_sim_2=1
            count_sim_1=1
        elif [ $count_sim_4 -gt $count_sim_5 ];
        then
            let count_sim_5++
            count_sim_4=1
            count_sim_3=1
            count_sim_2=1
            count_sim_1=1
        elif [ $count_sim_3 -gt $count_sim_4 ];
        then
            let count_sim_4++
            count_sim_3=1
            count_sim_2=1
            count_sim_1=1
        elif [ $count_sim_2 -gt $count_sim_3 ];
        then
            let count_sim_3++
            count_sim_2=1
            count_sim_1=1
        elif [ $count_sim_1 -gt $count_sim_2 ];
        then
            let count_sim_2++
            count_sim_1=1
        else
            let count_sim_1++
        fi
    done
    for (( i=0; i<$( expr $count_sim_1 + $count_sim_2 + $count_sim_3 + $count_sim_4 + $count_sim_5 + $count_sim_6 + $count_sim_7); i++ )) do
        if [ $i -lt $count_sim_1 ];
        then
            name+="${name_sim:0:1}"
        elif [ $i -lt $( expr $count_sim_1 + $count_sim_2 ) ];
        then
            name+="${name_sim:1:1}"
        elif [ $i -lt $( expr $count_sim_1 + $count_sim_2 + $count_sim_3 ) ];
        then
            name+="${name_sim:2:1}"
        elif [ $i -lt $( expr $count_sim_1 + $count_sim_2 + $count_sim_3 + $count_sim_4 ) ];
        then
            name+="${name_sim:3:1}"
        elif [ $i -lt $( expr $count_sim_1 + $count_sim_2 \
             + $count_sim_3 + $count_sim_4 + $count_sim_5 ) ];
        then
            name+="${name_sim:4:1}"
        elif [ $size_sim -gt 5 ] && [ $i -lt $( expr $count_sim_1 + $count_sim_2 \
             + $count_sim_3 + $count_sim_4 + $count_sim_5 + $count_sim_6 ) ];
        then
            name+="${name_sim:5:1}"
        elif [ $size_sim -eq 7 ];
        then
            name+="${name_sim:6:1}"
        fi
    done
fi
echo $name