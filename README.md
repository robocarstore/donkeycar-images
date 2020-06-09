# Features

- Supports RPI4B, Jetson Nano
- Supports Robohat MM1
- Built-in wifi hotspot
- Pre-installed librealsense and pyrealsense2
- Latest donkey software (v311)


# SSH Login
- username: pi
- password: raspberry

# Wifi Hotspot
This image is installed with Raspap. To login the Raspap portal, visit
```http://hostname/``` with the following credentials:

- username: admin
- password: secret

A hotspot is automatically available if there is no active wireless connection.
The hotspot name is determined by ```/etc/hostapd/hostapd.conf```, which is
updated by a script located in ```/usr/local/sbin/donkey-init.sh``` upon
first boot.

This script will use the prefix ```donkey-``` and the last 6 character of the
hardware mac address to create the hotspot. You can change this hotspot name to
something else by editing the file or using the Raspap portal.

The script ```switch-network.sh``` is a cron job run by root. It turns off the
hotspot when there is an active wireless connection. Similiarly, it turns on the
hotspot when there is no wireless connection.

# Downloads


# Initial Setup

## Change hostname
## Change SSH password
## Change RASPAP username and password



# Changelog
## RPI4B
### v20200310
- Performed OS upgrade
- Removed vim
- Added librealsense support (build 2.33.1)
- Enabled serial port for MM1 and installed pyserial
- Upgraded pip to 20.0.2
- Installed vim
- Adopted https://github.com/amix/vimrc


### v20200324
- Rename init script to donkey-init.sh
- Added ~/donkey.cfg for config reset
- donkey-init.sh will rename hostname when DONKEY_RESET=True in donkey.cfg
- donkey-init.sh will reset wpa_supplicant.conf
- Change raspap country to US and use 80211.ac 5Ghz
- Install switch-network.sh to crontab

### v20200421
- Installed donkey console v2 under ~/
- Installed donkey console as systemd service


### v20200526
- Installed ffmpeg and keras-vis
``` 
apt-get install ffmpeg
pip install git+https://github.com/sctse999/keras-vis.git
```
- 