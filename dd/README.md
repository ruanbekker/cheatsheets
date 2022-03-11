# dd cheatshet

## Create Files

To create a 1GB file:

```bash
$ dd if=/dev/zero of=1g.bin bs=1G count=1
```

## Benchmarking

Server Throughput (Streaming I/O):

```bash
$ dd if=/dev/zero of=/root/testfile bs=1G count=1 oflag=dsync
```

Server Latency:

```bash
$ dd if=/dev/zero of=/root/testfile bs=512 count=1000 oflag=dsync
```
