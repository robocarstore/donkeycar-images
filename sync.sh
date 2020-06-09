PI_HOSTNAME=donkey-10d94a.local

function sync() {
    rsync -avz ~/projects/donkeycar-images/ pi@$PI_HOSTNAME:~/donkeycar-images --delete

    # rsync -avz pi@pi4.local:~/mycar_mm1/data/ ~/mycar_mm1/data
    # rsync -avz  ~/mycar_mm1/models/ pi@pi4.local:~/mycar_mm1/models
}

while inotifywait -r -e modify,create,delete,move ~/projects/donkeycar-images; do
    sync
done

