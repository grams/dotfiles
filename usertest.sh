#!/bin/bash

# Creates a "test" user and initialize with these dotfiles

adduser test --disabled-password --gecos "test" || exit 1
sudo -u test -i ssh -o StrictHostKeyChecking=no github.com 2>/dev/null
cp ~/.ssh/id_rsa* /home/test/.ssh
cp ~/.Xauthority /home/test/.Xauthority
cp -R `dirname "$0"` /home/test/.dotfiles
chown -R test:test /home/test
sudo -u test -i .dotfiles/setupdotfiles.sh
sudo -u test -i .dotfiles/setupdotfiles.sh # Idempotency smoke test

# start a shell for manual UAT
su --login test

# cleanup
pkill -u test
deluser test && rm -rf /home/test

