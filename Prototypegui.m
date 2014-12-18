function varargout = prototypegui(varargin)
% PROTOTYPEGUI MATLAB code for prototypegui.fig
%      PROTOTYPEGUI, by itself, creates a new PROTOTYPEGUI or raises the existing
%      singleton*.
%
%      H = PROTOTYPEGUI returns the handle to a new PROTOTYPEGUI or the handle to
%      the existing singleton*.
%
%      PROTOTYPEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROTOTYPEGUI.M with the given input arguments.
%
%      PROTOTYPEGUI('Property','Value',...) creates a new PROTOTYPEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before prototypegui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to prototypegui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help prototypegui

% Last Modified by GUIDE v2.5 17-Jul-2014 12:37:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @prototypegui_OpeningFcn, ...
                   'gui_OutputFcn',  @prototypegui_OutputFcn, ...
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


% --- Executes just before prototypegui is made visible.
function prototypegui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to prototypegui (see VARARGIN)

% Choose default command line output for prototypegui
handles.output = hObject;

handles.br = 0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes prototypegui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = prototypegui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in examples.
function examples_Callback(hObject, eventdata, handles)
% hObject    handle to examples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pebble_prototype


% --- Executes on button press in belt.
function belt_Callback(hObject, eventdata, handles)
% hObject    handle to belt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pebble_belt

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.br = 1;

guidata(hObject, handles);



% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
% hObject    handle to pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.paws = 1;

guidata(hObject, handles);


% --- Executes on button press in belt1.
function belt1_Callback(hObject, eventdata, handles)
% hObject    handle to belt1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pebble_belt1
