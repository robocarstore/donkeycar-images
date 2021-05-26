# Warning

### Use this image at your own risk. This image is designed for the ease of use and therefore sacrifice quite some security concern. For example, it has an unprotected jupyter lab instance running with shell access. In addition, the donkeycar console installed accept any web or mobile client to connect without a password. This may be enhanced in the future but it is what it is now.

## Features

- Pre-installed Donkey Car Software
- Support Donkey Car mobile app
- Supports RPI4B
- Supports Robohat MM1
- Built-in wifi hotspot
- Pre-installed librealsense and pyrealsense2
- Jupyter Lab

## Download

| Date       | Platform                 | Donkeycar version | Download                                                                          |
| ---------- | ------------------------ | ----------------- | --------------------------------------------------------------------------------- |
| 2021-05-20 | Raspberry Pi 4B / Buster | v4                | [Download](https://www.dropbox.com/s/1y6577dina8h1am/pi4_dcv4_v20210520.zip?dl=0) |
| 2021-02-04 | Raspberry Pi 4B / Buster | v4                | [Download](https://www.dropbox.com/s/i9ro2vhmq55fmnt/pi4_dcv4_v20210204.zip?dl=0) |
| 2020-10-14 | Raspberry Pi 4B / Buster | v3                | [Download](https://www.dropbox.com/s/1v3gx2atjbg96fs/pi4_v20201014.zip?dl=0)      |
| 2020-07-18 | Raspberry Pi 4B / Buster | v3                | [Download](https://www.dropbox.com/s/tl9795vp2ywzonr/pi4_v20200718.zip?dl=0)      |

## Access

### SSH Login

- username: pi
- password: raspberry

### Jupyter Lab

```
http://donkey-xxxxxx.local:8888
```

## How to install

```
sudo git clone https://github.com/sctse999/donkeycar-images /opt/donkeycar-images
sudo ln -s donkey-init.service /etc/systemd/system/donkey-init.service

```

### Add Cron Job

Add the following lines after you execute `sudo crontab -e`

```
* * * * * /opt/donkeycar-images/switch-network.sh
* * * * * /home/pi/env/bin/python /opt/donkeycar-images/low-battery-auto-shutdown.py 2>&1 | /usr/bin/logger -t low-battery-protector

```

## Wifi Hotspot

This image is installed with Raspap. To login the Raspap portal, visit
`http://hostname/` with the following credentials:

- username: admin
- password: secret

Be default, a 5ghz hotspot is automatically available if there is no active wireless connection.
The hotspot name is determined by `/etc/hostapd/hostapd.conf`, which is
updated by a script located in `/usr/local/sbin/donkey-init.sh` upon
first boot.

This script will use the prefix `donkey-` and the last 6 character of the
hardware mac address to create the hotspot. You can change this hotspot name to
something else by editing the file or using the Raspap portal.

The script `switch-network.sh` is a cron job run by root. It turns off the
hotspot when there is an active wireless connection. Similiarly, it turns on the
hotspot when there is no wireless connection.

### Hotspot issue

- If you are experiencing unstable connection to the hotspot, modify the `country_code` under `/etc/hostapd/hostapd.conf`
- You can also change the channel of the wifi hotspot. Check `channels` in `/etc/hostapd/hostapd.conf`. Check possible channels here
  https://en.wikipedia.org/wiki/List_of_WLAN_channels#5_GHz_(802.11a/h/j/n/ac/ax)

- If you want to use 2.4Ghz instead of 5Ghz hotspot, edit `/boot/donkey.cfg` and update the following line to:

```
HOTSPOT_BAND="2.4"
```

There are two scripts called `switch_to_24ghz_hotspot.sh` and `switch_to_5ghz_hotspot.sh` that you can use to switch between bands.

How do I check if my hotspot is running 2.4Ghz?
Use this command if you are running on a linux or mac

```
sudo iwlist wlan0  scan
```

## Jupyter Lab

### Installation step

```
pip install jupyterlab

sudo systemctl enable jupyter-lab.service
```

### Startup Config

/etc/systemd/system/jupyter-lab.service

```
[Unit]
Description = JupyterLab

[Service]
PIDFile = /run/jupyter.pid
ExecStart = /home/pi/env/bin/jupyter-lab
User = pi
Group = pi
WorkingDirectory = /home/pi
Restart=always
RestartSec=10

[Install]
WantedBy = multi-user.target
```

### Reset script

The reset script will reset the current system to a clean state.

```
# Run either one of the following command

/opt/donkey-images/pre-release-v3.sh
/opt/donkey-images/pre-release-v4.sh
```

# Testing

## Checklist

1. Hostname should be renamed to donkey-xxxxxx where xxxxxx is the last 6 character of the wlan0 hardware address
   Use `ifconfig` to check wlan0 hardware address

2. 2.4 or 5ghz band should be configurable using `/boot/donkey.cfg`

3. Jupyter lab should be accessible via `http://<ip>:8888/`

4. Donkey car console should be running. Check `http://<ip>:8000/vehicle/status`

5. Mobile app should be able to finish one whole cycle of setup

6. Calibration should work

7. Drive UI should work

8. Training should work

# Others

## Software Info

### Donkey Car

origin: https://github.com/robocarstore/donkeycar

v4 branch: `robocarstore_v4`

v3 branch: `robocar_dev`

### Donkey Car Console

origin: `https://github.com/robocarstore/donkeycar-console`

branch: `dev`

# Commercial Use

If you intend to use this project for making money, you must obtain our consent before you do so. Contact us at sales@robocarstore.com

# Changelog

## RPI4B

### 20210526

- image version now written to /boot/version
- add two router config to wpa_supplicant.test.conf
- default hotspot band to 5Ghz

### 20210521

- Added ping vehicle status to avoid slow first time loading of vehicle status page
- Added /boot/donkey.cfg to allow Windows based machine to edit this file to update configuration

### v20210520

- Fixed Jupyter Lab missing installation
- Added hotspot band parameter in `donkey.cfg`
- Automatic rename ssid based on hardware address on every reboot

### v20210204

- Update donkey car to v4.2.0
- Compatible with Donkey Car Controller 1.3.2
- Single python venv at /home/pi/env. Both donkey console and donkey car software use this venv.

### v20201014 / v1.0

- Update donkey car to v3.1.5
- Update to latest donkeycar-console

### v20200708

- Fine tune myconfig.py value
- Install Google Coral Edgetpu library

### v20200707

- Installed jupyter lab as a service

### v20200526

- Installed ffmpeg and keras-vis

```
apt-get install ffmpeg
pip install git+https://github.com/sctse999/keras-vis.git

```

### v20200421

- Installed donkey console v2 under ~/
- Installed donkey console as systemd service

### v20200324

- Rename init script to donkey-init.sh
- Added ~/donkey.cfg for config reset
- donkey-init.sh will rename hostname when DONKEY_RESET=True in donkey.cfg
- donkey-init.sh will reset wpa_supplicant.conf
- Change raspap country to US and use 80211.ac 5Ghz
- Install switch-network.sh to crontab

### v20200310

- Performed OS upgrade
- Removed vim
- Added librealsense support (build 2.33.1)
- Enabled serial port for MM1 and installed pyserial
- Upgraded pip to 20.0.2
- Installed vim
- Adopted https://github.com/amix/vimrc
