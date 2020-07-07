## CloudWatch Logs Insights

- https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_QuerySyntax-examples.html

Loglines:

```
172.31.37.134 - - [07/Jul/2020 13:18:34] "GET / HTTP/1.1" 200 -
172.31.37.134 - - [07/Jul/2020 13:18:34] "GET /status HTTP/1.1" 200 -
```

Show all logs:

```
fields @message
```

Show the 25 most recent log entries:

```
fields @timestamp, @message | sort @timestamp desc | limit 25
```

Show all logs and include parsed fields:

```
fields @message, @log, @logStream, @ingestionTime, @timestamp
```

Only show logs containing `/status`:

```
fields @message | filter @message like '/status'
```

