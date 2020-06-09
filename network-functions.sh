wlan=wlan0
uap=uap0

is_wlan_up() {
    if iwconfig $wlan|grep -qe "ESSID:\".*\""; then
        if ifconfig $wlan | grep -q "inet " ; then
            true
        else
            false
        fi
        true
    else
        false
    fi
}

# syntactic sugar
is_wlan_down() {
    ! is_wlan_up
}

is_hotspot_up() {
    if ifconfig $uap | grep -q "inet " ; then
        true
    else
        false
    fi    
}

# syntactic sugar
is_hotspot_down() {
    ! is_hotspot_up
}


hotspot_up() {
    logger "Bringing up hotspot"
    if is_hotspot_down; then
        /etc/raspap/hostapd/servicestart.sh --interface uap0 --seconds 3
    else
        logger "hotspot up already, not restarting"
    fi
}

hotspot_down() {
    echo "Shutting down hotspot"
    logger "Shutting down hotspot"
    systemctl stop hostapd.service
}

wlan_reconnect() {
    wpa_cli -i wlan0 reconfigure
}

wlan_up() {
    echo "Obsoletted ... exiting"
    exit 255 

    # wpa_cli -i wlan0 reconfigure
}

wlan_down() {
    echo "Obsoletted ... exiting"
    exit 255 
    # wpa_cli -i wlan0 reconfigure
}
