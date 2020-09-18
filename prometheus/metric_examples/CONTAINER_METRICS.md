# Container Metrics

Examples for Prometheus focused on Container Level Metrics, scraped from cadvisor.

## Requirements

This is used on a ECS Cluster with the following:

1. cadvisor running on the cluster with this [cadvisor_taskdef.json](https://github.com/ruanbekker/cheatsheets/blob/master/ecs/task-definitions/cadvisor_taskdef.json)
2. prometheus scrape config with:

```
  # cadvisor
  - job_name: container-metrics
    scrape_interval: 15s
    ec2_sd_configs:
    - region: eu-west-1
      role_arn: 'arn:aws:iam::xxxxxxxxxxxx:role/prometheus-ec2-role'
      port: 9100
      filters:
        - name: tag:PrometheusContainerScrape
          values:
            - Enabled
    relabel_configs:
    - source_labels: [__meta_ec2_private_ip]
      replacement: '${1}:8080'
      target_label: __address__
    - source_labels: [__meta_ec2_tag_Name]
      target_label: instance
    - source_labels: [__meta_ec2_tag_ECSClusterName]
      target_label: cluster_name
```

## Grafana Variables

Interval:

```
Name: interval
Label: Interval
Type: interval
Values: 1m,10m,30m,1h,6h,12h,1d,7d,14d,30d
```

Cluster Name: 

```
Name: cluster_name
Label: ECS Cluster
Type: Query
Values: label_values(cadvisor_version_info,  cluster_name)
```

Service Name:

```
Name: service_name
Label: Service Name
Type: Query
Values: label_values(container_cpu_load_average_10s{cluster_name=~"$cluster_name"}, container_label_com_amazonaws_ecs_container_name)
```

## Example Prometheus Queries

Queries used in Grafana

### CPU

Used CPU Utilization per container (graph):

```
sum(rate(container_cpu_usage_seconds_total{name=~".+", cluster_name=~"$cluster_name", container_label_com_amazonaws_ecs_container_name=~"$service_name"}[$interval])) by (name, container_label_com_amazonaws_ecs_container_name, container_label_com_amazonaws_ecs_cluster) * 100
```

Used CPU Utilization aggregated by service (guage):

```
sum(sum(rate(container_cpu_usage_seconds_total{name=~".+", cluster_name=~"$cluster_name", container_label_com_amazonaws_ecs_container_name=~"$service_name"}[$interval])) by ( container_label_com_amazonaws_ecs_container_name) * 100)
```

### Memory

Used memory per container (graph):

```
sum(container_memory_rss{cluster_name=~"$cluster_name", container_label_com_amazonaws_ecs_container_name=~"$service_name"}) by (name, container_label_com_amazonaws_ecs_container_name, container_label_com_amazonaws_ecs_cluster)
```

Used memory aggregated by service (guage):

```
sum(sum(container_memory_rss{name=~".+", cluster_name=~"$cluster_name", container_label_com_amazonaws_ecs_container_name=~"$service_name"}) by (name, container_label_com_amazonaws_ecs_container_name, container_label_com_amazonaws_ecs_cluster))
```

### Network

Incoming Network Traffic per Container (graph):

```
sum(rate(container_network_receive_bytes_total{cluster_name=~"$cluster_name", container_label_com_amazonaws_ecs_container_name=~"$service_name"}[$interval])) by (name, container_label_com_amazonaws_ecs_container_name, container_label_com_amazonaws_ecs_cluster)
```

Outgoing Network Traffic per Container (graph):

```
sum(rate(container_network_transmit_bytes_total{cluster_name=~"$cluster_name", container_label_com_amazonaws_ecs_container_name=~"$service_name"}[$interval])) by (name, container_label_com_amazonaws_ecs_container_name, container_label_com_amazonaws_ecs_cluster)
```

To combine both metrics in one panel and invert the direction of the graph for outgoing:

```
Incoming:
  - Legend => down: {{name}}
Outgoing:
  - Legend => up: {{name}}
  
Series overrides
  - Alias or regex => /.*up.*/
  - Transform => negative-y
```

Incoming Network Traffic aggregated by Service (gauge):

```
sum(sum(rate(container_network_receive_bytes_total{cluster_name=~"$cluster_name", container_label_com_amazonaws_ecs_container_name=~"$service_name"}[$interval])) by (name, container_label_com_amazonaws_ecs_container_name, container_label_com_amazonaws_ecs_cluster))
```

Outgoing Network Traffic aggregated by Service (gauge):

```
sum(sum(rate(container_transmit_receive_bytes_total{cluster_name=~"$cluster_name", container_label_com_amazonaws_ecs_container_name=~"$service_name"}[$interval])) by (name, container_label_com_amazonaws_ecs_container_name, container_label_com_amazonaws_ecs_cluster))
```
