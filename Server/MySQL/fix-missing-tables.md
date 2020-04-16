# MySQL: Fix missing tables

**Error:** Table 'mysql.innodb_index_stats' doesn't exist in engine

## Check tables

```bash
mysqlcheck -uadmin -p mysql
```

## Get create table code

*Note: If you no longer have access to the create code, install a second MySQL in the virtual machine.*

Log into mysql:

```bash
mysql -uadmin -p
```

Switch to database and get table create code:

```sql
use mysql;
SHOW CREATE TABLE innodb_index_stats\G;
```

## Fix lost table

Log into mysql:

```bash
mysql -uadmin -p
```

Switch to database and drop table:

```sql
use mysql;
DROP TABLE `innodb_index_stats`;
```

Remove old files:

```bash
cd /var/lib/mysql/mysql
rm innodb_index_stats.*
```

Create new table:

```sql
CREATE TABLE `innodb_index_stats` (...) ENGINE=InnoDB ... STATS_PERSISTENT=0;
```

Restart mysql server:

```bash
systemctl restart mysql
```

Check MySQL tables:

```bash
mysqlcheck -uadmin -p mysql
```
