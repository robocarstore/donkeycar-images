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