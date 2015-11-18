function varargout = PreprocAdvanced(varargin)
% PREPROCADVANCED MATLAB code for PreprocAdvanced.fig
%      PREPROCADVANCED, by itself, creates a new PREPROCADVANCED or raises the existing
%      singleton*.
%
%      H = PREPROCADVANCED returns the handle to a new PREPROCADVANCED or the handle to
%      the existing singleton*.
%
%      PREPROCADVANCED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PREPROCADVANCED.M with the given input arguments.
%
%      PREPROCADVANCED('Property','Value',...) creates a new PREPROCADVANCED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PreprocAdvanced_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PreprocAdvanced_OpeningFcn via varargin.
%
%  .    *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PreprocAdvanced

% Last Modified by GUIDE v2.5 19-Nov-2014 09:48:04
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PreprocAdvanced_OpeningFcn, ...
                   'gui_OutputFcn',  @PreprocAdvanced_OutputFcn, ...
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


% --- Executes just before PreprocAdvanced is made visible.
function PreprocAdvanced_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PreprocAdvanced (see VARARGIN)

%%%SET DEFAULTS
handles.opt.cancel=0; 
set(handles.filterOn,'Value',1)
handles.opt.filter='filterOn';
set(handles.mfilterOn,'Value',1)
handles.opt.mfilter='mfilterOn';
set(handles.mspikeOn,'Value',1)
handles.opt.mspike='mspikeOn';
set(handles.ileaveOn,'Value',1)
handles.opt.ileave='ileaveOn';
set(handles.IcaFullOn,'Value',1)
handles.opt.IcaFull='IcaFullOn';

set(handles.tr,'String','2')
handles.opt.tr='2';
set(handles.trnum,'String','240')
handles.opt.trnum='240';
set(handles.delscans,'String','5')
handles.opt.delscans='5';
set(handles.scanner,'String','NIC')
handles.opt.scanner='NIC';
set(handles.lowFreq,'String','0.0083')
handles.opt.lowFreq='0.0083';
set(handles.highFreq,'String','0.15')
handles.opt.highFreq='0.15';
set(handles.ileavecutoff,'String','1260')
handles.opt.ileavecutoff='1260';
set(handles.mspikecutoff,'String','1')
handles.opt.mspikecutoff='1';
set(handles.sliceOrder,'String','2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35')
handles.opt.sliceorder='2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35';
set(handles.rsPrefix,'String','') 
handles.opt.rsprefix=''; 
set(handles.t1Prefix,'String','MP-LAS') 
handles.opt.t1prefix='MP-LAS';


%Choose default command line output for PreprocAdvanced
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
uiwait

% UIWAIT makes PreprocAdvanced wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PreprocAdvanced_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1}=[]; 
if ~handles.opt.cancel
    optnames=fieldnames(handles.opt);
    for x=1:length(optnames)
        if ~isempty(strfind(handles.opt.(optnames{x}),'On'))
            handles.opt.(optnames{x})=true;
        elseif ~isempty(strfind(handles.opt.(optnames{x}),'Off'))
            handles.opt.(optnames{x})=false;
        else
            handles.opt.(optnames{x})=handles.opt.(optnames{x});
        end
    end
    
    varargout{1} = handles.opt;
end
close


% --- Executes on button press in resDefaults.
function resDefaults_Callback(hObject, eventdata, handles)
% hObject    handle to resDefaults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%%SET DEFAULTS
%%%SET DEFAULTS
set(handles.filterOn,'Value',1)
handles.opt.filter='filterOn';
set(handles.mfilterOn,'Value',1)
handles.opt.mfilter='mfilterOn';
set(handles.mspikeOn,'Value',1)
handles.opt.mspike='mspikeOn';
set(handles.ileaveOn,'Value',1)
handles.opt.ileave='ileaveOn';
set(handles.IcaFullOn,'Value',1)
handles.opt.IcaFull='IcaFullOn';

set(handles.tr,'String','2')
handles.opt.tr='2';
set(handles.trnum,'String','240')
handles.opt.trnum='240';
set(handles.delscans,'String','5')
handles.opt.delscans='5';
set(handles.scanner,'String','NIC')
handles.opt.scanner='NIC';
set(handles.lowFreq,'String','0.0083')
handles.opt.lowFreq='0.0083';
set(handles.highFreq,'String','0.15')
handles.opt.highFreq='0.15';
set(handles.ileavecutoff,'String','1260')
handles.opt.ileavecutoff='1260';
set(handles.mspikecutoff,'String','1')
handles.opt.mspikecutoff='1';
set(handles.sliceOrder,'String','2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35')
handles.opt.sliceorder='2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35';
set(handles.rsPrefix,'String','') 
handles.opt.rsprefix=''; 
set(handles.t1Prefix,'String','MP-LAS') 
handles.opt.t1prefix='MP-LAS';

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in applyChanges.
function applyChanges_Callback(hObject, eventdata, handles)
% hObject    handle to applyChanges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume


% --- Executes on button press in helpbutton.
function helpbutton_Callback(hObject, eventdata, handles)
% hObject    handle to helpbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helptext=sprintf(['\n BASIC PARAMETERS: \n\n --TR: Time in seconds for each timepoint (default: 2) \n\n --Number of TRs: Number of Timepoints (default: 240), \ntotal time is TR x Number of TRs',...
    '\n\n--Delete Lead In Scans: Number of images to delete at the beginning of a scan to allow for field stabilization (default: 5)\n\n --rsfMRI Images Prefix: Prefix that all subject\''s resting state images have or',...
    ' leave blank to use all .nii files in rawfmri folder. \n\n--Structural Image Prefix: Prefix that all subject\''s structural images have or leave a blank to use the .img or .nii found in strucraw/ if the directory contains only one image.\n\n --Slice Order: A vector specifying the order that fMRI slices were',... 
    ' acquired. IMPORTANT: Don\''t guess; figure it out from a scanner technician. Also find out your slice aquisition type. If it is interleave (typically odd slices acquired then evens or vice versa) then '... 
    'Interleave Correction is recommended. If your slice acquisition type is ascending or descending, Interleave Correction should be off. \n\nADVANCED PARAMETERS:\n\n--Filtering: By default the images and motion parameter timeseries are filtered using a bandpass',...
    ' filter. The low and high frequency cutoffs are 0.0083Hz and 0.15Hz, respectively. All standard higher level analyses require filtering.\n\n--Interleave Correction: Used to reduce the impact of artifacts caused by interleave',...
    ' slice acquisition and motion. Turn off for ascending or descending slice aquisition types!\n\n--Full ICA Report: By default a Full ICA Report is generated whenever interleave correction is run but if interleave correction',...
    ' is not used a report can still be generated to manually look for artificats in the ICA components.\n\n--Realign & Slice Timing: By default and compatiblity with running ICA with Melodic, FSL runs Realignment and Slice Timing steps.',...
    ' You can have SPM run these steps but this disables ICA and Interleave Correction\n\n--Motion QA Report: Creates a motion report that includes a count of TRs with spikes exceeding the cutoff.']); 
helpfig=helpDocs({helptext});



function lowFreq_Callback(hObject, eventdata, handles)
% hObject    handle to lowFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lowFreq as text
%        str2double(get(hObject,'String')) returns contents of lowFreq as a double
handles.opt.lowFreq=get(hObject,'String');
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lowFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function highFreq_Callback(hObject, eventdata, handles)
% hObject    handle to highFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of highFreq as text
%        str2double(get(hObject,'String')) returns contents of highFreq as a double
handles.opt.highFreq=get(hObject,'String');
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function highFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to highFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scanner_Callback(hObject, eventdata, handles)
% hObject    handle to scanner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scanner as text
%        str2double(get(hObject,'String')) returns contents of scanner as a double
handles.opt.scanner=get(hObject,'String');
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function scanner_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scanner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delscans_Callback(hObject, eventdata, handles)
% hObject    handle to delscans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delscans as text
%        str2double(get(hObject,'String')) returns contents of delscans as a double
handles.opt.delscans=get(hObject,'String');
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function delscans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delscans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trnum_Callback(hObject, eventdata, handles)
% hObject    handle to trnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trnum as text
%        str2double(get(hObject,'String')) returns contents of trnum as a double
handles.opt.trnum=get(hObject,'String');
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function trnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trnum (see GCBO)
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
handles.opt.tr=get(hObject,'String');
% Update handles structure
guidata(hObject, handles);


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


% --- Executes on button press in cancelSel.
function cancelSel_Callback(hObject, eventdata, handles)
% hObject    handle to cancelSel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.opt.cancel=1; 
guidata(hObject, handles);
uiresume


% --- Executes when selected object is changed in CorNorSelect.
function CorNorSelect_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in CorNorSelect 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.opt.regtype=get(hObject,'Tag');  
% Update handles structure
guidata(hObject, handles);

% --- Executes when selected object is changed in SmoothSelect.
function SmoothSelect_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in SmoothSelect 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
 handles.opt.smooth=get(hObject,'Tag'); 
 % Update handles structure
guidata(hObject, handles);



% --- Executes when selected object is changed in FilterSelect.
function FilterSelect_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in FilterSelect 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.opt.filter=get(hObject,'Tag');  
% Update handles structure
guidata(hObject, handles);



% --- Executes when selected object is changed in MFilterSelect.
function MFilterSelect_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in MFilterSelect 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.opt.mfilter=get(hObject,'Tag');   
% Update handles structure
guidata(hObject, handles);


% --- Executes when selected object is changed in MSpikeSelect.
function MSpikeSelect_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in MSpikeSelect 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.opt.mspike=get(hObject,'Tag');  
% Update handles structure
guidata(hObject, handles);


% --- Executes when selected object is changed in ileaveSelect.
function ileaveSelect_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in ileaveSelect 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

if strcmp(handles.opt.IcaFull,'IcaFullOff')
    set(handles.ileaveOff,'Value',1)
    handles.opt.ileave='ileaveOff';
else
    handles.opt.ileave=get(hObject,'Tag');
end
% Update handles structure
guidata(hObject, handles);



% --- Executes when selected object is changed in ICAfixSelect.
function ICAfixSelect_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in ICAfixSelect 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.opt.IcaFix=get(hObject,'Tag');
% Update handles structure
guidata(hObject, handles);



% --- Executes when selected object is changed in ICAFull.
function ICAFull_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in ICAFull 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.opt.IcaFull=get(hObject,'Tag');   
if strcmp(handles.opt.IcaFull,'IcaFullOff')
    set(handles.ileaveOff,'Value',1)
    handles.opt.ileave='ileaveOff';
else
    set(handles.IcaFullOn,'Value', 1) 
end
% Update handles structure
guidata(hObject, handles);


function mspikecutoff_Callback(hObject, eventdata, handles)
% hObject    handle to mspikecutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mspikecutoff as text
%        str2double(get(hObject,'String')) returns contents of mspikecutoff as a double
handles.opt.mspikecutoff=get(hObject,'String');
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function mspikecutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mspikecutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function ileavecutoff_Callback(hObject, eventdata, handles)
% hObject    handle to ileavecutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ileavecutoff as text
%        str2double(get(hObject,'String')) returns contents of ileavecutoff as a double
handles.opt.ileavecutoff=get(hObject,'String');
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ileavecutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ileavecutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sliceOrder_Callback(hObject, eventdata, handles)
% hObject    handle to sliceOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sliceOrder as text
%        str2double(get(hObject,'String')) returns contents of sliceOrder as a double
handles.opt.sliceorder=get(hObject,'String');
% Update handles structure
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function sliceOrder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliceOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when uipanel31 is resized.
function uipanel31_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function t1Prefix_Callback(hObject, eventdata, handles)
% hObject    handle to t1Prefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of t1Prefix as text
%        str2double(get(hObject,'String')) returns contents of t1Prefix as a double
handles.opt.t1prefix=get(hObject,'String');
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function t1Prefix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t1Prefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rsPrefix_Callback(hObject, eventdata, handles)
% hObject    handle to rsPrefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rsPrefix as text
%        str2double(get(hObject,'String')) returns contents of rsPrefix as a double
handles.opt.rsprefix=get(hObject,'String');
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function rsPrefix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rsPrefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
