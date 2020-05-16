#!/bin/bash
set -e

function install_server() {
	install $1 /usr/local/bin/$1
	cat <<EOF > /etc/systemd/system/$1.service
[Unit]
Description=$2
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
User=centos
ExecStart=/usr/local/bin/$1

[Install]
WantedBy=multi-user.target
EOF
	systemctl enable $1
	systemctl start $1
}

install_server hn-data-server "HN Data Server"
install_server hn-data-publisher-am2301 "HN AM2301"
install_server hn-data-subscriber-oled-display "HN OLED display"
