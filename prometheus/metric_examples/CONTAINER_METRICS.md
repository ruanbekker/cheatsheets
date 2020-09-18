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

## Memory

Used memory per container:

```
sum(container_memory_rss{name=~".+", cluster_name=~"$cluster_name", container_label_com_amazonaws_ecs_container_name=~"$service_name"}) by (name, container_label_com_amazonaws_ecs_container_name, container_label_com_amazonaws_ecs_cluster)
```
