#!/bin/bash

path=$1
num_subfolders=$2
folder_chars=$3
num_files=$4
file_chars=$5
file_size_kb=$6

# Function to create folder or exit if free space is less than 1GB
check_free_space() {
  free_space=$(df -k --output=avail "$path" | tail -n 1)
  if (( free_space < 1048576 )); then
    echo "Error: Not enough free space."
    exit 1
  fi
}

# Function to generate unique random names
generate_random_name() {
  local length=$1
  local chars=$2
  local name=""
  while (( ${#name} < $length )); do
    char=${chars:$(( RANDOM % ${#chars} )):1}
    if [[ $name != *"$char"* ]]; then
      name+=$char
    fi
  done
  echo "$name"
}

# Create log file
log_file="script_log.txt"
echo "Log File: $log_file"

# Perform checks and create folders and files
check_free_space

for (( i=1; i<=num_subfolders; i++ )); do
  subfolder_name=$(generate_random_name 4 "$folder_chars")
  subfolder_path="$path/$subfolder_name$(date +%d%m%y)"
  mkdir "$subfolder_path"
  
  echo "$(date +%Y-%m-%d_%H:%M:%S) Folder Created: $subfolder_path" >> "$log_file"
  
  for (( j=1; j<=num_files; j++ )); do
    file_name=$(generate_random_name 7 "$file_chars")
    file_ext=$(generate_random_name 3 "$file_chars")
    file_path="$subfolder_path/$file_name$(date +%d%m%y).$file_ext"
    dd if=/dev/zero of="$file_path" bs=1k count=$file_size_kb
  
    echo "$(date +%Y-%m-%d_%H:%M:%S) File Created: $file_path (Size: ${file_size_kb}KB)" >> "$log_file"
  
    check_free_space
  done
done

echo "Script execution completed."