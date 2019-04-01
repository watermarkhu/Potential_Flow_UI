

hf=gcf;
ha=gca;
a=1;
b=1;
res = 20
icf=5e-2; %increased contour factor


xlim([-a a]);
ylim([-b b]);
hp=plot(NaN,NaN,'or');
axis equal;
xlim([-a a]);
ylim([-b b]);



title('put dots, push right-click to finsih');
x=[];
y=[];
while true
    [x1,y1,button] = ginput(1);
    if button~=3
        x=[x x1];
        y=[y y1];
        set(hp,'xdata',x,'ydata',y);
        xlim([-a a]);
        ylim([-b b]);
    else
        break;
    end
end

L0=length(x);

P=perimeter([x;y],L0); % perimeter;

rf=5; % repeat factor, to make periodicle
rf2=(rf-1)/2;


L=rf*L0;

x2=linspace(0-rf2,1+rf2,L);
y2=[repmat(x,1,rf);
    repmat(y,1,rf)];
pp = spline(x2,y2);
N1=round(P*res);
yy = ppval(pp, linspace(x2(1),x2(L0+1),N1));
yyp = ppval(pp, linspace(x2(1),x2(L0+1),500)); % to plot line with high resolution
hold on;
yy=yy(:,1:end-1); % exclude repeated vertex
plot(yyp(1,:),yyp(2,:),'b-');
%plot(yy(1,1),yy(2,1),'+r');
%plot(yy(1,end),yy(2,end),'xg');

r=yy;
%%
% % normals:
% sz=size(yy);
% N=sz(2);
% nn=zeros(2,N); % normals, perpendicular
% pp=zeros(2,N); % tangent
% for n=1:N
%     if n~=N
%         r1=r(:,n);
%         r2=r(:,n+1);
%     else
%         r1=r(:,N);
%         r2=r(:,1);
%     end
%         
%     
%     dr=r2-r1;
%     dr2=dr'*dr;
%     drl=sqrt(dr2);
%     pp1=dr/drl;
%     
%     nn(:,n)=[pp1(2);
%             -pp1(1)];
% 
% end
% 
% stdx=std(r(1,:));
% stdy=std(r(1,:));
% tsz=max([stdx stdy]);  % typcle size
% 
% % orientations of normals must be outside:
% rsh=r+1e-4*tsz*nn; % vertex shifted in derection of normals
% %IN = inpolygon(X,Y,xv,yv)
% in = inpolygon(rsh(1,:),rsh(2,:),r(1,:),r(2,:));
% ind=find(in);
% if length(ind)>length(in)/2 % more then half directed inside
%     % less then half directed outside
%     nn=-nn; % invert
% else
%     % less then half directed outside
%     % ok
% end
%     
% 
% 
% % increased contour
% ri=r+icf*tsz*nn;
% %plot([ri(1,:) ri(1,1)],[ri(2,:) ri(2,1)],'g-');
% 
% % add dots inside:
% for x5=-a:1/res:a
%     for y5=-b:1/res:b
%         if inpolygon(x5,y5,r(1,:),r(2,:))
%             r=[r [x5; y5]];
%         end
%     end
% end
% sr=size(r);
% N2=sr(2);
% 
% plot(r(1,:),r(2,:),'.k');
% ht=title('charges');
% 
% % get velocity from user:
% hds0=get_u_v;
% hds=guidata(hds0);
% U=str2num(get(hds.u,'string'));
% V=str2num(get(hds.v,'string'));
% close(hds.figure1);
% 
% % calculation
% set(ht,'string','charges, calulation...');
% 
% M=zeros(N,N2);
% for n1=1:N
%     r1=r(:,n1);
%     for n2=1:N2
%         if n1~=n2
%             r2=r(:,n2);
%             dr=r1-r2;
%             dr2=dr'*dr;
%             drl=sqrt(dr2);
%             Ec=-dr/(dr2*drl); % electric field from from any charge n2
%             % in position of on-contour charge n1
% 
%             %M(n1,n2)=Ec(1)*pp(1,n1)+Ec(2)*pp(2,n1);
%             M(n1,n2)=Ec(1)*nn(1,n1)+Ec(2)*nn(2,n1); % (E*n) % dot product
%             % component that is perpendiculat to contour
%             %M(n2,n1)=-M(n1,n2);
%         end
%         
%     end
% end
% 
% q=zeros(N2,1); % charges
% bb=zeros(N,1); % right-column of system of linear equations
% for it=1:1 % no iterations
%     for n1=1:N
%         %bb(n1)=-U*pp(1,n1)-V*pp(2,n1);
%         bb(n1)=-U*nn(1,n1)-V*nn(2,n1);
% 
%     end
%     %q=M\bb;
%     
%     q=pinv(M)*bb; % solve
% 
% end
% 
% set(ht,'string','charges, done');
% drawnow;
% 
% % get number of arrows per dimention from user:
% hds0=get_na;
% hds=guidata(hds0);
% na=str2num(get(hds.na,'string'));
% close(hds.figure1);
% 
% 
% cla(ha);
% 
% 
% plot(yyp(1,:),yyp(2,:),'k-');
% set(ht,'string','plot arrows...');
% drawnow;
% x2=linspace(-a,a,na);
% y2=linspace(-b,b,na);
% Nx=length(x2);
% Ny=length(x2);
% x3=zeros(1,Nx*Ny);
% y3=zeros(1,Nx*Ny);
% Ex=zeros(1,Nx*Ny);
% Ey=zeros(1,Nx*Ny);
% lc=1;
% for x1=x2;
%     for y1=y2
%         r1=[x1;
%             y1];
%         E=[0;
%             0];
%         for n=1:N2
%             r2=r(:,n);
%             dr=r1-r2;
%             dr2=dr'*dr;
%             drl=sqrt(dr2);
%             E=E+q(n)*(-dr/(dr2*drl)); % sum of fields from all charges
%         end
%         E=E+[U;
%             V];
%         x3(lc)=x1;
%         y3(lc)=y1;
%         if ~inpolygon(x1,y1,ri(1,:),ri(2,:))
%             %if true
%             Ex(lc)=E(1);
%             Ey(lc)=E(2);
%         else
%             Ex(lc)=NaN; % to not plot wrong arrows that inside body
%             Ey(lc)=NaN;
%         end
%         
%         
%         lc=lc+1;
%     end
% end
% hold on;
% quiver(x3,y3,Ex,Ey);
% set(ht,'string','velocity field');
% drawnow;
% 
c=menu('add perticles?','Yes','No');
if c==1
    % markers
    ds=1/res; % step betwee charges
    nm=10;
    rm=[-a*ones(1,nm);
        linspace(-0.9*b,0.9*b,nm)];

    hold on;
    hpm=plot(rm(1,:),rm(2,:),'r.');

    dt=0.01;
    tm=8;
    for t=0:dt:tm
        for n1=1:nm
            x1=rm(1,n1);
            y1=rm(2,n1);
            r1=[x1;
            y1];
            E=[0;
                0];
            for n=1:N2
                r2=r(:,n);
                dr=r1-r2;
                dr2=dr'*dr;
                drl=sqrt(dr2);
                if drl>ds*0.5
                    E=E+q(n)*(-dr/(dr2*drl));
                end
            end
            E=E+[U;
                V];
            rm0=rm(:,n1);
            rm1=rm0+E*dt;
            if inpolygon(rm1(1),rm1(2),r(1,1:N),r(2,1:N));
                % go to closest vertex:
                drs=zeros(2,N);
                drs(1,:)=r(1,1:N)-rm1(1);
                drs(2,:)=r(2,1:N)-rm1(2);
                drs2=sum(drs.^2,1);
                [tmp ind]=min(drs2);
                rm(:,n1)=r(:,ind)+(r(:,ind)-rm1)*1.5; % push aditionaly outside
            else
                rm(:,n1)=rm1;
            end
            set(hpm,'XData',rm(1,:),'YData',rm(2,:));
        end
        xlim([-a a]);
        ylim([-b b]);
        drawnow;
        if all(rm(1,:)>1.1*a)
            break;
        end

    end
end