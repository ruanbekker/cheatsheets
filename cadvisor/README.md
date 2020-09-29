# cAdvisor Cheatsheet

### Labels

```
- instance
- environment
- cluster_name
```

For AWS, we will configure prometheus as:

```
scrape_configs:
  - job_name: container-metrics
    scrape_interval: 15s
    ec2_sd_configs:
    - region: eu-west-1
      role_arn: 'arn:aws:iam::000000000000:role/prometheus-ec2-role'
      port: 9100
      filters:
        - name: tag:PrometheusContainerScrape
          values:
            - Enabled
    relabel_configs:
    - source_labels: [__meta_ec2_private_ip]
      replacement: '${1}:8080'
      target_label: __address__
    - source_labels: [__meta_ec2_tag_Name]
      target_label: instance
    - source_labels: [__meta_ec2_tag_ECSClusterName]
      target_label: cluster_name
    - source_labels: [__meta_ec2_tag_Environment]
      target_label: environment
```
