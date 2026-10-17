#! /bin/bash
# Install the demo private key for root, then stay up so commands can be exec'd in
install -d -m 700 /root/.ssh
install -m 600 /keys/id_ed25519 /root/.ssh/id_ed25519
exec sleep infinity
