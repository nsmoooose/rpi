#!/bin/bash

cat <<-EOF > /usr/local/bin/wifi-reconnect
#!/bin/bash
PING_TARGET="8.8.8.8"
WLAN_INTERFACE="wlan0"

# Check if we can ping
if ! ping -c 1 -W 5 "\$PING_TARGET" > /dev/null; then
    echo "\$(date): Wi-Fi down, attempting reconnection..."
    sudo ip link set "\$WLAN_INTERFACE" down
    sleep 2
    sudo ip link set "\$WLAN_INTERFACE" up
else
    echo "\$(date): Wi-Fi is up"
fi
EOF

chmod +x /usr/local/bin/wifi-reconnect

cat <<-EOF > /etc/systemd/system/wifi-reconnect.service
[Unit]
Description=WiFi Reconnect Service
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/usr/local/bin/wifi-reconnect.sh
Type=oneshot
EOF

cat <<-EOF > /etc/systemd/system/wifi-reconnect.timer
[Unit]
Description=Run WiFi Reconnect Script Every Minute

[Timer]
OnBootSec=1min
OnUnitActiveSec=1min
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable --now wifi-reconnect.timer
