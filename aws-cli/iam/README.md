## AWS CLI / IAM Cheatsheet

View Policy ARN:

```
$ aws --profile dev iam list-attached-user-policies --user my-policy | jq -r '.AttachedPolicies[].PolicyArn'
arn:aws:iam::000000000000:policy/my-policy
```

Detach Role Policy and Delete Role:

```
export iam_profile=dev
export role_name=MyRole
export role_arn=arn:aws:iam::aws:policy/ReadOnlyAccessX

aws --profile ${iam_profile} iam detach-role-policy --role-name ${role_name} --policy-arn ${role_arn}
aws --profile ${iam_profile} iam delete-role --role-name ${role_name}
```
