% EXAMPLE OF A WIDE ANGLE MODELING : USING MOVING BOX

% MOVING BOX
wbox=(bignx-2)*dx;
hbox=(bignz-2)*dx;
bufferwidth=2*dx;

boxx0=100*dx;
boxz0=0*dx;
boxvpx=0;
boxvpz=0;
movflag=1;


write_mpm_par(bignx,bignz,dx,xs,zs,tmax,Vmax,Vmin,'sourcetype',sourcetype,'beginsnap',beginsnap,'dsnap',dsnap,'pulsedelay',pulsedelay,'snapsize',snapsize,'autopad',autopad,'verbose',verbose,'movflag',movflag,'boxvpx',boxvpx,'wbox',wbox,'hbox',hbox,'bufferwidth',bufferwidth,'boxx0',boxx0,'boxz0',boxz0,'boxvpz',boxvpz,'geodepth',geodepth);


