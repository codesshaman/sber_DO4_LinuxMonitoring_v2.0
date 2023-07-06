#!/bin/bash

if [ "$#" -ne 6 ]; then
    echo "ERROR: The number of arguments should be 6 "
    exit 1
fi

avail_size=$(/bin/df -k / | /bin/grep /dev/mapper/ | /bin/awk '{print $4}')
if [ $avail_size -le 1048576 ]; then
    echo "Error: Not enough memory"
    exit 1
fi

error_target=0
NUMBER='[^0-9]+'
ALPHABET='[^a-zA-Z]+'
path=$1
if [[ ${1:$((${#1}-1)):1} != / ]]; 
then
    echo "ERROR: The path must end with a '/' character "
    error_target=1
elif [ ! -d $path ];
then
    echo "ERROR: Folder $path doesn't exsist "
    error_target=1
fi

number_of_subfolders=$2
if [[ $number_of_subfolders =~ $NUMBER ]]; 
then
    if [[ $error_target == 1 ]];
    then
        echo
    fi
    echo "ERROR: The number of subfolders can only be described by a number "
    echo "       Erroneous argument №2: $number_of_subfolders "
    error_target=1
fi

character_for_name_dir=$3
no_repeat_cheker_dir=$(echo $character_for_name_dir | /bin/sed 's/\(.\)\1/\1/g')
if [ ${#character_for_name_dir} -gt 7 ]
then
    if [[ $error_target == 1 ]];
    then
        echo
    fi
    echo "ERROR: The number of characters to generate a folder name should not exceed 7 "
    echo "       Erroneous argument №3: $character_for_name_dir "
    error_target=1
elif [[ $character_for_name_dir =~ $ALPHABET ]]
then
    if [[ $error_target == 1 ]];
    then
        echo
    fi
    echo "ERROR: Only Latin letters should be used to generate the folder name "
    echo "       Erroneous argument №3: $character_for_name_dir "
    error_target=1
elif [[ ${#no_repeat_cheker_dir} -ne ${#character_for_name_dir} ]]
then
    if [[ $error_target == 1 ]];
    then
        echo
    fi
    echo "ERROR: The letters for generating folder names should not be repeated "
    echo "       Erroneous argument №3: $character_for_name_dir "
    error_target=1
fi

number_of_file=$4
if [[ $number_of_file =~ $NUMBER ]]; 
then
    if [[ $error_target == 1 ]];
    then
        echo
    fi
    echo "ERROR: The number of subfolders can only be described by a number "
    echo "       Erroneous argument №4: $number_of_file "
    error_target=1
fi

character_for_file=$5
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
    echo "       Erroneous argument №5: $character_for_file "
    error_target=1
else
    if [ ${#character_for_name_file} -gt 7 ]
    then
        if [[ $error_target == 1 ]];
        then
            echo
        fi
        echo "ERROR: The number of characters to generate a file name should not exceed 7 "
        echo "       Erroneous argument №5: $character_for_file "
        error_target=1
    elif [[ $character_for_name_file =~ $ALPHABET ]]
    then
        if [[ $error_target == 1 ]];
        then
            echo
        fi
        echo "ERROR: Only Latin letters should be used to generate the file name "
        echo "       Erroneous argument №5: $character_for_file "
        error_target=1
    elif [[ ${#no_repeat_cheker_file_name} -ne ${#character_for_name_file} ]]
    then
        if [[ $error_target == 1 ]];
        then
            echo
        fi
        echo "ERROR: The letters for generating file names should not be repeated "
        echo "       Erroneous argument №5: $character_for_file "
        echo "       Erroneous argument №5: $character_for_file "
        error_target=1
    fi

    if [ ${#character_for_expansion_file} -gt 3 ]
    then
        if [[ $error_target == 1 ]];
        then
            echo
        fi
        echo "ERROR: The number of characters to generate a file expansion should not exceed 3 "
        echo "       Erroneous argument №5: $character_for_file "
        error_target=1
    elif [[ $character_for_expansion_file =~ $ALPHABET ]]
    then
        if [[ $error_target == 1 ]];
        then
            echo
        fi
        echo "ERROR: Only Latin letters should be used to generate the file expansion "
        echo "       Erroneous argument №5: $character_for_file "
        error_target=1
    elif [[ ${#no_repeat_cheker_file_expansion} -ne ${#character_for_expansion_file} ]]
    then
        if [[ $error_target == 1 ]];
        then
            echo
        fi
        echo "ERROR: The letters for generating file expansion should not be repeated "
        echo "       Erroneous argument №5: $character_for_file "
        error_target=1
    fi
fi

size_file=$6
size_num_files=${size_file%kb*}
if [[ $size_num_files =~ $NUMBER || ! $size_file == *kb ]]; 
then
    if [[ $error_target == 1 ]];
    then
        echo
    fi
    echo "ERROR: The file size should be described by the number and signature kb after. "
    echo "       Erroneous argument №6: $size_file "
    error_target=1
elif [ $size_num_files -gt 100 ]; 
then
    if [[ $error_target == 1 ]];
    then
        echo
    fi
    echo "ERROR: The amount of memory for the file should not exceed 100 kb "
    echo "       Erroneous argument №6: $size_file "
    error_target=1
fi

if [[ $error_target != 1 ]];
then
    /bin/touch "logger.log"
    data="_$(/bin/date +"%d%m%y")"
    for (( i=1; i<=${number_of_subfolders}; i++ )) do
        avail_size=$(/bin/df -k / | /bin/grep /dev/mapper/ | /bin/awk '{print $4}')
        if [ $avail_size -le 1048576 ]; then
            echo "Error: Not enough memory"
            break
        fi
        name_dir="$(/bin/bash gen.sh $character_for_name_dir $i)"
        /bin/mkdir "${path}${name_dir}${data}"
        echo -e "${path}${name_dir}${data}/\t\t\t\t\t$(/bin/date +"%d.%m.%y")" >> logger.log
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
fi