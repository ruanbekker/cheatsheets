# Elasticsearch Cheatsheet

My Elasticsearch Cheatsheet using Python

- [Using Python Elasticsearch Library](python-elasticsearch.md#python-library)
  - [Authentication](python-elasticsearch.md#authenticate-with-http-basic-auth)
  - [Info](python-elasticsearch.md#elasticsearch-info-response)
  - [Ingest](python-elasticsearch.md#ingest)
  - [Bulk Ingest](python-elasticsearch.md#ingest)
- [Using Python Requests]()
  - [Create a Index]()
- [Using cURL](README.md#using-curl)
  - [Cluster Health](README.md#health-with-curl)
  - [Reindex](README.md#reindex-using-curl)
  - [Update Replica Shards](README.md#update-replicas-curl)
  - [Snapshots](README.md#snapshots-with-curl)
  - [Restore Snapshots](README.md#restore-snapshots-with-curl)

## Python Library

#### Create a Client with Python

Using IAM Authentication for AWS Elasticsearch

```
from elasticsearch import Elasticsearch, RequestsHttpConnection, helpers
from requests_aws4auth import AWS4Auth

aws_auth = AWS4Auth(access_key, secret_key, AWS_REGION, 'es', session_token=token)
es = Elasticsearch(
    hosts = [{'host': ES_ENDPOINT, 'port': 443}], 
    http_auth=aws_credentials, use_ssl=True, verify_certs=True, 
    connection_class=RequestsHttpConnection
)
```

#### Authenticate with HTTP Basic Auth

```
from elasticsearch import Elasticsearch, RequestsHttpConnection, helpers

es = Elasticsearch(
    hosts = [{'host': ES_ENDPOINT, 'port': 443}], 
    http_auth=('user', 'password'), use_ssl=True, verify_certs=True, 
    connection_class=RequestsHttpConnection
)
```

#### Elasticsearch Info Response

Get a response from ES:

```
>>> es.info()
{'name': 'elasticsearch-02', 'cluster_name': 'es-cluster', 'cluster_uuid': 'EJDqv5VrQyao07ndQuwhCw', 'version': {'number': '6.8.2', 'build_flavor': 'default', 'build_type': 'deb', 'build_hash': 'b506955', 'build_date': '2019-07-24T15:24:41.545295Z', 'build_snapshot': False, 'lucene_version': '7.7.0', 'minimum_wire_compatibility_version': '5.6.0', 'minimum_index_compatibility_version': '5.0.0'}, 'tagline': 'You Know, for Search'}
```

prettify:

```
>>> print(json.dumps(es.info(), indent=2))
{
  "name": "elasticsearch-02",
  "cluster_name": "es-cluster",
  "cluster_uuid": "EJDqv5VrQyao07ndQuwhCw",
  "version": {
    "number": "6.8.2",
    "build_flavor": "default",
    "build_type": "deb",
    "build_hash": "b506955",
    "build_date": "2019-07-24T15:24:41.545295Z",
    "build_snapshot": false,
    "lucene_version": "7.7.0",
    "minimum_wire_compatibility_version": "5.6.0",
    "minimum_index_compatibility_version": "5.0.0"
  },
  "tagline": "You Know, for Search"
}
```

#### Ingest

Create a document and specify a `id`:

```
res = es.index(index="test-index", doc_type='tweet', id=1, body=doc)
```

#### Bulk Ingest

```
from elasticsearch import Elasticsearch, RequestsHttpConnection, helpers

bulk_docs = []
list_of_dicts = [{"name": "ruan", "age": 32}, {"name": "stefan", "age": 31}]

for doc in list_of_dicts:
    doc['_index'] = 'my-index-2019.06.12'
    doc['_type'] = '_doc'
    bulk_docs.append(doc)
    del doc
    
helpers.bulk(es, bulk_docs)
```

### View Indices

```
>>> es.indices.get_alias("*").keys()
dict_keys(['fluentd-2020.02.26', 'metricbeat-2020.02.25', 'filebeat-2020.02.25', 'fluentd-2020.02.25', '.tasks', 'fluentd-2020.02.24', 'metricbeat-2019', 'telegram-bot', '.kibana_1', 'metricbeat-2020.02.26', 'filebeat-2020.02.26', 'metricbeat-2020.02'])
```

### Search

Query: `{"query": {"match": {"text": "HI"}}}`

```
>>> es.search(index="telegram-bot", doc_type="_doc", body={"query": {"match": {"text": "HI"}}})
{'took': 335, 'timed_out': False, '_shards': {'total': 5, 'successful': 5, 'skipped': 0, 'failed': 0}, 'hits': {'total': 1, 'max_score': 0.6931472, 'hits': [{'_index': 'telegram-bot', '_type': '_doc', '_id': 'x', '_score': 0.6931472, '_source': {'message_id': x, 'date': x, 'text': 'HI', 'entities': [], 'caption_entities': [], 'photo': [], 'new_chat_members': [], 'new_chat_photo': [], 'delete_chat_photo': False, 'group_chat_created': False, 'supergroup_chat_created': False, 'channel_chat_created': False}}]}}

```

## Using Python Requests

### Create a Index:

```
>>> response = requests.put(
    'https://es.x.x/xstats', 
    auth=('username', 'pass'), 
    headers={'content-type': 'application/json'}, 
    json={'settings': {'number_of_shards': 2}}
)
```
