Create database:

```
CREATE database foo;
```

Create role:

```
CREATE ROLE user1 WITH LOGIN PASSWORD 'secret';
```

List roles:

```
\du
```

Grant all privileges to database:

```
GRANT ALL PRIVILEGES ON DATABASE "foo" to user1;
```

Create user:

```
CREATE USER testuser with encrypted password 'sekretpw';
```

Grant privileges for user:

```
GRANT ALL PRIVILEGES ON database foo TO testuser;
```

Create a auto-incremental column:

```
CREATE TABLE fruits(id SERIAL PRIMARY KEY, name VARCHAR NOT NULL)
INSERT INTO fruits(id,name) VALUES(DEFAULT,'Apple');
```

Resources:

- https://www.digitalocean.com/community/tutorials/how-to-use-roles-and-manage-grant-permissions-in-postgresql-on-a-vps--2
- https://www.postgresqltutorial.com/postgresql-cheat-sheet/
- https://www.postgresqltutorial.com/postgresql-serial/
- https://blog.ruanbekker.com/blog/2019/03/06/create-users-databases-and-granting-access-for-users-on-postgresql/
