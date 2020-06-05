#!/bin/bash

sudo apt-get install apache2

sudo /etc/init.d/nginx stop
sudo /etc/init.d/apache2 start
