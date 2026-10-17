#! /bin/bash

DOCROOT='/var/www/html'
# On the host almighty.sh points this at the repo's web_docs; on nodes control.sh copies web_docs to ~
WEB_DOCS_SRC="${WEB_DOCS_SRC:-$HOME/web_docs}"
export DEBIAN_FRONTEND=noninteractive

echo "           ~~~~~~~~~~~~~~~~~~~~ Applying Configurations! ~~~~~~~~~~~~~~~~~~~~               "
echo "          "

echo "                                ***Updating Services***                                     "
echo "          "
# Refresh package lists and upgrade services
sudo apt-get update || exit
sudo -E apt-get upgrade -y || exit

echo "          "
echo "                               ***Installing Apache2***                                     "
echo "          "
# Install apache
sudo -E apt-get install -y apache2 || exit

echo "          "
echo "                                 ***Installing PHP***                                       "
echo "          "
# Install php
sudo -E apt-get install -y php libapache2-mod-php || exit

# Remove test index so index.php is served
if [ -e "$DOCROOT/index.html" ]; then
    sudo rm "$DOCROOT/index.html" || exit
fi

echo "          "
echo "                             ***Moving some files around***                                 "
echo "          "
# Always sync so edits to web_docs reach the server on every push
sudo cp -r "$WEB_DOCS_SRC"/. "$DOCROOT"/ || exit
# `service` works under systemd and in containers without it
sudo service apache2 restart || exit
echo "                              ***Configuration Applied***                                   "
echo "          "
