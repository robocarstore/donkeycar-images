import sys
import subprocess

count = int(input("No of SD card: "))

no_of_disk_available = int(subprocess.check_output('df -h | grep /dev/sd | wc -l', shell = True).decode('utf-8')) // 2

if (no_of_disk_available != count):
    sys.exit(f"No of disk doesn't match. input = {count}, detected = {no_of_disk_available}. Program exited")

command = ["sudo", "dcfldd", "if=/tmp/pi4_v20200611.img"]

for i in range(count):
    command.append(f"of=/dev/sd{chr(ord('a') + i)}")

# subprocess.check_output(command)

def run_command(command):
    print(command)
    subprocess.check_output(command, shell=True)

for i in range(count):
    device = f"/dev/sd{chr(ord('a') + i)}"
    # subprocess.check_output()

    run_command(f"udisksctl unmount -b {device}1")
    run_command(f"udisksctl unmount -b {device}2")
    run_command(f"udisksctl power-off -b {device}")



