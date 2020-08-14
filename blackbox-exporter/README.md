# Blackbox Exporter

Blackbox Exporter by Prometheus

## Debugging

TCP Checks, host: `test.mydomain.com`, port: `443`

```
curl https://blackbox-exporter.mydomain.com/probe?target=test.mydomain.com:443&module=tcp_connect&debug=true
```

HTTP Check: `https://test.mydomain.com`

```
curl https://blackbox-exporter.mydomain.com/probe?target=https://test.mydomain.com&module=http_2xx&debug=true
```

SSH Check: `test.mydomain.com:22`

```
curl "https://blackbox-exporter.mydomain.com/probe?target=test.mydomain.com:22&module=ssh_banner&debug=true"
```
