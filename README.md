AIX load
=======================================================
Retrive AIX performance information from remote servers.

Usage: `aix_load "hostname"`

Examples:

 For single server: `aix_load sdp7a`
 For multiple servers: `aix_load sdp`

Legend:

 * HOST - Server hostname

 * EXEC TIME - Server local time, when performance information was requested

 * HW TYPE - Server hardware type

 * THREADS - Number of virtual processors (CPU threads). Used for max IOWAIT and RUNQ cacluation

 * RUNQ - Shows the number of tasks executing and waiting for CPU resources. When this number exceeds the number of THREADS on the server - a CPU bottleneck exists

 * BLKQ - Shows the number of tasks blocked to execution. If this value is higher then 2 and RUNQ is high - you probably have problems

 * CPU IDLE - Server CPU idle cycles (Higher is better)

 * CPU USER - Server CPU users cycles (Lower is better)

 * CPU SYSTEM - Server CPU system cycles (Lower is better)

 * COMP RAM - Percentage of Server computational RAM (MAX alloved - 90)

 * IOWAIT - Percentage of time the CPU is idle AND there is, at least, one I/O in progress. Depends from performance of server's storage. Iowait more 25 - system is probably IO bound

 * IS DISK LOAD - Indicates current Server disks load status (Should be NO)

 LOADED DISKS - Server most loaded discs. Shows diskname and tm_act percentage. Percent of time the device was active (we can see if disk load is balanced correctly or not, 1 used heavily others - not. 100 means disks always was busy when requested statistics. On some SDPs it can reach 260, bue to mirriring configuration.)


 Execution example:
 ------------------
``
CELCO:[root@upm1 scripts]# aix_load sdp
HOST |EXEC TIME|HW TYPE|THREADS|RUNQ|BLKQ|CPU IDLE|CPU USER|CPU SYSTEM|COMP RAM|IOWAIT|IS DISK LOAD|LOADED DISKS                  
sdp1 |17:18:28 |POWER5 |16     |8   |1   |43      |41      |13        |74.8    |2.5   |NO          |NO LOADED DISKS               
sdp2 |17:18:31 |POWER7 |32     |5   |1   |49      |34      |12        |72.3    |1.8   |NO          |NO LOADED DISKS               
sdp3 |17:18:33 |POWER7 |32     |8   |1   |42      |40      |15        |75.0    |3.1   |NO          |NO LOADED DISKS               
sdp4 |17:18:35 |POWER5 |16     |5   |1   |30      |54      |14        |59.2    |1.0   |NO          |NO LOADED DISKS               
sdp5 |17:18:37 |POWER5 |16     |7   |1   |60      |28      |7         |71.4    |3.5   |NO          |NO LOADED DISKS               
sdp6 |17:18:41 |POWER5 |16     |7   |1   |47      |38      |13        |62.1    |2.8   |DISKS LOAD  |hdisk28 100.0,hdisk29 95.0,hdisk73 94.7,hdisk72 100.0,
sdp7 |17:18:43 |POWER5 |16     |7   |1   |55      |32      |7         |72.6    |4.9   |NO          |NO LOADED DISKS               
sdp8 |17:18:47 |POWER7 |32     |6   |1   |60      |27      |8         |72.8    |1.7   |NO          |NO LOADED DISKS 
CELCO:[root@upm1 scripts]# 
``