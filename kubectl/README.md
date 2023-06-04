# kubectl cheatsheet

## Table of Contents

- [Secrets](#secrets)
  - [Create Secret from File](#create-secret-from-file)
  - [Create Secret from Literals](#create-secret-from-literals)

## Secrets

### Create Secret from File

Create two files with the username and password:

```bash
echo -n 'admin' > ./username.txt
echo -n '1f2d1e2e67df' > ./password.txt
```

Create the secret:

```bash
kubectl create secret generic db-secrets --from-file=admin-user=./username.txt --from-file=password=./password.txt
```

### Create Secret from Literals

Create the secret by specifying the values in the command:

```bash
kubectl create secret generic db-secrets --from-literal=admin-user=admin --from-literal=password='1f2d1e2e67df'
```
