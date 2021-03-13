#!/bin/bash


input_confirmed=false

while [[ !input_confirmed ]]; do
    read -p "SSID: " ssid
    read -p "SSID password: " ssid_password
    read -p "Country code(2 character ISO 3166)): " country

    read -p "confirm (y/n)? " yn
    
    case $yn in
        [Yy]* ) input_confirmed=true; break;;
        [Nn]* ) input_confirmed=false; echo "Please enter again";; 
        * ) echo "Please answer yes or no.";;
    esac    
done

sudo nmcli conn down id hotspot
sleep 5
sudo iw reg set $country
sudo nmcli device wifi connect $ssid password $ssid_password
