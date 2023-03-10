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

### KubeContainerWaiting

Pod `{{ $labels.namespace }}` / `{{ $labels.pod }}` container `{{ $labels.container }}` has been in waiting state for longer than 1 hour.

```
sum by(namespace, pod, container) (kube_pod_container_status_waiting_reason{job="kube-state-metrics",namespace=~".*"}) > 0
```

### KubeDeploymentReplicasMismatch

Deployment `{{ $labels.namespace }}`/`{{ $labels.deployment }}` has not matched the expected number of replicas for longer than 15 minutes.

```
(kube_deployment_spec_replicas{job="kube-state-metrics",namespace=~".*"} != kube_deployment_status_replicas_available{job="kube-state-metrics",namespace=~".*"}) and (changes(kube_deployment_status_replicas_updated{job="kube-state-metrics",namespace=~".*"}[5m]) == 0)
```

### KubeStatefulSetReplicasMismatch

StatefulSet `{{ $labels.namespace }}` / `{{ $labels.statefulset }}` has not matched the expected number of replicas for longer than 15 minutes.

```
(kube_statefulset_status_replicas_ready{job="kube-state-metrics",namespace=~".*"} != kube_statefulset_status_replicas{job="kube-state-metrics",namespace=~".*"}) and (changes(kube_statefulset_status_replicas_updated{job="kube-state-metrics",namespace=~".*"}[5m]) == 0)
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
