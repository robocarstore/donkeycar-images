#!/bin/bash
source ./network-functions.sh

RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'

go_to_sleep() {
    TIMEOUT=$((60-`date +%S` + 20)) # wait next cron job + 20 seconds     
    for (( c=0; c<=$TIMEOUT; c++ ))
    do
        echo -ne "Sleeping $TIMEOUT seconds .... $c"'\r'
        sleep 1
    done
}

print_ok() {
    echo -e "..... ${GREEN}OK${NC}"
}

print_failed() {
    echo -e "..... ${RED}FAILED${NC}"
}


# Wifi should be down by default
date
echo "Dev: Bring down wlan manually"
# This block should be commented out after dev 
cp resources/wpa_supplicant.empty.conf /etc/wpa_supplicant/wpa_supplicant.conf
wlan_reconnect

go_to_sleep
# End of comment block

printf "Checking wifi is down"
if is_wlan_down; then
    print_ok
else
    print_failed
fi

printf "Checking hotspot is up"
if is_hotspot_up; then
    print_ok
else
    print_failed
fi

printf "Connecting to a wifi network .... Please wait \n"
cp resources/wpa_supplicant.test.conf /etc/wpa_supplicant/wpa_supplicant.conf
wlan_reconnect
go_to_sleep

printf "Checking wifi is up"
if is_wlan_up; then
    print_ok
else
    print_failed
fi

printf "Checking hotspot is down"
if is_hotspot_down; then
    print_ok
else
    print_failed
fi

