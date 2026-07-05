#!/bin/bash

# Get device name
DEVICE_NAME=$(hostname)

# Get MAC address (WiFi first, Ethernet fallback)
MAC_ADDRESS=$(cat /sys/class/net/wlan0/address 2>/dev/null)

if [ -z "$MAC_ADDRESS" ]; then
    MAC_ADDRESS=$(cat /sys/class/net/eth0/address 2>/dev/null)
fi

echo "Device: $DEVICE_NAME MAC Address: $MAC_ADDRESS"
