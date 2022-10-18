from luma.core.interface.serial import i2c
from luma.core.render import canvas
from luma.oled.device import sh1106, ssd1306
from PIL import ImageFont
import netifaces
import socket
import time
import subprocess
import re


'''
Install this script by executing the following

sudo ln -sf /opt/donkeycar-images/resources/oled.service /etc/systemd/system/oled.service

'''

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


def read_config_file():
    import configparser
    with open('resources/donkey.cfg', 'r') as f:
        config_string = '[donkey_config]\n' + f.read()
        config = configparser.ConfigParser()
        config.read_string(config_string)

    return config


def get_password():
    config = read_config_file()
    try:
            password = config['donkey_config']['PASSWORD']
        except KeyError:
            password = "No PW"

        # print(config.items('donkey_config'))
        # config.get('donkey_config', 'PASSWORD')
        return password

def network_info():
    result = f"Hostname: {get_hostname()}\n"
    result += f"IP: {get_wlan_ip_address()}\n"
    result += f"SSID: {get_current_ssid()}\n"
        
    return result

def time_info():
    from datetime import datetime

    now = datetime.now()
    current_date = now.strftime("%Y-%m-%d")
    current_time = now.strftime("%H:%M:%S")

    password = get_password()
    result = f"Date: {current_date}\n"
    result += f"Time: {current_time}\n"

    config = read_config_file()
    print(config['donkey_config']['CYCLE_DISPLAY_PASSWORD'])
    if (config['donkey_config']['CYCLE_DISPLAY_PASSWORD']).lower() == "true":
        result += f"PW: {password}\n"
    
    return result
    

# serial = None
serial = i2c(port=1, address=0x3C)
device = None
while device is None:
    try:
      device = ssd1306(serial, rotate=0, height=32, persist=False)
    except:
      time.sleep(5)

device.cleanup = None

# requires sudo apt-get install fonts-dejavu
font = ImageFont.truetype(
    '/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf', 8)

# pwfont = ImageFont.truetype(font=None, size=10, index=0, encoding=”) 
pwfont = ImageFont.truetype(
    '/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf', 24)


with canvas(device) as draw:
    left_offset = int((10 - len(get_password()))/2*10)
    draw.text((left_offset, 6), get_password(), fill="white", font=pwfont)

time.sleep(2)

while(True):
    with canvas(device) as draw:
        draw.text((0, 0), time_info(), fill="white", font=font)
        
    time.sleep(2)
    
    with canvas(device) as draw:
        draw.text((0, 0), network_info(), fill="white", font=font)
        
    time.sleep(4)

    
