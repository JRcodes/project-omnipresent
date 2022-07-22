#! /bin/bash

DOCROOT='/var/www/html'

echo "           ~~~~~~~~~~~~~~~~~~~~ Applying Configurations! ~~~~~~~~~~~~~~~~~~~~               "
echo "          "

echo "                                ***Updating Services***                                     "
echo "          "
# Upgrade services
sudo apt upgrade -y || exit

echo "                               ***Installing Apache2***                                     "
echo "          "
# Install apache
sudo apt install apache2 -y || exit

echo "                                 ***Installing PHP***                                       "
echo "          "
# Install php
sudo apt install php -y || exit

# Remove test index and place php test file at document root
if [ -e $DOCROOT/index.html ]; then
    sudo rm /var/www/html/index.html || exit
fi

echo "                             ***Moving some files around***                                 "
echo "          "
if [ ! -e $DOCROOT/index.php ]; then
    sudo cp ~/web_docs/index.php $DOCROOT/index.php || exit
    sudo systemctl restart apache2.service || exit
    echo "                              ***Configuration Applied***                                   "
    echo "          "
else
    sudo systemctl restart apache2.service || exit
    echo "                              ***Configuration Applied***                                   "
    echo "          "
fi