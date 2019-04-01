% Daniel TAM
% September 2015

clear all;
close all;

% Define grid around a circle
[r,th]   = meshgrid(linspace(0+1/60,4,60),linspace(0,2*pi,60));

% Define center and radius of cylinder in the conformal map
rad  = 1.01;
cent = 0.0;

% rad  = 1.00;
% cent = 0.00;

x0   = -cent;
y0   =  cent;

% Define initial grid

[xx,yy] = meshgrid(linspace(-4,4,61),linspace(-4,4,61));
zz      = xx + 1i*yy;
zzeta   = (zz+sqrt(zz.^2-4))/2;
zzeta   = [zzeta (zz-sqrt(zz.^2-4))/2];

xip   = rad*cos(-pi:0.01:pi)+x0;
etap  = rad*sin(-pi:0.01:pi)+y0;

% [xi,eta] = meshgrid(linspace(-4,4,61),linspace(-4,4,61));
% 
% xi   = (rad+r).*cos(th)-cent;
% eta  = (rad+r).*sin(th)+cent;
xi    = real(zzeta);
eta   = imag(zzeta);

ind = find(sqrt((xi-x0).^2+(eta-y0).^2)>(rad+0.01));


zetap= xip+1i*etap;
zeta = xi+1i*eta;

% Define velocity in the conformal map
U           = 1;              % Magnitude Velocity at infinity
alpha       = 0*pi/6;         % Angle of flow at infinity
circulation = 0;

Uc    =   U*exp(-1i*alpha)-U*exp(1i*alpha)*rad^2./(zeta-cent*(-1+1i)).^2 + 1i*circulation/(2*pi).*1./(zeta-cent*(-1+1i));
uc    = real(Uc);
vc    = -imag(Uc);




% Plot flow around cylinder in conformal map
figure(3);
plot(xip,etap,'k','LineWidth',2); hold on;
quiver(xi(ind),eta(ind),uc(ind),vc(ind),2); axis equal;hold on;

% hflines = streamline(xi,eta,uc,vc,[-4*zeros(80,1)],[linspace(-4,4,80)']);
% hlines = streamline(xi,eta,-uc,-vc,[-4*zeros(80,1)],[linspace(-4,4,80)']);
 

% BACK in the original coordinate system Conformal map

z    = zeta+1./zeta;
zp   = zetap+1./zetap;

x    = real(z);
y    = imag(z);
xp    = real(zp);
yp    = imag(zp);

Ur   = Uc./(1-1./zeta.^2);
ur    = real(Ur);
vr    = -imag(Ur);


figure(1);
plot(x,y);

figure(2);
plot(xi,eta);
axis equal

figure(4);
quiver(x(ind),y(ind),ur(ind),vr(ind)); axis equal;hold on;
plot(xp,yp,'k','LineWidth',2)
% 
axis equal
hflines = streamline(x,y,ur,vr,[-4*zeros(80,1)],[linspace(-4,4,80)']);
hlines = streamline(x,y,-ur,-vr,[-4*zeros(80,1)],[linspace(-4,4,80)']);

