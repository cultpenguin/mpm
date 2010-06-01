clear all

%% SETUP MODEL
bignx=500;
bignz=500;

vp=ones(bignx,bignz);
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

%%%%%%%%%%
%	return
%%%%%%%%%%


xs=100*dx;
zs=5*dx;  % minimum 4*dx
tmax=36;

sourcetype=3;
beginsnap=30;
dsnap=30;
lastsnap=tmax/dt/dsnap

pulsedelay=150;

write_mpm_par(bignx,bignz,dx,xs,zs,tmax,Vmax,Vmin,'sourcetype',sourcetype,'beginsnap',beginsnap,'dsnap',dsnap,'pulsedelay',pulsedelay);

%unix('../../mpm')
mpm

M=mpmmov('div.snap',bignx-2,bignz-2,1,28,1,.000025);
movie(M,5,10)





