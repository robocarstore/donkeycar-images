#!/bin/bash
HOSTNAME=nano.local

function sync() {
    rsync -avzp --exclude dist ~/projects/donkeycar-images/ nano@$HOSTNAME:~/donkeycar-images --delete
}

sync

while inotifywait --exclude dist -r -e modify,create,delete,move,attrib ~/projects/donkeycar-images; do
    sync
done

