% mbox_constant.m : 
%
% TMH 16/08/02
%
clear all

% MODEL

bignx=1000;
bignz=500;

vp=3000*ones(bignz,bignx);
vs=vp/sqrt(3);
rho=vp;

vp(100:200,400:410)=vp(100:200,400:410).*.8;
save_mpm_el(vp,vs,rho);style=1;


autopad=1; % AUTO PAD BORDERS

% BASIX PARAMETERS
dx=35; 
dt=.007;  
mf=8; % MAX FREQUENCY


% CHECK THAT STABILITY AND DISPERSION IS OK
Vmax=max(vp(:));
Vmin=min(vs(:));
criteria(Vmax,Vmin,mf,dx,dt);

% SOURCE
sourcetype=3;
xs=350*dx; % XPOS - IN METERS
zs=100*dx; % YPOS - IN METERS

% REC
geodepth=1*dx;

tmax=5;
snapsize=3;
beginsnap=10;
dsnap=10;
lastsnap=tmax/dt/dsnap;


% MOVING BOX
movflag=1; 
boxvpx=0; % NO VELOCITY -> NO MOVING BOX
boxvpz=0; % NO VELOCITY -> NO MOVING BOX
boxx0=250*dx;
boxz0=100*dx;

verbose=2;

pulsedelay=150;

wbox=500*dx; 
hbox=400*dx;
bufferwidth=50*dx;




write_mpm_par(bignx,bignz,dx,xs,zs,tmax,Vmax,Vmin,'sourcetype',sourcetype,'beginsnap',beginsnap,'dsnap',dsnap,'pulsedelay',pulsedelay,'style',style,'snapsize',snapsize,'autopad',autopad,'verbose',verbose,'movflag',movflag,'boxvpx',boxvpx,'wbox',wbox,'hbox',hbox,'bufferwidth',bufferwidth,'boxx0',boxx0,'boxz0',boxz0,'boxvpz',boxvpz,'geodepth',geodepth);

tic;
unix('../../../src/mpm');
ctime=toc;

disp(['']);
disp(['COMPUTER         COMPILER        TIME(s)']);
disp(['----------------------------------------']);
disp(['Linux 1Ghz         pgf77           28  ']);
disp([' ']);
disp(['This computer : ',num2str(ctime)])
disp(['----------------------------------------']);




