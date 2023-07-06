#!/bin/bash

function scrape_cpu {
    echo "# HELP cpu_used_in_percent The total CPU used as percent value" >> metrics.html
    echo "# TYPE cpu_used_in_percent gauge" >> metrics.html	
    echo "cpu_used_in_percent $(ps -eo pcpu | awk '{s+=$1} END {print s}')" >> metrics.html
}

function scrape_free_hd_space {
    echo "# HELP free_hd_space_in_bytes The total number of bytes free in home directory" >> metrics.html
    echo "# TYPE free_hd_space_in_bytes gauge" >> metrics.html
    echo "free_hd_space_in_bytes $(df -B1 /home | awk 'NR==2{print $4}')" >> metrics.html
}

function scrape_free_mem {
    echo "# HELP free_mem_in_bytes The free RAM left in bytes" >> metrics.html
    echo "# TYPE free_mem_in_bytes gauge" >> metrics.html
    echo "free_mem_in_bytesx$(free -b | awk 'NR==2{print $4}')" >> metrics.html
}

if [ $# != 0 ]; then
	echo "Script takes no arguments"
	exit 1
else
	while true; do
		scrape_cpu
		scrape_free_hd_space
		scrape_free_mem
		sleep 3;
	done
fi