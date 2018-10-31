---
author: Andrew B. Collier
draft: true
title: 'MySQL Replication Server'
tags: ["MySQL"]
date: 2018-09-17T02:00:00Z
---

<!-- https://www.digitalocean.com/community/tutorials/how-to-set-up-master-slave-replication-in-mysql -->

## Master

Make a backup copy of `/etc/mysql/mysql.conf.d/mysqld.cnf`. Now edit `/etc/mysql/mysql.conf.d/mysqld.cnf`.

{{< highlight text >}}
[mysqld]
server-id               = 1
log_bin                 = /var/log/mysql/mysql-bin.log
sync_binlog             = 1

# Which database are we replicating?
#
binlog_do_db            = master_database
{{< /highlight >}}

Create a user which will be used for replication.

{{< highlight bash >}}
GRANT REPLICATION SLAVE ON *.* TO 'replication_slave'@'%' IDENTIFIED BY 'hazIct0Ospurn';
FLUSH PRIVILEGES;
{{< /highlight >}}

You need to create a fixed copy of the database which will serve as the reference point from which replication will occur.

{{< highlight bash >}}
USE master_database;
FLUSH TABLES WITH READ LOCK;
SHOW MASTER STATUS;
{{< /highlight >}}

Take a snapshot of the results from the last command.

In a separate window or tab run the following:

{{< highlight bash >}}
mysqldump -u root -p --opt master_database >master_database.sql
{{< /highlight >}}

{{< highlight text >}}
+------------------+----------+-----------------+------------------+
| File             | Position | Binlog_Do_DB    | Binlog_Ignore_DB |
+------------------+----------+-----------------+------------------+
| mysql-bin.000001 |      307 | master_database |                  |
+------------------+----------+-----------------+------------------+
{{< /highlight >}}

Then back in the original window or tab, unlock the database.

{{< highlight bash >}}
UNLOCK TABLES;
QUIT;
{{< /highlight >}}

If there is a firewall in place then open up port 3306 for access from the slave.

## Slave

{{< highlight bash >}}
CREATE DATABASE master_database;
QUIT;
{{< /highlight >}}

Restore the backup.

{{< highlight bash >}}
mysql -u root -p master_database <master_database.sql
{{< /highlight >}}

Make a backup copy of `/etc/mysql/mysql.conf.d/mysqld.cnf`. Now edit `/etc/mysql/mysql.conf.d/mysqld.cnf`.

{{< highlight text >}}
[mysqld]
server-id               = 2
log_bin                 = /var/log/mysql/mysql-bin.log

binlog_do_db            = master_database
{{< /highlight >}}

Set up the connection to the master. This will

- configure the current server as a slave
- provide the IP for the master
- provide the access credentials for the master and
- specifies the master log file and where to start replicating from.

{{< highlight bash >}}
CHANGE MASTER TO MASTER_HOST='178.128.151.83', MASTER_USER='replication_slave', MASTER_PASSWORD='hazIct0Ospurn', MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS=307;
{{< /highlight >}}

Start the slave.

{{< highlight bash >}}
START SLAVE;
{{< /highlight >}}

Check on status.

{{< highlight bash >}}
SHOW SLAVE STATUS\G
{{< /highlight >}}

These are the critical components that you are looking for in the output:

{{< highlight bash >}}
               Slave_IO_State: Waiting for master to send event
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
        Seconds_Behind_Master: 0
                Last_IO_Error: 
               Last_SQL_Error: 

{{< /highlight >}}

You can also check on the most recently modified tables.

{{< highlight bash >}}
SELECT table_schema, table_name, update_time
FROM information_schema.tables
WHERE engine = 'MyISAM'
ORDER BY update_time;
{{< /highlight >}}
