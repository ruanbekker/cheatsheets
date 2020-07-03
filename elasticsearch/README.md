# Elasticsearch Cheatsheet

- [Using cURL](#using-curl)
  - [Cluster Health](#health-with-curl)
  - [View Indices](#view-indices)
  - [Create Index](#create-index)
  - [Ingest](#ingest-data)
  - [Search](#search)
  - [Reindex](#reindex-using-curl)
  - [Update Replica Shards](#update-replicas-curl)
  - [Snapshots](#snapshots-with-curl)
  - [Restore Snapshots](#restore-snapshots-with-curl)
  - [Tasks API](#tasks)
- [using Python](python-elasticsearch.md#python-library)
  - [Ingest](python-elasticsearch.md#ingest-using-python)


## Using Curl

### Health with Curl

View the cluster health on a cluster level:

```
$ curl -s -XGET "http://127.0.0.1:9200/_cluster/health?pretty"
```

View the cluster health on a index level:

```
$ curl -XGET "http://127.0.0.1:9200/_cluster/health?level=indices&pretty"
```

Check all indices in yellow status:

```
$ curl -s -XGET 'http://127.0.0.1:9200/_cat/indices?v&health=yellow'
```

View recovery process:

```
curl -s -XGET 'http://127.0.0.1:9200/_cat/recovery?detailed&h=index,stage,time,bytes_percent'
```

### View Indices

View all your indices:

```
$ curl -s -XGET 'http://127.0.0.1:9200/_cat/indices?v'
```

View all indices from 2019.05:

```
$ curl -s -XGET 'http://127.0.0.1:9200/_cat/indices/*2019.05*?v'
```

View all your indices, sort by size:

```
$ curl -s -XGET 'http://127.0.0.1:9200/_cat/indices?v&s=pri.store.size'
```

View all indices, but return only the index.name value:

```
$ curl -s -XGET 'http://127.0.0.1:9200/_cat/indices?v&h=index'
```

### Create Index

Create a Index:

```
$ curl -XPOST -H "Content-Type: application/json" "http://localhost:9200/my-test-index
```

Create a Index with 5 Primary Shards, 1 Replica Shard and Refresh Interval of 30 seconds:

```
$ curl -XPUT -H "Content-Type: application/json" \
  http://localhost:9200/my-foobar-index \
  -d '{"index": {"number_of_shards":"5","number_of_replicas": 1, "refresh_interval": "30s"}}'
```

If you want to manually refresh your index to see the data:

```
$ curl -XPOST -H "Content-Type: application/json" "http://localhost:9200/my-foobar-index/_refresh"
```

### Update Index Settings

Documentation:
- https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-update-settings.html

View the index settings:

```
$ curl -XGET -H "Content-Type: application/json" "http://127.0.0.1:9200/my-foobar-index/_settings?pretty"
```

Update the settings, disable refresh for example:

```
$ curl -XPUT -H "Content-Type: application/json" "http://127.0.0.1:9200/my-foobar-index/_settings" -d '{"index": {"refresh_interval": "-1"}}'
```

### Ingest Data

### Search

**Searcing with query parameters:**

Name = Kevin

```
curl -XGET 'http://localhost:9200/myfirstindex/_search?q=name:kevin&pretty'
```

Age < 30

```
curl -XGET 'http://localhost:9200/myfirstindex/_search?q=age:<30&pretty'
```

Name = Michelle AND age < 30

```
curl -XGET 'http://localhost:9200/myfirstindex/_search?q=name:michelle%20AND%20age:<30&pretty'
```

### Reindex using Curl

Reindex source index to target index:

```
$ curl -XPOST -H 'Content-Type: application/json' 'http://127.0.0.1:9200/_reindex' -d '
  {
    "source": {
      "index": ["my-metrics-2019.01.03"]
    }, 
    "dest": {
      "index": "archived-metrics-2019.01.03", 
    }
}'
```

Reindex multiple source indices to one target index:

```
$ curl -XPOST -H 'Content-Type: application/json' 'http://127.0.0.1:9200/_reindex' -d '
  {
    "source": {
      "index": ["my-metrics-2019.01.03", "my-metrics-2019.01.04"]
    }, 
    "dest": {
      "index": "archived-metrics-2019.01", 
    }
}'
```

Reindex only missing documents from source to target index. You will receive conflicts for existing documents, but the proceed value will ignore the conflicts.

```
$ curl -XPOST -H 'Content-Type: application/json' 'http://127.0.0.1:9200/_reindex' -d '
  {
    "conflicts": "proceed", 
    "source": {
      "index": ["my-metrics-2019.01.03"]
    }, 
    "dest": {
      "index": "archived-metrics-2019.01.03", 
      "op_type": "create"
    }
}'
```

Reindex filtered data to a target index, by using a query:

```
$ curl -XPOST -H 'Content-Type: application/json' 'http://127.0.0.1:9200/_reindex' -d '
  {
    "source": {
      "index": "my-metrics-2019.01.03",
      "type": "log",
      "query": {
        "term": {
          "status": "ERROR"
        }
      }
    },
    "dest": {
      "index": "archived-error-metrics-2019.01.03"
    }
}'
```

Reindex the last 500 documents based on timestamp to a target index:

```
$ curl -XPOST -H 'Content-Type: application/json' 'http://127.0.0.1:9200/_reindex' -d '
  {
    "size": 500, 
    "source": {
      "index": "my-metrics-2019.01.03",
      "sort": {
        "timestamp": "desc"
      }
    }, 
    "dest": {
      "index": "archived-last500-metrics-2019.01.03", 
      "op_type": "create"
    }
}'
```

Reindex only specific fields to a target index:

```
$ curl -XPOST -H 'Content-Type: application/json' 'http://127.0.0.1:9200/_reindex' -d '
  {
    "source": {
      "index": "my-metrics-2019.01.03",
      "_source": [
        "response_code",
        "request_method",
        "referral"
      ]
    }, 
    "dest": {
      "index": "archived-subset-metrics-2019.01.03"
    }
}'
```

### Update Replicas Curl

Increase/Decrease the number of Replica Shards using the Settings API:

```
curl -XPUT -H 'Content-Type: application/json' 'http://127.0.0.1:9200/my-index-2018.12.31/_settings' \
  -d '{"index": {"number_of_replicas": 1, "refresh_interval": "30s"}}'
```

### Snapshots with Curl

View snapshot repositories:

```
curl -s -XGET 'http://127.0.0.1:9200/_snapshot?format=json'
{"cs-automated":{"type":"s3"},"es-index-backups":{"type":"s3"...
```

View snapshots under repository (table view):

```
curl -s -XGET 'http://127.0.0.1:9200/_cat/snapshots/index-backups?v'
# id, status, start_epoch, start_time, end_epoch, end_time, duration, indices, successful_shards, failed_shards, total_shards
snapshot_2019.05.23 SUCCESS
..
```

View snapshots under repository (json view):

```
curl -s -XGET 'http://127.0.0.1:9200/_cat/snapshots/es-index-backups?format=json'
[{"id":"snapshot_2019.05.23","status":"SUCCESS"....
```

Create a snapshot with all indices and wait for completion:

```
curl -XPUT -H 'Content-Type: application/json' 'http://127.0.0.1:9200/_snapshot/index-backups/my-es-snapshot-latest?wait_for_completion=true'
```

View snapshot status:

```
curl -s -XGET 'http://127.0.0.1:9200/_cat/tasks?detailed'
# cluster:admin/snapshot/create ..
```

View snapshot info:

```
curl -s 'http://127.0.0.1:9200/_snapshot/es-index-backups/my-es-snapshot-latest' | jq .
```

### Restore Snapshots with Curl

Restore with original names:

```
curl -XPOST -H 'Content-Type: application/json' 'http://127.0.0.1:9200/_snapshot/es-index-backups/test-snapshot-latest/_restore' -d '
{
  "indices": [
    "kibana_sample_data_ecommerce", "kibana_sample_data_logs"
  ], 
  "ignore_unavailable": false, 
  "include_global_state": false 
}'
```
```
curl 'http://127.0.0.1:9200/_cat/indices/kibana_sample*?v'
health status index
green  open   kibana_sample_data_logs
green  open   kibana_sample_data_ecommerce
```

Restore and rename:

```
curl -XPOST -H 'Content-Type: application/json' 'http://127.0.0.1:9200/_snapshot/es-index-backups/test-snapshot-latest/_restore' -d '
{
  "indices": [
    "kibana_sample_data_ecommerce", "kibana_sample_data_logs"
  ], 
  "ignore_unavailable": false, 
  "include_global_state": false, 
  "rename_pattern": "(.+)", 
  "rename_replacement": "restored_index_$1" 
}'
```
```
curl 'http://127.0.0.1:9200/_cat/indices/*restored*?v'
health status index
green  open   restored_index_kibana_sample_data_ecommerce 
green  open   restored_index_kibana_sample_data_logs
```

Restore and rename with a different name pattern:

```
curl -XPOST -H 'Content-Type: application/json' 'http://127.0.0.1:9200/_snapshot/es-index-backups/test-snapshot-latest/_restore' -d '
{ 
  "indices": [
    "kibana_sample_data_ecommerce", "kibana_sample_data_logs"
  ], 
  "ignore_unavailable": false, 
  "include_global_state": false, 
  "rename_pattern": 
  "kibana_sample_data_(.+)", 
  "rename_replacement": "restored_index_$1" 
}'
```
```
curl 'http://127.0.0.1:9200/_cat/indices/*restored*?v'
health status index                                       
green  open   restored_index_ecommerce                    
green  open   restored_index_logs                         
```

### Tasks

View tasks in table format:

```
$ curl -s -XGET 'http://127.0.0.1:9200/_cat/tasks?v&detailed' 
action                         task_id                          parent_task_id                   type      start_time    timestamp running_time ip            node    description
cluster:monitor/nodes/stats    DzSOmlH3RRaLGA33QJl3Bg:137161492 -                                transport 1566542180463 23:36:20  1.1s         x.x.x.x DzSOmlH 
cluster:monitor/nodes/stats[n] C50akcLqScuJDwLx2nk9UA:95915234  DzSOmlH3RRaLGA33QJl3Bg:137161492 netty     1566542180464 23:36:20  1.1s         x.x.x.x  C50akcL 
indices:data/write/bulk        yZXq8fZWRjiurCvtO7tSpQ:92155276  -                                transport 1566542181565 23:36:21  23ms         x.x.x.x yZXq8fZ requests[83], indices[logstash-logs-2019.08]
```

View tasks in json format:

```
$ curl -s -XGET 'http://127.0.0.1:9200/_tasks?detailed&format=json' 
{"nodes":{"xx":{"name":"xx","roles":["data","ingest"],"tasks":{"xx:xx":{"node":"xx","id":xx,"type":"transport","action":"cluster:monitor/nodes/stats"
```

View tasks in json format and pretty print:

```
$ curl -s -XGET 'http://127.0.0.1:9200/_tasks?detailed&pretty&format=json' 
{
  "nodes" : {
    "xx" : {
      "name" : "xx",
      "roles" : [ "data", "ingest" ],

```

View all tasks relating to snapshots being created:

```
$ curl -s -XGET 'http://127.0.0.1:9200/_tasks?detailed=true&pretty&actions=cluster:admin/snapshot/create'
```

View all tasks relating to write actions:

```
$ curl -s -XGET "http://127.0.0.1:9200/_tasks?detailed=true&pretty&actions=indices:*/write*"
{
  "nodes" : {
    "DzSOmlH3RRaLGA33QJl3Bg" : {
      "name" : "xx",
      "roles" : [ "data", "ingest" ],
      "tasks" : {
        "nodeX:idY" : {
          "node" : "nodeX",
          "id" : idY,
          "type" : "netty",
          "action" : "indices:data/write/bulk[s]",
          "status" : {
            "phase" : "waiting_on_primary"
          },
          "description" : "requests[5], index[logstash-logs-2019.08]",
          "start_time_in_millis" : 1566542804806,
          "running_time_in_nanos" : 65730,
          "cancellable" : false,
          "parent_task_id" : "nodeA:idZ",
          "headers" : { }
        }
      }
    },
```

Create a Task:

```
$ curl -XPOST -H 'Content-Type: application/json' 'http://127.0.0.1:9200/_reindex?wait_for_completion=false' -d '{"source": {"index": "metricbeat-2019.*"}, "dest": {"index": "metricbeat-2019"}}'
{"task":"-thJvCFgQlusd2vVFZGOfg:26962"}
```

View Task Status by TaskId:

```
$ curl http://localhost:9200/_tasks/-thJvCFgQlusd2vVFZGOfg:26962?pretty
{
  "completed" : true,
  "task" : {
    "node" : "-thJvCFgQlusd2vVFZGOfg",
    "id" : 26962,
    "type" : "transport",
    "action" : "indices:data/write/reindex",
...
  }
}
```

Some of the other actions:

```
"action" : "cluster:monitor/tasks/lists
"action" : "cluster:monitor/tasks/lists
"action" : "cluster:monitor/nodes/stats"
"action" : "cluster:admin/snapshot/create"
"action" : "internal:cluster/snapshot/update_snapshot_status"
"action" : "indices:data/read/search
 - "description": (context of query)
"action" : "indices:data/read/msearch"
"action" : "indices:data/write/bulk
```

### External Resources
- http://elasticsearch-cheatsheet.jolicode.com/
