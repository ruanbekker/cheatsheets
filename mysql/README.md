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
