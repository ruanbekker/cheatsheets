#!/bin/bash

# This exporter gets stats from top and sends it to pushgateway
# Prometheus will scrape the pushgateway service and consumes to prometheus
# Grafana will visualize the data

# resource:
# https://devconnected.com/monitoring-linux-processes-using-prometheus-and-grafana/

job_name="top"
my_hostname="my-ec2-instance"
exporter_type="bash"
auth_string="x:x"
pushgateway_url="pushgateway.mydomain.com"

z=$(ps aux)
while read -r z
do
   var=$var$(awk '{print "exporter_memory_usage{process=\""$11"\", pid=\""$2"\"}", $4z}');
done <<< "$z"
curl -X POST -u "$auth_string" -H  "Content-Type: text/plain" --data "$var
" https://$pushgateway_url/metrics/job/$job_name/instance/$my_hostname/exporter_type/$exporter_type
