# AWS CLI ECS Cheatsheet

## Register Task Definitions

```
$ aws --profile default ecs register-task-definition --cli-input-json file://taskdef.json
```

## List ECS Clusters

List ECS Clusters for a given profile:

```
$ aws --profile default ecs list-clusters
```

## List ECS Services

List ECS Services for a given ECS Cluster:

```
$ aws --profile default ecs list-services --cluster $cluster_name
```

## Describe ECS Service

Get the running count of containers for a given service:

```
$ aws --profile default ecs describe-services --cluster $cluster_name --services $service_name | jq -r '.services[].runningCount'
```

Get the task definition revision for a given service:

```
$ aws --profile default ecs describe-services --cluster $cluster_name --services $service_name | jq -r '.services[].taskDefinition'
```

## Update ECS Service

Update ECS Service to the latest task definition revision:

```
$ aws --profile default ecs update-service --cluster $cluster_name --service $service_name --task-definition $task_def
```

Update ECS Service to 3 replicas:

```
$ aws --profile default ecs update-service --cluster $cluster_name --service $service_name --desired-count 3
```

