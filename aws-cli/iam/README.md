## AWS CLI / IAM Cheatsheet

Detach Role Policy and Delete Role:

```
export iam_profile=dev
export role_name=MyRole
export role_arn=arn:aws:iam::aws:policy/ReadOnlyAccessX

aws --profile ${iam_profile} iam detach-role-policy --role-name ${role_name} --policy-arn ${role_arn}
aws --profile ${iam_profile} iam delete-role --role-name ${role_name}
```
