# Elasticsearch Cheatsheet

My Elasticsearch Cheatsheet using Python

- [using Python](python-elasticsearch.md#python-library)
  - [Ingest](python-elasticsearch.md#ingest-using-python)
- [Using cURL](README.md#using-curl)
  - [Cluster Health](README.md#health-with-curl)
  - [Reindex](README.md#reindex-using-curl)
  - [Update Replica Shards](README.md#update-replicas-curl)
  - [Snapshots](README.md#snapshots-with-curl)
  - [Restore Snapshots](README.md#restore-snapshots-with-curl)

## Python Library

#### Create a Client with Python

Using IAM Auth for AWS Elasticsearch

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

#### Ingest using Python

Create a document and specify a `id`:

```
res = es.index(index="test-index", doc_type='tweet', id=1, body=doc)
```

#### Bulk Ingest using Python

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

