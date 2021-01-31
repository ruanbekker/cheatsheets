# PushGateway

## Start Pushgateway

Run using docker:

```
$ docker run -it -p 9091:9091 prom/pushgateway
```

## Producing to Pushgateway

Using curl:

```
$ duration=0.01
$ echo "job_duration_seconds 0.01" | curl --data-binary @- http://localhost:9091/metrics/job/mysqldump/instance/db01
```

Using curl with multiline:

```
$ cat <<EOF | curl --data-binary @- http://localhost:9091/metrics/job/mysqldump/instance/db01
job_duration_seconds{instance="db01",job="mysqldump"} 0.02
job_exit_code_status{instance="db01",job="mysqldump"} 0
EOF
```

Using Python:

```
requests.post('http://192.168.0.4:9091/metrics/job/mysqldump/instance/db01', data='job_exit_code_status 0.04\n')
```

Using the prometheus python client:

- https://github.com/prometheus/client_python#exporting-to-a-pushgateway
- https://github.com/prometheus/client_python/blob/a5f0e25273b9007d2ab72480779a51378a86d83a/prometheus_client/metrics.py#L277

```
from prometheus_client import CollectorRegistry, Gauge, push_to_gateway
g = Gauge('job_duration_seconds', 'The time it takes for the job to run', registry=registry)
g.set(0.05) # g.inc(2) / g.dec(2)
push_to_gateway('localhost:9091', job='mysqldump', grouping_key={'instance':'db01','job':'mysqldump','process':'script.py'}, registry=registry)
```

## Reading from Pushgateway

Read the metrics endpoint:

```
$ curl -L http://localhost:9091/metrics/
# TYPE job_duration_seconds untyped
job_duration_seconds{instance="db01",job="mysqldump",process="script.py"} 0.02
# TYPE job_exit_code_status untyped
job_exit_code_status{instance="db01",job="mysqldump",process="script.py"} 0
```

Prometheus static scrape config:

```
scrape_configs
  - job_name: 'pushgateway-exporter'
    scrape_interval: 15s
    static_configs:
    - targets: ['192.168.0.10:9091']
      labels:
        instance: node1
        region: eu-west-1
    - targets: ['192.168.1.10:9091']
      labels:
        instance: node1
        region: eu-west-2
```
