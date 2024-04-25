# alerts

### Http Requests

The average rate per second of 5xx errors during that minute, aggregated by service, pod, and uri:
 
```promql
sum(rate(http_server_requests_seconds_count{status=~"5[0-9][0-9]"}[1m])) by (service, pod, uri)
```

Total number of 5xx errors in the last minute for each group:

```promql
sum(rate(http_server_requests_seconds_count{status=~"5[0-9][0-9]"}[1m])) by (service, pod, uri) * 60
```

Request latencies - How long, on average, each (2xx, 4xx, 5xx) response took:

```promql
sum by (service, uri) (
    rate(http_server_requests_seconds_sum{status=~"[2-5][0-9][0-9]", service=~".*"}[1m])
    /
    rate(http_server_requests_seconds_count{status=~"[2-5][0-9][0-9]", service=~".*"}[1m])
)
```

Request latencies - This multiplication converts the average response time from seconds to total seconds for all events in the last minute:

```promql
sum by (service, uri) (
    rate(http_server_requests_seconds_sum{status=~"[2-5][0-9][0-9]", service=~".*"}[1m])
    /
    rate(http_server_requests_seconds_count{status=~"[2-5][0-9][0-9]", service=~".*"}[1m])
) * 60
```
