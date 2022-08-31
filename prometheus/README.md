# Prometheus Cheatsheets

- [Basics](#basics)
- [Curated Examples](#curated-examples)
- [Example Queries](#example-queries)
- [Scrape Configs](#scrape-config)
- [Recording Rules](#recording-rules)
- [External Sources](#external-sources)

## Basics

- Counter: A counter metric always increases
- Gauge: A gauge metric can increase or decrease
- Histogram: A histogram metric can increase or descrease
- [Source and Statistics 101](https://opensource.com/article/18/4/metrics-monitoring-and-python)

## Curated Examples

Example queries per exporter / service:

- [Node Metrics](metric_examples/NODE_METRICS.md)

## Example Queries

How many nodes are up?

```
up
```

Combining values from 2 different vectors (Hostname with a Metric):

```
up * on(instance) group_left(nodename) (node_uname_info)
```

Exclude labels:

```
sum without(job) (up * on(instance)  group_left(nodename)  (node_uname_info))
```

Count targets per job:

```
count by (job) (up)
```

Amount of Memory Available:

```
node_memory_MemAvailable_bytes
```

Amount of Memory Available in MB:

```
node_memory_MemAvailable_bytes/1024/1024
```

Amount of Memory Available in MB 10 minutes ago:

```
node_memory_MemAvailable_bytes/1024/1024 offset 10m
```

Average Memory Available for Last 5 Minutes:

```
avg_over_time(node_memory_MemAvailable_bytes[5m])/1024/1024
```

Memory Usage in Percent:

```
100 * (1 - ((avg_over_time(node_memory_MemFree_bytes[10m]) + avg_over_time(node_memory_Cached_bytes[10m]) + avg_over_time(node_memory_Buffers_bytes[10m])) / avg_over_time(node_memory_MemTotal_bytes[10m])))
```

CPU Utilization:

```
100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle", instance="my-instance"}[5m])) * 100 ) 
```

CPU Utilization offset with 24hours ago:

```
100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle", instance="my-instance"}[5m] offset 24h)) * 100 )
```

CPU Utilization per Core:

```
( (1 - rate(node_cpu_seconds_total{job="node-exporter", mode="idle", instance="$instance"}[$__interval])) / ignoring(cpu) group_left count without (cpu)( node_cpu_seconds_total{job="node-exporter", mode="idle", instance="$instance"}) ) 
```

CPU Utilization by Node:

```
100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[10m]) * 100) * on(instance) group_left(nodename) (node_uname_info))
```

Memory Available by Node:

```
node_memory_MemAvailable_bytes * on(instance) group_left(nodename) (node_uname_info)
```

Or if you rely on labels from other metrics:

```
(node_memory_MemTotal_bytes{job="node-exporter"} - node_memory_MemFree_bytes{job="node-exporter"} - node_memory_Buffers_bytes{job="node-exporter"} - node_memory_Cached_bytes{job="node-exporter"}) * on(instance) group_left(nodename) (node_uname_info{nodename=~"$nodename"})
```

Load Average in percentage:

```
avg(node_load1{instance=~"$name", job=~"$job"}) /  count(count(node_cpu_seconds_total{instance=~"$name", job=~"$job"}) by (cpu)) * 100
```

Load Average per Instance:

```
sum(node_load5{}) by (instance) / count(node_cpu_seconds_total{mode="user"}) by (instance) * 100
```

Load Average (average per instance_id: lets say the metric has 2 identical label values but are different):

```
avg by (instance_id, instance) (node_load1{job=~"node-exporter", aws_environment="dev", instance="debug-dev"})
# {instance="debug-dev",instance_id="i-aaaaaaaaaaaaaaaaa"}
# {instance="debug-dev",instance_id="i-bbbbbbbbbbbbbbbbb"}
```

Disk Available by Node:

```
node_filesystem_free_bytes{mountpoint="/"} * on(instance) group_left(nodename) (node_uname_info)
```

Disk IO per Node: Outbound:

```
sum(rate(node_disk_read_bytes_total[1m])) by (device, instance) * on(instance) group_left(nodename) (node_uname_info)
```

Disk IO per Node: Inbound:

```
sum(rate(node_disk_written_bytes_total{job="node"}[1m])) by (device, instance) * on(instance) group_left(nodename) (node_uname_info)
```

Network IO per Node:

```
sum(rate(node_network_receive_bytes_total[1m])) by (device, instance) * on(instance) group_left(nodename) (node_uname_info)
sum(rate(node_network_transmit_bytes_total[1m])) by (device, instance) * on(instance) group_left(nodename) (node_uname_info)
```

Process Restarts:

```
changes(process_start_time_seconds{job=~".+"}[15m])
```

Container Cycling:

```
(time() - container_start_time_seconds{job=~".+"}) < 60
```

Histogram:

```
histogram_quantile(1.00, sum(rate(prometheus_http_request_duration_seconds_bucket[5m])) by (handler, le)) * 1e3
```

Metrics 24 hours ago (nice when you compare today with yesterday):

```
# query a
total_number_of_errors{instance="my-instance", region="eu-west-1"}
# query b
total_number_of_errors{instance="my-instance", region="eu-west-1"} offset 24h

# related:
# https://about.gitlab.com/blog/2019/07/23/anomaly-detection-using-prometheus/
```

Number of Nodes (Up):

```
count(up{job="cadvisor_my-swarm"})
```

Running Containers per Node:

```
count(container_last_seen) BY (container_label_com_docker_swarm_node_id)
```

Running Containers per Node, include corresponding hostnames:

```
count(container_last_seen) BY (container_label_com_docker_swarm_node_id) * ON (container_label_com_docker_swarm_node_id) GROUP_LEFT(node_name) node_meta 
```

HAProxy Response Codes:

```
haproxy_server_http_responses_total{backend=~"$backend", server=~"$server", code=~"$code", alias=~"$alias"} > 0
```

Metrics with the most resources:

```
topk(10, count by (__name__)({__name__=~".+"}))
```

the same, but per job:

```
topk(10, count by (__name__, job)({__name__=~".+"}))
```

or jobs have the most time series:

```
topk(10, count by (job)({__name__=~".+"}))
```

Top 5 per value:

```
sort_desc(topk(5, aws_service_costs))
```

Table - Top 5 (enable instant as well):

```
sort(topk(5, aws_service_costs))
```

Group per Day (Table) - wip

```
aws_service_costs{service=~"$service"} + ignoring(year, month, day) group_right
  count_values without() ("year", year(timestamp(
    count_values without() ("month", month(timestamp(
      count_values without() ("day", day_of_month(timestamp(
        aws_service_costs{service=~"$service"}
      )))
    )))
  ))) * 0
```

Group Metrics per node hostname:

```
node_memory_MemAvailable_bytes * on(instance) group_left(nodename) (node_uname_info)

..
{cloud_provider="amazon",instance="x.x.x.x:9100",job="node_n1",my_hostname="n1.x.x",nodename="n1.x.x"}
```

Subtract two gauge metrics (exclude the label that dont match):

```
polkadot_block_height{instance="polkadot", chain=~"$chain", status="sync_target"} - ignoring(status) polkadot_block_height{instance="polkadot", chain=~"$chain", status="finalized"}
```

Container CPU Average for 5m:

```
(sum by(instance, container_label_com_amazonaws_ecs_container_name, container_label_com_amazonaws_ecs_cluster) (rate(container_cpu_usage_seconds_total[5m])) * 100) 
```

Container Memory Usage: Total:

```
sum(container_memory_rss{container_label_com_docker_swarm_task_name=~".+"})
```

Container Memory, per Task, Node:

```
sum(container_memory_rss{container_label_com_docker_swarm_task_name=~".+"}) BY (container_label_com_docker_swarm_task_name, container_label_com_docker_swarm_node_id)
```

Container Memory per Node:

```
sum(container_memory_rss{container_label_com_docker_swarm_task_name=~".+"}) BY (container_label_com_docker_swarm_node_id)
```

Memory Usage per Stack:

```
sum(container_memory_rss{container_label_com_docker_swarm_task_name=~".+"}) BY (container_label_com_docker_stack_namespace)
```

Remove metrics from results that does not contain a specific label:

```
container_cpu_usage_seconds_total{container_label_com_amazonaws_ecs_cluster!=""}
```

Remove labels from a metric:

```
sum without (age, country) (people_metrics)
```

View top 10 biggest metrics by name:

```
topk(10, count by (__name__)({__name__=~".+"}))
```

View top 10 biggest metrics by name, job:

```
topk(10, count by (__name__, job)({__name__=~".+"}))
```

View all metrics for a specific job:

```
{__name__=~".+", job="node-exporter"}
```

View all metrics for more than one job using vector selectors

```
{__name__=~".+", job=~"traefik|cadvisor|prometheus"}
```

Website uptime with blackbox-exporter:

```
# https://www.robustperception.io/what-percentage-of-time-is-my-service-down-for

avg_over_time(probe_success{job="node"}[15m]) * 100
```

Remove / Replace:

- https://medium.com/@texasdave2/replace-and-remove-a-label-in-a-prometheus-query-9500faa302f0

Client Request Counts:

```
irate(http_client_requests_seconds_count{job="web-metrics", environment="dev", uri!~".*actuator.*"}[5m])
```

Client Response Time:

```
irate(http_client_requests_seconds_sum{job="web-metrics", environment="dev", uri!~".*actuator.*"}[5m]) / 
irate(http_client_requests_seconds_count{job="web-metrics", environment="dev", uri!~".*actuator.*"}[5m])
```

## Scrape Config

relabel configs:

```
# full example: https://gist.github.com/ruanbekker/72216bea59fc56af189f5a7b2e3a8002
scrape_configs:
  - job_name: 'multipass-nodes'
    static_configs:
    - targets: ['ip-192-168-64-29.multipass:9100']
      labels:
        env: test
    - targets: ['ip-192-168-64-30.multipass:9100']
      labels:
        env: test
    # https://grafana.com/blog/2022/03/21/how-relabeling-in-prometheus-works/#internal-labels
    relabel_configs:
    - source_labels: [__address__]
      separator: ':'
      regex: '(.*):(.*)'
      replacement: '${1}'
      target_label: instance
```

static_configs:

```
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
         - targets: ['localhost:9090']
      labels:
        region: 'eu-west-1'
```

dns_sd_configs:

```
scrape_configs:
  - job_name: 'mysql-exporter'
    scrape_interval: 5s
    dns_sd_configs:
    - names:
      - 'tasks.mysql-exporter'
      type: 'A'
      port: 9104
    relabel_configs:
    - source_labels: [__address__]
      regex: '.*'
      target_label: instance
      replacement: 'mysqld-exporter'
```

Useful links:

- https://gist.github.com/ruanbekker/72216bea59fc56af189f5a7b2e3a8002
- https://gist.github.com/trastle/1aa205354577ef0b329d4b8cc84c674a
- https://github.com/prometheus/docs/issues/341
- https://medium.com/quiq-blog/prometheus-relabeling-tricks-6ae62c56cbda
- https://blog.freshtracks.io/prometheus-relabel-rules-and-the-action-parameter-39c71959354a
- https://www.robustperception.io/relabel_configs-vs-metric_relabel_configs
- https://training.robustperception.io/courses/prometheus-configuration/lectures/3170347

## Grafana with Prometheus

If you have output like this on grafana:

```
{instance="10.0.2.66:9100",job="node",nodename="rpi-02"}
```

and you only want to show the hostnames, you can apply the following in "Legend" input:

```
{{nodename}}
```

If your output want `exported_instance` in:

```
sum(exporter_memory_usage{exported_instance="myapp"})
```

You would need to do:

```
sum by (exported_instance) (exporter_memory_usage{exported_instance="my_app"})
```

Then on Legend:

```
{{exported_instance}}
```

### Variables

- Hostname:

name: `node`
label: `node`
node: `label_values(node_uname_info, nodename)`

Then in Grafana you can use:

```
sum(rate(node_disk_read_bytes_total{job="node"}[1m])) by (device, instance) * on(instance) group_left(nodename) (node_uname_info{nodename=~"$node"})
```

- Node Exporter Address

type: `query`
query: `label_values(node_network_up, instance)`

- MySQL Exporter Address

type: `query`
query: `label_values(mysql_up, instance)`


- Static Values:

type: `custom`
name: `dc`
label: `dc`
values seperated by comma: `eu-west-1a,eu-west-1b,eu-west-1c`

- Docker Swarm Stack Names

name: `stack`
label: `stack`
query: `label_values(container_last_seen,container_label_com_docker_stack_namespace)`

- Docker Swarm Service Names

name: `service_name`
label: `service_name`
query: `label_values(container_last_seen,container_label_com_docker_swarm_service_name)`

- Docker Swarm Manager NodeId:

name: `manager_node_id`
label: `manager_node_id`
query: 
```
label_values(container_last_seen{container_label_com_docker_swarm_service_name=~"proxy_traefik", container_label_com_docker_swarm_node_id=~".*"}, container_label_com_docker_swarm_node_id)
```

- Docker Swarm Stacks Running on Managers

name: `stack_on_manager`
label: `stack_on_manager`
query: 
```
label_values(container_last_seen{container_label_com_docker_swarm_node_id=~"$manager_node_id"},container_label_com_docker_stack_namespace)
```

## Recording Rules

- [@deploy.live's Recording Rules Post](https://deploy.live/blog/today-i-learned-prometheus-recording-rules/)

## Application Instrumentation

### Python Flask

- [@ramdesh flask-prometheus-grafana-example](https://github.com/ramdesh/flask-prometheus-grafana-example)

## External Sources

- [Prometheus](https://prometheus.io/docs/querying/basics/)
- [PromQL for Beginners](https://medium.com/@valyala/promql-tutorial-for-beginners-9ab455142085)
- [Prometheus 101](https://medianetlab.gr/prometheus-101/)
- [Section.io: Prometheus Querying](https://www.section.io/blog/prometheus-querying/)
- [InnoQ: Prometheus Counters](https://www.innoq.com/en/blog/prometheus-counters/)
- [Biggest Metrics](https://www.robustperception.io/which-are-my-biggest-metrics)
- [Top Metrics](https://github.com/grafana/grafana/issues/6561)
- [Ordina-Jworks](https://ordina-jworks.github.io/monitoring/2016/09/23/Monitoring-with-Prometheus.html)
- [Infinity Works](https://github.com/infinityworks/prometheus-example-queries)
- [Prometheus Relabeling Tricks](https://medium.com/quiq-blog/prometheus-relabeling-tricks-6ae62c56cbda)
- [@Valyala: PromQL Tutorial for Beginners](https://medium.com/@valyala/promql-tutorial-for-beginners-9ab455142085)
- [@Jitendra: PromQL Cheat Sheet](https://github.com/jitendra-1217/promql.cheat.sheet)
- [InfinityWorks: Prometheus Example Queries](https://github.com/infinityworks/prometheus-example-queries/blob/master/README.md)
- [Timber: PromQL for Humans](https://timber.io/blog/promql-for-humans/)
- [SectionIO: Prometheus Querying](https://www.section.io/blog/prometheus-querying/)
- [RobustPerception]()
  - [RobustPerception: Understanding Machine CPU Usage](https://www.robustperception.io/understanding-machine-cpu-usage)
  - [RobustPerception: Common Query Patterns](https://www.robustperception.io/common-query-patterns-in-promql)
  - [RobustPerception: Website Uptime](https://www.robustperception.io/what-percentage-of-time-is-my-service-down-for)
  - [RobustPerception: Prometheus Histogram](https://www.robustperception.io/how-does-a-prometheus-histogram-work)
  - [RobustPerception: Prometheus Counter](https://www.robustperception.io/how-does-a-prometheus-counter-work)
  - [RobustPerception: Prometheus Guage](https://www.robustperception.io/how-does-a-prometheus-gauge-work)
  - [RobustPerception: Prometheus Summary](https://www.robustperception.io/how-does-a-prometheus-summary-work)
- [DevConnected: The Definitive Guide to Prometheus](https://devconnected.com/the-definitive-guide-to-prometheus-in-2019/)
- [@showmax Prometheus Introduction](https://tech.showmax.com/2019/10/prometheus-introduction/)
- [@rancher Cluster Monitoring](https://rancher.com/docs/rancher/v2.0-v2.4/en/cluster-admin/tools/cluster-monitoring/expression/)
- [Prometheus CPU Stats](https://utcc.utoronto.ca/~cks/space/blog/sysadmin/PrometheusCPUStats)
- [@aws Prometheus Rewrite Rules for k8s](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/ContainerInsights-Prometheus-Setup-configure.html#ContainerInsights-Prometheus-Setup-config-scrape)
- [ec2_sd_configs]()
  - [Prometheus AWS Cross Account ec2_sd_config](https://jarodw.com/posts/prometheus-ec2-sd-multiple-aws-accounts/)
  - [Prometheus AWS ec2_sd_config role](https://medium.com/investing-in-tech/automatic-monitoring-for-all-new-aws-instances-using-prometheus-service-discovery-97d37a5b2ea2)
- [kubernetes_sd_configs]()
  - [fabianlee kubernetes configs](https://fabianlee.org/2022/07/08/prometheus-monitoring-services-using-additional-scrape-config-for-prometheus-operator/)
- [@metricfire.com: Understanding the Rate Function](https://www.metricfire.com/blog/understanding-the-prometheus-rate-function/)
Dashboarding:
- [Alerting on Missing Labels and Metrics](https://niravshah2705.medium.com/prometheus-alert-for-missing-metrics-and-labels-afd4b8f12b1)
- [@devconnected Disk IO Dashboarding](https://devconnected.com/monitoring-disk-i-o-on-linux-with-the-node-exporter/)
- [@deploy.live recording rules](https://deploy.live/blog/today-i-learned-prometheus-recording-rules/)
- [CPU and Memory Requests](https://gist.github.com/max-rocket-internet/6a05ee757b6587668a1de8a5c177728b)
- 
Setups:

- [Simulating AWS Tags in Local Prometheus](https://ops.tips/blog/simulating-aws-tags-in-local-prometheus/)
