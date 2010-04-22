% get_snap : get snapshot from binadry moviefile
%
% Call :
% snap=get_snap(filename,nx,nz,isnap)
%
% snap=get_snap(filename,isnap);
%
%
% TMH AUG/2002
%
function snap=get_snap(filename,nx,nz,isnap)

     if nargin==2,
       isnap=nx;
       [nx,nz]=get_movie_size;
     end
     
     fid=fopen(filename,'r');
     
     fseek(fid,(isnap-1)*(nx*nz)*4,'bof');
     snap=fread(fid,[nz nx],'float32');
