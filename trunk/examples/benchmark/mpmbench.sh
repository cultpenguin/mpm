#!/bin/sh
#
# SMALL BENCHMARK FOR MPM
#
data_dir=bench_data

gunzip $data_dir/*.mod.gz
ln -s $data_dir/*.mod* .
ln -s $data_dir/*.par .

time mpm

echo ""
echo "COMPUTER         COMPILER        TIME(s)"
echo "----------------------------------------"
echo "Linux 1Ghz         pgf77           28  "
echo "Linux 1Ghz        g77 -Wall        44  "
echo "Linux 1Ghz         g77 -O3         42  "
echo "Linux 800Mhz    g77 -O3 -Wall      78  "
echo "Linux 2.4, 800Mhz ifc -O3 -W0      39  "
echo "Linux 2.4, 800Mhz  ifc -W0         47  "
echo "----------------------------------------"


gzip $data_dir/*.mod
