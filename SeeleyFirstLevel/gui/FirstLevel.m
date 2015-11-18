function varargout = FirstLevel(varargin)
% FIRSTLEVEL MATLAB code for FirstLevel.fig
%      FIRSTLEVEL, by itself, creates a new FIRSTLEVEL or raises the existing
%      singleton*.
%
%      H = FIRSTLEVEL returns the handle to a new FIRSTLEVEL or the handle to
%      the existing singleton*.
%
%      FIRSTLEVEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIRSTLEVEL.M with the given input arguments.
%
%      FIRSTLEVEL('Property','Value',...) creates a new FIRSTLEVEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FirstLevel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FirstLevel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FirstLevel

% Last Modified by GUIDE v2.5 14-Aug-2014 10:05:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FirstLevel_OpeningFcn, ...
                   'gui_OutputFcn',  @FirstLevel_OutputFcn, ...
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


% --- Executes just before FirstLevel is made visible.
function FirstLevel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FirstLevel (see VARARGIN)
[~,pth]=unix('which qsub');
setenv('SGE_ROOT', regexprep(pth,'/bin.*',''));

handles.firstlevel_dir=regexprep(fileparts(which('FirstLevel.m')),'/gui','');

[file,path] = uigetfile('*.mat','Select a list of subject directories');
a=[path,file];
load(a);


chdir(subjdir{1})
handles.subjdir=subjdir;
[file,path] = uigetfile('*.mat','Select sample preproc setup file');
a=[path,file];
load(a)
if  ~isfield(subjlist,'opt')
    opt.tr=2;
    opt.trnum=240;
    opt.delscans=5;
    opt.outstring=regexprep(regexprep(path,'.*interfmri_',''),'/log/','');
else
    opt=subjlist.opt; 
end
opt=ScanDetails(opt); 


handles.opt =opt; 
try
    handles.numScans=str2num(handles.opt.trnum)-str2num(handles.opt.delscans);
catch
    handles.numScans=handles.opt.trnum-handles.opt.delscans;
end

handles.procImages=['processedfmri_',handles.opt.outstring,'/images'];
fignum=PopUpMessage('Please wait while the subject directories are scanned...');
display('Scanning directories.....')
handles.dirs=length(subjdir);
close(fignum)
[~,goodsubs,badpaths,bsubind]=evalc('subexist(subjdir)');
if isempty(badpaths)
    handles.pths=0;
    handles.bsubpath={};
else
    handles.pths=length(badpaths);
    subjdir=goodsubs;
    handles.bsubpath=badpaths;
end

handles.badsubs={};
handles.custom={};
for x=1:length(subjdir)
    chdir(subjdir{x,1})
    chdir(handles.procImages);
    a=dir('swua_filteredf*');
    if length(a) ~= handles.numScans
        handles.badsubs{length(handles.badsubs)+1,1}=subjdir{x,1};
    end
end
set(handles.rs,'String',length(handles.badsubs));
set(handles.ready,'String',length(subjdir)-length(handles.badsubs));
set(handles.pthfound,'String',handles.pths)
set(handles.dirfound,'String',handles.dirs)
        
    
handles.seeds={};
handles.fALFF='fALFFoff';
set(handles.uitable1,'Data',{});
handles.customNum=0; 

% Choose default command line output for FirstLevel
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FirstLevel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FirstLevel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
state=get(hObject,'Value'); 
if state==1
handles.seeds{length(handles.seeds)+1,1}=[handles.firstlevel_dir, '/proc/rPCC_sphere_roi.mat'];
else 
    seedsNew={};
    for x=1:length(handles.seeds)
        if ~strcmp(handles.seeds{x,1}, [handles.firstlevel_dir, '/proc/rPCC_sphere_roi.mat'])
            seedsNew{length(seedsNew)+1,1}=handles.seeds{x,1};
        end
    end
    handles.seeds=seedsNew; 
end
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
state=get(hObject,'Value'); 
if state==1
handles.seeds{length(handles.seeds)+1,1}=[handles.firstlevel_dir, '/proc/44rvFI_vAt12_C2vx123_roi.mat'];
else 
    seedsNew={};
    for x=1:length(handles.seeds)
        if ~strcmp(handles.seeds{x,1}, [handles.firstlevel_dir, '/proc/44rvFI_vAt12_C2vx123_roi.mat'])
            seedsNew{length(seedsNew)+1,1}=handles.seeds{x,1};
        end
    end
    handles.seeds=seedsNew; 
end
% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
state=get(hObject,'Value'); 
if state==1
handles.seeds{length(handles.seeds)+1,1}=[handles.firstlevel_dir, '/proc/Boxer_DMidbrainTeg_sphere_3-5_-15_-8_roi.mat'];
else 
    seedsNew={};
    for x=1:length(handles.seeds)
        if ~strcmp(handles.seeds{x,1}, [handles.firstlevel_dir, '/proc/Boxer_DMidbrainTeg_sphere_3-5_-15_-8_roi.mat'])
            seedsNew{length(seedsNew)+1,1}=handles.seeds{x,1};
        end
    end
    handles.seeds=seedsNew; 
end
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5
state=get(hObject,'Value'); 
if state==1
    [file,path] = uigetfile('*.mat','Select ROI .mat file');
    handles.seeds{length(handles.seeds)+1,1}=[path,file];
    handles.custom=[path,file];
else
    seedsNew={};
     for x=1:length(handles.seeds)
        if ~strcmp(handles.seeds{x,1}, handles.custom)
            seedsNew{length(seedsNew)+1,1}=handles.seeds{x,1};
        end
    end
    handles.seeds=seedsNew; 
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(handles.custom)
handles.seeds=vertcat(handles.seeds,handles.custom);
end
for x=1:length(handles.subjdir)
    try
    load([handles.subjdir{x,1},'/interfmri_',handles.opt.outstring,'/log/preprocSetup.mat'])
    end
    if  ~isfield(subjlist,'opt')
        subjlist.opt.tr=handles.opt.tr;
        subjlist.opt.trnum=handles.opt.trnum;
        subjlist.opt.delscans=handles.opt.delscans;
        subjlist.opt.outstring=handles.opt.outstring;
    end
    subjlist.opt.seeds=handles.seeds'; 
    subjlist.opt.fALFF=handles.fALFF; 
    if ~exist([handles.subjdir{x,1},'/',fileparts(handles.procImages),'/log'])
        mkdir([handles.subjdir{x,1},'/',fileparts(handles.procImages),'/log'])
    end
    datevec=fix(clock);
    datestring=[num2str(datevec(1)),'_',num2str(datevec(2)),'_',num2str(datevec(3)),'_',num2str(datevec(4)),'_',num2str(datevec(5))]; 
    mkdir([handles.subjdir{x,1},'/',fileparts(handles.procImages),'/log/',datestring])
    save([handles.subjdir{x,1},'/',fileparts(handles.procImages),'/log/',datestring,'/roiSetup.mat'],'subjlist');
end
fid=fopen( [handles.firstlevel_dir,'/gui/subjdir.txt'],'w+','n', 'US-ASCII');
fprintf(fid,'%s\n%s\n',handles.opt.outstring, handles.subjdir{:});
fclose(fid);
unix([handles.firstlevel_dir,'/grid/RunSGE_1stLevel_MASTER_GUI ',handles.firstlevel_dir,' ',datestring])        


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    



% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ViewDirListBsubs(handles.bsubpath);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ViewDirListBsubs(handles.badsubs);


% --- Executes when selected object is changed in uipanel2.
function uipanel2_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel2 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles.fALFF=get(hObject,'Tag');  
% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.custom={};
customDisp={};
set(handles.uitable1,'Data',customDisp);
if handles.customNum>0
    for w=1:handles.customNum

    [file,path] = uigetfile('*.mat',['Select seed ',num2str(w),' (.mat file):']);
    if path==0
        break
    end
    handles.custom{length(handles.custom)+1,1}=[path,file];
    customDisp{length(customDisp)+1,1}=file;
% else
%     seedsNew={};
%      for x=1:length(handles.seeds)
%         if ~strcmp(handles.seeds{x,1}, handles.custom)
%             seedsNew{length(seedsNew)+1,1}=handles.seeds{x,1};
%         end
%     end
%     handles.seeds=seedsNew; 
    end
    set(handles.uitable1,'Data',customDisp);
end
% Update handles structure
guidata(hObject, handles);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
handles.customNum=str2double(get(hObject,'String'));
set(handles.uitable1,'Data',{});
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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

    
