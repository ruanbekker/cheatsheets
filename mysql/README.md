# MySQL Cheatsheet

* [Changing Tables](#changing-tables)
* [Check and Repair Tables](#check-and-repair-tables)
* [Create Tables](#create-tables)
* [Delete](#delete)
* [Get Size in MB](#get-size-in-mb)
* [Indexes](#indexes)
* [Insert Data](#insert-data)
* [Performance Schema Metrics](#performance-schema-metrics)
* [Permissions](#permissions)
* [Repair Table](#repair-table)

## Permissions

Create Database:

```
mysql> CREATE DATABASE my_db;
```

Create User:

```
mysql> CREATE USER 'user1'@'%' IDENTIFIED BY 'securepass';
```

Grant User all Permissions to Database:

```
mysql> GRANT ALL PRIVILEGES ON my_db.* TO 'user1'@'%';
```

Grant User all Permissions to Database in AWS RDS:

```
mysql> GRANT SELECT, UPDATE, DELETE, INSERT, CREATE, DROP, INDEX, ALTER, LOCK TABLES, EXECUTE, CREATE TEMPORARY TABLES, EXECUTE, TRIGGER, CREATE VIEW, SHOW VIEW, EVENT ON my_db.* TO user1@'%';
```

Flush:

```
mysql> FLUSH PRIVILEGES;
```

## Create Tables


Create a table:

```
mysql> CREATE TABLE domains (
  id INT(10) NOT NULL AUTO_INCREMENT,
  domain varchar(50) NOT NULL, 
  owner  varchar(50),
  year_registered int(4)
);
```

Create a table with primary key:

```
mysql> CREATE TABLE domains (
  id INT(10) NOT NULL AUTO_INCREMENT,
  domain varchar(50) NOT NULL, 
  owner  varchar(50),
  year_registered int(4),
  PRIMARY KEY (domain) 
);
```

Create a table as a select query:

```
mysql> CREATE TABLE purchases_fnb_2016 
       AS 
         SELECT * FROM customers where date >= '2016-01-01 00:00:00' 
         AND date  <= '2016-10-29 00:00:00' 
         AND bank = 'fnb'
;
```

Create a table with a boolean data type:

```
CREATE TABLE myusers(name VARCHAR(50), matriculated BOOLEAN);
```

Insert with boolean data:

```
INSERT INTO myusers VALUES('tom', False);
```

Read data:

```
mysql> select name, matriculated from myusers limit 1;
+------+--------------+
| name | matriculated |
+------+--------------+
| tom  |            0 |
+------+--------------+
```

Use IF statement and replace value:

```
mysql> select name, IF(matriculated, 'yes', 'no') matriculated from myusers limit 1;
+------+--------------+
| name | matriculated |
+------+--------------+
| tom  | no           |
+------+--------------+
```

To query for people not matriculated:

```
mysql> select name, IF(matriculated, 'yes', 'no') matriculated from myusers where matriculated = false limit 1;
+------+--------------+
| name | matriculated |
+------+--------------+
| tom  | no           |
+------+--------------+

# you can use it without the if
```

To view unique values:

```
mysql> select distinct country from people;
+---------+
| country |
+---------+
| MOZ     |
| NGA     |
| KEN     |
| ZWE     |
| IND     |
| GHA     |
+---------+
```

## Changing Tables

Changing the column length:

```
mysql> ALTER TABLE contacts_business CHANGE COLUMN contact_number contact_number varchar(40);
```

## Check and Repair Tables

Check all tables in mailscanner db:

```
$ mysqlcheck -c mailscanner -u root -p
```

Check all tables all dbs:

```
$ mysqlcheck -c  -u root -p --all-databases
```

Check one table:

```
$ check table maillog;
```

analyzes employee table that is located in thegeekstuff database:

```
$ mysqlcheck -a thegeekstuff employee -u root -p
```

optimizes employee table that is located in thegeekstuff database.

```
$ mysqlcheck -o thegeekstuff employee -u root -p
```

repairs employee table that is located in thegeekstuff database.

```
$ mysqlcheck -r thegeekstuff employee -u root -p
```

checks, optimizes and repairs all the corrupted table in thegeekstuff database.

```
$ mysqlcheck -u root -p --auto-repair -c -o thegeekstuff
```

optimize and repair all the tables across all your databases using the following command.

```
$ mysqlcheck -u root -p --auto-repair -c -o --all-databases
```

## Delete

Delete data older than x:

```
mysql> delete from maillog where timestamp < "2012-09-07";
mysql> optimize table maillog;
```

## Get Size in MB

```
SELECT table_schema "Data Base Name", 
sum( data_length + index_length ) / 1024 / 
1024 "Data Base Size in MB", 
sum( data_free )/ 1024 / 1024 "Free Space in MB" 
FROM information_schema.TABLES 
GROUP BY table_schema ;
```

## Indexes

Add a index to an existing table:

```
mysql> DESCRIBE salaries;
+-----------+---------+------+-----+---------+-------+
| Field     | Type    | Null | Key | Default | Extra |
+-----------+---------+------+-----+---------+-------+
| emp_no    | int(11) | NO   | PRI | NULL    |       |
| salary    | int(11) | NO   |     | NULL    |       |
| from_date | date    | NO   | PRI | NULL    |       |
| to_date   | date    | NO   |     | NULL    |       |
+-----------+---------+------+-----+---------+-------+
4 rows in set (0.00 sec)


ALTER TABLE salaries ADD INDEX ( salary );
```

## Insert Data

Insert data into our domain table

```
mysql> INSERT INTO domains (domain,owner,year_registered) VALUES("example.com", "John", 2019);
```

## Information Schema

Show me idle connections:

```
mysql> select id, user, host, db, command, time from information_schema.processlist where command = "sleep";
+-----------+-------+---------------------+--------+---------+------+
| id        | user  | host                | db     | command | time |
+-----------+-------+---------------------+--------+---------+------+
| 659558686 | james | 172.31.27.126:37154 | mydb12 | Sleep   |  332 |
```

Show me connected sessions:

```
mysql> select count(*) from information_schema.processlist;
+----------+
| count(*) |
+----------+
|       60 |
+----------+

or

mysql> show status where variable_name = 'threads_connected';
+-------------------+-------+
| Variable_name     | Value |
+-------------------+-------+
| Threads_connected | 61    |
+-------------------+-------+
```

Show connection related variables:

```
mysql> SHOW VARIABLES LIKE '%connections%';
+-----------------------+-------+
| Variable_name         | Value |
+-----------------------+-------+
| extra_max_connections | 1     |
| max_connections       | 1296  |
| max_user_connections  | 0     |
+-----------------------+-------+
3 rows in set (0.16 sec)
```

or"

```
mysql> show status like '%onn%';
+-----------------------------------------------+-----------+
| Variable_name                                 | Value     |
+-----------------------------------------------+-----------+
| Aborted_connects                              | 35        |
| Connection_errors_accept                      | 0         |
| Connection_errors_internal                    | 0         |
| Connection_errors_max_connections             | 0         |
| Connection_errors_peer_address                | 0         |
| Connection_errors_select                      | 0         |
| Connection_errors_tcpwrap                     | 0         |
| Connections                                   | 66059     |
| Max_used_connections                          | 502       |
| Performance_schema_session_connect_attrs_lost | 0         |
| Slave_connections                             | 0         |
| Slaves_connected                              | 1         |
| Ssl_client_connects                           | 0         |
| Ssl_connect_renegotiates                      | 0         |
| Ssl_finished_connects                         | 0         |
| Threads_connected                             | 46        |
| wsrep_connected                               | OFF       |
+-----------------------------------------------+-----------+
17 rows in set (0.16 sec)
```

Show me cache information:

```
mysql> SHOW VARIABLES LIKE 'have_query_cache';
mysql> SHOW STATUS LIKE 'Qcache%';
```

Show me how long a connection can idle:

```
# https://aws.amazon.com/blogs/database/best-practices-for-configuring-parameters-for-amazon-rds-for-mysql-part-3-parameters-related-to-security-operational-manageability-and-connectivity-timeout/
mysql> SHOW VARIABLES LIKE 'wait_timeout';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| wait_timeout  | 28800 |
+---------------+-------+
```

Binlog format:

```
mysql> show variables like 'binlog_format';
```

## Performance Schema Metrics:

Execution time of all the different statement types executed by each user:

```
mysql> select * from sys.user_summary_by_statement_type;
+------------+----------------+-------+---------------+-------------+--------------+-----------+---------------+---------------+------------+
| user       | statement      | total | total_latency | max_latency | lock_latency | rows_sent | rows_examined | rows_affected | full_scans |
+------------+----------------+-------+---------------+-------------+--------------+-----------+---------------+---------------+------------+
| background | select         |     1 | 212.00 us     | 212.00 us   | 0 ps         |         1 |             0 |             0 |          0 |
| root       | insert         |   175 | 46.26 s       | 823.43 ms   | 6.33 s       |         0 |             0 |       3919027 |          0 |
| root       | select         |    50 | 12.21 s       | 10.00 s     | 10.41 ms     |       223 |       7498268 |             0 |         17 |
```

Slowest statements (those in the 95th percentile by runtime):

```
mysql> select * from sys.statements_with_runtimes_in_95th_percentile\G
*************************** 1. row ***************************
            query: SELECT `sleep` (?)
               db: sys
        full_scan:
       exec_count: 1
        err_count: 0
       warn_count: 0
    total_latency: 10.00 s
      max_latency: 10.00 s
      avg_latency: 10.00 s
        rows_sent: 1
    rows_sent_avg: 1
    rows_examined: 0
rows_examined_avg: 0
       first_seen: 2019-07-04 11:21:23.155084
        last_seen: 2019-07-04 11:21:23.155084
           digest: x
```

Number of queries that generated errors or warnings:

```
mysql> SELECT SUM(errors) FROM sys.statements_with_errors_or_warnings;
+-------------+
| SUM(errors) |
+-------------+
|           4 |
+-------------+
```

## Repair Table

```
mysql> repair table x;
mysql> optimize table x;
```

## External Resources:

- https://www.mysqltutorial.org/mysql-inner-join.aspx/
- https://www.mysqltutorial.org/mysql-index/mysql-create-index/
