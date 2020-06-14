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
    read -p "Development mode? (will not delete key and wifi) " yn
    case $yn in
        [Yy]* ) DEV_MODE=true; break;;
        [Nn]* ) DEV_MODE=false; break;;
        * ) echo "Please answer yes or no.";;
    esac
done

if [ "$DEV_MODE" = true ] ; then
    sed -i  "s/DEV_MODE.*/DEV_MODE=true/g" $CONFIG_FILE
else
    echo "deleting keys"
    rm $HOME/.ssh/authorized_keys
fi

# Delete mycar and donkeycar
rm -rf $HOME/mycar


# Clone donkeycar from robocarstore repo
# git clone https://github.com/robocarstore/donkeycar --branch robocar_dev $HOME/donkeycar
cd $HOME/donkeycar
git checkout .

pip install -e $HOME/donkeycar[pi]
pip install -e $HOME/donkeycar[mm1]

# Rebuild my car
donkey createcar --path $HOME/mycar

# Update console
cd $CONSOLE_DIR
git pull
rm $CONSOLE_DIR/db.sqlite3
rm $CONSOLE_DIR/gunicorn.log
rm $CONSOLE_DIR/gunicorn.access.log
cp $CONSOLE_DIR/dkconsole/vehicle/myconfig.py $HOME/mycar/myconfig.py

deactivate
source activate $HOME/env_dc/bin/activate
pip install $CONSOLE_DIR/requirements/production.txt

$HOME/env_dc/bin/python $CONSOLE_DIR/manage.py migrate

sed -i  "s/DONKEY_RESET.*/DONKEY_RESET=true/g" $CONFIG_FILE

echo "Success. You can poweroff and make an image."