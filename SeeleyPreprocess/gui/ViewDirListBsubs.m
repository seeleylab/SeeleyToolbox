function varargout = ViewDirListBsubs(varargin)
% VIEWDIRLISTBSUBS MATLAB code for ViewDirListBsubs.fig
%      VIEWDIRLISTBSUBS, by itself, creates a new VIEWDIRLISTBSUBS or raises the existing
%      singleton*.
%
%      H = VIEWDIRLISTBSUBS returns the handle to a new VIEWDIRLISTBSUBS or the handle to
%      the existing singleton*.
%
%      VIEWDIRLISTBSUBS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWDIRLISTBSUBS.M with the given input arguments.
%
%      VIEWDIRLISTBSUBS('Property','Value',...) creates a new VIEWDIRLISTBSUBS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ViewDirListBsubs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ViewDirListBsubs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ViewDirListBsubs

% Last Modified by GUIDE v2.5 13-May-2014 16:06:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ViewDirListBsubs_OpeningFcn, ...
                   'gui_OutputFcn',  @ViewDirListBsubs_OutputFcn, ...
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


% --- Executes just before ViewDirListBsubs is made visible.
function ViewDirListBsubs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ViewDirListBsubs (see VARARGIN)

% Choose default command line output for ViewDirListBsubs
%handles.output = hObject;
%display(varargin(1));
if ~isempty(varargin)
handles.data=varargin{1};

set(handles.uitable1,'Data',handles.data);

handles.outdata=handles.data;
end

% Update handles structure
guidata(hObject, handles);
uiwait


% UIWAIT makes ViewDirListBsubs wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ViewDirListBsubs_OutputFcn(hObject, eventdata, handles) 
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
