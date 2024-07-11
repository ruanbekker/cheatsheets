# cassandra-cheatsheet

## Cassandra Client

### Installing cqlsh

To install the `cqlsh` client on alpine linux:

```bash
apk --no-cache add python3 py3-pip
pip3 install cqlsh
```

### Connecting to Cassandra

From the same node:

```bash
cqlsh -u user -p password
```

Over the network:

```bash
CQLSH_HOST=cassandra.databases CQLSH_PORT=9042 cqlsh -u user -p password
```

### Describe Keyspaces

```sql
DESCRIBE keyspaces;
```
