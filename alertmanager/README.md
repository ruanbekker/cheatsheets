# Alertmanager

## External References

Alerts:

- [Awesome Prometheus Rules for Alertmanager](https://awesome-prometheus-alerts.grep.to/rules.html)
- [Basic Prometheus Alerts](https://alex.dzyoba.com/blog/prometheus-alerts/)
- [Better alerts for Slack](https://medium.com/quiq-blog/better-slack-alerts-from-prometheus-49125c8c672b)
- [Graph in Slack](https://stackoverflow.com/questions/52918312/customizing-prometheus-alertmanager-notifications-in-slack)

Routing:

- [Routing Alerts based on Severity Levels and Tags](https://rtfm.co.ua/en/prometheus-alertmanagers-alerts-receivers-and-routing-based-on-severity-level-and-tags/)


Setups:
- [Setup Alertmanager with Ansible](https://itnext.io/prometheus-with-alertmanager-f2a1f7efabd6)


## API Calls

Manual trigger alert:

```
$ curl -H "Content-Type: application/json" -d '[{"status": "firing", "labels":{"alertname":"TestAlert1"}}]' localhost:9093/alertmanager/api/v1/alerts
```
