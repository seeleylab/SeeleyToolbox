function varargout = OKmessage(varargin)
% OKMESSAGE MATLAB code for OKmessage.fig
%      OKMESSAGE, by itself, creates a new OKMESSAGE or raises the existing
%      singleton*.
%
%      H = OKMESSAGE returns the handle to a new OKMESSAGE or the handle to
%      the existing singleton*.
%
%      OKMESSAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OKMESSAGE.M with the given input arguments.
%
%      OKMESSAGE('Property','Value',...) creates a new OKMESSAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OKmessage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OKmessage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OKmessage

% Last Modified by GUIDE v2.5 25-Nov-2014 14:16:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OKmessage_OpeningFcn, ...
                   'gui_OutputFcn',  @OKmessage_OutputFcn, ...
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


% --- Executes just before OKmessage is made visible.
function OKmessage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OKmessage (see VARARGIN)
if ~isempty(varargin)
handles.data=varargin{1};

set(handles.Message,'String',handles.data);

handles.outdata=handles.data;
end

% Choose default command line output for OKmessage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OKmessage wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OKmessage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close
