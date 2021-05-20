#!/bin/bash

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $SRC_DIR/network-functions.sh

hotspot_down

ln -sf /opt/donkeycar-images/resources/hostapd.24ghz.conf /etc/hostapd/hostapd.conf

hotspot_up