# kubernetes-prometheus-metrics

### CPUThrottlingHigh

```
sum by(container, pod, namespace) (increase(container_cpu_cfs_throttled_periods_total{container!=""}[5m])) / sum by(container, pod, namespace) (increase(container_cpu_cfs_periods_total[5m])) > (25 / 100)
```

### KubeAPIDown

KubeAPI has disappeared from Prometheus target discovery.

```
absent(up{job="apiserver"} == 1)
```

### KubeletDown

Kubelet has disappeared from Prometheus target discovery.

```
absent(up{job="kubelet"} == 1)
```

### KubePodCrashLooping

Pod is restarting x amount of times / 5 minutes.

```
rate(kube_pod_container_status_restarts_total{job="kube-state-metrics",namespace=~".*"}[15m]) * 60 * 5 > 0
```

And to manipulate the message:

```
Pod {{ $labels.namespace }} / {{ $labels.pod }} ({{ $labels.container }}) is restarting {{ printf "%.2f" $value }} times / 5 minutes.
```

### PrometheusDown

Prometheus has disappeared from Prometheus target discovery.

```
absent(up{job="prometheus-operator-prometheus",namespace="monitoring"} == 1)
```
