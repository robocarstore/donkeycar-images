#!/bin/bash
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

CONFIG_FILE="$SRC_DIR/resources/donkey.cfg"
HOSTAPD_CONF="/etc/hostapd/hostapd.conf"
HWADDR=$(ip link show wlan0 | awk 'NR==2{print $2}'  | sed 's/://g' | cut -c 7- )

echo $CONFIG_FILE
. $CONFIG_FILE

if [ "$HOTSPOT_BAND" = "2.4" ] ; then
    logger "Hotspot using 2.4ghz band"
    sudo ln -sf $SRC_DIR/resources/hostapd.24ghz.conf $HOSTAPD_CONF
fi

if [ "$HOTSPOT_BAND" = "5" ] ; then
    logger "Hotspot using 5ghz band"
    sudo ln -sf $SRC_DIR/resources/hostapd.5ghz.conf $HOSTAPD_CONF
fi

# Update ssid name based on hardware address
sed -i "s/ssid=donkey.*/ssid=donkey-$HWADDR/g" $HOSTAPD_CONF

if [ "$DONKEY_RESET" = true ] ; then
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
    sed -i  "s/DEV_MODE.*/DEV_MODE=false/g" $CONFIG_FILE
fi

logger "donkey-init completed"

exit 0
