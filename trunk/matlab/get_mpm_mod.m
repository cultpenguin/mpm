% get_mpm_mod : returns get the model used by MPM 
%
% CALL :  [vp,vs,den,x,z]=get_mpm_mod(d,datapath);
%  

function [vp,vs,den,x,z,l,l2mu,mu,denu,denw]=get_mpm_mod(d,datapath);
if nargin==0,
  datapath=pwd;
  d=5;
end

if nargin==1,
  if isstr(d)==1, 
    datapath=d;
    d=5;
  else
    datapath=pwd;
  end
end

% SHIFT INPUT IF NEEDED
if nargin==2,
  if isstr(d)==1, 
    dd=datapath;
    datapath=d;
    d=dd;
  end
end

if exist(datapath)==0,
  disp(['GET_MPMMOD : The specified path does not exist :',datapath])
  return
end

if exist([datapath,'/l2mu.mod'])~=2,
  disp(['GET_MPMMOD : couldnt find l2mu.mod in ',datapath])
  return
elseif exist([datapath,'/l.mod'])~=2,
  disp(['GET_MPMMOD : couldnt find l.mod in ',datapath])
  return
elseif exist([datapath,'/mu.mod'])~=2,
  disp(['GET_MPMMOD : couldnt find mu.mod in ',datapath])
  return
elseif exist([datapath,'/denu.mod'])~=2,
  disp(['GET_MPMMOD : couldnt find denu.mod in ',datapath])
  return
elseif exist([datapath,'/denw.mod'])~=2,
  disp(['GET_MPMMOD : couldnt find denw.mod in ',datapath])
  return
end    


[bignx,bignz,dx]=read_mpm_par('bignx','bignz','dx');

%VP
l2mu=readbin([datapath,'/l2mu.mod'],bignx,bignz,d); 
denu=readbin([datapath,'/denu.mod'],bignx,bignz,d); 
denw=readbin([datapath,'/denw.mod'],bignx,bignz,d); 
vp=sqrt(l2mu./denu);


%VS
mu=readbin([datapath,'/mu.mod'],bignx,bignz,d); 
vs=sqrt(mu./denu);

%DENSITY
den=denu;

%TEST
l=readbin([datapath,'/l.mod'],bignx,bignz,d); 
if l2mu~=(l+2.*mu) 
  disp(['GET_MPMMOD : l, l2mu and mu are not consistent'])
end
 
[nz,nx]=size(vp);
x=[1:1:nx].*d*dx;
z=[1:1:nz].*d*dx;

p=0;
if p==1,
  
  subplot(3,1,1)
  imagesc(x./1000,z./1000,vp);
  title('V_p')
  subplot(3,1,2)
  imagesc(x./1000,z./1000,vs);
  title('V_s')
  subplot(3,1,3)
  imagesc(x./1000,z./1000,den);
  title('\rho')
  
  for i=1:3,
    subplot(3,1,i)
    axis image
    colorbar
    xlabel(['Offset [km]'])
    ylabel(['Depth [km]'])
  end
end