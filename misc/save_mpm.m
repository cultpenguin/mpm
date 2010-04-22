% save_mpm : Saves model for MPM, using vp, vp/vs and vp/rho
% 
% function save_mpm(Vp,vs_frac,den_frac);
%
% Vp [matrix], P-wave velocities [m/s]
% vs_frac [scalar] , vs=vp/vs_frac
% den_frac [scalar] , den=vp/den_frac
%
% 05/2000 Thomas Mejer Hansen
%
% SAVE MODEL for mpm
%
function save_mpm(vp,vs_frac,rho_frac);

 if nargin==1,
   vs_frac=1.73,
   rho_frac=1.5,
 end
 disp(['Saving model for MPM'])
 [nz,nx]=size(vp);
 
 write_bin_matrix(vp.^3./rho_frac,'l2mu.mod');
 write_bin_matrix(vp.^3./(rho_frac*vs_frac^2),'mu.mod');
 write_bin_matrix( (vp.^3./rho_frac)-2*(vp.^3./(rho_frac*vs_frac^2)) ,'l.mod');
 write_bin_matrix(vp./rho_frac,'denu.mod');
 write_bin_matrix(vp./rho_frac,'denw.mod');



