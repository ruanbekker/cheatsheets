# mysqldump cheatsheet

## Backup One Database

```
mysqldump -h 127.0.0.1 -u admin -padmin --triggers --routines --events mydb > mydb_$(date +%F).sql
```

If you get a error in mysql 8 about unknown columns:

```
mysqldump --column-statistics=0 -h 127.0.0.1 --user admin -prootpassword mydb > mydb_$(date +%F).sql
```

## Backup All Databases

```
mysqldump -h 127.0.0.1 -u admin -padmin --triggers --routines --events --all-databases > alldbs_$(date +%F).sql
```

