#!/bin/bash
##################################################################
# A Project of TNET Services, Inc
# Original verion can be found at:
# https://github.com/dweeber/WiFi_Check
# This version is modified by:
# ExploWare  http://raspberrypi.stackexchange.com/users/13296/exploware
#
# Purpose:
#
# Script checks to see if WiFi has a network IP and if not
# restart WiFi
#
# Uses a lock file which prevents the script from running more
# than one at a time.  If lockfile is old, it removes it
#
#
##################################################################
##################################################################
# Settings
# Where and what you want to call the Lockfile
lockfile='/run/lock/WiFi_Check.pid'
# Which Interface do you want to check/fix
wlan='wlan0'
wired='eth0'
PATH=$PATH:/sbin
silent=false
if [[ "$1" == "silent" ]]; then
    silent=true
fi
##################################################################
#echo
$silent || echo -n "Starting WiFi check for $wlan"
#echo 

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source $SRC_DIR/network-functions.sh
logger "pwd = " `pwd`
logger "path = $PATH"
logger $SRC_DIR

# Check to see if there is a lock file
if [ -e $lockfile ]; then
    # A lockfile exists... Lets check to see if it is still valid
    pid=`cat $lockfile`
    if kill -0 &>1 > /dev/null $pid; then
        # Still Valid... lets let it be...
        #echo "Process still running, Lockfile valid"
        $silent || echo -n .
        exit 1
    else
        # Old Lockfile, Remove it
        #echo "Old lockfile, Removing Lockfile"
        $silent || echo -n .
        rm $lockfile
        sleep .5
    fi
else
    $silent || echo -n .
fi
# If we get here, set a lock file using our current PID#
#echo "Setting Lockfile"
$silent || echo -n .
echo $$ > $lockfile

# We can perform check
#echo "Performing Network check for $wlan"
if iwconfig $wlan|grep -qe "ESSID:\".*\""; then
    echo "ESSID found"
    logger "ESSID found"
    if ifconfig $wlan | grep -q "inet" ; then
        logger "Wifi connection on $wlan is OK"
        hotspot_down
    else
        $silent || echo "Network connection down! Attempting reconnection."
        logger "Wifi connection on $wlan is DOWN, trying to reconnect... "
        date
        wlan_reconnect
        if ifconfig $wlan | grep -q "inet" ; then
            logger "Wifi connection on $wlan seems to be up and running again."
            hotspot_down
        else
            logger "Wifi connection on $wlan is DOWN"
            hotspot_up
        fi
    fi
else
    $silent || logger "Network connection down!!!! Attempting reconnection."
    logger "Wifi connection on $wlan is DOWN, trying to reconnect... "
    date
    wlan_reconnect

    if ifconfig $wlan | grep -q "inet" ; then
        logger Wifi connection on $wlan seems to be up and running again.
        hotspot_down
    else
        logger Wifi connection on $wlan is DOWN, enabling the hotspot ...
        hotspot_up
    fi
fi

$silent || echo -n "Current Setting:"
$silent || iwconfig $wlan | grep -oe "ESSID:\".*\"";ifconfig $wlan | grep "inet"
logger `iwconfig $wlan | grep -oe "ESSID:\".*\"";ifconfig $wlan | grep "inet"`

# Check is complete, Remove Lock file and exit
#echo "process is complete, removing lockfile"
rm $lockfile

##################################################################
# End of Script
##################################################################