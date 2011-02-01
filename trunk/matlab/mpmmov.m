% mpmmov : show movie of MPM snapshot file.
%
% function MOVIE=mpmmov(file,ix,iz,snap1,snap2p,dsnap,clip,p1,p2)
%
% MOVIE of snapshots wtitten out from MPM (in fortran format)
%
% show from snapshot snap1 to snap2, in intervals of dsnap, 
%      using maximum amplitude=clip.
% 
% p1 and p2 are optionally, and prints p1*p2 snapshots on one figure
% clip is optionally
%
%
% ex 
%  mpmmov('div.snap',1e-4); movie of div.snap, clipping value of 1e-4

%
function [M,T]=mpmmov(file,iix,iiz,n1,nsnap,skip,clip,p1,p2)



noclip=1;


if nargin==0,
  help mpmmov
  return
end

if nargin==1;
 [autopad,bignx,bignz,dx]=read_mpm_par('autopad','bignx','bignz','dx');
 [iix,iiz]=get_movie_size;
 [beginsnap,dsnap,dt,tmax]=read_mpm_par('beginsnap','dsnap','dt','tmax');
 n1=1;
 nsnap=floor(tmax/dt/dsnap);
 skip=1;
 p=0;
 clip=1e-4;
 noclip=0;
end

if nargin==2;
 clip=iix;
 [iix,iiz]=get_movie_size;
 [autopad,bignx,bignz,dx]=read_mpm_par('autopad','bignx','bignz','dx');
 [beginsnap,dsnap,dt,tmax]=read_mpm_par('beginsnap','dsnap','dt','tmax');
 n1=1;
 nsnap=floor(tmax/dt/dsnap)
 skip=1;
 p=0;
 noclip=0;
end

if ((isempty(iix)|isempty(iiz)))
 [iix,iiz]=get_movie_size;
end

if nargin==3,
  n1=1;nsnap=1;skip=1;p=0; 
end

if nargin==4,
  nsnap=1;skip=1;p=0;   
end

if nargin==5,
  skip=1;p=0;
end  

if nargin==6,
  p=0;
end

if nargin==7,
  noclip=0;
  p=0;
end


if nargin==8,
  p2=p1;
  p1=clip;
  noclip=1;
  p=1;
end

if nargin==9,
  p=1;noclip=0;
end



splot=0;

for n=n1:skip:nsnap,
  splot=splot+1;  
  
  T=get_snap(file,iix,iiz,n);
  
  if noclip==1, clip=.1*max(max(T)); end,
  
  if p==1, 

    sb=subplot(p1,p2,splot); 
    fig_handle=imagesc(T);
    if length(clip)==2,
      caxis([clip(1) clip(2)])
    else
      caxis([-clip clip])
    end
    fig_title=title(['s=',num2str(n),' - mA=',num2str(clip)],'Fontsize',8);
    axis('equal');axis('tight')
  else
   
    if n==n1, 
      fig_handle=imagesc(T);
      if length(clip)==2,
	caxis([clip(1) clip(2)])
      else
	caxis([-clip clip])
      end    
      fig_title=title(['s=',num2str(n),' - mA=',num2str(clip)],'Fontsize',8);
      set(gca,'Fontsize',10)
      set(fig_handle,'erasemode','normal');
      set(fig_title,'erasemode','background');
      axis('equal');axis('tight')
      drawnow
      pause(1)
      if nargout>0, M(splot)=getframe; end
    else
      set(fig_handle,'Cdata',T);
      set(fig_title,'string',['s=',num2str(n),' - mA=',num2str(clip)]);
      axis('equal');axis('tight')
      drawnow
      if nargout>0, M(splot)=getframe; end
    end
  %if p==0, pause(.11), end
end


end



