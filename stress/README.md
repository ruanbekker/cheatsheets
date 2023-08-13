# stress cheatsheet

CLI tool to cause stress to a operating system

## Installation and Usage

Installation:

```bash
$ sudo apt install stress -y
```

Usage:

```
$ stress --cpu 8 --io 4 --vm 4 --vm-bytes 1024M --timeout 10s
```

## Stress-ng

Installation:

```bash
sudo apt install stress-ng -y
```

Use `stress-ng` to simulate CPU load:

```bash
# This command will stress all available CPUs for 60 seconds, you can adjust the --cpu parameter to match the number of CPU cores you want to stress
stress-ng --cpu 4 --timeout 60s
```

Use `stress-ng` to simulate memory load:

```bash
# This command will allocate 2 virtual machines each with 1GB of memory for 60 seconds, you can adjust the --vm and --vm-bytes parameters to control the memory stress
stress-ng --vm 2 --vm-bytes 1G --timeout 60s
```

Use `dd` to simulate I/O load:

```bash
# This command will create a 1GB test file filled with zeros in /tmp while synchronizing data to the disk, this will put stress on the I/O subsystem
dd if=/dev/zero of=/tmp/testfile bs=1M count=1024 conv=fdatasync
```
