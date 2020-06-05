#!/bin/bash

cd /var/www/php-watermark/in

for x in `seq 0 999`; do

if [[ $x -lt 10 ]]; then sudo cp DSC06447.JPG file-00${x}.JPG 

elif [[ $x -lt 100 ]]; then sudo cp DSC06447.JPG file-0${x}.JPG

else sudo cp DSC06447.JPG file-${x}.JPG

fi

done
