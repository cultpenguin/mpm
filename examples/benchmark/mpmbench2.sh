#!/bin/sh
#
# SMALL BENCHMARK FOR MPM
#
data_dir=bench2_data

gunzip $data_dir/*.mod.gz
ln -s $data_dir/*.mod* .
ln -s $data_dir/*.par .

time mpm

echo ""
echo "COMPUTER         COMPILER        TIME(s)"
echo "----------------------------------------"
echo "----------------------------------------"

gzip $data_dir/*.mod
