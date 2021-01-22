# ECR CLI Cheatsheet

## Docker Login Token

Get the docker login token:

```
$(aws --profile dev ecr get-login --region eu-west-1 --no-include-email | tr -d '\r')
```

## Create Repository

Create a ECR Repository:

```
$ aws --profile dev ecr create-repository --repository-name my-ecr-repo
```
