#!/bin/bash
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

CONFIG_FILE="$SRC_DIR/resources/donkey.cfg"
HOSTAPD_CONF="/etc/hostapd/hostapd.conf"


echo $CONFIG_FILE
. $CONFIG_FILE

if [ "$DONKEY_RESET" = true ] ; then
    HWADDR=$(ip link show wlan0 | awk 'NR==2{print $2}'  | sed 's/://g' | cut -c 7- )
    echo $HWADDR
    sed -i "s/ssid=donkey.*/ssid=donkey-$HWADDR/g" $HOSTAPD_CONF
    sed -i  "s/127.0.1.1.*/127.0.1.1\tdonkey-$HWADDR/g" /etc/hosts
    echo "donkey-$HWADDR" > /etc/hostname

    sed -i  "s/DONKEY_RESET.*/DONKEY_RESET=false/g" $CONFIG_FILE

    cp ./resources/wpa_supplicant.empty.conf /boot/wpa_supplicant.conf

    sudo raspi-config --expand-rootfs

    logger "donkey-init rebooting"

    reboot
fi

if [ "$DEV_MODE" = true ] ; then
    cat resources/pub > /home/pi/.ssh/authorized_keys
    cp ./resources/wpa_supplicant.test.conf /etc/wpa_supplicant/wpa_supplicant.conf
fi

logger "donkey-init completed"

exit 0
