# Alertmanager

## External References

Alerts:

- [Awesome Prometheus Rules for Alertmanager](https://awesome-prometheus-alerts.grep.to/rules.html)
- [Basic Prometheus Alerts](https://alex.dzyoba.com/blog/prometheus-alerts/)
- [Better alerts for Slack](https://medium.com/quiq-blog/better-slack-alerts-from-prometheus-49125c8c672b)
- [Graph in Slack](https://stackoverflow.com/questions/52918312/customizing-prometheus-alertmanager-notifications-in-slack)

Configs:

- [Basic getting started example with Slack](https://gist.github.com/l13t/d432b63641b6972b1f58d7c037eec88f)
- [Webhook config example](https://github.com/prometheus/alertmanager/pull/444#issuecomment-428493861)
- [Setup DeadManSwitch alert](https://www.noqcks.io/notes/2018/01/29/prometheus-alertmanager-deadmansswitch/) and [DeadManSwitch Webhook Config](https://github.com/prometheus/alertmanager/pull/444#issuecomment-428493861) and [Golang Webhook Example](https://medium.com/@zhimin.wen/custom-notifications-with-alert-managers-webhook-receiver-in-kubernetes-8e1152ba2c31)

Routing:

- [Routing Alerts based on Severity Levels and Tags](https://rtfm.co.ua/en/prometheus-alertmanagers-alerts-receivers-and-routing-based-on-severity-level-and-tags/)
- [Routing Alerts based on Alert name](https://www.reddit.com/r/PrometheusMonitoring/comments/dmzm1k/alertmanager_notifications_how_to_notify_only_on/)

Setups:
- [Setup Alertmanager with manual call example](https://daenney.github.io/2018/04/21/setting-up-alertmanager)
- [Setup Alertmanager with Ansible](https://itnext.io/prometheus-with-alertmanager-f2a1f7efabd6)


## API Calls

Manual trigger alert:

```
$ curl -H "Content-Type: application/json" -d '[{"status": "firing", "labels":{"alertname":"TestAlert1"}}]' localhost:9093/alertmanager/api/v1/alerts
```
