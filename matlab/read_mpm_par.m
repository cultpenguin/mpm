% read_mpm_par : Read parameters from mpm.par
% CALL [par1,par2,par3,...]=read_mpm_par('par1','par2','par3',...);
% Purpose : READS PAR-FILE FOR USE WITH 'MPM' (Thomas Mejer Hansen)
% SEE ALSO read_all_mpm
% HCS 12/01/01
% TMH 15/08/02 : Updated to new mpm.par format


 function varargout=read_mpm_par(varargin);

     fid=fopen('mpm.par');
     fgetl(fid);
     bignx=fscanf(fid,'%g',1);
     bignz=fscanf(fid,'%g',1);
     fgetl(fid);
     dx=fscanf(fid,'%g',1);
     fgetl(fid);
     autopad=fscanf(fid,'%g',1);
     fgetl(fid);
     fgetl(fid);
     wbox=fscanf(fid,'%g',1);
     hbox=fscanf(fid,'%g',1);
     bufferwidth=fscanf(fid,'%g',1);
     fgetl(fid);
     movflag=fscanf(fid,'%g',1);
     fgetl(fid);
     boxx0=fscanf(fid,'%g',1);
     boxz0=fscanf(fid,'%g',1);
     boxvpx=fscanf(fid,'%g',1);
     boxvpz=fscanf(fid,'%g',1);
     fgetl(fid);
     fgetl(fid);
     tmax=fscanf(fid,'%g',1);
     fgetl(fid);
     dt=fscanf(fid,'%g',1);
     fgetl(fid);
     fgetl(fid);
     sourcetype=fscanf(fid,'%g',1);
     rotation=fscanf(fid,'%g',1);
     fgetl(fid);
     xs=fscanf(fid,'%g',1);
     zs=fscanf(fid,'%g',1);
     fgetl(fid);
     f_main=fscanf(fid,'%g',1);
     fgetl(fid);
     pulsedelay=fscanf(fid,'%g',1);
     fgetl(fid);
     fgetl(fid);
     geotype=fscanf(fid,'%g',1);
     fgetl(fid);
     geodepth=fscanf(fid,'%g',1);
     fgetl(fid);
     fgetl(fid);
     freeupper=fscanf(fid,'%g',1);
     fgetl(fid);
     absmode=fscanf(fid,'%g',1);
     fgetl(fid);
     edgefactor=fscanf(fid,'%g',1);
     dampingwidth=fscanf(fid,'%g',1);
     dampingexponent=fscanf(fid,'%g',1);
     dampingtype=fscanf(fid,'%g',1);
     fgetl(fid);
     edgefactorf=fscanf(fid,'%g',1);
     vdamp=fscanf(fid,'%g',1);
     maxfdamp=fscanf(fid,'%g',1);
     expbase=fscanf(fid,'%g',1);
     fgetl(fid);
     fgetl(fid);
     restoreautosave=fscanf(fid,'%g',1);
     fgetl(fid);
     dautosave=fscanf(fid,'%g',1);
     fgetl(fid);
     fgetl(fid);
     usnapflag=fscanf(fid,'%g',1);
     wsnapflag=fscanf(fid,'%g',1);
     prsnapflag=fscanf(fid,'%g',1);
     divsnapflag=fscanf(fid,'%g',1);
     rotsnapflag=fscanf(fid,'%g',1);
     fgetl(fid);
     snapsize=fscanf(fid,'%g',1);
     fgetl(fid);
     beginsnap=fscanf(fid,'%g',1);
     dsnap=fscanf(fid,'%g',1);
     fgetl(fid);
     xyskip=fscanf(fid,'%g',1);
     fgetl(fid);
     traceskip=fscanf(fid,'%g',1);
     fgetl(fid);
     tskip=fscanf(fid,'%g',1);
     fgetl(fid);
     verbose=fscanf(fid,'%g',1);
     fgetl(fid);
     fclose(fid);

%ASSIGN VALUES

    for i=1:nargin
     varargout{i}=eval(varargin{i}); 
    end 






