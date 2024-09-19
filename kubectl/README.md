# kubectl cheatsheet

## Table of Contents

- [Secrets](#secrets)
  - [Create Secret from File](#create-secret-from-file)
  - [Create Secret from Literals](#create-secret-from-literals)
  - [View Secrets](#view-secrets)
 
## External Resources

- [The guide to kubectl I never had](https://medium.com/@jake.page91/the-guide-to-kubectl-i-never-had-3874cc6074ff)

## Diffs

```bash
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl diff -f - -n kube-system
diff -u -N /tmp/LIVE-1353412465/v1.ConfigMap.kube-system.kube-proxy /tmp/MERGED-1463100091/v1.ConfigMap.kube-system.kube-proxy
--- /tmp/LIVE-1353412465/v1.ConfigMap.kube-system.kube-proxy    2023-10-03 23:00:21.016935582 +0000
+++ /tmp/MERGED-1463100091/v1.ConfigMap.kube-system.kube-proxy  2023-10-03 23:00:21.016935582 +0000
@@ -33,7 +33,7 @@
       excludeCIDRs: []
       minSyncPeriod: 0s
       scheduler: rr
-      strictARP: false
+      strictARP: true
       syncPeriod: 30s
       tcpFinTimeout: 0s
       tcpTimeout: 0s
```

## List Resources in a Namespace

To identify resources in a namespace:

```bash
kubectl api-resources --verbs=list --namespaced=true | awk '{ print $1 }' | xargs -n 1 kubectl get -n default
```

## Pods

View pods:

```bash
kubectl get pods -n monitoring
```

View pods by label selector:

```bash
kubectl get pods -n monitoring --selector 'app.kubernetes.io/name=promtail' -w -o wide
```

## Deployments

Rollout Restart:

```bash
kubectl rollout restart deployment/foo -n test
```

Status of Rollout Restart:

```bash
kubectl rollout status deployment foo -n test
```

## Manipulate Output

Display only the pod name with label selectors:

```bash
kubectl get pods -n gitea -o custom-columns=NAME:.metadata.name -l 'app=gitea' --no-headers
# gitea-69f6b67895-6hwq6
```

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

### View Secrets

You can use `jsonpath`:

```bash
kubectl get secret mongodb-operator-passwords -o yaml -o jsonpath='{.data.password}'
```

The value is encoded with `base64`, to decode it:

```bash
kubectl get secret mongodb-operator-passwords -o yaml -o jsonpath='{.data.password}' | base64 -d ; echo
```

You can use `jq` to view secrets

```bash
kubectl get secret mongodb-operator-passwords -o json | jq -r '.data | with_entries(.value |= @base64d)'
```
