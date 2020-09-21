# Node Metrics

Examples for Prometheus focused on Node Level Metrics.

## CPU

CPU Utilization:

```
100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle", instance="my-instance-name"}[5m])) * 100) 
```

## Memory

Memory Available in %:

```
node_memory_MemAvailable_bytes{instance="my-instance-name"} / node_memory_MemTotal_bytes{instance="my-instance-name"} * 100
```

Memory Pressure:

```
rate(node_vmstat_pgmajfault{instance="my-instance-name"}[1m])
```

## Disk

Disk Space Available in bytes:

```
node_filesystem_avail_bytes{instance=~"my-ec2-instance",job=~"node-exporter",mountpoint="/"}
```

Disk Space Available in Percentage:

```
(node_filesystem_avail_bytes{mountpoint="/", instance=~"my-ec2-instance"}  * 100) / node_filesystem_size_bytes{mountpoint="/", instance=~"my-ec2-instance"} 
```

Disk Latencies:

```
rate(node_disk_read_time_seconds_total{instance="my-instance-name"}[1m]) / rate(node_disk_reads_completed_total{instance="my-instance-name"}[1m])
rate(node_disk_write_time_seconds_total{instance="my-instance-name"}[1m]) / rate(node_disk_writes_completed_total{instance="my-instance-name"}[1m])
```

## Network

Network Trhoughput

```
irate(node_network_receive_bytes_total{instance="my-instance-name"}[5m]) * 8
irate(node_network_transmit_bytes_total{instance="my-instance-name}[5m]) * 8
```

## Uptime

Node Uptime:

```
node_time_seconds{instance="my-ec2-instance",job="node-exporter"} - node_boot_time_seconds{instance="my-ec2-instance",job="node-exporter"}
```
