#!/bin/bash
# Philipp Shilov 2018 
# v0.1 05.01.2018
if [ ! -n "$1" ]; then printf "\nRetrive AIX performance information from remote servers.\n\nUsage: aix_load \042hostname\042 \n\nExamples: \n\n For single server: aix_load sdp7 \n For multiple servers: aix_load sdp \n\nLegend:\n\n HOST - Server hostname.\n\n EXEC TIME - Server local time, when performance information was requested.\n\n HW TYPE - Server hardware type.\n\n THREADS - Number of virtual processors (CPU threads). Used for max IOWAIT and RUNQ cacluation.\n\n RUNQ - Shows the number of tasks executing and waiting for CPU resources. When this number exceeds the number of THREADS on the server - a CPU bottleneck exists.\n\n BLKQ - Shows the number of tasks blocked to execution. If this value is higher then 2 and RUNQ is high - you probably have problems.\n\n CPU IDLE - Server CPU idle cycles (Higher is better).\n\n CPU USER - Server CPU users cycles (Lower is better).\n\n CPU SYSTEM - Server CPU system cycles (Lower is better).\n\n COMP RAM - Percentage of Server computational RAM (MAX alloved - 90).\n\n IOWAIT - Percentage of time the CPU is idle AND there is, at least, one I/O in progress. Iowait more 25 - system is probably IO bound.\n\n IS DISK LOAD - Indicates current Server disks load status (Should be NO).\n\n LOADED DISKS - Server most loaded discs. Shows diskname and tm_act percentage. Percent of time the device was active (we can see if disk load is balanced correctly or not, 1 used heavily others not. 100 means disks always was busy when requested statistics. On some SDPs it can reach 260).\n\n"; exit; fi;
delat_krasivo=$1                #blkq                #comp
printf "%-5s|%-9s|%-7s|%-7s|%-4s|%-4s|%-8s|%-8s|%-10s|%-8s|%-6s|%-12s|%-30s\n" "HOST" "EXEC TIME" "HW TYPE" "THREADS" "RUNQ" "BLKQ" "CPU IDLE" "CPU USER" "CPU SYSTEM" "COMP RAM" "IOWAIT" "IS DISK LOAD" "LOADED DISKS";
for host in $(grep -iE $delat_krasivo /etc/hosts|grep -viE '^ *#|localhost|farm|nsr|cfs|persistent|blu|acmi|emc|v7000|om|hmc|fcs|emc|tape|asmi|admin|zbx|hsbu|mau|rctu'|awk {'print$2'}|sort|uniq | grep -v 'a' | grep -v 'b');
do ping -c1 -W1 $host 1>/dev/null && printf "%-5s|" "$host" && ssh $host "
sar 1 | tail -1 > /tmp/ny_cpu_monitor.txt
find /tmp -name 'prtconf.txt' -mtime +365 -exec rm {} \;
if [ ! -f /tmp/prtconf.txt ]; then prtconf > /tmp/prtconf.txt 2>/dev/null ; fi
hw_type=\`grep 'Processor Type:' /tmp/prtconf.txt| awk '{print \$3}'| tail -c 7 |tr -d '\n';\`
num_of_threads=\`vmstat | grep configuration | awk '{print substr (\$3,6)}'\`
runq=\`vmstat 1 1 | tail -1 | awk '{print \$1}'| tr -d '\n'\`
blockq=\`vmstat 1 1 | tail -1 | awk '{print \$2}'| tr -d '\n'\`
exec_time=\`cat /tmp/ny_cpu_monitor.txt| awk '{print \$1}'| tr -d '\n'\`
cpu_idle=\`cat /tmp/ny_cpu_monitor.txt| awk '{print \$5}'| tr -d '\n'\`
user_usage=\`cat /tmp/ny_cpu_monitor.txt| awk '{print \$2}'| tr -d '\n'\`
system_usage=\`cat /tmp/ny_cpu_monitor.txt| awk '{print \$3}'| tr -d '\n'\`
iowait=\`iostat | head -5 | tail -1 | awk '{print \$6}'| tr -d '\n'\`
comp_percent=\`vmstat -v | grep computational| awk '{print \$1}'| tr -d '\n'\`
loaded_disks=\`iostat -Dl | grep -v hdiskpower| awk '/hdisk/ && \$2 > 90 {print \$0}' | awk '{print \$1,\$2}'| tr '\n' ','\`
if [[ -z \$loaded_disks ]]; then loaded_disks=\`printf \"NO LOADED DISKS\"\`; disk_io_status=\`printf \"NO\"\`; else disk_io_status=\`printf \"DISKS LOAD\"\` ; fi
printf \"%-9s|%-7s|%-7s|%-4s|%-4s|%-8s|%-8s|%-10s|%-8s|%-6s|%-12s|%-30s\n\" \"\$exec_time\" \"\$hw_type\" \"\$num_of_threads\" \"\$runq\" \"\$blockq\" \"\$cpu_idle\" \"\$user_usage\" \"\$system_usage\" \"\$comp_percent\" \"\$iowait\" \"\$disk_io_status\" \"\$loaded_disks\";";done;
#thats all folks!