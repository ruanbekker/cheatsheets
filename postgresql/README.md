Create database:

```
CREATE database foo;
```

Create role:

```
CREATE ROLE user1 WITH LOGIN PASSWORD 'secret';
```

Grant all privileges to database:

```
GRANT ALL PRIVILEGES ON DATABASE "foo" to user1;
```
