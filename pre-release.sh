#!/bin/bash
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CONFIG_FILE="$SRC_DIR/resources/donkey.cfg"

rm /home/pi/.ssh/pub
rm -rf /home/pi/mycar/data/*
rm /home/pi/mycar/setup.json
sed -i  "s/DONKEY_RESET.*/DONKEY_RESET=true/g" $CONFIG_FILE