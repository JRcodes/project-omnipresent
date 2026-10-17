#! /bin/bash
# Install the demo public key for the deploy user, then run sshd in the foreground
install -d -m 700 -o deploy -g deploy /home/deploy/.ssh
install -m 600 -o deploy -g deploy /keys/id_ed25519.pub /home/deploy/.ssh/authorized_keys
exec /usr/sbin/sshd -D -e
