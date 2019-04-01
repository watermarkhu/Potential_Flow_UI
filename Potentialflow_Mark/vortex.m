function [u,v] = vortex(x,y,X,Y,Gamma)

u    = zeros(size(x));
v    = zeros(size(y));

DR   = sqrt((x(2,2)-x(1,1))^2+(y(2,2)-y(1,1))^2);

th   = atan2(y-Y,x-X);
r    = sqrt((x-X).^2+(y-Y).^2);

ur   = zeros(size(x));
ut   = Gamma./(2*pi*r).*(r>DR);

u    = cos(th).*ur -sin(th).*ut;
v    = sin(th).*ur +cos(th).*ut;

