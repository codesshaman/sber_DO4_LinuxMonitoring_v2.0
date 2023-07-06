#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "ERROR: The number of arguments should be 3 "
    exit 1
fi

avail_size=$(/bin/df -k / | /bin/grep /dev/mapper/ | /bin/awk '{print $4}')
if [ $avail_size -le 1048576 ]; then
    echo "Error: Not enough memory"
    exit 1
fi

START_TIME_NANOSEC=$(date +%s%N)
START_TIME=$(date +%H:%M:%S)
error_target=0
NUMBER='[^0-9]+'
ALPHABET='[^a-zA-Z]+'

character_for_name_dir=$1
no_repeat_cheker_dir=$(echo $character_for_name_dir | /bin/sed 's/\(.\)\1/\1/g')
if [ ${#character_for_name_dir} -gt 7 ]
then
    if [[ $error_target == 1 ]];
    then
        echo
    fi
    echo "ERROR: The number of characters to generate a folder name should not exceed 7 "
    echo "       Erroneous argument №1: $character_for_name_dir "
    error_target=1
elif [[ $character_for_name_dir =~ $ALPHABET ]]
then
    if [[ $error_target == 1 ]];
    then
        echo
    fi
    echo "ERROR: Only Latin letters should be used to generate the folder name "
    echo "       Erroneous argument №1: $character_for_name_dir "
    error_target=1
elif [[ ${#no_repeat_cheker_dir} -ne ${#character_for_name_dir} ]]
then
    if [[ $error_target == 1 ]];
    then
        echo
    fi
    echo "ERROR: The letters for generating folder names should not be repeated "
    echo "       Erroneous argument №1: $character_for_name_dir "
    error_target=1
fi

character_for_file=$2
character_for_name_file=${character_for_file%.*}
character_for_expansion_file=${character_for_file#*.}
no_repeat_cheker_file_name=$(echo $character_for_name_file | /bin/sed 's/\(.\)\1/\1/g')
no_repeat_cheker_file_expansion=$(echo $character_for_expansion_file | /bin/sed 's/\(.\)\1/\1/g')
if [[ ! $character_for_file == *.* ]];
then
    if [[ $error_target == 1 ]];
    then
        echo
    fi
    echo "ERROR: There should be a dot between the file name and the extension "
    echo "       Erroneous argument №2: $character_for_file "
    error_target=1
else
    if [ ${#character_for_name_file} -gt 7 ]
    then
        if [[ $error_target == 1 ]];
        then
            echo
        fi
        echo "ERROR: The number of characters to generate a file name should not exceed 7 "
        echo "       Erroneous argument №2: $character_for_file "
        error_target=1
    elif [[ $character_for_name_file =~ $ALPHABET ]]
    then
        if [[ $error_target == 1 ]];
        then
            echo
        fi
        echo "ERROR: Only Latin letters should be used to generate the file name "
        echo "       Erroneous argument №2: $character_for_file "
        error_target=1
    elif [[ ${#no_repeat_cheker_file_name} -ne ${#character_for_name_file} ]]
    then
        if [[ $error_target == 1 ]];
        then
            echo
        fi
        echo "ERROR: The letters for generating file names should not be repeated "
        echo "       Erroneous argument №2: $character_for_file "
        echo "       Erroneous argument №2: $character_for_file "
        error_target=1
    fi

    if [ ${#character_for_expansion_file} -gt 3 ]
    then
        if [[ $error_target == 1 ]];
        then
            echo
        fi
        echo "ERROR: The number of characters to generate a file expansion should not exceed 3 "
        echo "       Erroneous argument №2: $character_for_file "
        error_target=1
    elif [[ $character_for_expansion_file =~ $ALPHABET ]]
    then
        if [[ $error_target == 1 ]];
        then
            echo
        fi
        echo "ERROR: Only Latin letters should be used to generate the file expansion "
        echo "       Erroneous argument №2: $character_for_file "
        error_target=1
    elif [[ ${#no_repeat_cheker_file_expansion} -ne ${#character_for_expansion_file} ]]
    then
        if [[ $error_target == 1 ]];
        then
            echo
        fi
        echo "ERROR: The letters for generating file expansion should not be repeated "
        echo "       Erroneous argument №2: $character_for_file "
        error_target=1
    fi
fi

size_file=$3
size_num_files=${size_file%Mb*}
if [[ $size_num_files =~ $NUMBER || ! $size_file == *Mb ]]; 
then
    if [[ $error_target == 1 ]];
    then
        echo
    fi
    echo "ERROR: The file size should be described by the number and signature Mb after. "
    echo "       Erroneous argument №3: $size_file "
    error_target=1
elif [ $size_num_files -gt 100 ]; 
then
    if [[ $error_target == 1 ]];
    then
        echo
    fi
    echo "ERROR: The amount of memory for the file should not exceed 100 Mb "
    echo "       Erroneous argument №3: $size_file "
    error_target=1
fi

if [[ $error_target != 1 ]];
then
    /bin/touch "logger.log"
    data="_$(/bin/date +"%d%m%y")"
    number_of_subfolders=$(($RANDOM%100))
    for (( i=1; i<=${number_of_subfolders}; i++ )) do
        avail_size=$(/bin/df -k / | /bin/grep /dev/mapper/ | /bin/awk '{print $4}')
        if [ $avail_size -le 1048576 ]; then
            echo "Error: Not enough memory"
            break
        fi
        path="$(find /home -type d 2>/dev/null | grep -E '[^(bin|sbin)]' | head -n$(($RANDOM%650)) | tail -n1)/"
        name_dir="$(/bin/bash gen.sh $character_for_name_dir $i)"
        /bin/mkdir "${path}${name_dir}${data}"
        echo -e "${path}${name_dir}${data}/\t\t\t\t\t$(/bin/date +"%d.%m.%y")" >> logger.log
        number_of_file=$(($RANDOM%100))
        for (( j=1; j<=${number_of_file}; j++ )) do
            avail_size=$(/bin/df -k / | /bin/grep /dev/mapper/ | /bin/awk '{print $4}')
            if [ $avail_size -le 1048576 ]; then
                echo "Error: Not enough memory"
                break
            fi
            name_file="$(/bin/bash gen.sh $character_for_name_file $((j)))"
            /bin/fallocate -l ${size_file} "${path}${name_dir}${data}/${name_file}${data}.${character_for_expansion_file}"
            echo -e "${path}${name_dir}${data}/${name_file}${data}.${character_for_expansion_file}\t$(/bin/date +"%d.%m.%y") ${size_num_files}" >> logger.log
        done
    done
    END_TIME=$(date +%H:%M:%S)
    END_TIME_NANOSEC=$(date +%s%N)
    echo "Start time: $START_TIME"
    echo "End time: $END_TIME"
    echo "Total workong time: $((($END_TIME_NANOSEC - $START_TIME_NANOSEC)/1000000000)) seconds"
    echo "Start time: $START_TIME" >> logger.log
    echo "End time: $END_TIME" >> logger.log
    echo "Total workong time: $((($END_TIME_NANOSEC - $START_TIME_NANOSEC)/1000000000)) seconds" >> logger.log
fi