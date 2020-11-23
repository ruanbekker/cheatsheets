# regex

## Tools:
- https://regex101.com/

## Sources
- https://groups.google.com/forum/#!topic/fluentd/arfxLzfU_5c

## Patterns

string:

```
10.0.2.2 - - [19/Jul/2019 10:02:48] "GET /?ccnum=1234 HTTP/1.1" 200 -
```

match ccnum value:

```
ccnum=\d+
```

match everything until ccnum=

```
\d+.\d+.\d+.\d+ .* \[\d{2}\/\w+\/\d{4}.*\d{2}:\d{2}:\d{2}\].*"\w+.*\/?ccnum=\d+
```

Log:

```
2020-04-21 08:37:04 172.16.1.1 - - [21/Apr/2020:08:37:04 +0200] "POST /path?foo=bar HTTP/1.1" 200 540 "http://localhost/bar/" "Mozilla/5.0 (Linux; Android 10; One Build/One-Boo; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/81.0.4044.111 Mobile Safari/537.36" "1.1.1.1"
```

Date:

```
.[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]
.\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}
```

IP Address `10.173.4.20`:

```
 \d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}
```

Apache / Nginx Log:

```
172.128.80.109 - Bins5273 656 [2019-05-03T13:11:48-04:00] "PUT /mesh" 406 10272

^([\w\.]+) - ([\w]+) ([\d]+) \[(.*)\] "([\w]+) (.*)" ([\d]+) ([\d]+)$
```

```
127.0.0.1 - - [21/Apr/2020:11:47:07 +0000] "GET / HTTP/1.1" 200 612 "http://" "curl/7.58.0"

^([\w\.]+) ([^ ]*) ([^ ]*) \[(.*)\] "(\S+)(?: +([^ ]*) +\S*)?" ([\d]+) ([\d]+) "([^"]*)" "([^\"]*)"?
```

```
127.0.0.1 - - [21/Apr/2020:11:47:07 +0000] "GET / HTTP/1.1" 200 612 "http://" "curl/7.58.0"

^([\w\.]+) - ([^ ]*) \[(.*)\] "([^ ]*) ([^ ]*) ([^ ]*)" ([\d]+) ([\d]+) "([^"]*)" "([^\"]*)"?
```

```
127.0.0.1 - - [21/Apr/2020:11:47:07 +0000] "GET / HTTP/1.1" 200 612 "http://" "curl/7.58.0" "10.20.30.1"

^([\w\.]+) - ([^ ]*) \[(.*)\] "([^ ]*) ([^ ]*) ([^ ]*)" ([\d]+) ([\d]+) "([^"]*)" "([^\"]*)" "([\w\.]+)"?
```

Assigning it labels with things like vector, promtail:

```
^(?P<remote_ip>[\w\.]+) - (?P<user>[^ ]*) \[(?P<timestamp>.*)\] "(?P<method>[^ ]*) (?P<request_url>[^ ]*) (?P<request_http_protocol>[^ ]*)" (?P<status>[\d]+) (?P<bytes_out>[\d]+) "(?P<http_referer>[^"]*)" "(?P<user_agent>[^"]*)" "(?P<client_ip>[\w\.]+)"?
```

Full match value between brackets:

```
this is [foo] bar
\(?\w+(?=\]):?
```

using positive lookbehind:

```
this is [foo] bar
(?<=\[)[\w+.-]*
```

Match everything up until `abc` but dont include it:

```
/^(.*?)abc/
```

Or numbers:

```
/^(.*?)[0-9]/
```

This example is with Loki using Regex, the line:

```
1.2.3.4 - - [23/Nov/2020:17:31:00 +0200] "POST /foo/bar?token=x.x HTTP/1.1" 201 83 "http://localhost/" "Mozilla/5.0 (Linux; Android 10; Nokia 6.1 Build/x.x.x; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/x.0.x.110 Mobile Safari/537.36" "1.2.3.4"
```

The regex:

```
| regexp "(?P<ip>\\d+.\\d+.\\d+.\\d+) (.*) (.*) (?P<date>\\[(.*)\\]) (\")(?P<verb>(\\w+)) (?P<request_path>([^\"]*)) (?P<http_ver>([^\"]*))(\") (?P<status_code>\\d+) (?P<bytes>\\d+) (\")(?P<referrer>(([^\"]*)))(\") (\")(?P<user_agent>(([^\"]*)))(\")"
```
