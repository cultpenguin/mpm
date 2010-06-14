% readbin : Reads a binary file to matlab
%
% CALL : function [dataout]=readbin(fileid,nx,nz,skip,b_order,fchar)
%
% REQUIRED
%   fileid
%   nx
%
% OPTIONAL
%   nz      : Number of samples in 2nd direction
%   fchar (scalar)  : (==1)Remove F77 chracters
%   b_order : set byteorder : '0' : Little Endian 
%                             '1' : Big endian 
%
%
% /TMH FEB 09 1999
%
function [dataout]=readbin(fileid,nx,nz,skip,b_order,fchar)

if nargin<2;
  disp('This function needs both fileid and nx as minimum input')
  help readbin
  return
end

if nargin==2;
  nz=0;
end

if exist('fchar')==0, fchar=0; end

if fchar==1;
  nz=nz+2;
end

if exist('skip')==0, skip=1; end  

if exist('b_order')
  if b_order==0, b_order='ieee-le'; end
  if b_order==1, b_order='ieee-be'; end
end
  

% 
% if bye-order is set -> use it
%  
if exist('b_order')==1,
  fid=fopen(fileid,'r',b_order);
else
  fid=fopen(fileid,'r');
end

if nz==0,
  [data,ndata]=fread(fid,'float32');
   fclose(fid);
   app_nz=floor(ndata/nx);
   nz=app_nz; 
   dataout=reshape(data(1:nx*nz),nz,nx); 
   disp([mfilename,' : Using nz=',num2str(nz)])
else
   [dataout,ndata]=fread(fid,[nz nx],'float32');
end


% Remove f77 characters
%
if fchar==1,
  dataout=dataout(2:nz-1,1:nx);
  nz=nz-2;
end

if skip>1
  dataout=dataout([1:skip:nz],[1:skip:nx]);
end
