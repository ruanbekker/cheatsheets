## Memory

* **Free** memory is the amount of memory which is currently not used for anything. This number should be small, because memory which is not used is simply wasted.

* **Available** memory is the amount of memory which is available for allocation to a new process or to existing processes.

### Memory Stats

Difference between vsz and rss:

```
The Virtual Set Size is a memory size assigned to a process ( program ) during the initial execution. The Virtual Set Size memory is simply a number of how much memory a process has available for its execution. 

As oppose to VSZ ( Virtual Set Size ), RSS is a memory currently used by a process. This is a actual number in kilobytes of how much RAM the current process is using. 
```

Using ps to sort by memory usage:

```
$ ps aux --sort -rss
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root      2124  0.1 11.4 422028 232864 ?       Ssl  Mar19   0:35 /bin/thanos
```

Using `/proc/meminfo`:

```
$ cat /proc/meminfo
MemTotal:       16424260 kB
MemFree:          173988 kB
MemAvailable:   13493104 kB
Buffers:          253116 kB
Cached:         12950152 kB
```

Using vmstat:

```
$ vmstat -s
16424260 K total memory
 2598624 K used memory
 3701676 K active memory
11821540 K inactive memory
  328008 K free memory
  253208 K buffer memory
  13244420 K swap cache
```

Using top:

```
$ top -n 1 -b
top - 07:50:06 up 13 days, 22:22,  1 user,  load average: 0.06, 0.07, 0.02
Tasks: 124 total,   1 running,  73 sleeping,   0 stopped,   0 zombie
%Cpu(s):  2.0 us,  0.4 sy,  0.0 ni, 97.3 id,  0.0 wa,  0.0 hi,  0.2 si,  0.0 st
KiB Mem : 16424260 total,   249368 free,  2597924 used, 13576968 buff/cache
KiB Swap:        0 total,        0 free,        0 used. 13490404 avail Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
15482 user      20   0 7949520 2.150g  24408 S  37.5 13.7  40:35.70 java
```

More info on above:

```
%MEM is directly related to RES, it’s the percentage use of total physical memory by the process.
VIRT is the total memory that this process has access to shared memory, mapped pages, swapped out pages, etc.
RES is the total physical memory used shared or private that the process has access to.
SHR is the total physical shared memory that the process has access to.
```

Get memory stats:

```
$ wget https://raw.githubusercontent.com/pixelb/ps_mem/master/ps_mem.py
$ sudo python ps_mem.py
```

## Permissions

### Permissions for Directories and Files

```
$ sudo chmod 755 /disk
$ sudo chown -R ubuntu:ubuntu /disk
$ sudo find /disk/2/htpc -type f -print -exec chmod 644 {} \;
$ sudo find /disk/2/htpc -type d -print -exec chmod 755 {} \;
```

### External Resources

- https://www.tummy.com/articles/isolating-heavy-load/
- https://bobcares.com/blog/high-cpu-utilization/
- https://coderwall.com/p/utc42q/understanding-iostat
- https://www.techrepublic.com/article/how-to-use-the-linux-iostat-command-to-check-on-your-storage-subsystem/
