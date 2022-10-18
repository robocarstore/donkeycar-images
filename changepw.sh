#!/bin/bash

while getopts p: flag
do
    case "${flag}" in
        p) NEW_PASSWORD=${OPTARG};;        
    esac
done

if [ -z "$NEW_PASSWORD" ]; then
    echo "Interactive mode"
    while true; do
        echo "Password must be 6-8 characters long, containing alphabet and/or digits only"

        while true; do
            echo "Please enter the new password:"
            read -s PW1

            if [[ $PW1 =~ [A-Za-z0-9]{4,8} ]]; then
                break
            else
                echo "Password is not valid"
            fi
        done

        echo "Please repeat the new password:"
        read -s PW2
        # Check both passwords match
        if [ $PW1 != $PW2 ]; then
            echo "Passwords do not match"
        else
            NEW_PASSWORD=$PW1
            break
        fi
    done
else
    echo "Silent mode"
    
    # Check password for 
    if ! [[ $NEW_PASSWORD =~ [A-Za-z0-9]{4,8} ]]; then
        echo "Password is not valid"
        exit
    fi
fi

# NEW_PASSWORD="abcd12345"

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo $SRC_DIR

CONFIG_FILE="$SRC_DIR/resources/donkey.cfg"

JUPYTER_CONFIG_FILE="$SRC_DIR/resources/jupyter_config/jupyter_server_config.json"

echo $JUPYTER_CONFIG_FILE


# Update config file password
sed -i  "s/^PASSWORD.*$/PASSWORD=$NEW_PASSWORD/g" $CONFIG_FILE

# Update system password
echo "pi:$NEW_PASSWORD" | sudo chpasswd

# Update Jupyter Lab password
JUPYTER_PW=$(/home/pi/env/bin/python3 -c "from notebook.auth import passwd; print(passwd('$NEW_PASSWORD'))")
jq ".ServerApp.password=\"$JUPYTER_PW\"" $JUPYTER_CONFIG_FILE | sponge $JUPYTER_CONFIG_FILE

sudo chown pi.pi $JUPYTER_CONFIG_FILE

sudo systemctl restart jupyter-lab.service


echo "password updated successfully"
