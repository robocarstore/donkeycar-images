#!/bin/bash
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

# while true; do
#     read -p "Development mode(will not delete key and wifi)? " yn
#     case $yn in
#         [Yy]* ) DEV_MODE=true; break;;
#         [Nn]* ) DEV_MODE=false; break;;
#         * ) echo "Please answer yes or no.";;
#     esac
# done

# Hardcode DEV_MODE is true so that our Wifi info are retained
DEV_MODE=true

if [ "$DEV_MODE" = true ] ; then
    sed -i  "s/DEV_MODE.*/DEV_MODE=true/g" $CONFIG_FILE
else
    echo "deleting keys"
    rm $HOME/.ssh/authorized_keys
fi


# Delete mycar, donkeycar and legacy folders
rm -rf $HOME/mycar
rm -rf $HOME/env_dc

# Create venv
cd $HOME

# Run the following manually
# deactivate
# sudo rm -rf $HOME/env
# python3 -m virtualenv -p python3 env --system-site-packages
# source env/bin/activate

# Clone donkeycar from robocarstore repo
# git clone https://github.com/robocarstore/donkeycar --branch robocar_dev $HOME/donkeycar
cd $HOME/donkeycar
git remote set-url origin https://github.com/robocarstore/donkeycar
git checkout .
git fetch
git checkout robocarstore_v4
git pull

# install luma.oled for oled display
sudo apt-get -y install fonts-dejavu
pip install luma.oled

if ! crontab -l | grep -q 'oled'; then
    echo "Adding oled cron job"
    (crontab -l 2>/dev/null; echo "* * * * * /home/pi/env/bin/python /opt/donkeycar-images/oled-hostname-ip.py") | crontab -
fi

# install TF2.5

if ! pip list | grep tensorflow | grep 2.5.0; then
    echo "Tensorflow 2.5.0 not installed! Downloading and installing now"
    TF_BIN_NAME=tensorflow-2.5.0-cp37-none-linux_armv7l
    SCRIPT_NAME=${TF_BIN_NAME}_numpy1195_download.sh

    # wget "https://raw.githubusercontent.com/PINTO0309/Tensorflow-bin/master/tensorflow-2.3.1-cp37-none-linux_armv7l_download.sh"
    wget "https://raw.githubusercontent.com/PINTO0309/Tensorflow-bin/master/$SCRIPT_NAME"

    chmod u+x $SCRIPT_NAME
    ./$SCRIPT_NAME
    rm SCRIPT_NAME

    pip install ${TF_BIN_NAME}.whl
    rm ${TF_BIN_NAME}.whl

    echo "Tensorflow installation completed."
fi

# Install PiGPIO
# https://gist.github.com/tstellanova/8b1fb350a148eace6541b5fbd2c021ca
sudo apt-get -y install pigpio python3-pigpio
sudo systemctl enable pigpiod
sudo systemctl start pigpiod


pip install -e $HOME/donkeycar[pi]
pip install -e $HOME/donkeycar[mm1]


# chmod u+x tensorflow-2.3.1-cp37-none-linux_armv7l_download.sh
# ./tensorflow-2.3.1-cp37-none-linux_armv7l_download.sh
# pip install tensorflow-2.3.1-cp37-none-linux_armv7l.whl
# rm tensorflow-2.3.1-cp37-none-linux_armv7l.whl


# Rebuild my car
donkey createcar --path $HOME/mycar --template complete

# Install donkey gym
cd $HOME
rm -rf gym-donkeycar
git clone https://github.com/tawnkramer/gym-donkeycar
cd gym-donkeycar
pip install -e .[gym-donkeycar]


# Install moviepy and scikit-image for movie generation
pip install scikit-image==0.16.2
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
cp $SRC_DIR/resources/myconfig.py $HOME/mycar/myconfig.py

pip install -r $CONSOLE_DIR/requirements/production.txt

python $CONSOLE_DIR/manage.py migrate

sed -i  "s/DONKEY_RESET.*/DONKEY_RESET=true/g" $CONFIG_FILE

echo "Success. You can poweroff and make an image."