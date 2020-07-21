# Grafana Cheatsheet

- [Datasources]
  - [CloudWatch]()
  - [MySQL]()


## Datasource: CloudWatch

### Variables for CloudWatch

Docs: 

- https://grafana.com/docs/grafana/latest/features/datasources/cloudwatch/

Overview:

The `Name` field allows you to use it as a variable, example:

```
Name: region
Type: Query
Label: Region
Query: regions()
```

Will show as Region in grafana, and you will be able to use a variable `$region` to select the value from the `Region` selector.

AWS Regions:

```
Query: regions()
```

AutoScaling Group:

```
Query: dimension_values($region,AWS/EC2,CPUUtilization,AutoScalingGroupName)
```

EC2 InstanceId from Tag Name:

```
Query: ec2_instance_attribute(eu-west-1, InstanceId, {"tag:ASG":["my-app-asg"]}) 
```

EBS VolumeId from InstanceId:

```
Query: ebs_volume_ids($region, $instanceid)
```

ECS Cluster Name:

```
Query: dimension_values($region,AWS/ECS,CPUUtilization,ClusterName)
```

ECS Service Name:

```
Query: dimension_values($region,AWS/ECS,CPUUtilization,ServiceName)
```

RDS Cluster Name:

```
Query: dimension_values($region,AWS/RDS,CPUUtilization,DBClusterIdentifier)
```

RDS Instance Name:

```
Query: dimension_values($region,AWS/RDS,CPUUtilization,DBInstanceIdentifier)
```

## Datasource: MySQL

### Variables for MySQL 

Name: `status`
Label: `Status`
Type: `Query`
Datasource: `MySQL`
Query: `SELECT status FROM mytable`

### Queries for MySQL

Gauge:

```
SELECT 
country,
SUM(cnt) AS total,
NOW() AS time
FROM mytable
WHERE status = ${status}
GROUP BY country
```

Bar Gauge:

```
SELECT NOW() AS time, count(*) as cnt, CONCAT(name,', ',surname,', ',country) AS entity FROM mytable 
WHERE status = "PENDING"
AND name REGEXP '${name:pipe}' 
AND surname REGEXP '${surname:pipe}'
AND country REGEXP '${country:pipe}'
GROUP BY CONCAT(name,', ',surname,', ',country)
```

Table Panel:

```
SELECT name, surname, country, status, pending_time from mytable
WHERE status = "PENDING"
AND name REGEXP '${name:pipe}' 
AND surname REGEXP '${surname:pipe}'
AND country REGEXP '${country:pipe}'
```
