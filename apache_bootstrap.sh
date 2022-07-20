#! /bin/bash

# Upgrade services
sudo apt upgrade -y

# Install apache
sudo apt install -y apache2

# Install php
sudo apt install -y php

# Install apache-php module
sudo apt instal -y libapache2-mod-php

# Enable module
sudo a2enmod php

# Reload apache
sudo systemctl reload apache2