% logs_to_2d : Convert logs to a 2D elastic model
function [vp_profile,vs_profile,rho_profile,x,z]=logs_to_2d(z_log,vp,vs,rho,z_range,offset,dx,max_freq,doPlot)

if nargin<9
    doPlot=0;
end
if nargin<8
    max_freq=2.5*50;
end

if nargin==6;
    x=offset;
    dx=x(2)-x(1);    
    nx=length(x);
    offset=nx*dx;
end

compute_dx=0;
%if length(offset)==1;
%    % IN THIS CASE OFFSET INPUT IS INTERPRETED AS 'nx'
%    nx=offset;
%    dx=1;
%    offset=nx*dx;
%    x=[dx:dx:offset];
%else     
    if nargin>6
        if isempty(dx);
            compute_dx=1;
        end
    end    
    %if nargin<7
    %    compute_dx=1;
    %end
%end

if compute_dx==1;
    min_l=(min(vs(:))/max_freq);
    dx=.99*min_l/5;
    disp(sprintf('setting dx=%5.3f using max frequency of %4.1f  Hz ',dx,max_freq))
end


x=[dx:dx:offset];
nx=length(x);

if nargin<5,z_range=[];end
if isempty(z_range)
    z_range(1)=min(z_log);
    z_range(2)=max(z_log);
end

dz=dx;
z=[z_range(1):dz:z_range(2)];
nz=length(z);
vp_int=interp1([-10;z_log],[vp(1);vp],z,'nearest','extrap');
vs_int=interp1([-10;z_log],[vs(1);vs],z,'nearest','extrap');
rho_int=interp1([-10;z_log],[rho(1);rho],z,'nearest','extrap');

%% PLOT WELL LOGS
if doPlot==1;
    figure(1);set_paper;
    subplot(1,2,1);
    plot(vp,z_log,'k-',vp_int,z,'r');
    hold on
    plot(vs,z_log,'k-',vs_int,z,'g');
    plot(rho,z_log,'k-',rho_int,z,'b');
    hold off
    legend('V_p','V_p','V_s','V_s','\rho','\rho')
    set(gca,'ydir','revers')
    grid on;
    ylabel('Depth (m)')
end
% MAKE 2D MATRIX
vp_profile=repmat(vp_int(:),[1 nx]);
vs_profile=repmat(vs_int(:),[1 nx]);
rho_profile=repmat(rho_int(:),[1 nx]);

if doPlot==1;
    figure(1);
    subplot(3,2,2);imagesc(x,z,vp_profile);axis image;colorbar;title('V_p')
    subplot(3,2,4);imagesc(x,z,vs_profile);axis image;colorbar;title('V_s')
    subplot(3,2,6);imagesc(x,z,rho_profile);axis image;colorbar;title('\rho')
end