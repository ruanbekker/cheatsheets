# regex

## Tools:
- https://regex101.com/

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
