# Elasticsearch Cheatsheet

- [Using cURL](#using-curl)
  - [Cluster Health](#health-with-curl)
  - [Reindex](#reindex-using-curl)
  - [Update Replica Shards](#update-replicas-curl)
  - [Snapshots](#snapshots-with-curl)
  - [Restore Snapshots](#restore-snapshots-with-curl)
- [using Python](python-elasticsearch.md#python-library)
  - [Ingest](python-elasticsearch.md#ingest-using-python)


## Using Curl

#### Health with Curl

View the cluster status:

```
curl -s -XGET 'http://127.0.0.1:9200_cluster/health?pretty'
```

Check all indices in yellow status:

```
curl -s -XGET 'http://127.0.0.1:9200/_cat/indices?v&health=yellow'
```

View recovery process:

```
curl -s -XGET 'http://127.0.0.1:9200/_cat/recovery?detailed&h=index,stage,time,bytes_percent'
```

#### Reindex using Curl

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

#### Update Replicas Curl

Increase/Decrease the number of Replica Shards using the Settings API:

```
curl -XPUT -H 'Content-Type: application/json' 'http://127.0.0.1:9200/my-index-2018.12.31/_settings' \
  -d '{"index": {"number_of_replicas": 1, "refresh_interval": "30s"}}'
```

#### Snapshots with Curl

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

#### Restore Snapshots with Curl

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

