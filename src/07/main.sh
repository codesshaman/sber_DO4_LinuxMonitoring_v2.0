#!/bin/bash

VERSION="2.32.1"
sudo useradd --system --no-create-home --shell /bin/false prometheus
sudo apt install -y wget tar
wget https://github.com/prometheus/prometheus/releases/download/v2.32.1/prometheus-2.32.1.linux-amd64.tar.gz
tar -xvf prometheus-2.32.1.linux-amd64.tar.gz
sudo mkdir -p /data /etc/prometheus
cd prometheus-2.32.1.linux-amd64
sudo mv prometheus promtool /usr/local/bin/
sudo mv prometheus.yml /etc/prometheus/prometheus.yml
sudo chown -R prometheus:prometheus /etc/prometheus/ /data/
prometheus --version
sudo cp prometheus.service /etc/systemd/system/prometheus.service
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus
sudo systemctl status prometheus

VERSION="1.3.1"
sudo useradd --system --no-create-home --shell /bin/false node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz -O - | tar -xzv -C ./
tar -xvf node_exporter-1.3.1.linux-amd64.tar.gz
sudo mv node_exporter-1.3.1.linux-amd64/node_exporter /usr/local/bin/
node_exporter --version
sudo cp node_exporter.service /etc/systemd/system/node_exporter.service
sudo systemctl daemon-reload
sudo systemctl enable node_exporter 
sudo systemctl start node_exporter 
sudo systemctl status node_exporter

sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
sudo apt-get install -y adduser libfontconfig1
wget https://dl.grafana.com/oss/release/grafana_9.4.3_amd64.deb
sudo dpkg -i grafana_9.4.3_amd64.deb
sudo apt-get update && sudo apt-get -y install grafana
sudo systemctl daemon-reload
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
sudo systemctl status grafana-server
sudo apt install firewalld
sudo firewall-cmd --zone=public --add-port=3000/tcp --permanent
sudo systemctl reload firewalld

sudo apt install -y stress
stress -c 2 -i 1 -m 1 --vm-bytes 32M -t 10s
sudo rm -rf node_exporter-1.3.1.linux-amd64 prometheus-2.32.1.linux-amd64 grafana_9.4.3_amd64
