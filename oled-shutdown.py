from luma.core.interface.serial import i2c
from luma.core.render import canvas
from luma.oled.device import sh1106, ssd1306
from PIL import ImageFont
import socket
import time



def get_hostname():
    return socket.gethostname()

def text():
    result = f"Hostname: {get_hostname()}\n"
    result += f"Shutdown/Reboot\n"
    result += f"Unplug power for shutdown\n"
        
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

with canvas(device) as draw:
    draw.text((0, 0), text(), fill="white", font=font)


    
