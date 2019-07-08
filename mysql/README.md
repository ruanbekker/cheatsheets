## MySQL Cheatsheet

* [Get Size in MB](#get-size-in-mb)

## Get Size in MB

```
SELECT table_schema "Data Base Name", 
sum( data_length + index_length ) / 1024 / 
1024 "Data Base Size in MB", 
sum( data_free )/ 1024 / 1024 "Free Space in MB" 
FROM information_schema.TABLES 
GROUP BY table_schema ;
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
