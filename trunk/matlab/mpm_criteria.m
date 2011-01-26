% mpm_criteria : Tests stability and dispersion on for 4th order elastic FWM code
% 
% Call : [dx,dt, dtmin, fmax]=criteria(Vmax,Vmin,mf,dx,dt,verbose_level)
%
%   'dx' and 'dt' can be left empty ([]) or a value can be given. 
%
%      [dx,dt]=criteria(Vmax,Vmin,mf);
%   is equivalent to 
%      [dx,dt]=criteria(Vmax,Vmin,mf,[],[]);
%   and
%      [dx,dt, dtmin, fmax]=criteria(Vmax,Vmin,mf,[]);
%
%   to compute maximum dx use 
%      [dx,dt]=criteria(Vmax,Vmin,mf,[],dt);
%
%
%   verbose level can be [-1],[0], and [1]. A higher number provides more 
%      textual feedback
%
%
% Auth :/TMH Jan18 1999, Updated /TMH Jan18 2011 
%

function [dx,dt,dtmin,fmax,stability_ok,dispersion_ok]=mpm_criteria(Vmax,Vmin,mf,dx,dt,verbose_level)

if nargin<4, dx=[]; end
if nargin<5, dt=[]; end
if nargin<6, verbose_level=0; end

%% DISPERSION / MAX DX
dispersion_ok=1;
min_l=(Vmin/mf);
if isempty(dx);dx=min_l/5;end

%% STABILITY / DT
stability_ok=1;
dtmin=0.606*dx./Vmax;
fmax=Vmin/(5*dx);
fak=0.606*dx/Vmax;
if isempty(dt), dt=dtmin; end





if dx<min_l/5,
    dispersion_ok=0;
    if (verbose_level>-1);
        disp(['Dispersion VIOLATED : dx = ',num2str(dx),' < lambda_m/5 = ',num2str(min_l/5)])
    end
else
    if (verbose_level>0);
        disp(['Dispersion ok       : dx = ',num2str(dx),' < lambda_m/5 = ',num2str(min_l/5)])
    end
end


if fak<dt,
    stability_ok=0;
    if (verbose_level>-1);
        disp(['Stability VIOLATED  : dt = ',num2str(1000*dt),'ms < 606*dx/Vmax = ',num2str(1000*fak)])
    end
else
    stability_ok=0;
    if (verbose_level>0);
        disp(['Stability ok        : dt = ',num2str(1000*dt),'ms < 606*dx/Vmax = ',num2str(1000*fak)])
    end
end



if (verbose_level>1);
   disp(['Vmax gives  : dt<',num2str(dtmin)])
   disp(['Vmin,dt gives  : Max Frequency<',num2str(fmax)])
   disp(['               : Max Center Frequency<',num2str(fmax/2.5)])
end
   