#!/bin/bash

sudo apt-get install build-essential python3 python3-dev python3-pip python3-virtualenv python3-numpy python3-picamera python3-pandas python3-rpi.gpio i2c-tools avahi-utils joystick libopenjp2-7-dev libtiff5-dev gfortran libatlas-base-dev libopenblas-dev libhdf5-serial-dev libgeos-dev git ntp

python3 -m virtualenv -p python3 env --system-site-packages
echo "source ~/env/bin/activate" >> ~/.bashrc
source ~/.bashrc

pip3 install --upgrade pip setuptools wheel



IMAGE_DIR="/opt/donkeycar-images"

sudo git clone https://github.com/robocarstore/donkeycar-images $IMAGE_DIR

# install jupyter lab
pip3 install jupyter
pip3 install jupyterlab

# For changepw.sh jq and sponge
sudo apt-get install jq moreutils

ln -s /opt/donkeycar-images/resources/jupyter_config .jupyter
sudo ln -sf /opt/donkeycar-images/resources/jupyter-lab.service /etc/systemd/system/jupyter-lab.service
sudo systemctl enable jupyter-lab.service


# install luma.oled for oled display
sudo apt-get -y install fonts-dejavu
pip3 install netifaces
pip install luma.oled
sudo ln -sf $IMAGE_DIR/resources/oled.service /etc/systemd/system/oled.service
sudo systemctl enable oled.service


# Miscellaneous
sudo ln -sf /opt/donkeycar-images/donkey-init.service /etc/systemd/system/donkey-init.service
# sudo ln -sf /opt/donkeycar-images/resources/gunicorn.service /etc/systemd/system/gunicorn.service
# sudo ln -sf /opt/donkeycar-images/resources/ping_vehicle_status.service /etc/systemd/system/ping_vehicle_status.service

sudo systemctl enable donkey-init.service

# Install Tensorflow 2.10
sudo apt-get install -y \
    libhdf5-dev libc-ares-dev libeigen3-dev gcc gfortran \
    libgfortran5 libatlas3-base libatlas-base-dev \
    libopenblas-dev libopenblas-base libblas-dev \
    liblapack-dev cython3 libatlas-base-dev openmpi-bin \
    libopenmpi-dev python3-dev python-is-python3
pip3 install pip --upgrade
pip3 install keras_applications==1.0.8 --no-deps
pip3 install keras_preprocessing==1.1.2 --no-deps
pip3 install numpy==1.24.2
pip3 install h5py==3.6.0
pip3 install pybind11==2.9.2
pip3 install -U --user six wheel mock
pip3 uninstall tensorflow

TFVER=2.10.0

PYVER=39

ARCH=`python -c 'import platform; print(platform.machine())'`
echo CPU ARCH: ${ARCH}

pip3 install \
--no-cache-dir \
https://github.com/PINTO0309/Tensorflow-bin/releases/download/v${TFVER}/tensorflow-${TFVER}-cp${PYVER}-none-linux_${ARCH}.whl


# Install OpenCV
sudo apt install python3-opencv


# Install Donkey Car
git clone https://github.com/autorope/donkeycar
cd donkeycar
git checkout main
pip install -e .[pi]

donkey createcar --path ~/mycar

# Install donkey gym
cd $HOME
rm -rf gym-donkeycar
git clone https://github.com/tawnkramer/gym-donkeycar
cd gym-donkeycar
pip install -e .[gym-donkeycar]





# Install / Update console

CONSOLE_DIR="/opt/donkeycar-console"

git clone https://github.com/robocarstore/donkeycar-console $CONSOLE_DIR
sudo chown -R pi.pi $CONSOLE_DIR
# git remote set-url origin https://github.com/robocarstore/donkeycar-console
# git config --global filter.lfs.smudge "git-lfs smudge --skip -- %f"
# git config --global filter.lfs.process "git-lfs filter-process --skip"

# git config --global user.email "support@robocarstore.com"
# git config --global user.name "Robocar Store"

rm $CONSOLE_DIR/db.sqlite3
rm $CONSOLE_DIR/gunicorn.log
rm $CONSOLE_DIR/gunicorn.access.log
# cp $SRC_DIR/resources/myconfig.py $HOME/mycar/myconfig.py

pip install -r $CONSOLE_DIR/requirements/production.txt

python $CONSOLE_DIR/manage.py migrate

sudo ln -sf $CONSOLE_DIR/gunicorn.service /etc/systemd/system/gunicorn.service
sudo systemctl enable gunicorn.service


sudo systemctl daemon-reload



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
git checkout robocarstore_v43
git pull

# install luma.oled for oled display
sudo apt-get -y install fonts-dejavu
pip install luma.oled
sudo ln -sf $SRC_DIR/resources/oled.service /etc/systemd/system/oled.service

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

# Rebuild my car
donkey createcar --path $HOME/mycar --template complete




# Install moviepy and scikit-image for movie generation
pip install scikit-image==0.16.2
pip install moviepy==1.0.3


# Add coral tpu support
echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | sudo tee /etc/apt/sources.list.d/coral-edgetpu.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install python3-edgetpu

cd ~/env/lib/python3.7/site-packages
ln -sf /usr/lib/python3/dist-packages/edgetpu .
ln -sf /usr/lib/python3/dist-packages/edgetpu-2.15.0.egg-info .


sudo ln -sf $SRC_DIR/resources/donkey.cfg $HOME/donkey.cfg

sed -i  "s/DONKEY_INIT.*/DONKEY_INIT=true/g" $CONFIG_FILE

echo "Success. You can poweroff and make an image."