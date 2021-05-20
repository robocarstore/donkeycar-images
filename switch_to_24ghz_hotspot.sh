#!/bin/bash

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $SRC_DIR/network-functions.sh

echo "Please note that this will switch network band for this session. Hotspot band will fallback on next reboot. For permanent change please edit donkey.cfg"

hotspot_down

ln -sf /opt/donkeycar-images/resources/hostapd.24ghz.conf /etc/hostapd/hostapd.conf

hotspot_up