% write_mpm_par : Write mpm.par file for use with MPM
% Purpose : WRITES OUT PAR-FILE FOR USE WITH 'MPM' (Thomas Mejer Hansen)
%
% CALL  write_mpm_par(bignx,bignz,dx,xs,zs,tmax,Vmax,Vmin,varargin)
% varargin is specified in MATLAB style as eg. varargin=['movflag',1,'boxx0',100,....]
%
% (C) cultpenguin.com 2001
% Author : HCS/2001
%

function write_mpm_par(bignx,bignz,dx,xs,zs,tmax,Vmax,Vmin,varargin)

% If values are not specified in the varargin list, defaults (see below) are used.
% MODEL ON DISK:
%  bignx, bignz        [scalar] : Size of model on disk in samples
%  dx                  [scalar] : Spatial sampling interval [m]
%  Vmax                [scalar] : Maximum P-wave velocity [m/s]
%  Vmin                [scalar] : Minimum P-wave velocity [m/s]
% MOVING BOX:
%  wbox,hbox           [scalar] : Size of small moving box in meters
%  bufferwidth         [scalar] : Padding zone (meters) for optimal boundary performance
%  movflag             [scalar] : Position of moving box. 0 for load from file wavepos.asc, 1 for definition by boxx0, boxz0, boxvpx, boxvpz
%  boxx0, boxz0        [scalar] : Startposition of center of moving box[meters]
%  boxvpx, boxvpz      [scalar] : Velocity of moving box [m/s]
% TIME SAMPLING
%  t_max               [scalar] : Maximum time
%  dt                  [scalar] : Time sampling interval
% SOURCE
%  sourcetype          [scalar] : Define source wavelet. 1 for Ricker, 2 for cosine, 3 for Gaussian
%  rotation            [scalar] : [1] S-wave , [0] P-wave
%  xs, zs              [scalar] : Source location [m]
%  f_main              [scalar] : Main frequency in source wavelet
%  pulsedelay          [scalar] : Delay of center of source wavelet (see User Guide ver. 1.0)
% RECEIVERS
%  geotype             [scalar] : Quantity to be measured. 1=velocity, 2=div/rot, 3=both
%  geodepth            [scalar] : Depth to receivers in samples
% BOUNDARIES
%  freeupper           [scalar] : 1 for free upper surface, 0 otherwise
%  absmode             [scalar] : Type of absorbing boundary. 0 for Clayton & Engquist, 1 for Cerjan.
%  edgefactor          [scalar] : Only relevant if absmode=1. Set damping value at the border
%  dampingwidth        [scalar] : Only relevant if absmode=1. Width of damping zone in samples
%  dampingexponent     [scalar] : Only relevant if absmode=1.
%  dampingtype         [scalar] : Only relevant if absmode=1. Damping applied to: 1 the stress field, 2 both stress and velocity fields
%  edgefactorf         [scalar] :
%  vdamp
%  maxfdamp
%  expbase
% AUTOSAVE
%  restoreautosave     [scalar] : In case of crash; 1 restart modeling from autosaved file, 0 start over
%  dautosave           [scalar] : Autosave interval in timesamples
% IO
%  usnapflag           [scalar] : Save snapshot of u_t. 1=yes, 0=no
%  wsnapflag           [scalar] : Save snapshot of w_t. 1=yes, 0=no
%  prsnapflag          [scalar] : Save snapshot of pr_t. 1=yes 0=no
%  divsnapflag         [scalar] : Save snapshot of the divergence of the wavefield (P-waves). 1=yes, 0=no
%  rotsnapflag         [scalar] : Save snapshot of the rotation of the wavefield (S-waves). 1=yes, 0=no
%  snapsize            [scalar] : Size of snapshot region. 1 for small moving box, 2 for moving box plus buffer region, 
%                                 3 for the whole model (3 only possible for u_t and w_t)
%  beginsnap           [scalar] : First snapshot in time samples
%  xyskip              [scalar] : Skip every xyskip sample from snapshots
%  traceskip           [scalar] : Skip every traceskipe receiver
%  tskip               [scalar] : Skip every tskip timesample from receivers
%  verbose             [scalar] : Info printed to terminal. -1 for none, 0 for brief, 1 for standard, 5 for a lot :)
% HCS 10/01/01
%



%SET DEFAULTS

wbox=(bignx-2)*dx;
hbox=(bignz-2)*dx;
bufferwidth=2*dx;

autopad=0;
%buffer=1;
%nx=bignx-buffer-1;nz=bignz-buffer-1;
movflag=1;
boxx0=1;boxz0=1;
boxvpx=0;boxvpz=0;
dt=0.606*dx./Vmax;
nt=ceil(tmax/dt+1);
sourcetype=1;
rotation=0;
%nxs = round(xs/dx+1);
%nzs = round(zs/dx+1);
f_main=Vmin/(2.5*5*dx);
pulsedelay=50;
geotype=1;
geodepth=10*dx;
freeupper=1;
absmode=1; %Clayton Engquist default
edgefactor=.92;
dampingwidth=50;
dampingexponent=2;
dampingtype=2;
edgefactorf=.8;
vdamp=6000;
maxfdamp=4;
expbase=1;
restoreautosave=0;  % restart modeling from autosaved file
dautosave=1000;     %Autosave interval in timesamples
usnapflag=1;
wsnapflag=1;
prsnapflag=1;
divsnapflag=1;
rotsnapflag=1;
snapsize=1;
dsnap=200;
beginsnap=dsnap;
xyskip=1;
traceskip=1;
tskip=1;
traceskip=1;
verbose=0;

%APPLY VARARGIN LIST


for i=1:2:length(varargin)
  var=varargin{i};
  val=varargin{i+1};
  eval([var,'=',num2str(val),';']);
end  

fid=fopen('mpm.par','w');

fprintf(fid,'#MODEL ON DISK (2 lines)\n');
fprintf(fid,'%5i %5i bignx,bignz\n',bignx,bignz);
fprintf(fid,'%6.2f  dx\n',dx);
fprintf(fid,'%5i  autopad [0] no padding, [1] padding\n',autopad);
fprintf(fid,'#MOVING BOX (3 lines)\n');
fprintf(fid,'%8.2f %8.2f %8.2f wbox,hbox,bufferwidth\n',wbox,hbox,bufferwidth);
fprintf(fid,'%5i movflag\n',movflag);
fprintf(fid,'%6.2f %6.2f %6.2f %6.2f  boxx0,boxz0,boxvpx,boxvpz\n',boxx0,boxz0,boxvpx,boxvpz);
fprintf(fid,'#TIME SAMPLING (2 lines)\n');
fprintf(fid,'%5i  tmax [s]\n',tmax);
fprintf(fid,'%12.8f  dt [s]\n',dt);
fprintf(fid,'#SOURCE (4 lines)\n');
fprintf(fid,'%5i %5i  sourcetype,rotation\n',sourcetype,rotation);
fprintf(fid,'%5i %5i     xs,zs [meter]\n',xs,zs);
fprintf(fid,'%6.2f  f_main\n',f_main);
fprintf(fid,'%5i  pulsedelay\n',pulsedelay);
fprintf(fid,'#RECEIVERS (2 lines)\n');
fprintf(fid,'%5i  geotype\n',geotype);
fprintf(fid,'%8.2f  geodepth [meter]\n',geodepth);
fprintf(fid,'#BOUNDARIES (4 lines)\n');
fprintf(fid,'%5i  freeupper\n',freeupper);
fprintf(fid,'%5i  absmode\n',absmode);
fprintf(fid,'%6.2f %5i %5i %5i edgefactor, dampingwidth,dampingexponent,dampingtype\n',edgefactor, dampingwidth,dampingexponent,dampingtype);
fprintf(fid,'%6.2f %5i %5i %6.2f edgefactorf, vdamp, maxfdamp, expbase\n',edgefactorf, vdamp, maxfdamp, expbase);
fprintf(fid,'#AUTOSAVE (2 lines)\n');
fprintf(fid,'%5i  restoreautosave\n',restoreautosave);
fprintf(fid,'%5i  dautosave\n',dautosave);
fprintf(fid,'#IO (6 lines)\n');
fprintf(fid,'%5i %5i %5i %5i %5i usnapflag,wsnapflag,prsnapflag,divsnapflag,rotsnapflag\n',usnapflag,wsnapflag,prsnapflag,divsnapflag,rotsnapflag);
fprintf(fid,'%5i  snapsize\n',snapsize);
fprintf(fid,'%5i %5i beginsnap,dsnap\n',beginsnap,dsnap);
fprintf(fid,'%5i  xyskip xyskip\n',xyskip);
fprintf(fid,'%5i  traceskip (traceskip)\n',traceskip);
fprintf(fid,'%5i  tskip (timeskip)\n',tskip);
fprintf(fid,'%5i  verbose\n',verbose);
fclose(fid);





