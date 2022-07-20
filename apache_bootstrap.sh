#! /bin/bash

# Upgrade services
sudo apt upgrade -y

# Install apache
sudo apt install -y apache2

# Install php
sudo apt install -y php libapache2-mod-php

# Remove test index and place php test file at document root
sudo rm /var/www/html/index.html
sudo cp index.php /var/www/html/index.php