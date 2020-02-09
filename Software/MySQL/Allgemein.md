# MySQL

[HeidiSQL](https://www.heidisql.com/)

## User configuration

File `~/.my.cnf`:

```ini
[client]
user=dev
password=dev
```

## Global configuration

File `/etc/mysql/conf.d/mysql.cnf`:

```ini
[mysqld]
character-set-server=utf8
collation-server=utf8_general_ci
```

## Synchronize database

```bash
# Enter with password
ssh {server} 'mysqldump -u{username} -p{password} {database-remote}' | mysql -u{username} -p{password} {database-local}

# Only if access data is stored in .my.cnf
ssh {server} 'mysqldump {database-remote}' | mysql {database-local}
```

## Export database

```bash
# Dump with date
mysqldump {Database} > {filename}_`date +%F_%H-%M-%S`.sql
mysqldump -u{User} -p {Database} > {filename}_`date +%F_%H-%M-%S`.sql

# Short
mysqldump {database} > {filename}.sql

# Multiple database tables
mysqldump {database} {table1} {table2} > {filename}.sql

# Dump als XML
mysqldump --xml {database} {table1} > {filename}.sql

# Complete
mysqldump -h{host} -u{username} -p{password} {database} > {filename}.sql

# All databases
mysqldump --all-databases > {filename}.sql

# All databases, but only the database structure
mysqldump --no-data --all-databases > {filename}.sql
```

## Import database

```bash
# Short
mysql {database} < {filename}.sql

# Complete
mysql -h{host} -u{username} -p{password} {database} < {filename}.sql
```

## Reset database root password

https://dev.mysql.com/doc/refman/5.7/en/resetting-permissions.html

```bash
/etc/init.d/mysql stop

# MySQL 5.7
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root';" > /tmp/setRootPassword.sql

# MySQL 5.6 and earlier
echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('root');" > /tmp/setRootPassword.sql

mysqld_safe --init-file=/tmp/setRootPassword.sql &
# Press Ctrl + c

rm /tmp/setRootPassword.sql
/etc/init.d/mysql start
```

## Import several SQL files in .tar.gz into the MySQL database

```bash
tar -xzOf {file.tar.gz} | mysql {database}
```

## Check databases after server crash

```bash
mysqlcheck -u {username} --all-databases --medium-check -p
```

## Database permissions

### Start MySQL without permissions

```bash
sudo service mysql stop
sudo mysqld --skip-grant-tables &
mysql -u root mysql
```
### Set password or create new user

```sql
/* Set password */
UPDATE `user` SET `Password` = PASSWORD('{NewPassword}') WHERE `User` = 'root';

/* Create new root user */
GRANT ALL PRIVILEGES ON *.* TO '{username}'@'localhost' IDENTIFIED BY '{password}' WITH GRANT OPTION;
FLUSH PRIVILEGES;

/* Create new user, allow database & tables, with password */
GRANT ALL PRIVILEGES ON {database}.{table} TO {username}@localhost IDENTIFIED BY '{password}';
FLUSH PRIVILEGES;
```
