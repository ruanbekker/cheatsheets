# etcdctl cheatsheet

## deployment

Deploy with kubernetes:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install apisix-etcd bitnami/etcd --set auth.rbac.create=False --set replicaCount=3 --namespace kube-system
```

To create a pod that you can use as a etcd client run the following command:

```bash
kubectl run apisix-etcd-client --restart='Never' --image docker.io/bitnami/etcd:3.5.9-debian-11-r146 --env ETCDCTL_ENDPOINTS="apisix-etcd.kube-system.svc.cluster.local:2379" --namespace kube-system --command -- sleep infinity
```

Exec into the client pod:

```bash
kubectl exec --namespace kube-system -it apisix-etcd-client -- bash
```

## commands

List members:

```bash
etcdctl member list --write-out=table
```

Write a value to a key:

```bash
etcdctl  put /message Hello
```

View a key's value:

```bash
etcdctl  get /message
```

Same as above, but only view the value:

```bash
etcdctl get /message --print-value-only
```

View all the keys:

```bash
etcdctl get "" --prefix --keys-only
```

View the key and values:

```bash
etcdctl get "" --prefix
```

Return the value only

## resources

More cheatsheets:
- https://lzone.de/cheat-sheet/etcd
