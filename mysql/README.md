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
