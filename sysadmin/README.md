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

Get memory stats:

```
$ wget https://raw.githubusercontent.com/pixelb/ps_mem/master/ps_mem.py
$ sudo python ps_mem.py
```

### External Resources

- https://www.tummy.com/articles/isolating-heavy-load/
- https://bobcares.com/blog/high-cpu-utilization/
- https://coderwall.com/p/utc42q/understanding-iostat
- https://www.techrepublic.com/article/how-to-use-the-linux-iostat-command-to-check-on-your-storage-subsystem/
