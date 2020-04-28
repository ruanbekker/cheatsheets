
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
