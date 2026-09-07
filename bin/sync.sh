#!/bin/bash

# synchronize dir content with remote for testing with VM's this is useful to avoid mounting remote filesystem with sshfs or similar solutions.
# ssh need to be cofigured for the remote host to sync

REMOTES="$@"
TARGET_FILES="."

function do_sync(){
  echo $@ | tr ' ' '\n' | parallel 'rsync -avr --delete . {}:~/$(basename $(pwd))'
}

# syncronize with remote host deleting remote files with local ones
do_sync $REMOTES

# monitor for move_self and create cause vim deletes original file and rename swapfile
inotifywait \
--monitor  \
--event move_self \
--event create \
--event modify \
--event delete \
--recursive \
--exclude "$(find .  -name '.git' -type d -printf '%P|').*\.aux|.*\.bbl|.*\.bcf|.*\.bcf-SAVE-ERROR|.*\.blg|.*\.fdb_latexmk|.*\.fls|.*\.idx|.*\.ilg|.*\.ind|.*\.log|.*\.out|.*\.pdf|.*\.run" \
--format "%w %e %f" $TARGET_FILES | while read file event newfile; do

do_sync $REMOTES

done
