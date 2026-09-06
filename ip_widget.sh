#!/bin/bash
INTERFACE="eth0" # Change to your desired interface (e.g., wlan0, tun0)
ADDR=$(ip -o addr show | awk '/inet / {print $2 ": " $4}' | cut -d/ -f1 | grep -v '127.0.0.1' | paste -s -d'|')
if [ -n "$ADDR" ]; then
  echo "$ADDR"
fi
