% f77unstrip : add f77 characters to binary file 
%
%f77unstrip(data,file);
%
% data [matrix], required
% file [string], optional, deafult='f77.bin'
%
% Purpose : Writes a matrix to a binary file 
%           in fortran style
%
% At the beginning and end of each row, an integer
% containing the number of bytes in the row is printed
% (like ftnunstrip/ftnstrip in the CWP SU package)
%
% by Thomas Mejer Hansen, 05/2000
% Octave 2.0.15 and Matlab 5.3 compliant
%
function f77unstrip(data,file);

if nargin==1, file='f77.bin'; end
if nargin==0, help wrtf77; return; end


[nz,nx]=size(data);

% f77 int32 char
f77char=nx*4;


fid=fopen(file,'wb');
for iz=1:nz,
  fwrite(fid,f77char,'int32');
  d=data(iz,:);
  fwrite(fid,d(:),'float32');
  fwrite(fid,f77char,'int32');
end
fclose(fid);



