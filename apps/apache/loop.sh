#!/bin/bash

sudo /etc/init.d/nginx stop
sudo /etc/init.d/apache2 start

for ((;;))
do
	ab -n 1000000 -c 1000 http://localhost/ &>> $1
done
