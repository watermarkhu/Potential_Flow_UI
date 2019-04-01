% Daniel TAM
% September 2015

clear all;
close all;
clc

[x,y] = meshgrid(linspace(-3,3,61),linspace(-3,3,61));
[th]  = linspace(0,2*pi,100);

 

%%

% Vector Field
time = linspace(0,4,60); 
figure;

[u,v] = uniform(x,y,1,0);
%[u,v] = source(x,y,-0.5,0,-1);
%[u1,v1] = source(x,y,0.5,0,1);
%[u,v] = vortex(x,y,1,0,1);
%[u,v] = dipole(x,y,0,1,1);

%%
[u1,v1] = source(x,y,-1.5,0,2);
[u2,v2] = source(x,y,+1.5,0,-2);
[u3,v3] = vortex(x,y,0,0,-1.5);



% [u,v] = uniform(x,y,1,0);
% [u1,v1] = dipole(x,y,0,0,4);
% [u2,v2] = vortex(x,y,0,0,-5);



% u = u1;
% v = v1;

% u = u2;
% v = v2;

% u = u+u1;
% v = v+v1;
% 
% u = u+u1+u2;
% v = v+v1+v2;

u = u+u1+u2+u3;
v = v+v1+v2+v3;

quiver(x,y,u,v,1); axis equal;hold on;

%hflines = streamline(x,y,u,v,[-3*zeros(80,1)],[linspace(-3,3,80)']);
%hlines = streamline(x,y,-u,-v,[-3*zeros(80,1)],[linspace(-3,3,80)']);
axis equal;
hold off;



% hlines = streamline(x,y,u,v,[-3*ones(20,1);linspace(-3,3,20)'],[linspace(-3,3,20)';-3*ones(20,1)]);
% hflines.Color = 'red';
% hlines.Color = 'red';
% set(hlines,'LineWidth',1,'Color','r')


