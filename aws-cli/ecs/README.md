# AWS CLI ECS Cheatsheet

## Register Task Definitions

```
$ aws --profile default ecs register-task-definition --cli-input-json file://taskdef.json
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

