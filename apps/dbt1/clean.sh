#!/bin/bash

cd $HOME

rm -rf pgdata
rm -rf finaloutput
rm -rf postgresql-7.4.1*
rm -rf dbt1-pgsql*
rm -rf pgdata
rm -rf logfile

sudo rm -rf /usr/local/pgsql

rm -rf /tmp/address.data /tmp/author.data /tmp/cc_xacts.data /tmp/country.data /tmp/customer.data 
rm -rf /tmp/item.data /tmp/order*
rm -rf /tmp/.s.PGSQL*

#free port
sudo netstat -anp | grep "5432"
killall postgres
killall postmaster
killall appCache

