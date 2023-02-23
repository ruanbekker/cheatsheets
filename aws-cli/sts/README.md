# sts cheatsheet

## Caller Identity

```bash
aws --profile default sts get-caller-identity
```

## Assume Role

Get temporary credentials:

```bash
aws --profile default sts assume-role \
    --role-arn arn:aws:iam::000000000000:role/my-aws-role \
    --role-session-name my-aws-role \
    --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
    --output text
```

One liner to export to environment:

```bash
export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" $(aws --profile default sts assume-role --role-arn arn:aws:iam::000000000000:role/my-aws-role --role-session-name my-aws-role --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" --output text))
```
