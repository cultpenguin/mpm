% mpmbech3.m : a script to benchmark MPM
%
% This example shows a very simple propagating wave.
%
%
clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CREATE MODEL
bignx=600;
bignz=600;
vp=ones(bignz,bignx);
rho=vp;
rho(:,400:500)=rho(:,400:500)*1.5;
vs=vp/sqrt(3);


% SAVE MODEL
save_mpm_el(vp,vs,rho);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CHECK STABILITY/DISPERSION
Vmax=max(vp(:));
Vmin=min(vs(:));

dx=.1; 
dt=.06;  
mf=1; %1;

criteria(Vmax,Vmin,mf,dx,dt);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MODELING PARAMETERS

% SOURCE 
xs=(bignx/2)*dx;  
zs=(bignx/2)*dx;  % minimum 4*dx
tmax=48;
pulsedelay=150;
sourcetype=3;
rotation=1; % [1] Rotation (S) source, [0] Compressional (P) source

% RECEIVERS
geodepth=(bignx/2)*dx; % Geophonedepth
geotype=3;

% Upper Boundary
freeupper=0; % [1] free surface, [0] no free surface

% SNAPSHOTS
beginsnap=20;
dsnap=beginsnap;
lastsnap=tmax/dt/dsnap;
snapsize=1;

autopad=1;

verbose=1;

write_mpm_par(bignx,bignz,dx,xs,zs,tmax,Vmax,Vmin,'dt',dt,'sourcetype',sourcetype,'rotation',rotation,'beginsnap',beginsnap,'dsnap',dsnap,'snapsize',snapsize,'pulsedelay',pulsedelay,'verbose',verbose,'autopad',autopad,'geodepth',geodepth,'geotype',geotype);


tic;
unix('../../src/mpm');
ctime=toc;

disp(['']);
disp(['COMPUTER         COMPILER        TIME(s)']);
disp(['----------------------------------------']);
disp([' ']);
disp(['This computer : ',num2str(ctime)])
disp(['----------------------------------------']);




