% mpmbech.m : a script to benchmark MPM
%
%
clear all

bignx=3000;
bignz=500;

vp=ones(bignz,bignx);
vp(200:215,200:280)=vp(200:215,200:280)*1.5;

vs=vp/sqrt(3);
rho=vp;

save_mpm_el(vp,vs,rho);

Vmax=max(vp(:));
Vmin=min(vs(:));

dx=.1; 
dt=.04;  
mf=1; %1;

criteria(Vmax,Vmin,mf,dx,dt);


xs=100*dx;
zs=100*dx;  % minimum 4*dx
tmax=240;

sourcetype=3;
beginsnap=100;
dsnap=100;
lastsnap=tmax/dt/dsnap;
snapsize=3;

boxx0=-100*dx;
boxz0=200*dx;
boxvpx=vp(1);
boxvpz=0;

wbox=500*dx;
hbox=300*dx;
bufferwidth=100*dx;



nxs=350;
nzs=100;

pulsedelay=150;

autopad=1;

verbose=1;

write_mpm_par(bignx,bignz,dx,xs,zs,tmax,Vmax,Vmin,'sourcetype',sourcetype,'beginsnap',beginsnap,'dsnap',dsnap,'snapsize',snapsize,'pulsedelay',pulsedelay,'wbox',wbox,'hbox',hbox,'bufferwidth',bufferwidth,'boxx0',boxx0,'boxz0',boxz0,'boxvpx',boxvpx,'boxvpz',boxvpz,'nxs',nxs,'nzs',nzs,'verbose',verbose,'autopad',autopad);
tic;
unix('../../src/mpm');
ctime=toc;

disp(['']);
disp(['COMPUTER         COMPILER        TIME(s)']);
disp(['----------------------------------------']);
disp([' ']);
disp(['This computer : ',num2str(ctime)])
disp(['----------------------------------------']);




