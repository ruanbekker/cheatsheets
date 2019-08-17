## InfluxDB Cheatsheet

### Connect to InfluxDB:

```
$ influx
```

### Create DB:

```
> create database test
```

###  List Databases:

```
> show databases
```

### Select a DB:

```
> use test
```

### List Measurements

```
> show measurements
```

### Show Measurements for name: bar

```
> select * from bar
```

### Drop bar Measurements

```
> drop measurement bar
```

### Show field keys

```
> show field keys from "bar-A1"
```
