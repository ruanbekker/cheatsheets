# LogQL

## Other Examples

- https://github.com/grafana/loki/blob/master/docs/logql.md#filter-expression
- https://medium.com/grafana-tutorials/logql-in-grafana-loki-ffc822a65f59

## logql examples

View all logs for dev/logs:

```
{job="dev/logs"}
```

View loglines for a specific filename for dev/logs:

```
{job="dev/logs", filename="/var/log/app.log"}
```

Search for logs that has the exact match "This is a test":

```
{job="dev/logs"} |= "This is a test"
```

Similar as above, but dont include exact match "testerId=123":

```
{job="dev/logs"} |= "This is a test" != "testerId=123"
```

Similar as above, and include a contains match for anything starting with "accountId=000":

```
{job="dev/logs"} |= "This is a test" != "testerId=123" |~ "accountId=000"
```

Similar as above, but exclude test with deviceId=001 and deviceId=209:

```
{job="dev/logs"} |= "This is a test" |= "accountId=000" !~ "deviceId=(001|209)"
```

Log events per container_name:

```
sum by(container_name) (rate({job="prod/dockerlogs"}[1m]))
```

## logql-parser

From [ctovena/loki:logql-parser-5e0238e](https://hub.docker.com/layers/ctovena/loki/logql-parser-5e0238e/images/sha256-a326d3329c25729b111216bdb0bddb4b8e976a40954c8be4c5396f36a5fb4f23?context=explore)

```
{job="adsb"} | json | gs > 500
```

```
sum by (query) (avg_over_time({job="dev/app"} |= "caller=metrics.go" | logfmt | duration > 100ms | unwrap througput_mb[1m]))
```

```
{job="dev/app"} |= "caller=metrics.go" | logfmt | throughput_mb < 100 and duration >= 200ms | line_format "{{.duration}}{{.query}}"
```

```
{compose_service="loki", job="dockerlogs"} | logfmt | read >= 0
```

```
{compose_service="loki",job="dockerlogs"} | logfmt | read >= 0 | line_format "{{.level}}"
```

```
{container_name=~"ecs-.*-nginx-.*"} 
| json 
| status=~"(200|4..)" and request_length>250 and request_method!="POST" and xff=~"(54.*|34.*)" 
| line_format "ReqMethod: {{.request_method}}, Status: {{.status}}, UserAgent: {{.http_user_agent}} Args: {{.args}} , ResponseTime: {{.responsetime}}"
```

## Regex

Using regex, this line:

```
1.2.3.4 - - [23/Nov/2020:17:31:00 +0200] "POST /foo/bar?token=x.x HTTP/1.1" 201 83 "http://localhost/" "Mozilla/5.0 (Linux; Android 10; Nokia 6.1 Build/x.x.x; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/x.0.x.110 Mobile Safari/537.36" "1.2.3.4"
```

With regex:

```
{job="prod/logs"} |~ "foo" | regexp "(?P<ip>\\d+.\\d+.\\d+.\\d+) (.*) (.*) (?P<date>\\[(.*)\\]) (\")(?P<verb>(\\w+)) (?P<request_path>([^\"]*)) (?P<http_ver>([^\"]*))(\") (?P<status_code>\\d+) (?P<bytes>\\d+) (\")(?P<referrer>(([^\"]*)))(\") (\")(?P<user_agent>(([^\"]*)))(\")"
```

And filtering on `status_code=201`:

```
{job="prod/logs"} |~ "doAPICall" | regexp "(?P<ip>\\d+.\\d+.\\d+.\\d+) (.*) (.*) (?P<date>\\[(.*)\\]) (\")(?P<verb>(\\w+)) (?P<request_path>([^\"]*)) (?P<http_ver>([^\"]*))(\") (?P<status_code>\\d+) (?P<bytes>\\d+) (\")(?P<referrer>(([^\"]*)))(\") (\")(?P<user_agent>(([^\"]*)))(\")" | status_code=201
```

- https://grafana.com/docs/loki/latest/logql/#label-filter-expression
