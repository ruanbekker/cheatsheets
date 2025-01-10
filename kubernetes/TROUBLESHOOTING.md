# Kubernetes Troubleshooting

## Daemonset not running on all nodes

1. Describe the daemonset and check:
   - Events
   - Selectors, Node-Selectors and Tolerations
3. Identify the nodes that the pods are not running in:
   - `kubectl get pods -A --field-selector spec.nodeName=ip-10-254-1-20`
4. Describe the node where the pods are not running for Taints:
   - `kubectl describe node ip-10-254-1-20| grep Taints`
   - if you see something like `Taints: application=monitoring:NoSchedule` you need to add tolerations to the daemonset:

```yaml
tolerations:
  - key: "application"
    operator: "Equal"
    value: "monitoring"
    effect: "NoSchedule"
```
