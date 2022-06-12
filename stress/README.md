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
