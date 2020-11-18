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

## Describe ECS Task States

Check if the deployment info has accepted the new deployment:

```
$ aws --profile default ecs describe-services --cluster $cluster_name --services $service_name | jq -r '.services[].deployments'
```

If not, get the latest event info:

```
$ aws --profile default ecs describe-services --cluster $cluster_name --services $service_name | jq -r '.services[].events[0]'
```

Grab the task id and describe the info to get the last know status:

```
$ aws --profile default ecs describe-tasks --tasks 00000000-0000-0000-0000-000000000000 --cluster $cluster_name  | jq -r '.tasks[].lastStatus'
STOPPED
```

Get the stop code:

```
$ aws --profile default ecs describe-tasks --tasks 00000000-0000-0000-0000-000000000000 --cluster $cluster_name   | jq -r '.tasks[].stopCode'
TaskFailedToStart
```

Get the stop reason:

```
$ aws --profile default ecs describe-tasks --tasks 00000000-0000-0000-0000-000000000000 --cluster $cluster_name   | jq -r '.tasks[].stoppedReason'
Fetching secret data from SSM Parameter Store in eu-west-1: invalid parameters: /demo/dev/MY_INVALID_PARAMETER
```

## Create ECS Service

Create a ECS Service and specifying a Capacity Provider:

```
$ aws --profile default ecs create-service --cluster $cluster_name --service-name $service_name --task-definition mytaskdef:1 --desired-count 1 --scheduling-strategy "REPLICA" --capacity-provider-strategy='[{"capacityProvider": "ondemand-capacity","weight": 0, "base": 1},{"capacityProvider": "spot-capacity", "weight": 100, "base": 0}]'
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

Update ECS Service to use Capacity Providers:

```
$ aws --profile default ecs update-service --cluster $cluster_name --service $service_name --capacity-provider-strategy='[{"capacityProvider": "ondemand-capacity", "weight": 0, "base": 1},{"capacityProvider": "spot-capacity", "weight": 100, "base": 0}]' --force-new-deployment
```
