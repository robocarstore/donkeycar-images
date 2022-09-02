#!/bin/bash

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo $SRC_DIR

CONFIG_FILE="$SRC_DIR/resources/donkey.cfg"

JUPYTER_CONFIG_FILE="$SRC_DIR/resources/pi4_v4/jupyter_config/jupyter_server_config.json"

echo $JUPYTER_CONFIG_FILE

# echo "Please enter the new password:"
# read -s PW1
# echo "Please repeat the new password:"
# read -s PW2
# # Check both passwords match
# if [ $PW1 != $PW2 ]; then
#     echo "Passwords do not match"
#      exit    
# fi

NEW_PASSWORD=$PW1
NEW_PASSWORD="abcd1234"

# sed -i  "s/PASSWORD.*/PASSWORD=$NEW_PASSWORD/g" $CONFIG_FILE

sed -i  "s/PASSWORD.*/PASSWORD=$NEW_PASSWORD/g" $CONFIG_FILE


# Update Jupyter Lab password
JUPYTER_PW=$(python3 -c "from notebook.auth import passwd; print(passwd('$NEW_PASSWORD'))")
# echo $JUPYTER_PW
jq ".ServerApp.password=\"$JUPYTER_PW\"" $JUPYTER_CONFIG_FILE | sponge $JUPYTER_CONFIG_FILE

# cat resources/pi4_v4/jupyter_config/jupyter_server_config.json

# sed -i "s/\"argon2\:.*\"$/\"$JUPYTER_PW\"/g" resources/pi4_v4/jupyter_config/jupyter_server_config.json

# echo "pi:$" | sudo chpasswd

