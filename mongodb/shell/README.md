# MongoDB Cheatsheet

A cheatsheet of MongoDB using the mongo shell

## Table of Contents

- [Definitions](#definitions)
- [View Databases](#view-databases)
- [Collections](#collections)
- [Write to MongoDB](#write-to-mongodb)
- [Read from MongoDB](#read-from-mongodb)
- [External Resources](#external-resources)
 
## Definitions

- A field in mongodb : {`"key": "value"`}
- A field consist of a key and value
- A operator like `gte` or `lt` can be used

## Create a MongoDB Instance

Create a instance with docker and connect to the shell

```
docker run --rm -itd --name mongodb -e MONGO_INITDB_ROOT_USERNAME=root -e MONGO_INITDB_ROOT_PASSWORD=password -p 27017:27017 mongo:4.4
docker exec -it mongodb mongo -u "root" -p "password" --authenticationDatabase "admin"
> 
```

## View Databases

View existing databases:

```
> show dbs
admin   0.000GB
config  0.000GB
local   0.000GB
```

Create or switch to a database:

```
> use mydb
switched to db mydb
```

View current database:

```
> db
mydb
```

## Collections

Create a collection:

```
> db.createCollection("mycol1")
{ "ok" : 1 }
> db.createCollection("mycol2")
{ "ok" : 1 }
```

View collections:

```
> show collections
mycol1
mycol2
```

## Write to MongoDB

Insert data into a collection:

```
> db.mycol1.insert({"name": "ruan", "age": 32, "hobbies": ["golf", "programming", "music"]})
WriteResult({ "nInserted" : 1 })
> db.mycol1.insert({"name": "michelle", "age": 28, "hobbies": ["art", "music", "reading"]})
WriteResult({ "nInserted" : 1 })
```

## Read from MongoDB

Read all the data from a collection, similar to:

- `select * from mycol1` :

```
> db.mycol1.find()
{ "_id" : ObjectId("5cc60c8ebdbf7f5dd3f7cdc3"), "name" : "ruan", "age" : 32, "hobbies" : [ "golf", "programming", "music" ] }
{ "_id" : ObjectId("5cc60cacbdbf7f5dd3f7cdc4"), "name" : "michelle", "age" : 28, "hobbies" : [ "art", "music", "reading" ] }
```

Using pretty printing:

```
> db.mycol1.find().pretty()
{
	"_id" : ObjectId("5cc60c8ebdbf7f5dd3f7cdc3"),
	"name" : "ruan",
	"age" : 32,
	"hobbies" : [
		"golf",
		"programming",
		"music"
	]
}
{
	"_id" : ObjectId("5cc60cacbdbf7f5dd3f7cdc4"),
	"name" : "michelle",
	"age" : 28,
	"hobbies" : [
		"art",
		"music",
		"reading"
	]
}
```

Select only the name and age key, similar to:

- `select name, age from mycol1` :

```
> db.mycol1.find({}, {"name": 1, "age": 1, "_id": 0})
{ "name" : "ruan", "age" : 32 }
{ "name" : "michelle", "age" : 28 }
```

Select only the data where the age is equal to something, similar to:
- `select name, age from mycol1 where age = 32` :

```
> db.mycol1.find({"age": 32}, {"name": 1, "age": 1, "_id": 0})
{ "name" : "ruan", "age" : 32 }
````

Return the name from a given document id, similar to:
- `select name from mycol1 where id = xx` :

```
> db.mycol1.findOne({_id: ObjectId("5cc60c8ebdbf7f5dd3f7cdc3")}).name
ruan
```

Find documents older than a specific age:

```
> db.mycol1.find({"age": {"$gt": 30}})
{ "_id" : ObjectId("5cc60c8ebdbf7f5dd3f7cdc3"), "name" : "ruan", "age" : 32, "hobbies" : [ "golf", "programming", "music" ] }
```

## External Resources
- [MongoDB Cheatsheet #1](https://gist.github.com/rbekker87/5b4cd9ef36b6ae092a6260ab9e621a43)
- [@aponxi](https://gist.github.com/aponxi/4380516)
- [@michaeltreat](https://gist.github.com/michaeltreat/d3bdc989b54cff969df86484e091fd0c)
