# https://pymongo.readthedocs.io/en/stable/examples/authentication.html?highlight=authentication
# example server: 
# - https://github.com/ruanbekker/cheatsheets/blob/master/mongodb/python/docker/docker-compose.yml

from pymongo import MongoClient
client = MongoClient("192.168.0.8:27017", username="root", password="pass", authSource="admin", authMechanism="SCRAM-SHA-256")
client.list_database_names()

# uri = "mongodb://root:pass@192.168.0.8:27017/?authSource=admin&authMechanism=SCRAM-SHA-256"
# client = MongoClient(uri)
# client.list_database_names()
