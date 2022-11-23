# redis-cli

## Redis Server

There's a `docker-compose.yaml` in the directory, so you can just boot it with docker-compose;

```bash
docker-compose up -d
```

## Redis Cli

If you have `redis-cli` installed, you can connect to the redis-server on `localhost:6379`, but for convenience I am going to run a redis container and use it's redis-cli and connect to our redis-server running on `redis-server:6379`:

```bash
docker run -it --network app redis:7.0 redis-cli -h redis-server -p 6379
```

You should see:

```bash
redis-server:6379>
```

Since we are connected to the redis-server already, we can just run `INFO` instead of `redis-cli INFO`, if you ran this from a container it would be `docker run -it --network app redis:7.0 redis-cli -h redis-server -p 6379 INFO`.

So 3 different ways to run:

1. From your local workstation with redis-cli running: `redis-cli INFO`
2. Using a container and attach to the shell: `docker run -it --network app redis:7.0 bash` then run `redis-cli -h redis-server INFO`
3. Using a container and attach to the cli: `docker run -it --network app redis:7.0 redis-cli -h redis-server -p 6379`
4. Using a container and running it in one go: `docker run -it --network app redis:7.0 redis-cli -h redis-server -p 6379 redis-cli INFO`

I will be using the method to attach directly to the server:

```bash
docker run -it --network app redis:7.0 redis-cli -h redis-server
```

### Commands

Get info from the server:

```bash
redis-server:6379> INFO

# Server
redis_version:7.0.5
# Memory
used_memory:945592
used_memory_human:923.43K
# Persistence
loading:0
async_loading:0
# Stats
total_connections_received:1
total_commands_processed:1
instantaneous_ops_per_sec:0
...
```

View the config:

```bash
redis-server:6379> CONFIG GET *
```

Changing the database (the default database is 0):

```bash
redis-server:6379> SELECT 1
```

To view how many databases:

```bash
docker run -it --network app redis:7.0 bash
redis-cli -h redis-server INFO | grep ^db
```

To drop the currently selected database:

```bash
redis-server:6379> FLUSHDB
```

To drop all databases:

```bash
redis-server:6379> FLUSHALL
```

View all keys:

```bash
redis-server:6379> keys *
```

Set a key into the cache:

```bash
redis-server:6379> set name ruan
```

Read a value from the cache:

```bash
redis-server:6379> get name
```

### External Cheatsheet

- [lzone.de](https://lzone.de/cheat-sheet/Redis)
- [gist@LeCoupa](https://gist.github.com/LeCoupa/1596b8f359ad8812c7271b5322c30946)