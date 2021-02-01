PI_HOSTNAME=donkey-2a7e91.local

function sync() {
    rsync -avz --exclude 'dist' 'resources/donkey.cfg' ~/projects/donkeycar-images/ pi@$PI_HOSTNAME:/opt/donkeycar-images --delete

    # rsync -avz pi@pi4.local:~/mycar_mm1/data/ ~/mycar_mm1/data
    # rsync -avz  ~/mycar_mm1/models/ pi@pi4.local:~/mycar_mm1/models
}
sync

while inotifywait -r -e modify,create,delete,move ~/projects/donkeycar-images; do
    sync
done
