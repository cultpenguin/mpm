% mpmbech.m : a script to benchmark MPM
%
%
clear all

bignx=500;
bignz=500;

vp=ones(bignx,bignz);
vp(100:215,100:280)=vp(100:215,100:280)*1.5;

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
zs=5*dx;  % minimum 4*dx
tmax=30;

sourcetype=3;

snapsize=3;
beginsnap=30;
dsnap=30;
lastsnap=tmax/dt/dsnap;

autopad=1;

verbose=0;

pulsedelay=150;

write_mpm_par(bignx,bignz,dx,xs,zs,tmax,Vmax,Vmin,'sourcetype',sourcetype,'beginsnap',beginsnap,'dsnap',dsnap,'pulsedelay',pulsedelay,'snapsize',snapsize,'autopad',autopad,'verbose',verbose);

tic;
unix('../../src/mpm');
ctime=toc;

disp(['']);
disp(['COMPUTER         COMPILER        TIME(s)']);
disp(['----------------------------------------']);
disp(['Linux 1Ghz         pgf77           28  ']);
disp(['Linux 1Ghz        g77 -Wall        44  ']);
disp(['Linux 1Ghz         g77 -O3         42  ']);
disp(['Linux 800Mhz    g77 -O3 -Wall      78  ']);
disp([' ']);
disp(['This computer : ',num2str(ctime)])
disp(['----------------------------------------']);




