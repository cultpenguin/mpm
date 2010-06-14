% show_mpm_model : show the model used for MPM modeling
function show_mpm_model


[autopad,bignx,bignz,dx]=read_mpm_par('autopad','bignx','bignz','dx');

if autopad==1
  load modelpadding.asc;
  padleft=modelpadding(1);
  padtop=modelpadding(2);
  padright=modelpadding(3);
  padbot=modelpadding(4); 

  bignx2=bignx+padleft+padright;
  bignz2=bignz+padtop+padbot;

  l2mu=readbin('l2mu_pad.mod',bignx2,bignz2);
  denu=readbin('denu_pad.mod',bignx2,bignz2);
  
else
  padleft=0;
  padtop=0;
  padright=0;
  padbot=0;
  bignx2=bignx;
  bignz2=bignz;

  l2mu=readbin('l2mu.mod',bignx2,bignz2);
  denu=readbin('denu.mod',bignx2,bignz2);
end

vp=(sqrt(l2mu./denu));
clear l2mu denu


X0=padleft*dx;
Z0=padtop*dx;

X=[1:1:(bignx+(padleft+padright))]*dx-X0;
Z=[1:1:(bignz+(padtop+padbot))]*dx-Z0;

cla
imagesc(X,Z,vp)
% contour(X,Z,vp)


hold on

% MODEL
% [vp,vs,den,x,z]=get_mpm_model(5);
% imagesc(x,z,vp);

ax=[min(X) max(X) min(Z) max(Z)];

axis(ax)
axis image
set(gca,'Ydir','revers')

hold on
plot([0 bignx bignx 0 0].*dx,[0 0 bignz bignz 0].*dx,'g-')





if exist('waveposout.asc');
  load waveposout.asc
  wx=waveposout(:,2);
  wz=waveposout(:,3);
  wt=waveposout(:,1);
  plot(wx-X0,wz-Z0,'b.');

  dit=0.5;
  for it=dit:dit:max(wt)
     xi = interp1(wt,wx,it);
     zi = interp1(wt,wz,it);
    text(xi-X0,zi-Z0,['t=',num2str(it)],'HorizontalAlignment','Left');
  end

  % MOVING BOX
  [wbox,hbox,bufferwidth]=read_mpm_par('wbox','hbox','bufferwidth');
  buffer=bufferwidth/dx;
  x1=round(wx(1)/dx)-ceil(wbox/dx/2); if x1<1, x1=1; end
  z1=round(wz(1)/dx)-ceil(hbox/dx/2); if z1<1, z1=1; end
  plot([x1 x1+wbox/dx x1+wbox/dx x1 x1]*dx,[z1 z1 z1+hbox/dx z1+hbox/dx z1]*dx,'b-')
  plot([x1 x1+buffer+wbox/dx x1+buffer+wbox/dx x1 x1]*dx,[z1 z1 z1+buffer+hbox/dx z1+buffer+hbox/dx z1]*dx,'b--')
end



% SOURCE
load sourcepos.asc
   nxs=sourcepos(1);
   nzs=sourcepos(2);

plot(nxs*dx-X0,nzs*dx-Z0,'r*','MArkerSize',12)


% GEOPHONES
load geophoneposout.asc
  gx=geophoneposout(:,2);
  gz=geophoneposout(:,3);
  gi=geophoneposout(:,1);
plot((gx-padleft)*dx,(gz-padtop)*dx,'y.')
