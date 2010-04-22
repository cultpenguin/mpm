#!/bin/sh
#
# SMALL BENCHMARK FOR MPM
#
data_dir=bench3_data

gunzip $data_dir/*.mod.gz
ln -s $data_dir/*.mod* .
ln -s $data_dir/*.par .

time mpm

gzip $data_dir/*.mod
