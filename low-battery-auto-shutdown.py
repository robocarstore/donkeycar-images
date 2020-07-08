import board
import busio
import adafruit_ina219
import subprocess

try:
    i2c = busio.I2C(board.SCL, board.SDA)
    ina219 = adafruit_ina219.INA219(i2c, 0x41)

    current_voltage = ina219.bus_voltage
    print(f"Current voltage = {current_voltage}")

    if current_voltage < 7:
        print("current voltage under 7. Shutting down to protect the pi")
        subprocess.check_output(['sudo', 'shutdown', '-h', 'now'])
except Exception as e:
    print(e)