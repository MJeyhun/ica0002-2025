# Backup SLA

## Coverage

We back up services that satisfy at least one of these criteria:
 - are primary source of truth for particular data
 - contain customer and/or client data
 - are not feasible (or very costly) to restore by other means

Services that are backed up:
 - MySQL (agama database)
 - Prometheus
 - _____
 - Ansible code git repository


## Schedule

Full backups for mysql, prometheus, and loki are created once per day; it takes up to a few minutes to create and store the backup.

Incremental backups for prometheus, and loki are created once per day; it takes up to a few minutes to create and store the backup.

Prometheus and Loki backups are created once per day; it takes up to a few minutes to create and store the backup.

Infrastructure code and configuration backups are created every day; it takes up to 5 minutes to create and store the backup.

All backups are started automatically by cron jobs.

Backup RPO (recovery point objective) is:
 - 24 hours for MySQL
 - 24 hours for Prometheus
 - 24 hours for Loki
 - 24 hours for Infrastructure code and configuration

## Storage

MySQL, Prometheus, and Loki backups are uploaded to the backup server.

Infrastructure code and configuration is mirrored to the internal Git server.



## Retention

MySQL backups are stored for 30 days; multiple recovery points are available to restore.

Prometheus backups are stored for 30 days; multiple recovery points are available to restore.

Loki backups are stored for 30 days; multiple recovery points are available to restore.

## Usability checks

MySQL backups are verified on demand by performing a test restore and validating database contents.

Prometheus backups are verified on demand by restoring snapshots and validating historical metrics in Grafana.

Loki backups are verified on demand by restoring data and validating historical logs in Grafana.


## Restore process

Service is recovered from the backup in case of an incident, and when service cannot be restored in any other way.

RTO (recovery time objective) is:

    30 minutes for MySQL

    30 minutes for Prometheus

    30 minutes for Loki

