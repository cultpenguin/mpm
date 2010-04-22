% EXAMPLE OF A WIDE ANGLE MODELING : USING MOVING BOX

% MOVING BOX
wbox=500*dx;
hbox=500*dx;
bufferwidth=100*dx;

boxvpx=8100;
boxvpz=0;
boxx0=xs-pulsedelay*dt*boxvpx;
boxz0=0*dx;
movflag=1;


write_mpm_par(bignx,bignz,dx,xs,zs,tmax,Vmax,Vmin,'sourcetype',sourcetype,'beginsnap',beginsnap,'dsnap',dsnap,'pulsedelay',pulsedelay,'snapsize',snapsize,'autopad',autopad,'verbose',verbose,'movflag',movflag,'boxvpx',boxvpx,'wbox',wbox,'hbox',hbox,'bufferwidth',bufferwidth,'boxx0',boxx0,'boxz0',boxz0,'boxvpz',boxvpz,'geodepth',geodepth);


