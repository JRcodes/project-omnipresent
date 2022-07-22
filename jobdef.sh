#! /bin/bash

DOCROOT='/var/www/html'

# Upgrade services
sudo apt upgrade -y

# Install apache: check if installed if not then install
echo "# # # # # Checking if apache2 is installed...."
sudo apt install apache2 -y

# Install php: check if installed if not then install
echo "# # # # # Checking if php is installed....\n"
psudo apt install php -y

# Remove test index and place php test file at document root
if [ -e $DOCROOT/index.html ]; then
    sudo rm /var/www/html/index.html
fi

if [ ! -e $DOCROOT/index.php ]; then
    echo "# # # # # Copying over web documents to document root...\n."
    sudo cp ~/web_docs/index.php $DOCROOT/index.php
    sudo systemctl restart apache2.service
    echo "# # # # # Configuration Complete\n!"
else
    sudo systemctl restart apache2.service
    echo "# # # # # Configuration Complete!\n"
fi