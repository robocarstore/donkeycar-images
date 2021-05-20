#!/bin/bash

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $SRC_DIR/network-functions.sh

hotspot_down

rm /etc/hostapd/hostapd.conf

ln -s /opt/donkeycar-images/resources/hostapd.5ghz.conf ../../etc/hostapd/hostapd.conf

hotspot_up