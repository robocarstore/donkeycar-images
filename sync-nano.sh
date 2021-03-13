#!/bin/bash
HOSTNAME=nano.local
TARGET_PATH=/opt/donkeycar-images

function sync() {
    rsync -avzp --exclude dist ~/projects/donkeycar-images/ nano@$HOSTNAME:$TARGET_PATH --delete
}

sync

while inotifywait --exclude dist -r -e modify,create,delete,move,attrib ~/projects/donkeycar-images; do
    sync
done

