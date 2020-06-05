#!/bin/bash

#./sockperf server --tcp -i 0.0.0.0  -p 12345
./sockperf sr --msg-size 140000 --ip 0.0.0.0 --port 19140 --tcp
