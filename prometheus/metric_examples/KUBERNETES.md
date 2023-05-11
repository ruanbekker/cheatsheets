# kubernetes-prometheus-metrics

## Container Metrics

### CPUThrottlingHigh

`{{ $value | humanizePercentage }}` throttling of CPU in namespace `{{ $labels.namespace }}` for container `{{ $labels.container }}` in pod `{{ $labels.pod }}`.

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

### KubeAPIErrorsHigh

API server is returning errors for `{{ $value | humanizePercentage }}` of requests for `{{ $labels.verb }} {{ $labels.resource }} {{ $labels.subresource }}`.

```
sum by(resource, subresource, verb) (rate(apiserver_request_total{code=~"5..",job="apiserver"}[5m])) / sum by(resource, subresource, verb) (rate(apiserver_request_total{job="apiserver"}[5m])) > 0.1
```

### KubeAPILatencyHigh

The API server has an abnormal latency of `{{ $value }}` seconds for `{{ $labels.verb }} {{ $labels.resource }}`.

```
(cluster:apiserver_request_duration_seconds:mean5m{job="apiserver"} > on(verb) group_left() (avg by(verb) (cluster:apiserver_request_duration_seconds:mean5m{job="apiserver"} >= 0) + 2 * stddev by(verb) (cluster:apiserver_request_duration_seconds:mean5m{job="apiserver"} >= 0))) > on(verb) group_left() 1.2 * avg by(verb) (cluster:apiserver_request_duration_seconds:mean5m{job="apiserver"} >= 0) and on(verb, resource) cluster_quantile:apiserver_request_duration_seconds:histogram_quantile{job="apiserver",quantile="0.99"} > 1
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

### KubePersistentVolumeFillingUp

The PersistentVolume claimed by `{{ $labels.persistentvolumeclaim }}` in Namespace `{{ $labels.namespace }}` is only `{{ $value | humanizePercentage }}` free.

```
kubelet_volume_stats_available_bytes{job="kubelet",metrics_path="/metrics",namespace=~".*"} / kubelet_volume_stats_capacity_bytes{job="kubelet",metrics_path="/metrics",namespace=~".*"} < 0.03
```

### KubePersistentVolumeErrors

The persistent volume `{{ $labels.persistentvolume }}` has status `{{ $labels.phase }}`.

```
kube_persistentvolume_status_phase{job="kube-state-metrics",phase=~"Failed|Pending"} > 0
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

### PodNotRunning

```
sum by (pod)(kube_pod_status_ready{condition="true"} == 0)
```

### TotalRestartsForContainer

```
increase(kube_pod_container_status_restarts_total[1h])
# or
increase(kube_pod_container_status_restarts_total{namespace="my-namespace", pod=~".*prefix.*"}[1h])
```

### OomReasonForTermination

```
kube_pod_container_status_last_terminated_reason{reason="OOMKilled"}
# or
container_oom_events_total{name="container-name"}
# or
kube_pod_container_status_last_terminated_reason{reason="OOMKilled",namespace="my-namespace"}
```

### LessReplicasThanDesired

```
kube_deployment_status_replicas_available{namespace="my-namespace"} / kube_deployment_spec_replicas{namespace="my-namespace"}
```

### PrometheusDown

Prometheus has disappeared from Prometheus target discovery.

```
absent(up{job="prometheus-operator-prometheus",namespace="monitoring"} == 1)
```

## NodeMetrics

### NodeFilesystemSpaceFillingUp

Filesystem on `{{ $labels.device }}` at `{{ $labels.instance }}` has only `{{ printf "%.2f" $value }}%` available space left and is filling up.

```
(node_filesystem_avail_bytes{fstype!="",job="node-exporter"} / node_filesystem_size_bytes{fstype!="",job="node-exporter"} * 100 < 40 and predict_linear(node_filesystem_avail_bytes{fstype!="",job="node-exporter"}[6h], 24 * 60 * 60) < 0 and node_filesystem_readonly{fstype!="",job="node-exporter"} == 0)
```

### NodeFilesystemAlmostOutOfSpace

Filesystem on `{{ $labels.device }}` at `{{ $labels.instance }}` has only `{{ printf "%.2f" $value }}%` available space left.

```
(node_filesystem_avail_bytes{fstype!="",job="node-exporter"} / node_filesystem_size_bytes{fstype!="",job="node-exporter"} * 100 < 5 and node_filesystem_readonly{fstype!="",job="node-exporter"} == 0)
```

### NodeCPUHigh

```
100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle", instance=~"(.*)"}[5m])) * 100) * on(instance) group_left(nodename) node_uname_info{} > 80
```

### NodeMemoryHigh

```
100 * (1 - ((avg_over_time(node_memory_MemFree_bytes[10m]) + avg_over_time(node_memory_Cached_bytes[10m]) + avg_over_time(node_memory_Buffers_bytes[10m])) / avg_over_time(node_memory_MemTotal_bytes[10m]))) * on(instance) group_left(nodename) node_uname_info{} > 80
```
