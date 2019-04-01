function [u,v] = dipole(x,y,X,Y,d)

DR     = sqrt((x(2,2)-x(1,1))^2+(y(2,2)-y(1,1))^2);

u      = zeros(size(x));
v      = zeros(size(y));

th     = atan2(y-Y,x-X);
r      = sqrt((x-X).^2+(y-Y).^2);

ur     = -d/(2*pi)*cos(th)./r.^2.*(r>DR);
ut     = -d/(2*pi)*sin(th)./r.^2.*(r>DR);

u      = cos(th).*ur -sin(th).*ut;
v      = sin(th).*ur +cos(th).*ut;









