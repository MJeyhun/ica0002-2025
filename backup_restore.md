# Backup Restore Procedure

## MySQL Restore
### Steps

1. Deploy infrastructure:
   ansible-playbook infra.yaml

2. Download backup from backup server:
   sudo -u backup rm -rf /home/backup/restore/mysql/*
   sudo -u backup duplicity --no-encryption restore rsync://MJeyhun@backup.batice.ttu/mysql /home/backup/restore/mysql

3. Restore database as root:
   mysql agama < /home/backup/restore/mysql/agama.sql

4. Verify restore as root:
    - Check if the `agama` database is restored with all its data:
      mysql -e 'USE agama; SHOW TABLES;'
    - Check if the data matches your expectations
      mysql -e 'USE agama; SELECT * FROM item;'

## Prometheus Restore

### Steps

1. Deploy infrastructure:
   ansible-playbook infra.yaml

2. Download backup as user backup:
   sudo -u backup rm -rf /home/backup/restore/prometheus/*
   sudo -u backup duplicity --no-encryption --no-restore-ownership restore \
     rsync://MJeyhun@backup.batice.ttu/prometheus \
     /home/backup/restore/prometheus 

3. Stop Prometheus as root:
   systemctl stop prometheus

4. Remove old data (keep directory) as root   
   rm -rf /var/lib/prometheus/metrics2/*

5. Restore snapshot as root:
   mv /home/backup/restore/prometheus/*/* /var/lib/prometheus/metrics2/

6. Fix ownership as root:
   chown -R prometheus:prometheus /var/lib/prometheus/metrics2/

7. Start Prometheus as root:
   systemctl start prometheus

8. Verify:
   - Open Grafana
   - Increase time range to ≥ 2 days
   - Confirm historical metrics are visible
