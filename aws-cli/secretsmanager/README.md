# aws secretsmanager

## View Secret by Secret Name

```bash
aws --profile default secretsmanager get-secret-value --secret-id my-db-secret --query SecretString --output text
```
