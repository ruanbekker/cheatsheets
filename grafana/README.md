# Grafana Cheatsheet

- [Dashboards](#dashboards)
- [Tutorials](#tutorials)
- [CloudWatch](#datasource-cloudwatch)
  - [CloudWatch Datasource](#datasource-cloudwatch)
  - [CloudWatch Variables](#variables-for-cloudWatch)
- [Elasticsearch]()
  - [Elasticsearch Datasource](#datasource-elasticsearch)
  - [Elasticsearch Variables](#variables-for-elasticsearch)
- [MySQL]()
  - [MySQL Datasource](#datasource-mysql)
  - [MySQL Variables](#variables-for-mysql)
  - [MySQL Queries](#mysql-queries)
- [Prometheus](#prometheus-datasource)
  - [Prometheus Datasource](#prometheus-datasource)
  - [Prometheus Variables](#prometheus-variables)
  - [Prometheus Queries](#prometheus-queries)


## Dashboards

- [Loki](https://grafana.com/grafana/dashboards/12019)
- [JVM Micrometer](https://grafana.com/grafana/dashboards/4701)

## Tutorials

- [sbcode](https://sbcode.net/grafana/)

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

## Datasource: Elasticsearch

- [how-to-effectively-use-the-elasticsearch-data-source-in-grafana-and-solutions-to-common-pitfalls/](https://grafana.com/blog/2016/03/09/how-to-effectively-use-the-elasticsearch-data-source-in-grafana-and-solutions-to-common-pitfalls/)

### Variables for Elasticsearch

Domain Name:

```
{"find": "terms", "field": "domain_name.keyword"}
```

Domain Name (Filtered Results):

```
{"find": "terms", "field": "domain_name.keyword", "query": "domain_name: *.mydomain.com"}
```

2 Variables, ALB and Domain Name (domain name results filtered based on the alb that you select / should be in correct order):

```
alb_name:
{"find": "terms", "field": "alb_name.keyword"}

domain_name:
{"find": "terms", "field": "domain_name.keyword", "query": "domain_name: *.mydomain.com AND alb_name:$alb_name.keyword"}
```

## Datasource: MySQL

### Variables for MySQL 

Name: `status`
Label: `Status`
Type: `Query`
Datasource: `MySQL`
Query: `SELECT status FROM mytable`

To use a regex to filter out any NULLs:

```
# this will only return results with letters/numbers
/([a-zA-Z0-9\.]+)/  
```

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

## Prometheus: Datasource

### Variables for Prometheus

**Basics**

Lets say you want to have a variable defined `jobs` and the metric looks like:

```
up{cluster_name="cluster-a",instance="1.1.1.1:443",job="container-metrics"}
up{cluster_name="cluster-b=",instance="1.1.1.1:443",job="node-metrics"}
```

Add a variable with the following:

```
Name: jobs
Label: Jobs
Query: label_values(up, job)
```

Which will produce `container-metrics` and `node-metrics` and in your dasboard query you can select them using:

```
up{job=~"$job"}
```

**Filtered**

Lets say you only want the variable results to display jobs from `cluster-b` and call it `cluster_b_jobs`:

```
label: cluster_b_jobs
label_values(up{cluster_name="cluster-b"}, job)
```

Now we can also use that variable for something else to filter more, like `label_values(metric{jobs=~"$cluster_b_jobs"}, some_label)`

You can use this to get environments, then filter on resources as example.

**Regex**

Let's say you have the following results for jobs:

```
qa/nginx
qa/app
qa/app-syslog
qa/app-deploy
prod/app
prod/app-syslog
prod/app-deploy
```

and you only want to display {env}/app,

The query: 
```
label_values(labels, job)
```

The regex: 

```
/^(.*app)/
```

which results in:

```
qa/app
prod/app
```

If you wanted everything after the `/`:

```
/.*(.*app.*).*/
```

which will result in:

```
app
app-syslog 
app-deploy
```

For a example where you want to return everything up until the numbers, example:

```
ecs-prod-app-10-container-12345
ecs-dev-app-12-container-12345
```

you can use:

```
/^(.*?)-[0-9]/
```

which will result in:

```
ecs-prod-app
ecs-dev-app
```

### Queries for Prometheus
