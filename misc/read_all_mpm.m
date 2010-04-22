% read_all_mpm : reads all parameters from mpm.par [NOT UPDATED]
% Purpose : READS ALL PARAMETERS FROM PAR-FILE FOR USE WITH 'MPM' (Thomas Mejer Hansen)
% SEE ALSO read_mpm_par
% HCS 12/01/01
    
     fid=fopen('mpm.par');
     fgetl(fid);
     bignx=fscanf(fid,'%g',1);
     bignz=fscanf(fid,'%g',1);
     fgetl(fid);
     dx=fscanf(fid,'%g',1);
     fgetl(fid);
     fgetl(fid);
     nx=fscanf(fid,'%g',1);
     nz=fscanf(fid,'%g',1);
     buffer=fscanf(fid,'%g',1);
     fgetl(fid);
     movflag=fscanf(fid,'%g',1);
     fgetl(fid);
     boxx0=fscanf(fid,'%g',1);
     boxz0=fscanf(fid,'%g',1);
     boxvpx=fscanf(fid,'%g',1);
     boxvpz=fscanf(fid,'%g',1);
     fgetl(fid);
     fgetl(fid);
     nt=fscanf(fid,'%g',1);
     fgetl(fid);
     dt=fscanf(fid,'%g',1);
     fgetl(fid);
     fgetl(fid);
     sourcetype=fscanf(fid,'%g',1);
     fgetl(fid);
     nxs=fscanf(fid,'%g',1);
     nzs=fscanf(fid,'%g',1);
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
     tskip=fscanf(fid,'%g',1);
     fgetl(fid);
     verbose=fscanf(fid,'%g',1);
     fgetl(fid);
     fclose(fid);







