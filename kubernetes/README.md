### Nodes

Show nodes in the cluster:

```
kubectl get nodes
```

Show nodes with extra info:

```
kubectl get nodes -o wide
```

Show nodes in yaml format:

```
kubectl get nodes -o yaml
```

### Pods

Show pods:

```
kubectl get pods
```

Show pods from all namespaces:

```
kubectl get pods --all-namespaces
```

Show pods in yaml format:

```
kubectl get pods --output yaml
```

Show pods and dont truncate the output:

```
kubectl get pods -o wide
```

Show pods with their labels:

```
kubectl get pods --show-labels
```

Show pods from a specific deployment:

```
kubectl get pods --output wide --selector app.kubernetes.io/name=my-test-app
```

Show pods on specific node:

```
kubectl get pods -o wide --field-selector spec.nodeName="ip-10-0-1-20.eu-west-1.compute.internal"
```

Show pods, sort output by node:

```
kubectl get pods -o wide --sort-by="{.spec.nodeName}"
```

Show pods, sort output by restarts:

```
kubectl get pods --sort-by="{.status.containerStatuses[:1].restartCount}"
```

### Resources:

Kubectl Output Formatting:
- https://gist.github.com/so0k/42313dbb3b547a0f51a547bb968696ba

Kubernetes Cheatsheet:
- https://kubernetes.io/docs/reference/kubectl/cheatsheet/
