# Alertmanager

## External References

Tools:

- [Slack Alert Builder](https://juliusv.com/promslack/)

Alerts:

- [Awesome Prometheus Rules for Alertmanager](https://awesome-prometheus-alerts.grep.to/rules.html)
- [Basic Prometheus Alerts](https://alex.dzyoba.com/blog/prometheus-alerts/)
- [Better alerts for Slack](https://medium.com/quiq-blog/better-slack-alerts-from-prometheus-49125c8c672b)
- [Graph in Slack](https://stackoverflow.com/questions/52918312/customizing-prometheus-alertmanager-notifications-in-slack)
- [Example Config, Alert, Template](https://gist.github.com/Cellane/7ee4d8cb4b54eb245701605814350021)
- [Example Alerts 1](https://github.com/prometheus/alertmanager/issues/2220#issuecomment-612099644) | [Example Alerts 2](https://gist.github.com/Cellane/7ee4d8cb4b54eb245701605814350021) | [Example Alert 3 (context switches)](https://stackoverflow.com/a/56735484) | [Example Alert 4 (slack)](https://infinityworks.com/insights/slack-prometheus-alertmanager/)
- [Deadmans Switch](https://jpweber.io/blog/taking-advantage-of-deadmans-switch-in-prometheus/)
- [Continue Routes in Alertmanager](https://stackoverflow.com/a/62725594)
- [Alert on Missing Labels and Metrics](https://niravshah2705.medium.com/prometheus-alert-for-missing-metrics-and-labels-afd4b8f12b1)

Configs:

- [Basic getting started example with Slack](https://gist.github.com/l13t/d432b63641b6972b1f58d7c037eec88f)
- [Webhook config example](https://github.com/prometheus/alertmanager/pull/444#issuecomment-428493861)
- [Setup DeadManSwitch alert](https://www.noqcks.io/notes/2018/01/29/prometheus-alertmanager-deadmansswitch/) and [DeadManSwitch Webhook Config](https://github.com/prometheus/alertmanager/pull/444#issuecomment-428493861) and [Golang Webhook Example](https://medium.com/@zhimin.wen/custom-notifications-with-alert-managers-webhook-receiver-in-kubernetes-8e1152ba2c31)

Routing:

- [Routing Alerts based on Severity Levels and Tags](https://rtfm.co.ua/en/prometheus-alertmanagers-alerts-receivers-and-routing-based-on-severity-level-and-tags/)
- [Routing Alerts based on Alert name](https://www.reddit.com/r/PrometheusMonitoring/comments/dmzm1k/alertmanager_notifications_how_to_notify_only_on/)
- [Route Alerts to Multiple Destinations](https://www.robustperception.io/sending-alert-notifications-to-multiple-destinations)

Setups:
- [Setup Alertmanager with manual call example](https://daenney.github.io/2018/04/21/setting-up-alertmanager)
- [Setup Alertmanager with Ansible](https://itnext.io/prometheus-with-alertmanager-f2a1f7efabd6)
- [Log Monitoring and Alerting with Loki](https://www.infracloud.io/blogs/grafana-loki-log-monitoring-alerting/)
- [Alerta for Alertmanager](https://github.com/alerta/prometheus-config)

Tooling:
- [Webhook for Alertmanager](https://github.com/bakins/alertmanager-webhook-example)

## API Calls

Manual trigger alert:

```
$ curl -H "Content-Type: application/json" -d '[{"status": "firing", "labels":{"alertname":"TestAlert1"}}]' localhost:9093/alertmanager/api/v1/alerts
```
