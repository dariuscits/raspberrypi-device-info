#!/bin/bash

echo "=============================="

# Device name
DEVICE_NAME=$(hostname)

# MAC address (WiFi first, fallback Ethernet)
MAC_ADDRESS=$(cat /sys/class/net/wlan0/address 2>/dev/null)

if [ -z "$MAC_ADDRESS" ]; then
    MAC_ADDRESS=$(cat /sys/class/net/eth0/address 2>/dev/null)
fi

echo "Device: $DEVICE_NAME"
echo "MAC Address: $MAC_ADDRESS"

echo "=============================="

# Check if NetworkManager is installed
if command -v nmcli &> /dev/null; then
    echo "[INFO] NetworkManager detected"

    echo ""
    echo "Checking WiFi connection profiles..."

    nmcli -t connection show | cut -d: -f1 | while read -r conn; do
        MODE=$(nmcli connection show "$conn" | grep "802-11-wireless.cloned-mac-address" | awk '{print $2}')

        if [ "$MODE" != "permanent" ]; then
            echo "[WARNING] '$conn' may be using MAC randomization"
        else
            echo "[OK] '$conn' uses permanent MAC"
        fi
    done

    echo ""
    echo "To disable MAC randomization (manual fix):"
    echo "nmcli connection modify \"YOUR_WIFI_NAME\" 802-11-wireless.cloned-mac-address permanent"
    echo "sudo systemctl restart NetworkManager"
else
    echo "[INFO] NetworkManager not detected"
fi

echo "=============================="
