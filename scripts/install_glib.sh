#!/bin/bash

#tested on Ubuntu-server-14.04.4

sudo apt-get install libglib2.0-0 libglib2.0-dev
cd /usr/include/glib-2.0/
sudo cp * -rf ../
sudo cp /usr/lib/x86_64-linux-gnu/glib-2.0/include/glibconfig.h /usr/include/
