#!/bin/bash

# Install mediatomb
sudo apt-get install mediatomb

# Install mencoder
sudo apt-get install mencoder libsqlite3-dev


#wget wget http://mirrors.standaloneinstaller.com/video-sample/jellyfish-25-mbps-hd-hevc.mkv

wget https://www.sample-videos.com/video/mkv/240/big_buck_bunny_240p_30mb.mkv

#mv jellyfish-25-mbps-hd-hevc.mkv test1.mkv
mv big_buck_bunny_240p_30mb.mkv test1.mkv
