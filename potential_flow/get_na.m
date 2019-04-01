function varargout = get_na(varargin)
% GET_NA M-file for get_na.fig
%      GET_NA, by itself, creates a new GET_NA or raises the existing
%      singleton*.
%
%      H = GET_NA returns the handle to a new GET_NA or the handle to
%      the existing singleton*.
%
%      GET_NA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GET_NA.M with the given input arguments.
%
%      GET_NA('Property','Value',...) creates a new GET_NA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before get_na_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to get_na_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help get_na

% Last Modified by GUIDE v2.5 15-Jan-2011 11:29:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @get_na_OpeningFcn, ...
                   'gui_OutputFcn',  @get_na_OutputFcn, ...
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


% --- Executes just before get_na is made visible.
function get_na_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to get_na (see VARARGIN)

% Choose default command line output for get_na
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes get_na wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = get_na_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function na_Callback(hObject, eventdata, handles)
% hObject    handle to na (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of na as text
%        str2double(get(hObject,'String')) returns contents of na as a double


% --- Executes during object creation, after setting all properties.
function na_CreateFcn(hObject, eventdata, handles)
% hObject    handle to na (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
uiresume(handles.figure1);
