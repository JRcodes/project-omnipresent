#! /bin/bash

DOCROOT='/var/www/html'

# Upgrade services
sudo apt upgrade -y

# Install apache: check if installed if not then install
echo "# # # # # Checking if apache2 is installed...."
apache=$(which apache2)

if [ -z $apache ]; then
    echo "# # # # # Could not find a version of apache2."
    echo "# # # # # Installing apache2...."
    sudo apt install -y apache2
else
    echo "# # # # # An installation for apache2 found\n"
fi
# Install php: check if installed if not then install
echo "# # # # # Checking if php is installed....\n"
php=$(which php)

if [ -z $php ]; then
    echo "# # # # # Could not find a version of php\n"
    echo "# # # # # Installing php....\n"
    sudo apt install -y php
else
    echo "# # # # # An installation for php found\n"
fi

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