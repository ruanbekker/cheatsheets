## Datadog Grok Parser

### Example 1

Message: 

```
Endpoints not available for default/team-app-service-foobar
```

Pattern:

```
warning_endpoint_rule %{regex("[endpoints not available for a-zA-Z]*"):message_line}/%{regex("[a-zA-Z0-9-]*"):service}
```

Result:

```
{
  "message_line": "Endpoints not available for default",
  "service": "team-app-service-foobar"
}
```

### Example 2

Message:

```
[2019-12-10 00:00:07,890: INFO/ForkPoolWorker-10] Task api.tasks.handle_job[000000a0-1a2a-12a3-4a56-d12dd3456789] succeeded in 0.02847545174881816s: None
```

Pattern:

```
my_rule \[%{date("yyyy-MM-dd HH:mm:ss,SSS"):timestamp}: %{word:severity}/%{regex("[a-zA-Z0-9-]*"):process}\] %{data:details}
```

Result:

```
{
  "timestamp": 1575982567890,
  "severity": "INFO",
  "process": "ForkPoolWorker-10",
  "details": "Task api.tasks.handle_job[000000a0-1a2a-12a3-4a56-d12dd3456789] succeeded in 0.02847545174881816s: None"
}
```

### Example 3

Message:

```
2019-12-05 11:00:08,921 INFO module=trace, process_id=13, Task apps_dir.health.queue.tasks.add[000000a0-1a2a-12a3-4a56-d12dd3456789] succeeded in 0.0001603253185749054s: 8
```

Pattern:

```
my_rule .*%{date("yyyy-MM-dd HH:mm:ss,SSS"):date} %{word:status} .*
```

Result:

```
{
  "date": 1575982567890,
  "status": "INFO" 
}
```
