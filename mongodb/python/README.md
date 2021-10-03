# PyMongo Cheatsheet

## Resources
- https://pymongo.readthedocs.io/en/stable/examples/authentication.html

WIP

Create a running environment:

```bash
docker run -it python:3.8 bash
```

Update the hostnames to the ip's of our mongodb (see `docker-compose-rs.yml`)

```bash
MONGO_IP=192.168.0.8
cat >> /etc/hosts << EOF
$MONGO_IP     mongodb-rs-0
$MONGO_IP     mongodb-rs-1
$MONGO_IP     mongodb-rs-2
EOF
```

For my use-case it looks like this:

```bash
cat /etc/hosts
127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
172.17.0.2      733ed18bf690
192.168.0.8     mongodb-rs-0
192.168.0.8     mongodb-rs-1
192.168.0.8     mongodb-rs-2
```

Install pymongo

```bash
python3 -m pip install pymongo
```

Enter python

```bash
python3
Python 3.8.12 (default, Sep 28 2021, 19:06:31)
[GCC 10.2.1 20210110] on linux
Type "help", "copyright", "credits" or "license" for more information.
```

Create a client:

```python
>>> from pymongo import MongoClient
>>> mongodb_uri = "mongodb://mongodb-rs-0:30001,mongodb-rs-1:30002,mongodb-rs-2:30003/?replicaSet=rs0"
>>> client = MongoClient(mongodb_uri)
```

## New Database and New Collection

List database names:

```python
>>> client.list_database_names()
['admin', 'config', 'crypto_wallets', 'local', 'slack']
```

Define a new db and collection:

```python
>>> db = client.testdb
>>> collection = db.test_collection
```

Write a document into the collection:

```python
>>> collection.insert_one({"name": "james", "country": "south africa"}).inserted_id
ObjectId('615999c248185d3efbc55561')
```

## Existing Database and Existing Collection:

List database names:

```python
>>> client.list_database_names()
['admin', 'config', 'crypto_wallets', 'local', 'slack']
```

List Collections:

```python
>>> client.testdb.list_collection_names()
['test_collection']
```

List collections:

```python
>>> db = client.crypto_wallets
>>> db.list_collection_names()
['balances']
```

Find all documents in the collection:

```
>>> balances = db.balances
>>> cursor = balances.find({})
>>> for doc in cursor:
...     print(doc)

{'_id': ObjectId('6159802db8f15fced7ea1df7'), 'timestamp': datetime.datetime(2021, 10, 3, 10, 4, 30, 927000), 'crypto_symbol': 'DASH', 'crypto_name': 'Dash', 'balance': 3820.58241136, 'node_name': 'rpi-05', 'network_name': 'testnet', 'wallet_name': 'main', 'txid': 'd77610c2f2020dc12e1170ed67e0c20ddc3e45fdea49421e07e4310668800eb5'}
{'_id': ObjectId('615982182cf3f371b507ce1a'), 'timestamp': datetime.datetime(2021, 10, 3, 10, 12, 41, 126000), 'crypto_symbol': 'DASH', 'crypto_name': 'Dash', 'balance': 3828.34261545, 'node_name': 'rpi-05', 'network_name': 'testnet', 'wallet_name': 'main', 'txid': '0b84a82c2e3506d8fbed3b7ed7a6a330c54eb13a383c338400fb01f6cb618d05'}
>>>
```

Count all the documents:

```
>>> balances.find({}).count()
134
```

Find all documents with missing keys ('txid')

```
>>> balances.find({"txid": None}).count()
33
```

Or you can find missing keys like the following:

```
>>> balances.find({"txid": {"$exists": False}}).count()
33
```

Resource:
- https://docs.mongodb.com/manual/tutorial/query-for-null-fields/

Delete one document with a missing field 'txid':

```python
>>> balances.delete_one({"txid": {"$exists": False}})
<pymongo.results.DeleteResult object at 0x7f6058086440>
```

When we search for all documents with missing txid as fields, we can see one less:

```python
>>> balances.find({"txid": {"$exists": False}}).count()
32
```

Delete all documents with missing fields for txid:

```python
>>> result = balances.delete_many({"txid": {"$exists": False}})
```

We can access the deleted_count method to return the number of deleted documents:

```python
>>> result.deleted_count
31
```

Now when we find the documents with missing fields of txid it should show zero:

```python
>>> balances.find({"txid": {"$exists": False}}).count()
0
```

Now when we search for documents with txid as existing fields, it should show the same as all the documents:

```python
>>> balances.find({"txid": {"$exists": True}}).count()
101
>>> balances.find({}).count()
101
```

Resource:
- https://docs.mongodb.com/manual/tutorial/remove-documents/

We can find one document with the txid as the given one below as such:

```python
>>> cursor = balances.find({"txid": "0b84a82c2e3506d8fbed3b7ed7a6a330c54eb13a383c338400fb01f6cb618d05"})
>>> cursor
<pymongo.cursor.Cursor object at 0x7f6052cf4970>
>>> [doc for doc in cursor]
[{'_id': ObjectId('615982182cf3f371b507ce1a'), 'timestamp': datetime.datetime(2021, 10, 3, 10, 12, 41, 126000), 'crypto_symbol': 'DASH', 'crypto_name': 'Dash', 'balance': 3828.34261545, 'node_name': 'rpi-05', 'network_name': 'testnet', 'wallet_name': 'main', 'txid': '0b84a82c2e3506d8fbed3b7ed7a6a330c54eb13a383c338400fb01f6cb618d05'}]
```
