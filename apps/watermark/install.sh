#!/bin/bash

# Record PWD
SCRIPT_DIR=$PWD

# Prepare
sudo apt-get install git

# Install php for watermark
sudo apt-get install php5
sudo apt-get install php5-gd

# Install apache2
sudo apt-get install apache2
sudo apt-get install apache2-utils

# Configure Server port
sudo sed -i '$a ServerName localhost:80' /etc/apache2/apache2.conf

# Change folders to configure benchmark
cd /var/www/html

# Download the GD tool
sudo git clone https://github.com/far-rainbow/php-watermark.git

# Prepare the 1000 images
cd $SCRIPT_DIR

#sudo ./copy.sh

sudo chmod 777 /var/www/html/php-watermark/out
