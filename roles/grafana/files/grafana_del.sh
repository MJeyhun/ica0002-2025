apt-get purge --auto-remove grafana
sudo rm -rf /etc/grafana/          # Config files
sudo rm -rf /var/lib/grafana/       # Data files, plugins, etc.
sudo rm -rf /var/log/grafana/       # Log files
sudo rm -rf /usr/share/grafana/     # Static files
sudo userdel grafana
sudo groupdel grafana
