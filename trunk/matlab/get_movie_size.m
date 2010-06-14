% get_movie_size : get size of movie.
%
% TMH AUG/2002
function [xmov,zmov]=get_movie_size


[snapsize,wbox,hbox,bignx,bignz,dx,bufferwidth]=read_mpm_par('snapsize','wbox','hbox','bignx','bignz','dx','bufferwidth');

if snapsize==1
  xmov=round(wbox/dx);
  zmov=round(hbox/dx);
elseif snapsize==2.
  wb=bufferwidth/dx;
  xmov=round(wbox/dx)+wb;
  zmov=round(hbox/dx)+wb;
elseif snapsize==3.
  load modelpadding.asc;
  xmov=bignx+modelpadding(1)+modelpadding(3);
  zmov=bignz+modelpadding(2)+modelpadding(4);
end








