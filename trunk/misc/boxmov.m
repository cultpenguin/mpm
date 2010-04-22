% boxmov : Show the moving box (NOT IMPLEMENTED)

load waveposout.asc
wp=waveposout;
nt=length(wp(:,1));

nx=1000;
nz=1000;

x=wp(:,2);
z=wp(:,3);

hold on
dit=1000;
for n=dit:dit:nt
  xx=[x(n) x(n)+nx x(n)+nx x(n) x(n)];
  zz=[z(n) z(n) z(n)+nz z(n)+nz z(n)];
  plot(xx,zz,'k-',x(n),z(n),'g*')
end
hold off
