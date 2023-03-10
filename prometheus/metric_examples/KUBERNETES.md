# kubernetes-prometheus-metrics

### KubePodCrashLooping

Pod is restarting x amount of times / 5 minutes.

```
rate(kube_pod_container_status_restarts_total{job="kube-state-metrics",namespace=~".*"}[15m]) * 60 * 5 > 0
```

And to manipulate the message:

```
Pod {{ $labels.namespace }} / {{ $labels.pod }} ({{ $labels.container }}) is restarting {{ printf "%.2f" $value }} times / 5 minutes.
```
