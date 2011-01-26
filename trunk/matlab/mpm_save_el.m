% mpm_save_el : saves model for MPM using vp,vs and density
% 
% function mpm_save_el(Vp,Vs,Densityrho_frac);
%
% Vp [matrix], P-wave velocities [m/s]
% Vs [matrix], S-wave velocities [m/s]
% Density [matrix], Density [kg/m3]
%
% 05/2000 Thomas Mejer Hansen
%
% SAVE MODEL for mpm

function mpm_save_el(vp,vs,den);

 if nargin==1,
   vs=vp./sqrt(3);
   den=vp./sqrt(3);
 end
 disp(['Saving model for MPM'])
 [nz,nx]=size(vp);
 
 write_bin_matrix(vp.^2.*den,'l2mu.mod');
 write_bin_matrix(vs.^2.*den,'mu.mod');
 write_bin_matrix( den.*(vp.^2-2*vs.^2) ,'l.mod');
 write_bin_matrix(den,'denu.mod');
 write_bin_matrix(den,'denw.mod');



