# PyMongo Cheatsheet

WIP

```
docker run -it python:3.8 bash
```

```
MONGO_IP=192.168.0.8
cat >> /etc/hosts << EOF
$MONGO_IP     mongodb-rs-0
$MONGO_IP     mongodb-rs-1
$MONGO_IP     mongodb-rs-2
EOF
```

```
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

```
python3 -m pip install pymongo
```

```
python3
Python 3.8.12 (default, Sep 28 2021, 19:06:31)
[GCC 10.2.1 20210110] on linux
Type "help", "copyright", "credits" or "license" for more information.
```

```
>>> from pymongo import MongoClient
>>> mongodb_uri = "mongodb://mongodb-rs-0:30001,mongodb-rs-1:30002,mongodb-rs-2:30003/?replicaSet=rs0"
>>> client = MongoClient(mongodb_uri)
>>> client.list_database_names()
['admin', 'config', 'crypto_wallets', 'local', 'slack']
>>> db = client.crypto_wallets
>>> db.list_collection_names()
['balances']
```

```
>>> balances = db.balances
>>> cursor = balances.find({})
>>> for doc in cursor:
...     print(doc)

{'_id': ObjectId('6159802db8f15fced7ea1df7'), 'timestamp': datetime.datetime(2021, 10, 3, 10, 4, 30, 927000), 'crypto_symbol': 'DASH', 'crypto_name': 'Dash', 'balance': 3820.58241136, 'node_name': 'rpi-05', 'network_name': 'testnet', 'wallet_name': 'main', 'txid': 'd77610c2f2020dc12e1170ed67e0c20ddc3e45fdea49421e07e4310668800eb5'}
{'_id': ObjectId('615982182cf3f371b507ce1a'), 'timestamp': datetime.datetime(2021, 10, 3, 10, 12, 41, 126000), 'crypto_symbol': 'DASH', 'crypto_name': 'Dash', 'balance': 3828.34261545, 'node_name': 'rpi-05', 'network_name': 'testnet', 'wallet_name': 'main', 'txid': '0b84a82c2e3506d8fbed3b7ed7a6a330c54eb13a383c338400fb01f6cb618d05'}
>>>
```

```
>>> balances.find({}).count()
134
>>> balances.find({"txid": None}).count()
33
```

```
>>> balances.find({"txid": {"$exists": False}}).count()
33
```

- https://docs.mongodb.com/manual/tutorial/query-for-null-fields/

```
>>> balances.delete_one({"txid": {"$exists": False}})
<pymongo.results.DeleteResult object at 0x7f6058086440>
>>> balances.find({"txid": {"$exists": False}}).count()
32
```

```
>>> result = balances.delete_many({"txid": {"$exists": False}})
>>> result.deleted_count
31
```

```
>>> balances.find({"txid": {"$exists": False}}).count()
0
```

```
>>> balances.find({"txid": {"$exists": True}}).count()
101
>>> balances.find({}).count()
101
```

https://docs.mongodb.com/manual/tutorial/remove-documents/

```
>>> cursor = balances.find({"txid": "0b84a82c2e3506d8fbed3b7ed7a6a330c54eb13a383c338400fb01f6cb618d05"})
>>> cursor
<pymongo.cursor.Cursor object at 0x7f6052cf4970>
>>> [doc for doc in cursor]
[{'_id': ObjectId('615982182cf3f371b507ce1a'), 'timestamp': datetime.datetime(2021, 10, 3, 10, 12, 41, 126000), 'crypto_symbol': 'DASH', 'crypto_name': 'Dash', 'balance': 3828.34261545, 'node_name': 'rpi-05', 'network_name': 'testnet', 'wallet_name': 'main', 'txid': '0b84a82c2e3506d8fbed3b7ed7a6a330c54eb13a383c338400fb01f6cb618d05'}]
```
