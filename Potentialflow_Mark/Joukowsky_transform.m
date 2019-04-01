% Daniel TAM
% September 2015

clear all;
close all;

% Define grid around a circle

% Define center and radius of cylinder in the conformal map

rad  = 1.08;
cent = 0.05;

x0   = -cent;
y0   =  cent;

[xx,yy] = meshgrid(linspace(-4,4,61),linspace(-4,4,61));
zz      = xx + 1i*yy;
zzeta   = (zz+sqrt(zz.^2-4))/2;
zzeta   = [zzeta (zz-sqrt(zz.^2-4))/2];

xip   = rad*cos(-pi:0.01:pi)+x0;
etap  = rad*sin(-pi:0.01:pi)+y0;



xi    = real(zzeta);
eta   = imag(zzeta);
ind = find(sqrt((xi-x0).^2+(eta-y0).^2)>rad);


zetap= xip+1i*etap;
zeta = xi+1i*eta;

% Define velocity in the conformal map
U           = 1;              % Magnitude Velocity at infinity
alpha       = pi/12;         % Angle of flow at infinity
circulation = 0;

Uc    =   U*exp(-1i*alpha)-U*exp(1i*alpha)*rad^2./(zeta-cent*(-1+1i)).^2 + 1i*circulation/(2*pi).*1./(zeta-cent*(-1+1i));
%uc    = real(Uc);
%vc    = -imag(Uc);

% Plot flow around cylinder in conformal map
%figure(2);
%plot(xip,etap,'k','LineWidth',2); hold on;
%quiver(xi(ind),eta(ind),uc(ind),vc(ind),2); axis equal;hold on;

% hflines = streamline(xi,eta,uc,vc,[-4*zeros(80,1)],[linspace(-4,4,80)']);
% hlines = streamline(xi,eta,-uc,-vc,[-4*zeros(80,1)],[linspace(-4,4,80)']);
 

% BACK in the original coordinate system Conformal map

z    = zeta+1./zeta;
zp   = zetap+1./zetap;

x    = real(z);
y    = imag(z);
xp    = real(zp);
yp    = imag(zp);

% x        = xi.*(xi.^2+eta.^2+1)./(xi.^2+eta.^2);
% y        = eta.*(xi.^2+eta.^2-1)./(xi.^2+eta.^2);
Ur   = Uc./(1-1./zeta.^2);
ur    = real(Ur);
vr    = -imag(Ur);

figure(3);
quiver(x(ind),y(ind),ur(ind),vr(ind),2); axis equal;hold on;
plot(xp,yp,'k','LineWidth',2)
% 
% hflines = streamline(x,y,ur,vr,[-4*ones(80,1)],[linspace(-4,4,80)']);
% hlines = streamline(x,y,-ur,-vr,[-4*ones(80,1)],[linspace(-4,4,80)']);






% plot(x,y)
% plot3(x,y,zeros(size(x)),'.');
% axis equal;

% quiver(x,y,ones(size(x)),ones(size(x)));




% 
% % ctor Field
% time = linspace(0,4,60); 
% figure;
% 
% [u,v] = uniform(x,y,1,0);
% %[u,v] = source(x,y,-0.5,0,-1);
% %[u1,v1] = source(x,y,0.5,0,1);
% %[u,v] = vortex(x,y,1,0,1);
% %[u,v] = dipole(x,y,0,1,1);
% 
% 
% 
% % [u,v] = uniform(x,y,1,0);
% [u1,v1] = dipole(x,y,0,0,4);
% [u2,v2] = vortex(x,y,0,0,-15667984);
% 
% 
% 
% % u = u1;
% % v = v1;
% 
% % u = u2;
% % v = v2;
% 
% u = u+u1;
% v = v+v1;
% % 
% u = u+u1+u2;
% v = v+v1+v2;
% 
% quiver(x,y,u,v,2); axis equal;hold on;
% 
% hflines = streamline(x,y,u,v,[-3*zeros(40,1)],[linspace(-3,3,40)']);
% hlines = streamline(x,y,-u,-v,[-3*zeros(40,1)],[linspace(-3,3,40)']);
% hold off;
% 
% 
% 
% % hlines = streamline(x,y,u,v,[-3*ones(20,1);linspace(-3,3,20)'],[linspace(-3,3,20)';-3*ones(20,1)]);
% % hflines.Color = 'red';
% % hlines.Color = 'red';
% % set(hlines,'LineWidth',1,'Color','r')


