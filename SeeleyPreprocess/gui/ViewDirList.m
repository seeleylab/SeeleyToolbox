function varargout = ViewDirList(varargin)
% VIEWDIRLIST MATLAB code for ViewDirList.fig
%      VIEWDIRLIST, by itself, creates a new VIEWDIRLIST or raises the existing
%      singleton*.
%
%      H = VIEWDIRLIST returns the handle to a new VIEWDIRLIST or the handle to
%      the existing singleton*.
%
%      VIEWDIRLIST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWDIRLIST.M with the given input arguments.
%
%      VIEWDIRLIST('Property','Value',...) creates a new VIEWDIRLIST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ViewDirList_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ViewDirList_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ViewDirList

% Last Modified by GUIDE v2.5 01-Apr-2014 04:02:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ViewDirList_OpeningFcn, ...
                   'gui_OutputFcn',  @ViewDirList_OutputFcn, ...
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


% --- Executes just before ViewDirList is made visible.
function ViewDirList_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ViewDirList (see VARARGIN)

% Choose default command line output for ViewDirList
%handles.output = hObject;
%display(varargin(1));
if ~isempty(varargin)
handles.data=varargin{1};
handles.bsubind=varargin{2};
set(handles.uitable1,'Data',handles.data);
if isempty(handles.bsubind)
    bsubString='Row numbers with bad paths: None';
else
    bsubString=['Row numbers with bad paths: ', num2str(handles.bsubind')];
end
set(handles.bsubText,'String', bsubString)
handles.outdata=handles.data;
end

% Update handles structure
guidata(hObject, handles);
uiwait


% UIWAIT makes ViewDirList wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ViewDirList_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.outdata;
close


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume



% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
handles.outdata=get(hObject,'data');
% Update handles structure
guidata(hObject, handles);
