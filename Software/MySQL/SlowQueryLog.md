# MySQL

## Activate slow query log

vim /etc/mysql/conf.d/mysql.cnf

```ini
[mysqld]
# Slow log
slow_query_log=1
slow_query_log_file=/var/log/mysql/slow-query.log
long_query_time=1
log_queries_not_using_indexes=1
```

Create log file and restart server.

```bash
touch /var/log/mysql/slow-query.log
chown mysql:adm /var/log/mysql/slow-query.log
chmod 640 slow-query.log
service mysql restart
```

Test slow query log:

```sql
/* Activate query log - Maybe useful to show errors */
SET GLOBAL SLOW_QUERY_LOG=ON;

/* Check if slow query log working */
SELECT SLEEP(2);
```
