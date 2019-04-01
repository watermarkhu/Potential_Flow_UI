function varargout = PotentialFlow(varargin)
% POTENTIALFLOW MATLAB code for PotentialFlow.fig
%      POTENTIALFLOW, by itself, creates a new POTENTIALFLOW or raises the existing
%      singleton*.
%
%      H = POTENTIALFLOW returns the handle to a new POTENTIALFLOW or the handle to
%      the existing singleton*.
%
%      POTENTIALFLOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in POTENTIALFLOW.M with the given input arguments.
%
%      POTENTIALFLOW('Property','Value',...) creates a new POTENTIALFLOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PotentialFlow_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PotentialFlow_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PotentialFlow

% Last Modified by GUIDE v2.5 14-Jan-2018 19:55:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PotentialFlow_OpeningFcn, ...
                   'gui_OutputFcn',  @PotentialFlow_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before PotentialFlow is made visible.
function PotentialFlow_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PotentialFlow (see VARARGIN)

% Choose default command line output for PotentialFlow
handles.output = hObject;

handles.data.xlimits = [-5,5];
handles.data.ylimits = [-5,5];
set(handles.axes_flow,'XLim',handles.data.xlimits,'YLim',handles.data.ylimits,...
    'DataAspectRatio',[1,1,1])
xlabel(handles.axes_flow,'X');ylabel(handles.axes_flow,'Y');

handles.data.gridpointchanged = 1;
handles.data.uniformchanged = 1;
handles.data.potentialchanged = 1;
handles.data.potentials = [];
handles.data.potentialu = 0;
handles.data.potentialv = 0;
handles.data.uniformu = 0;
handles.data.uniformv = 0;

handles.data.plotmode = 1;

handles = Calculation(handles);

Plotfunction(handles)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PotentialFlow wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function handles = Calculation(handles)

switch handles.data.plotmode
    case 1 %Elementary mode

        if handles.data.gridpointchanged == 1
            handles.data.gridsize = str2double(handles.num_gridpoints.String);

            [handles.data.x, handles.data.y] = meshgrid(linspace(handles.data.xlimits(1),...
            handles.data.xlimits(2),handles.data.gridsize),linspace(handles.data.ylimits(1),...
            handles.data.ylimits(2),handles.data.gridsize));

            % Need to calculate uniform and potential velocity in new grid
            handles.data.uniformchanged = 1;
            handles.data.potentialchanged = 1;
            handles.data.potentialu = 0;
            handles.data.potentialv = 0;
        end

        if handles.data.uniformchanged == 1
            handles.data.uniform_u = str2double(handles.uniform_u.String);
            handles.data.uniform_v = str2double(handles.uniform_v.String);
            [handles.data.uniformu, handles.data.uniformv] = uniform(handles.data.x,handles.data.y,...
            handles.data.uniform_u,handles.data.uniform_v);
        end

        if handles.data.potentialchanged == 1

            sumu = 0;
            sumv = 0;
            for i = 1:size(handles.data.potentials,1)
                switch handles.data.potentials(i,3)
                    case 1 %source/sink
                        [u,v] = source(handles.data.x,handles.data.y,handles.data.potentials(i,1),...
                            handles.data.potentials(i,2), handles.data.potentials(i,4));
                    case 2 %vortex
                        [u,v] = vortex(handles.data.x,handles.data.y,handles.data.potentials(i,1),...
                            handles.data.potentials(i,2), handles.data.potentials(i,4));
                    case 3 %dipole
                        [u,v] = dipole(handles.data.x,handles.data.y,handles.data.potentials(i,1),...
                            handles.data.potentials(i,2), handles.data.potentials(i,4));
                end
                sumu = sumu + u;
                sumv = sumv + v;
            end

            handles.data.potentialu = sumu;
            handles.data.potentialv = sumv;  
        end

        handles.data.u = handles.data.uniformu + handles.data.potentialu;
        handles.data.v = handles.data.uniformv + handles.data.potentialv;
        
    case 2 %Zhukhov mode
        
        if handles.data.gridpointchanged ==1
            handles.data.gridsize = str2double(handles.num_gridpoints.String);
            [handles.data.x, handles.data.y] = meshgrid(linspace(handles.data.xlimits(1),...
            handles.data.xlimits(2),handles.data.gridsize),linspace(handles.data.ylimits(1),...
            handles.data.ylimits(2),handles.data.gridsize));

            handles.data.uniformchanged = 1;
        end

        if handles.data.uniformchanged ==1
            handles.data.uniform_u = str2double(handles.uniform_u.String);
            handles.data.uniform_v = str2double(handles.uniform_v.String);
            uniform_U = sqrt(handles.data.uniform_u^2+handles.data.uniform_v^2);
            handles.data.zhux = str2double(handles.zhux.String);
            handles.data.zhuy = str2double(handles.zhuy.String);
            handles.data.zhurad = str2double(handles.zhurad.String);
            handles.data.zhupar = str2double(handles.zhupar.String);
            handles.data.zhugam = str2double(handles.zhugamma.String);

            % Create mesh in zeta space from original mesh
            zmesh = handles.data.x + 1i*handles.data.y;
            zetamesh = [(zmesh+sqrt(zmesh.^2-4*handles.data.zhupar.^2))/2,...
               (zmesh-sqrt(zmesh.^2-4*handles.data.zhupar.^2))/2];
            zetax = real(zetamesh);
            zetay = imag(zetamesh);

            % Get circle coordinates and indices outside of circle
            zetac = handles.data.zhurad * (cos(-pi:0.01:pi) + 1i*sin(-pi:0.01:pi))...
                + handles.data.zhux + 1i*handles.data.zhuy;
            ind = sqrt((zetax-handles.data.zhux).^2 + ...
                (zetay-handles.data.zhuy).^2) > handles.data.zhurad;

            % Get complex velocity in zeta space
            zetadiff = (zetax-handles.data.zhux)+1i*(zetay-handles.data.zhuy);
            zetau = handles.data.uniform_u + 1i*handles.data.uniform_v ...
                - uniform_U*handles.data.zhurad^2./(zetadiff).^2 ...
                + 1i*handles.data.zhugam./(2*pi*zetadiff);

            % Convert to original z space
            z = zetamesh + handles.data.zhupar^2./zetamesh;
            zc = zetac + handles.data.zhupar^2./zetac;
            U = zetau./(1-handles.data.zhupar^2./zetamesh.^2);

            % Get x and y coordiates
            x = real(z(ind)); y = imag(z(ind));
            u = real(U(ind)); v = imag(U(ind)); 
            handles.data.xc = real(zc);
            handles.data.yc = imag(zc);

            % Convert velocity from vector to mesh
            dec = 4;
            X = round(dec*handles.data.x)/dec; Y = round(dec*handles.data.y)/dec;
            U = NaN(size(handles.data.x)); V = NaN(size(handles.data.y));
            for i=1:length(x)
                index = find(X == round(dec*x(i))/dec & Y == round(dec*y(i))/dec);
                U(index) = u(i); V(index) = v(i);
            end
            handles.data.u = U; handles.data.v = V;

        end
end
        
handles.data.gridpointchanged = 0;
handles.data.uniformchanged = 0;
handles.data.potentialchanged = 0;



function Plotfunction(handles)
cla(handles.axes_flow)

hold on

% plot pressure dat
if handles.showpressure.Value
    mov = (handles.data.u.*2 + handles.data.v.^2)./2;
    pfig = imagesc(handles.data.xlimits,handles.data.ylimits,mov);
    colormap('cool')
end

% plot streamlines
if handles.showstreamlines.Value
    xstart = handles.data.x;
    ystart = handles.data.y;
   
    sfig = streamline(handles.axes_flow,handles.data.x,handles.data.y,...
        handles.data.u,handles.data.v,xstart,ystart);
    set(sfig,'Color',[0.8,0.3,0.1])
end

% plot streamslices
if handles.showstreamslice.Value
    s2fig = streamslice(handles.axes_flow,handles.data.x,handles.data.y,...
        handles.data.u,handles.data.v);
    set(s2fig,'Color',[0.5,0.5,0.1])
end

% plot vectors

scale = str2double(handles.vectorscale.String);

if handles.showvectors.Value
    qfig = quiver(handles.axes_flow,handles.data.x,handles.data.y,...
        handles.data.u,handles.data.v, scale);
    set(qfig,'Color',[0,0.1,0.4])
end

% Draw circle and stagnation points if possible
drawcircle = false;
drawpoints = false;
potentials = handles.data.potentials;

if handles.data.uniform_v == 0
    if ~isempty(handles.data.potentials)      
        if size(potentials,1) == 1
            if potentials(1,3) == 3
                drawcircle = true;
            end
        elseif size(potentials,1) > 1
            if sum([diff(potentials(:,1)),diff(potentials(:,2))])==0
                if all((potentials(:,3)==2)|(potentials(:,3)==3)) && any(potentials(:,3)==2) &&...
                        any(potentials(:,3)==3)
                    drawcircle = true;
                    drawpoints = true;
                elseif all(potentials(:,3)==3)
                    drawcircle = true;
                end    
            end
        end
    end
end

if drawcircle
    index = find(potentials(:,3)==3);
    d = sum(potentials(index,4));
    radius = sqrt(d/(2*pi*handles.data.uniform_u));
    cplot = viscircles([potentials(index(1),1),potentials(index(1),2)],...
        radius,'EdgeColor',[0.9,0.2,0.2]);
    
    if drawpoints
        index2 = potentials(:,3)==2;
        gamma = sum(potentials(index2,4));
        
        if gamma <= 4*pi*radius*handles.data.uniform_u
        theta = asin(-gamma/(4*pi*radius*handles.data.uniform_u));
        theta = [-theta, pi+theta];
        X = potentials(1,1)+radius*cos(theta);
        Y = potentials(1,2)+radius*sin(theta);
        plot(X,Y,'ko','linewidth',2)
        
        end
    end
end

if handles.data.plotmode == 2
    
    fill(handles.data.xc,handles.data.yc,[0.9,0.9,0.9])
    %plot(handles.data.xc,handles.data.yc,'LineWidth',1,'Color','k')
end


set(handles.axes_flow,'XLim',handles.data.xlimits,'YLim',handles.data.ylimits,...
'DataAspectRatio',[1,1,1])

hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Outputs from this function are returned to the command line.
function varargout = PotentialFlow_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in push_clearfigure.
function push_clearfigure_Callback(hObject, eventdata, handles)
handles.data.uniformchanged = 1;
handles.data.potentials = [];
handles.data.potentialu = 0;
handles.data.potentialv = 0;

handles = Calculation(handles);
Plotfunction(handles)
guidata(hObject, handles);



function uniform_u_Callback(hObject, eventdata, handles)
% hObject    handle to uniform_u (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.uniformchanged = 1;
handles = Calculation(handles);
Plotfunction(handles)
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function uniform_u_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uniform_u (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function uniform_v_Callback(hObject, eventdata, handles)
% hObject    handle to uniform_v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.uniformchanged = 1;
handles = Calculation(handles);
Plotfunction(handles)
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function uniform_v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uniform_v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_newwindow.
function push_newwindow_Callback(hObject, eventdata, handles)
h = findobj(gca,'type','axes'); % Find the axes object in the GUI
f1 = figure; %; Open a new figure with handle f1
s = copyobj(h,f1); % Copy axes object h into figure f1



function num_gridpoints_Callback(hObject, eventdata, handles)
% hObject    handle to num_gridpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.data.gridpointchanged = 1;
handles = Calculation(handles);
Plotfunction(handles)
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function num_gridpoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_gridpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showvectors.
function showvectors_Callback(hObject, eventdata, handles)
% hObject    handle to showvectors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Plotfunction(handles)


% --- Executes on button press in showstreamlines.
function showstreamlines_Callback(hObject, eventdata, handles)
% hObject    handle to showstreamlines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Plotfunction(handles)

% --- Executes on button press in showstreamslice.
function showstreamslice_Callback(hObject, eventdata, handles)
% hObject    handle to showstreamslice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Plotfunction(handles)

% --- Executes on button press in showpressure.
function showpressure_Callback(hObject, eventdata, handles)
% hObject    handle to showpressure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Plotfunction(handles)


function vectorscale_Callback(hObject, eventdata, handles)
% hObject    handle to vectorscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Plotfunction(handles)


% --- Executes during object creation, after setting all properties.
function vectorscale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vectorscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes when selected object is changed in buttongroup_mode.
function buttongroup_mode_SelectionChangedFcn(hObject, eventdata, handles)
if handles.mode_elementary.Value == 1
    handles.data.plotmode = 1;
elseif handles.mode_zhukhov.Value ==1
    handles.data.plotmode = 2;
end
handles.data.uniformchanged = 1;
handles = Calculation(handles);
Plotfunction(handles)
guidata(hObject, handles);
%%%%%%% Update plot when enter or update plot button is pressed %%%%%%%%%%%%

function figure1_KeyPressFcn(hObject, eventdata, handles)
    
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
    key = get(gcf,'CurrentKey');
    
    if(strcmp (key , 'return'))
        handles = Calculation(handles);
        Plotfunction(handles)
    end
    guidata(hObject, handles);
    
function num_gridpoints_KeyPressFcn(hObject, eventdata, handles)
    key = get(gcf,'CurrentKey');
    if(strcmp (key , 'return'))
        handles = Calculation(handles);
        Plotfunction(handles)
    end
    guidata(hObject, handles);
    
function uniform_v_KeyPressFcn(hObject, eventdata, handles)
    key = get(gcf,'CurrentKey');
    if(strcmp (key , 'return'))
        handles = Calculation(handles);
        Plotfunction(handles)
    end
    guidata(hObject, handles);
    
function uniform_u_KeyPressFcn(hObject, eventdata, handles)
    key = get(gcf,'CurrentKey');
    if(strcmp (key , 'return'))
        handles = Calculation(handles);
        Plotfunction(handles)
    end
    guidata(hObject, handles);


% --- Executes on button press in updateplot.
function updateplot_Callback(hObject, eventdata, handles)

handles.data.gridpointchanged = 1;
handles.data.uniformchanged = 1;
handles = Calculation(handles);
Plotfunction(handles)
guidata(hObject, handles);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in addbutton.
function addbutton_Callback(hObject, eventdata, handles)

if handles.select_sourcesink.Value == 1
    potential = 1;
elseif handles.select_vortex.Value == 1
    potential = 2;
else
    potential = 3;
end
strength = str2double(handles.potentialstrength.String);

if handles.checkmanual.Value ==1
    set(handles.warningtext,'String','Left click to select coordinate, right click to cancel')
    [clickx,clicky,mouseclick] = ginput(1);
    if mouseclick == 1
        handles.data.potentials = [handles.data.potentials; [clickx,clicky,potential,strength]];
    end
else
    x = str2double(handles.manualx.String);
    y = str2double(handles.manualy.String);
    handles.data.potentials = [handles.data.potentials; [x,y,potential,strength]];
end

handles.data.potentialchanged = 1;
handles = Calculation(handles);
Plotfunction(handles)
set(handles.warningtext,'String','')

set(handles.warningtext,'String','')
guidata(hObject, handles);



function potentialstrength_Callback(hObject, eventdata, handles)
% hObject    handle to potentialstrength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of potentialstrength as text
%        str2double(get(hObject,'String')) returns contents of potentialstrength as a double


% --- Executes during object creation, after setting all properties.
function potentialstrength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to potentialstrength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Changed names of ui elements of potentials %%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in select_sourcesink.
function select_sourcesink_Callback(hObject, eventdata, handles)
set(handles.potentialstrength_name,'String','Source/Sink strength Q')
set(handles.addbutton,'String','Add source/sink')


% --- Executes on button press in select_vortex.
function select_vortex_Callback(hObject, eventdata, handles)
set(handles.potentialstrength_name,'String','Vortex strength Gamma')
set(handles.addbutton,'String','Add vortex')

% --- Executes on button press in select_dipole.
function select_dipole_Callback(hObject, eventdata, handles)
set(handles.potentialstrength_name,'String','Dipole strength d')
set(handles.addbutton,'String','Add dipole')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in checkmanual.
function checkmanual_Callback(hObject, eventdata, handles)
if handles.checkmanual.Value == 1
    set(handles.manualx,'Enable','off')
    set(handles.manualy,'Enable','off')
else
    set(handles.manualx,'Enable','on')
    set(handles.manualy,'Enable','on')
end



function manualx_Callback(hObject, eventdata, handles)
% hObject    handle to manualx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of manualx as text
%        str2double(get(hObject,'String')) returns contents of manualx as a double


% --- Executes during object creation, after setting all properties.
function manualx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to manualx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function manualy_Callback(hObject, eventdata, handles)
% hObject    handle to manualy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of manualy as text
%        str2double(get(hObject,'String')) returns contents of manualy as a double


% --- Executes during object creation, after setting all properties.
function manualy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to manualy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zhupar_Callback(hObject, eventdata, handles)
% hObject    handle to zhupar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zhupar as text
%        str2double(get(hObject,'String')) returns contents of zhupar as a double


% --- Executes during object creation, after setting all properties.
function zhupar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zhupar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zhurad_Callback(hObject, eventdata, handles)
% hObject    handle to zhurad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zhurad as text
%        str2double(get(hObject,'String')) returns contents of zhurad as a double


% --- Executes during object creation, after setting all properties.
function zhurad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zhurad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zhuy_Callback(hObject, eventdata, handles)
% hObject    handle to zhuy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zhuy as text
%        str2double(get(hObject,'String')) returns contents of zhuy as a double


% --- Executes during object creation, after setting all properties.
function zhuy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zhuy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zhux_Callback(hObject, eventdata, handles)
% hObject    handle to zhux (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zhux as text
%        str2double(get(hObject,'String')) returns contents of zhux as a double


% --- Executes during object creation, after setting all properties.
function zhux_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zhux (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zhugamma_Callback(hObject, eventdata, handles)
% hObject    handle to zhugamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zhugamma as text
%        str2double(get(hObject,'String')) returns contents of zhugamma as a double


% --- Executes during object creation, after setting all properties.
function zhugamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zhugamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in mode_elementary.
function mode_elementary_Callback(hObject, eventdata, handles)
handles.data.plotmode = 1;
handles.data.uniformchanged = 1;
handles = Calculation(handles);
Plotfunction(handles)
guidata(hObject, handles);


% --- Executes on button press in mode_zhukhov.
function mode_zhukhov_Callback(hObject, eventdata, handles)
handles.data.plotmode = 2;
handles.data.uniformchanged = 1;
handles = Calculation(handles);
Plotfunction(handles)
guidata(hObject, handles);


% --- Executes on button press in drawshape.
function drawshape_Callback(hObject, eventdata, handles)

hf=gcf;
ha=gca;
a=1;
b=1;

icf=5e-2; %increased contour factor

res = round(1/(handles.data.xlimits(2)-handles.data.xlimits(1))*20);

set(handles.warningtext,'String','Draw dots to make shape, right-click to finsih');

x=[];
y=[];
while true
    [x1,y1,button] = ginput(1);
    if button~=3
        x=[x x1];
        y=[y y1];
        hold on 
        plot(x1, y1, 'or')
        hold off
    else
        break;
    end
end

L0=length(x);

r = [x;y];
N = L0;
% find perimeter of the polygon

n=1:N-1;
r1=r(:,n); % current points
r2=r(:,n+1); % next points
dr=r1-r2; % difference
dr2=sum(dr.^2); % squared lenghts
drl=sqrt(dr2); % lenghts
P=sum(drl); % perimeter

% last and first:
r1=r(:,N); % current points
r2=r(:,1); % next points
dr=r1-r2; % difference
dr2=sum(dr.^2); % squared lenghts
drl=sqrt(dr2); % lenghts
P=P+drl; % perimeter

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

% normals:
sz=size(yy);
N=sz(2);
nn=zeros(2,N); % normals, perpendicular
pp=zeros(2,N); % tangent
for n=1:N
    if n~=N
        r1=r(:,n);
        r2=r(:,n+1);
    else
        r1=r(:,N);
        r2=r(:,1);
    end
    dr=r2-r1;
    dr2=dr'*dr;
    drl=sqrt(dr2);
    pp1=dr/drl;
    
    nn(:,n)=[pp1(2);
            -pp1(1)];
end

stdx=std(r(1,:));
stdy=std(r(1,:));
tsz=max([stdx stdy]);  % typcle size

% orientations of normals must be outside:
rsh=r+1e-4*tsz*nn; % vertex shifted in derection of normals
%IN = inpolygon(X,Y,xv,yv)
in = inpolygon(rsh(1,:),rsh(2,:),r(1,:),r(2,:));
ind=find(in);
if length(ind)>length(in)/2 % more then half directed inside
    % less then half directed outside
    nn=-nn; % invert
else
    % less then half directed outside
    % ok
end

% increased contour
ri=r+icf*tsz*nn;
%plot([ri(1,:) ri(1,1)],[ri(2,:) ri(2,1)],'g-');

% add dots inside:
for x5=handles.data.xlimits(1):1/res:handles.data.xlimits(2)
    for y5=-b:1/res:b
        if inpolygon(x5,y5,r(1,:),r(2,:))
            r=[r [x5; y5]];
        end
    end
end
sr=size(r);
N2=sr(2);

plot(r(1,:),r(2,:),'.k');

% get velocity from user:

U=handles.data.uniform_u;

V=handles.data.uniform_v;


% calculation

M=zeros(N,N2);
for n1=1:N
    r1=r(:,n1);
    for n2=1:N2
        if n1~=n2
            r2=r(:,n2);
            dr=r1-r2;
            dr2=dr'*dr;
            drl=sqrt(dr2);
            Ec=-dr/(dr2*drl); % electric field from from any charge n2
            % in position of on-contour charge n1

            %M(n1,n2)=Ec(1)*pp(1,n1)+Ec(2)*pp(2,n1);
            M(n1,n2)=Ec(1)*nn(1,n1)+Ec(2)*nn(2,n1); % (E*n) % dot product
            % component that is perpendiculat to contour
            %M(n2,n1)=-M(n1,n2);
        end
        
    end
end

q=zeros(N2,1); % charges
bb=zeros(N,1); % right-column of system of linear equations
for it=1:1 % no iterations
    for n1=1:N
        bb(n1)=-U*nn(1,n1)-V*nn(2,n1);

    end
    q=pinv(M)*bb; % solve

end
drawnow;


plot(yyp(1,:),yyp(2,:),'k-');
drawnow;

x = handles.data.x;
y = handles.data.y;
Ex = zeros(size(x));
Ey = zeros(size(y));


for i = 1:numel(x)
    x1 = x(i);
    y1 = y(i);

        r1=[x1;y1];
        E=[0;0];
        for n=1:N2
            r2=r(:,n);
            dr=r1-r2;
            dr2=dr'*dr;
            drl=sqrt(dr2);
            E=E+q(n)*(-dr/(dr2*drl)); % sum of fields from all charges
        end
        E=E+[U;
            V];
        
        if ~inpolygon(x1,y1,ri(1,:),ri(2,:))
            %if true
            Ex(i)=E(1);
            Ey(i)=E(2);
        else
            Ex(i)=NaN; % to not plot wrong arrows that inside body
            Ey(i)=NaN;
        end
end

handles.data.u = Ex;
handles.data.v = Ey;
handles.data.xc = yyp(1,:);
handles.data.yc = yyp(2,:);

handles.data.plotmode = 2;
Plotfunction(handles)
set(handles.warningtext,'String','')

guidata(hObject, handles);


% --- Executes on button press in flowani.
function flowani_Callback(hObject, eventdata, handles)
% hObject    handle to flowani (see GCBO)
    
    gs = handles.data.gridsize;
    x = handles.data.x;
    y = handles.data.y;
    u = handles.data.uniform_u;
    v = handles.data.uniform_v;
    
    if u>0 && v == 0
        rm = [x(:,1)';y(:,1)'];
        nm = size(x,1);
    elseif u>0 && v < 0 
        rm = [x(:,1)', x(1,2:end) ;y(:,1)', y(1,2:end)];
        nm = sum(size(x))-1;
    elseif u ==0 && v < 0
        rm = [x(1,:); y(1,:)];
        nm = size(x,2);
    elseif u < 0 && v < 0
        rm = [x(1,:), x(2:end,end)'; y(1,:), y(2:end,end)'];
        nm = sum(size(x))-1;
    elseif u < 0 && v == 0
        rm = [x(:,end)'; y(:,end)'];
        nm = size(x,1);
    elseif u>0 && v > 0 
        rm = [x(:,1)', x(end,2:end) ;y(:,1)', y(end,2:end)];
        nm = sum(size(x))-1;
    elseif u ==0 && v > 0
        rm = [x(end,:); y(end,:)];
        nm = size(x,2);
    elseif u < 0 && v > 0
        rm = [x(end,:), x(2:end,end)'; y(end,:), y(2:end,end)'];
        nm = sum(size(x))-1;
    end
    
    xrange = x(1,:);
    yrange = y(:,1)';

    hold on;
    hpm=plot(rm(1,:),rm(2,:),'r.');

    dt=0.02;
    tm=20;
    for t=0:dt:tm
        
        for n1=1:nm
            x1=rm(1,n1);
            y1=rm(2,n1);
            
            [~, minx] = min(abs(xrange - x1));
            [~, miny] = min(abs(yrange - y1));
            
            u1 = handles.data.u(miny,minx);
            v1 = handles.data.v(miny,minx);
            
            rm(1,n1) = rm(1,n1) + u1*dt;
            rm(2,n1) = rm(2,n1) + v1*dt;
%             r1=[x1;
%             y1];
%             E=[0;
%                 0];
%             for n=1:N2
%                 r2=r(:,n);
%                 dr=r1-r2;
%                 dr2=dr'*dr;
%                 drl=sqrt(dr2);
%                 if drl>ds*0.5
%                     E=E+q(n)*(-dr/(dr2*drl));
%                 end
%             end
%             E=E+[U;
%                 V];
%             rm0=rm(:,n1);
%             rm1=rm0+E*dt;
%             if inpolygon(rm1(1),rm1(2),r(1,1:N),r(2,1:N));
%                 % go to closest vertex:
%                 drs=zeros(2,N);
%                 drs(1,:)=r(1,1:N)-rm1(1);
%                 drs(2,:)=r(2,1:N)-rm1(2);
%                 drs2=sum(drs.^2,1);
%                 [tmp ind]=min(drs2);
%                 rm(:,n1)=r(:,ind)+(r(:,ind)-rm1)*1.5; % push aditionaly outside
%             else
%                 rm(:,n1)=rm1;
%             end
            set(hpm,'XData',rm(1,:),'YData',rm(2,:));
        end

        drawnow;

    end
