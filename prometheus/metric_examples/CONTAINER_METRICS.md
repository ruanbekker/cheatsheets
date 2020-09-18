# Container Metrics

Examples for Prometheus focused on Container Level Metrics, scraped from cadvisor.

## Variables

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

## CPU

Used CPU Utilization per container (graph):

```
sum(rate(container_cpu_usage_seconds_total{name=~".+", cluster_name=~"$cluster_name", container_label_com_amazonaws_ecs_container_name=~"$service_name"}[$interval])) by (name, container_label_com_amazonaws_ecs_container_name, container_label_com_amazonaws_ecs_cluster) * 100
```

Used CPU Utilization aggregated by service (guage):

```
sum(sum(rate(container_cpu_usage_seconds_total{name=~".+", cluster_name=~"$cluster_name", container_label_com_amazonaws_ecs_container_name=~"$service_name"}[$interval])) by ( container_label_com_amazonaws_ecs_container_name) * 100)
```

## Memory

Used memory per container (graph):

```
sum(container_memory_rss{cluster_name=~"$cluster_name", container_label_com_amazonaws_ecs_container_name=~"$service_name"}) by (name, container_label_com_amazonaws_ecs_container_name, container_label_com_amazonaws_ecs_cluster)
```

Used memory aggregated by service (guage):

```
sum(sum(container_memory_rss{name=~".+", cluster_name=~"$cluster_name", container_label_com_amazonaws_ecs_container_name=~"$service_name"}) by (name, container_label_com_amazonaws_ecs_container_name, container_label_com_amazonaws_ecs_cluster))
```

## Network

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
