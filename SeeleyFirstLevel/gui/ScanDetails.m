function varargout = ScanDetails(varargin)
% SCANDETAILS MATLAB code for ScanDetails.fig
%      SCANDETAILS, by itself, creates a new SCANDETAILS or raises the existing
%      singleton*.
%
%      H = SCANDETAILS returns the handle to a new SCANDETAILS or the handle to
%      the existing singleton*.
%
%      SCANDETAILS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCANDETAILS.M with the given input arguments.
%
%      SCANDETAILS('Property','Value',...) creates a new SCANDETAILS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ScanDetails_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ScanDetails_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ScanDetails

% Last Modified by GUIDE v2.5 30-Apr-2015 11:27:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ScanDetails_OpeningFcn, ...
                   'gui_OutputFcn',  @ScanDetails_OutputFcn, ...
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


% --- Executes just before ScanDetails is made visible.
function ScanDetails_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ScanDetails (see VARARGIN)

if ~isempty(varargin)
    handles.opt=varargin{1}; 
    set(handles.suffix,'String',handles.opt.outstring)
    set(handles.tr,'String',handles.opt.tr)
    set(handles.numscans,'String',handles.opt.trnum)
    set(handles.leadin,'String',handles.opt.delscans)
end



% Choose default command line output for ScanDetails
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
uiwait

% UIWAIT makes ScanDetails wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ScanDetails_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.opt;
close


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume

function suffix_Callback(hObject, eventdata, handles)
% hObject    handle to suffix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of suffix as text
%        str2double(get(hObject,'String')) returns contents of suffix as a double
handles.opt.outstring=get(hObject,'String'); 
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function suffix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to suffix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tr_Callback(hObject, eventdata, handles)
% hObject    handle to tr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tr as text
%        str2double(get(hObject,'String')) returns contents of tr as a double
handles.opt.tr=str2num(get(hObject,'String'));  %#ok<*ST2NM>
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function tr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numscans_Callback(hObject, eventdata, handles)
% hObject    handle to numscans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numscans as text
%        str2double(get(hObject,'String')) returns contents of numscans as a double
handles.opt.trnum=str2num(get(hObject,'String'));  %#ok<*ST2NM>
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function numscans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numscans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function leadin_Callback(hObject, eventdata, handles)
% hObject    handle to leadin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of leadin as text
%        str2double(get(hObject,'String')) returns contents of leadin as a double
handles.opt.delscans=str2num(get(hObject,'String'));  %#ok<*ST2NM>
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function leadin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to leadin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
