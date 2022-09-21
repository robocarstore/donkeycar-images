sudo apt-get update
sudo apt install git vim


cd /opt
sudo git clone https://github.com/robocarstore/donkeycar-images.git


sudo apt-get install build-essential python3 python3-dev python3-pip python3-virtualenv python3-numpy python3-picamera python3-pandas python3-rpi.gpio i2c-tools avahi-utils joystick libopenjp2-7-dev libtiff5-dev gfortran libatlas-base-dev libopenblas-dev libhdf5-serial-dev libgeos-dev git ntp


python3 -m virtualenv -p python3 env --system-site-packages
echo "source ~/env/bin/activate" >> ~/.bashrc
source ~/.bashrc


pip3 install netifaces

pip install jupyterlab
sudo systemctl enable jupyter-lab.service
sudo systemctl enable oled.timer

# Set timezone using raspi-config
sudo ln -sf /opt/donkeycar-images/donkey-init.service /etc/systemd/system/donkey-init.service
sudo ln -sf /opt/donkeycar-images/resources/pi4_v4/jupyter-lab.service /etc/systemd/system/jupyter-lab.service

sudo ln -sf /opt/donkeycar-images/resources/pi4_v4/oled.service /etc/systemd/system/oled.service
sudo ln -sf /opt/donkeycar-images/resources/pi4_v4/oled.timer /etc/systemd/system/oled.timer


jupyter server --generate-config


sudo systemctl enable oled.service
sudo systemctl enable donkey-init.service

ln -s /opt/donkeycar-images/resources/pi4_v4/.jupyter/ .

jupyter server password

# Follow here to let systemd track i2c readiness
# https://forums.raspberrypi.com/viewtopic.php?t=221507
# this is not working, we don't need this
# workaround, have the oled.py wait until i2c ready