#!/bin/bash
# Xiaowei Shang <xs225@njit.edu> (bash) 2018

#build and install xgboost on Ubuntu
XGBOOST_HOME=~/xgboost

sudo apt-get update
sudo apt-get install g++ gfortran python-dev python-numpy python-scipy python-matplotlib python-pandas libatlas-base-dev
sudo apt-get install build-essential python-dev python-setuptools python-numpy python-scipy libatlas-dev libatlas3gf-base
sudo apt-get install python-setuptools
sudo apt-get install python-pip git
sudo apt-get install python-dev
sudo pip install scikit-learn

#build
cd ../
CURRENT_DIR=`pwd`
cd ~
git clone --recursive https://github.com/xiaoweishang/xgboost
cd $XGBOOST_HOME
make

#install
cd python-package; sudo python setup.py install

#test
python ../tests/benchmark/benchmark.py

#recovery dir
#cd $CURRENT_DIR
#mv $XGBOOST_HOME ./
#cd xgboost
#XGBOOST_HOME=`pwd`
