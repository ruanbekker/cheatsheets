# Kubernetes Troubleshooting

## Daemonset not running on all nodes

1. Describe the daemonset and check:
  1.1 Events
  1.2 Selectors, Node-Selectors and Tolerations
2. Identify the nodes that the pods are not running in:
  2.1 `kubectl get pods -A --field-selector spec.nodeName=ip-10-254-1-20`
3. Describe the node where the pods are not running for Taints:
  3.1 `kubectl describe node ip-10-254-1-20| grep Taints`
  3.2 if you see something like `Taints: application=monitoring:NoSchedule` you need to add tolerations to the daemonset:

```yaml
tolerations:
  - key: "application"
    operator: "Equal"
    value: "monitoring"
    effect: "NoSchedule"
```
