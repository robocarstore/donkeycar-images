from luma.core.interface.serial import i2c
from luma.core.render import canvas
from luma.oled.device import sh1106
from PIL import ImageFont
import netifaces
import socket
import time
import subprocess
import re

wlan = "wlan0"


def get_wlan_ip_address():
    addrs = get_addrs(wlan)

    if addrs is None:
        return None

    if (netifaces.AF_INET in addrs) and (len(addrs[netifaces.AF_INET]) == 1):
        return addrs[netifaces.AF_INET][0]['addr']
    else:
        return None


def get_addrs(interface):
    interfaces = netifaces.interfaces()

    if interface not in interfaces:
        # logger.error(f"Network interface is not properly configured. {interface} does not exists.")
        return None

    return netifaces.ifaddresses(interface)


def get_current_ssid():
    try:
        output = str(subprocess.check_output(['/sbin/iwconfig', wlan]))
        m = re.search('ESSID:"(.*)"', output)

        if m is None:
            return None
        else:
            return m.group(1)
    except Exception as e:
        print(e)
        return "OS not support"


def get_hostname():
    return socket.gethostname()


def text():
    result = f"Hostname: {get_hostname()}\n"
    result += f"IP: {get_wlan_ip_address()}\n"
    result += f"SSID: {get_current_ssid()}\n"

    from datetime import datetime

    now = datetime.now()

    current_time = now.strftime("%H:%M:%S")

    result += f"Date: {current_time}\n"

    return result


serial = i2c(port=1, address=0x3C)
device = sh1106(serial, persist=True)
device.cleanup = None

font = ImageFont.truetype(
    '/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf', 8)

with canvas(device) as draw:
    draw.rectangle(device.bounding_box, outline="white", fill="black")
    draw.text((0, 0), text(), fill="white", font=font)
