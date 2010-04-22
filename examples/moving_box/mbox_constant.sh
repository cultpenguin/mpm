#!/bin/sh
#
# mbox_constant.sh
#
data_dir=data

gunzip $data_dir/*.mod.gz
ln -s $data_dir/*.mod* .
ln -s $data_dir/mpm.par.constant mpm.par

time mpm

gzip $data_dir/*.mod

xmovie n2=1100 n1=603 < div.snap clip=1e-11 width=400 height=300 title='%g'