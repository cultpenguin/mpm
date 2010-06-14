% mpm : run MPM binary from within matlab

function [geou,geow,options]=mpm(x,z,vp,vs,rho,dt,mf,xs,zs,options)
options.null=[];
geou=[];
geow=[];

% GET MPM BINARY
% mpm_bin='/usr/local/bin/mpm';

if exist('mpm_bin')~=2
    mpm_bin=[fileparts(which('mpm.m')),filesep,'..',filesep,'src',filesep,'mpm'];
end
if exist(mpm_bin)==0
    disp(sprintf('%s : could not locate MPM binary ''%s''',mfilename,mpm_bin))
end

if nargin==0

    
    [status]=system(sprintf(['%s'],mpm_bin));
    
    return
end

if nargin<2
    y=1;
end

nx=length(x);
nz=length(z);
try
    dx=x(2)-x(1);
catch
    dx=z(2)-z(2);
end

if nargin<3; vp=ones(nz,nx).*1;end
if nargin<4; vs=vp/sqrt(3);end
if nargin<5; rho=vp;end
Vmax=max(vp(:));
Vmin=min(vs(:));
if nargin<6; options.dt=0.606*dx./Vmax;end
if nargin<7; options.mf=1; end
if nargin<8; options.xs=100*dx; end
if nargin<9; options.zs=5*dx; end


% CHECK STABILITY AND DISPERSION

[a,b,stability_ok]=criteria(Vmax,Vmin,options.mf,dx,options.dt);
if (stability_ok==0)
    disp(sprintf('%s : STABILITY criterion violated - stopping',mfilename))
    return
end

% COMPUTE ELASTIC FIELDS AND WRITE TO DISK
save_mpm_el(vp,vs,rho);

if ~isfield(options,'tmax'); options.tmax=30; end
if ~isfield(options,'sourcetype');options.sourcetype=3;end
if ~isfield(options,'snapsize');options.snapsize=3;end
if ~isfield(options,'beginsnap');options.beginsnap=30;end
if ~isfield(options,'dsnap');options.dsnap=30;end
if ~isfield(options,'lastsnap');options.lastsnap=round(options.tmax/options.dt/options.dsnap);end
if ~isfield(options,'autopad');options.autopad=1;end
if ~isfield(options,'verbose');options.verbose=0;end
if ~isfield(options,'pulsedelay');options.pulsedelay=150;end

write_mpm_par(nx,nz,dx,options.xs,options.zs,options.tmax,Vmax,Vmin,'sourcetype',options.sourcetype,'beginsnap',options.beginsnap,'dsnap',options.dsnap,'pulsedelay',options.pulsedelay,'snapsize',options.snapsize,'autopad',options.autopad,'verbose',options.verbose,'dt',options.dt);

    
[status]=system(sprintf(['%s'],mpm_bin));
    
try;geou=f77strip('geou.f77');catch;geou=[];end
try;geow=f77strip('geow.f77');catch;geow=[];end

%disp(sprintf('%s : %s',mfilename,status))


