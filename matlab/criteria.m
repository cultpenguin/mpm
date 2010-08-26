% criteria : Tests stability and dispersion on for 4th order elastoc FWM code
% 
% Call : [dx,dt, dtmin, fmax]=criteria(Vmax,Vmin,mf,dx,dt)
%
% Auth :/TMH Jan18 1999, Updated /TMH Jan18 1999 
%

function [dx,dt,dtmin,fmax,stability_ok,dispersion_ok]=criteria(Vmax,Vmin,mf,dx,dt)

% DISPERSION / DX
dispersion_ok=1;
min_l=(Vmin/mf);
if nargin<4
    dx=min_l/5;
end
if dx<=min_l/5,
    disp(['Dispersion ok       : dx = ',num2str(dx),' < lambda_m/5 = ',num2str(min_l/5)])
else
    dispersion_ok=0;
    disp(['Dispersion VIOLATED : dx = ',num2str(dx),' < lambda_m/5 = ',num2str(min_l/5)])
end



% STABILITY / DT
stability_ok=1;
dtmin=0.606*dx./Vmax;
fmax=Vmin/(5*dx);
fak=0.606*dx/Vmax;
if nargin<5
    dt=dtmin;
end
if fak>=dt,
    disp(['Stability ok        : dt = ',num2str(1000*dt),'ms < 606*dx/Vmax = ',num2str(1000*fak)])
else
    stability_ok=0;
    disp(['Stability VIOLATED  : dt = ',num2str(1000*dt),'ms < 606*dx/Vmax = ',num2str(1000*fak)])
end




disp(['Vmax gives  : dt<',num2str(dtmin)])
disp(['Vmin,dt gives  : Max Frequency<',num2str(fmax)])
disp(['               : Max Center Frequency<',num2str(fmax/2.5)])
