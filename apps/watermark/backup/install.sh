#!/bin/bash

# Record PWD
SCRIPT_DIR = $PWD

# Prepare
apt-get install git

# Install php for watermark
apt-get install php5
apt-get install php5-gd

# Install apache2
apt-get install apache2
apt-get install apache2-utils

# Configure Server port
sed -i '$a ServerName localhost:80' /etc/apache2/apache2.conf

# Change folders to configure benchmark
cd /var/www

# Download the GD tool
git clone https://github.com/far-rainbow/php-watermark.git

cd $SCRIPT_DIR
