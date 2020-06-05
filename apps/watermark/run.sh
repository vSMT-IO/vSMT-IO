#!/bin/bash

# Benchark output
mkdir Benchmark_Output

# Run the benchmark
ab -n 600000 -c 24 -g Benchmark_Output/out_gnuplot -e Benchmark_Output/out_csv http://127.0.0.1/php-watermark/wm.php

echo "Benchmark_Output stores ab output information"
echo ""
echo "PHP Output stores php output information"  
