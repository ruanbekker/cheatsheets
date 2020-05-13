## Examples
- https://www.bookstack.cn/read/loki/clients-promtail-pipelines.md
- https://github.com/grafana/loki/issues/333#issuecomment-570651075 (parsing labels from log tag)
- https://docs.docker.com/config/containers/logging/configure/      (^ related) 
- https://github.com/grafana/loki/issues/775#issuecomment-568814165 (create labels from filename)
- https://www.gitmemory.com/issue/grafana/loki/748/534945463 (drop logs from something)
- https://github.com/cyriltovena/loki/blob/master/docs/clients/promtail/stages/match.md#example (drop logs from match)
- https://www.youtube.com/watch?v=bIAC0uQee0k (using promtail with loki)

## Current Issues

- https://github.com/grafana/loki/issues/74 (multi-line)
- https://github.com/grafana/loki/issues/1880 (malformed logs with slashes)

## Pipelines

More Info: 
  - https://github.com/grafana/loki/blob/master/docs/clients/promtail/pipelines.md
  - https://github.com/grafana/loki/blob/master/docs/clients/promtail/stages/template.md

> The pipeline example below, takes the current value of level from the extracted map and converts its value to be all lowercase. For example, if the extracted map contained level with a value of INFO, this pipeline would change its value to info"

Pipeline Transform example, change uppercase values to lowercase (INFO to info):

```
scrape_configs:
  - job_name: app1
    static_configs:
    - targets:
        - localhost
      labels:
        job: app1
        environment: production
        host: app1.mydomain.com
        service: app1
        __path__: /var/log/app1_*.log
    pipeline_stages:
    - match:
        selector: '{service="app1"}'
        stages:
        - regex:
            expression: "(?P<level>(INFO|WARNING|ERROR))(.*)"
        - template:
            source: level
            template: '{{ ToLower .Value }}'
        - labels:
            level:
```
