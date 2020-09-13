# Loki

## Blogposts about Loki
- https://rtfm.co.ua/en/grafana-labs-loki-logs-collector-and-monitoring-system/
- [Using Fluentd and Loki on Docker](https://dev.to/thakkaryash94/docker-container-logs-using-fluentd-and-grafana-loki-a15)

## Dashboards for Grafana
- https://grafana.com/grafana/dashboards/12019

## Usage

Install the [loki docker driver](https://grafana.com/docs/loki/latest/clients/docker-driver/):

```
$ sudo docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions
```

Configure the daemon.json

```
$ cat /etc/docker/daemon.json
{
    "debug" : true,
    "log-driver": "loki",
    "log-opts": {
        "loki-url": "https://docker:x@loki.x.x.x.x/loki/api/v1/push",
        "loki-batch-size": "300",
        "loki-external-labels": "job=dev/dockerlogs,container_name={{.Name}},cluster_name=dev-ecs-cluster,hostname=ip-172-31-50-37.eu-west-1.compute.internal,aws_account=dev,environment=development"
    }
}
```

Restart the service:

```
$ sudo systemctl restart docker
```
