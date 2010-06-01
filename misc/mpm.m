% mpm : main phase modeling
%
% Call : 
%   mpm
%   mpm('c:\PATH\TO\mpm.exe');
%
function out=mpm(f_exec)

if nargin==0
    f_exec=[pwd,filesep,'mpm'];
end

if ~(exist(f_exec,'file')==2);
    [p]=fileparts(which('mpm.m'));
    p=[p,filesep,'..',filesep,'src'];
    f_exec=sprintf('%s%s',p,filesep,'mpm');
    if isunix==0
        f_exec=[f_exec,'.exe'];
    end
        
end

if ~(exist(f_exec,'file')==2);
    disp(sprintf('MPM : Could not locate MPM executable at : %s',f_exec))
    return;
end
    
disp(sprintf('MPM running : %s',f_exec))

system(f_exec);