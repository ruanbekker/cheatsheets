## SSM AWS CLI Cheatsheet

Put SSM Parameter:

```
$ aws --profile dev ssm put-parameter --type 'String' --name "/my-service/dev/DATABASE_NAME" --value "test"
```

Get SSM Parameters by Path:

```
$ aws --profile dev --region eu-west-1 ssm get-parameters-by-path --path '/my-service/dev/' | jq '.Parameters[]' | jq -r '.Name' 
/my-service/dev/DATABASE_HOST
/my-service/dev/DATABASE_NAME
```

Decrypt and View SSM Parameter Value:

```
$ aws --profile dev ssm get-parameters --names '/my-service/dev/DATABASE_NAME' --with-decryption | jq -r '.Parameters[]' | jq -r '.Value'
test
```
