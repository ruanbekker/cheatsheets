# ECR CLI Cheatsheet

## Docker Login Token

Get the docker login token:

```
$(aws --profile dev ecr get-login --region eu-west-1 --no-include-email | tr -d '\r')
```

One liner to login:

```
$ aws --profile prod ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.eu-west-1.amazonaws.com
```

## Create Repository

Create a ECR Repository:

```
$ aws --profile dev ecr create-repository --repository-name my-ecr-repo
```

## Lifecycle Policy

To keep the last 5 tags of the following prefixes:
- dev-*
- staging-*
- production-*

And then to keep the last 10 untagged images, we can use a policy:

```json
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 5 production images",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["production-"],
        "countType": "imageCountMoreThan",
        "countNumber": 5
      },
      "action": { "type": "expire" }
    },
    {
      "rulePriority": 2,
      "description": "Keep last 5 staging images",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["staging-"],
        "countType": "imageCountMoreThan",
        "countNumber": 5
      },
      "action": { "type": "expire" }
    },
    {
      "rulePriority": 3,
      "description": "Keep last 5 sandbox images",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["dev-"],
        "countType": "imageCountMoreThan",
        "countNumber": 5
      },
      "action": { "type": "expire" }
    },
    {
      "rulePriority": 4,
      "description": "Keep last 10 untagged images",
      "selection": {
        "tagStatus": "untagged",
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": { "type": "expire" }
    }
  ]
}
```

To apply this policy to your ECR repository, define the policy:

```bash
LIFECYCLE_POLICY_TEXT='{"rules": [{"rulePriority": 1, "description": "Keep last 5 production images", "selection": {"tagStatus": "tagged", "tagPrefixList": ["production-"], "countType": "imageCountMoreThan","countNumber": 5}, "action": {"type": "expire"}}, {"rulePriority": 2, "description": "Keep last 5 staging images", "selection": {"tagStatus": "tagged", "tagPrefixList": ["staging-"], "countType": "imageCountMoreThan", "countNumber": 5}, "action": {"type": "expire"}}, {"rulePriority": 3, "description": "Keep last 5 dev images", "selection": {"tagStatus": "tagged", "tagPrefixList": ["dev-"],"countType": "imageCountMoreThan", "countNumber": 5}, "action": {"type": "expire"}}, {"rulePriority": 4, "description": "Keep last 10 untagged images", "selection": {"tagStatus": "untagged", "countType": "imageCountMoreThan","countNumber": 10}, "action": {"type": "expire"}}]}'
```

Then apply the policy:

```bash
aws ecr put-lifecycle-policy --registry-id <your-aws-account-id> --repository-name your-ecr-repo-name --lifecycle-policy-text $LIFECYCLE_POLICY_TEXT
```
