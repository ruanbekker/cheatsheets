## Grafana Cheatsheet

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
