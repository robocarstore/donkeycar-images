

## Features

- Pre-installed Donkey Car Software
- Support Donkey Car mobile app
- Supports RPI4B
- Pre-installed tensorflow 2.5
- Pre-installed coral library
- Jupyter Lab
- Connected SSID, system password is displayed via Donkey HAT OLED
- ~~Supports Robohat MM1~~
- ~~Built-in wifi hotspot~~



## Download
| Date       | Platform                 | Donkeycar version | Download                                                                                |
| ---------- | ------------------------ | ----------------- | --------------------------------------------------------------------------------------- |
| 2025-02-28 | Raspberry Pi 4B / Bulleye | v5.0-dev3        | [Download](https://www.dropbox.com/scl/fi/x9oi2x1yf4afqkd2u63st/pi4_dcv5_v20250228.zip?rlkey=pl83xhj7ndjfo8xldrza9s00a&st=ah8ct7yo&dl=0) |
| 2023-11-14 | Raspberry Pi 4B / Bulleye | v5.0-dev3        | [Download](https://www.dropbox.com/scl/fi/kr6xg6hi80nd9he1d7z4z/pi4_dcv5_v20231114.zip?rlkey=oojn8cs86m2l623ph3mu1swfr&dl=0) |
| 2023-04-06 | Raspberry Pi 4B / Buster | v4.3.22           | [Download](https://www.dropbox.com/s/emht0vqhbdmxgm8/pi4_dcv4_v20230406.zip?dl=0)       | 
| 2022-11-03 | Raspberry Pi 4B / Buster | v4.3.22           | [Download](https://www.dropbox.com/s/0sjue293q6dky1z/pi4_dcv4_v20221103b.zip?dl=0)      |
| 2022-10-27 | Raspberry Pi 4B / Buster | v4.3.22           | [Download](https://www.dropbox.com/s/jtzgzt4y5mvo7ji/pi4_dcv4_v20221027.zip?dl=0)       |
| 2022-06-02 | Raspberry Pi 4B / Buster | v4                | [Download](https://www.dropbox.com/s/y25rhwcjmxsqnlu/pi4_dcv4_v20220602.zip?dl=0)       |
| 2021-12-07 | Raspberry Pi 4B / Buster | v4                | [Download](https://www.dropbox.com/s/kytoot81l09iqnh/pi4_dcv4_v20211207.zip?dl=0)       |
| 2021-07-12 | Jetson Nano              | v4                | [Download](https://www.dropbox.com/s/zro10hfpzp8uc9l/jetson_nano_4gb_20210712.zip?dl=0) |
| 2021-05-27 | Raspberry Pi 4B / Buster | v4                | [Download](https://drive.google.com/uc?export=download&confirm=5eLQ&id=19hYKLFnuD7l0YiKEilakvZvX3BYVRta3) |
| 2021-05-26 | Raspberry Pi 4B / Buster | v4                | [Download](https://www.dropbox.com/s/i4ex5v0y9c5n0t4/pi4_dcv4_v20210526.zip?dl=0)       |
| 2021-05-20 | Raspberry Pi 4B / Buster | v4                | [Download](https://www.dropbox.com/s/1y6577dina8h1am/pi4_dcv4_v20210520.zip?dl=0)       |
| 2021-02-04 | Raspberry Pi 4B / Buster | v4                | [Download](https://www.dropbox.com/s/i9ro2vhmq55fmnt/pi4_dcv4_v20210204.zip?dl=0)       |
| 2020-10-14 | Raspberry Pi 4B / Buster | v3                | [Download](https://www.dropbox.com/s/1v3gx2atjbg96fs/pi4_v20201014.zip?dl=0)            |
| 2020-07-18 | Raspberry Pi 4B / Buster | v3                | [Download](https://www.dropbox.com/s/tl9795vp2ywzonr/pi4_v20200718.zip?dl=0)            |


## Password
A random 6-digit password is generated during the first boot. This password is used to access
- Jupyter Lab
- Mobile App
- SSH


There are two ways to retreive this password:
1. The password will be displayed through the OLED display of the Donkey HAT
2. The password is stored in /home/pi/donkey.cfg

To change the password, do not directly edit /home/pi/donkey.cfg. Editing this file directly will result in permanent loss of the shell login if you have not written it down. Use /opt/donkeycar-images/changepw.sh instead. This script will change the password of the raspbian user, jupyter-lab and the mobile app password in one go. 

## Access


### SSH Login

#### Pi
- username: pi
- password: <Refer to password section above>

#### Nano
- username: nano
- password: asdfasdf

### Jupyter Lab

```
http://donkey-xxxxxx.local:8888
```

## How to install

```
sudo git clone https://github.com/sctse999/donkeycar-images /opt/donkeycar-images
sudo ln -s donkey-init.service /etc/systemd/system/donkey-init.service

```

## Jupyter Lab

### Installation step

```
pip install jupyterlab

sudo systemctl enable jupyter-lab.service
```

## Initial Pi Setup

- Enable SSH
- Enable Camera
- Enable I2C

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
# Run the following command

/opt/donkey-images/pre-release-v4.sh
```

# Testing

## Checklist

1. Hostname should be renamed to donkey-xxxxxx where xxxxxx is the last 6 character of the wlan0 hardware address
   Use `ifconfig` to check wlan0 hardware address

2. ~~2.4 or 5ghz band should be configurable using `/boot/donkey.cfg`~~

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

### 20250228
- Included [donkeycar-notebook](https://github.com/sctse999/donkeycar-notebook)
- Installed tabulate via pip

### 20230406
- Flip camera by default
- Fix recording not working issue by updating to the latest. 

### 20221103
- Recreate donkeycar app for calibration and copilot support
- Fix gunicorn.service symlink location
- numpy upgrade to 1.20.3 fixing 
- Fix donkey makemovie

### 20221027
- Random 6-digit system password
- System password is displayed via Donkey HAT OLED display
- Jupyter lab is password protected
- Installed with donkey car v4.3.22

### 20220602

- Disable donkey car LED part

### 20211207

- Support Donkey HAT
- Added `oled-hostname-ip.py`
- Enable OLED part by default
- Switched to TF2.5 
- Removed low battery auto shutdown cron job
- Installed keras-vis, moviepy and scikit-image to support tub movie generation
- pre-installed edge tpu dependencies
- Tuned pigpio to 10microsecond sampling rate (https://forum.radxa.com/t/pigpiod-eating-7-cpu-nonstop/3911)


### 20210713

- Installed [donkey gym](https://github.com/tawnkramer/gym-donkeycar) by default
- Installed Tensorflow 2.5
- Upgraded to donkey 4.3

### 20210526

- Updated /opt/donkeycar-console to the newest version (commit 01adc2ca841f5d1c17332d22e02bf260dbb1d9f4)

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

## Jetson Nano

### 20210712
