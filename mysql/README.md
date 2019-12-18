# MySQL Cheatsheet

* [Get Size in MB](#get-size-in-mb)

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
