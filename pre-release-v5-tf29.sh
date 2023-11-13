#!/bin/bash

donkey createcar --path ~/mycar


if [ ! -d "/home/pi" ] ; then
    echo "Warning: This is supposed to be run on pi only."
    echo "Program exited"
    exit 0
fi

# Timestamp this image
today=$(date +"%Y%m%d")
sudo sed -i "s/Version: .*/Version: $today/g" /etc/motd
echo $today | sudo tee /boot/version

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CONFIG_FILE="$SRC_DIR/resources/donkey.cfg"
CONSOLE_DIR="/opt/donkeycar-console"

# Delete keys
echo "deleting keys"
rm $HOME/.ssh/authorized_keys
rm $HOME/.ssh/id_rsa

# Delete mycar, donkeycar and legacy folders
rm -rf $HOME/mycar
rm -rf $HOME/env_dc
rm -f $HOME/.jupyter/lab/workspaces/*

# Create venv
cd $HOME

# Clone donkeycar from robocarstore repo
# git clone https://github.com/robocarstore/donkeycar --branch robocar_dev $HOME/donkeycar
cd $HOME/donkeycar
git remote set-url origin https://github.com/robocarstore/donkeycar
git checkout .
git fetch
git checkout v5
git pull

# pip install -e .[pi]

# install luma.oled for oled display
sudo apt-get -y install fonts-dejavu
pip install luma.oled
sudo ln -sf $SRC_DIR/resources/oled.service /etc/systemd/system/oled.service

# Rebuild my car
donkey createcar --path $HOME/mycar --template complete
cp $SRC_DIR/resources/myconfig.py $HOME/mycar/myconfig.py

# Install moviepy and scikit-image for movie generation
pip install scikit-image==0.21.0
pip install moviepy==1.0.3

# Update console
cd $CONSOLE_DIR
git remote set-url origin https://github.com/robocarstore/donkeycar-console
# git config --global filter.lfs.smudge "git-lfs smudge --skip -- %f"
# git config --global filter.lfs.process "git-lfs filter-process --skip"

git config --global user.email "support@robocarstore.com"
git config --global user.name "Robocar Store"

git checkout .
git pull

rm $CONSOLE_DIR/db.sqlite3
rm $CONSOLE_DIR/gunicorn.log
rm $CONSOLE_DIR/gunicorn.access.log

pip install -r $CONSOLE_DIR/requirements/production.txt
python $CONSOLE_DIR/manage.py migrate

sudo cp $SRC_DIR/resources/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf

sudo ln -sf $SRC_DIR/resources/donkey.cfg $HOME/donkey.cfg

sed -i  "s/DONKEY_INIT.*/DONKEY_INIT=true/g" $CONFIG_FILE

echo "Success. You can poweroff and make an image."