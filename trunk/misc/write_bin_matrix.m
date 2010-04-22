% write_bin_matrixf77unstrip(data,file);
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
function write_bin_matrix(data,file);

if nargin==1, file='matrix_bin.bin'; end
if nargin==0, help write_bin_matrix; return; end

[nz,nx]=size(data);

fid=fopen(file,'wb');
fwrite(fid,data,'float32');
fclose(fid);

