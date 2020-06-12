#!/bin/bash
if [ ! -d "/home/pi" ] ; then
    echo "Warning: This is supposed to be run on pi only."
    echo "Program exited"
    exit 0
fi

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CONFIG_FILE="$SRC_DIR/resources/donkey.cfg"
CONSOLE_DIR="/opt/donkeycar-console"

while true; do
    read -p "Do you want to delete authorized_key [y/n]? " yn
    case $yn in
        [Yy]* ) DELETE_KEY=true; break;;
        [Nn]* ) DELETE_KEY=false; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

if [ "$DELETE_KEY" = true ] ; then
    echo "deleting keys"
    rm $HOME/.ssh/authorized_keys
fi

# Delete mycar and donkeycar
rm -rf $HOME/mycar
rm -rf $HOME/donkeycar


# Clone donkeycar from robocarstore repo
git clone https://github.com/robocarstore/donkeycar --branch robocar_dev $HOME/donkeycar
pip install -e $HOME/donkeycar[pi]
pip install -e $HOME/donkeycar[mm1]

# Rebuild my car
donkey createcar --path $HOME/mycar

# Update console
git pull $CONSOLE_DIR
rm $CONSOLE_DIR/db.sqlite3
rm $CONSOLE_DIR/gunicorn.log
rm $CONSOLE_DIR/gunicorn.access.log
cp $CONSOLE_DIR/dkconsole/vehicle/myconfig.py $HOME/mycar

$HOME/env_dc/bin/python $CONSOLE_DIR/manage.py migrate

sed -i  "s/DONKEY_RESET.*/DONKEY_RESET=true/g" $CONFIG_FILE

echo "Success. You can poweroff and make an image."