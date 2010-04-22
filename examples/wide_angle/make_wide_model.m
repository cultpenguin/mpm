maxX=1800000;
maxZ=400000;

dx=240;
nx=ceil(maxX/dx);
nz=ceil(maxZ/dx);


prop=4; % Parts to split the velocity field in
        % must be an 'equal' number (dividable by 2)

nabs=50; % Width of absorbing border

nnx=round(nx./prop);

nx=round(ceil(maxX/dx)/prop)*prop;
nz=ceil(maxZ/dx);

vp=ones(nz,nnx);

% UPPER CRUST
z1=20000;
nz1=round(z1/dx);
vp(1:nz1,:)=vp(1:nz1,:).*0+5800;

% LOWER CRUST
z2=35000;
nz2=round(z2/dx);
rseed=58;dz=dx;
ix=nnx*dx;iz=(nz2-nz1)*dz;
ax=800;
az=200;
pop=2; % PDF
pop=1; % GAUSS
med=3; % von Karman
nu=.6; % D=2.7
vel=[600];
frac=[1];
[rand_lc]=vonk2d(rseed,dx,dz,ax,az,ix,iz,pop,med,nu,vel,frac);
rand_lc=(rand_lc./max(max(rand_lc))).*vel+6500;
vp((nz1+1):nz2,:)=rand_lc;


% UPPER MANTLE
nz3=nz;
rseed=58;dz=dx;
ix=nnx*dx;iz=(nz-nz2)*dz;
az=700*1;
ax=az*4*1;
pop=1; % GAUSS
med=1; % von Karman
nu=.6; % D=2.7
vel=[600];
frac=[1];
[rand_um]=vonk2d(rseed,dx,dz,ax,az,ix,iz,pop,med,nu,vel,frac);
maxr=max(max(rand_um));
rand_um=(rand_um./maxr).*vel+8100;
%[rand_um2]=vonk2d(rseed,dx,dz,ax,az/4,ix,iz,pop,med,nu,vel,frac);
%rand_um2=(rand_um2./maxr).*vel+8100;
vp((nz2+1):nz,:)=rand_um;

vp_small=vp;
for i=2:prop
vp=[vp,vp_small];
end


[nz,nx]=size(vp);

x=[1:1:nx].*dx/1000;
z=[1:1:nz].*dx/1000;

save_mpm(vp,sqrt(3),1.5);




% MODELING PARAMETERS
disp('Detrmining modeling parameters')
 Vmax=max(max(vp));
 Vmin=0.88*min(min(vp./1.73));
 f_peak=5;
 mf=2.5*f_peak;
 dt=0.001;
 tmax=50;
 
 [dt,mf]=criteria(Vmax,Vmin,mf,dx,dt);
 [dt,mf]=criteria(Vmax,Vmin,mf,dx,dt);

 nt=tmax/dx;
 disp(['nt=',num2str(nt)])


% BASIC MODEL
[bignz,bignx]=size(vp);
autopad=1;

% SOURCE
sourcetype=3;
xs=200*dx; % XPOS - IN METERS
zs=1*dx; % YPOS - IN METERS
pulsedelay=150;
% RECEIVERS
geodepth=1*dx;


% SNAP
dsnap=100;
beginsnap=dsnap;
snapsize=3;


verbose=1;






