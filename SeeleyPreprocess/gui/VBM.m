function varargout = VBM(varargin)
% VBM MATLAB code for VBM.fig
%      VBM, by itself, creates a new VBM or raises the existing
%      singleton*.
%
%      H = VBM returns the handle to a new VBM or the handle to
%      the existing singleton*.
%
%      VBM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VBM.M with the given input arguments.
%
%      VBM('Property','Value',...) creates a new VBM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VBM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VBM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VBM

% Last Modified by GUIDE v2.5 13-Aug-2014 00:47:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VBM_OpeningFcn, ...
                   'gui_OutputFcn',  @VBM_OutputFcn, ...
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


% --- Executes just before VBM is made visible.
function VBM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VBM (see VARARGIN)
[~,pth]=unix('which qsub');
setenv('SGE_ROOT', regexprep(pth,'/bin.*',''));
[file,path] = uigetfile({'*.mat'},'Select a list of subject directories');
a=[path,file];
load(a)

guihome=fileparts(which('Preprocess'));
fignum=PopUpMessage('Please wait while the subject directories are scanned...');
display('Scanning directories.....')
handles.dirs=length(subjdir);
%%Add subexist to global path
[~,goodsubs,badsubs,bsubind]=evalc('subexist(subjdir)');
close(fignum)
if isempty(badsubs)
    handles.pths=0;
    handles.bsubpath={};
else
    handles.pths=length(badsubs);
    subjdir=goodsubs;
    handles.bsubpath=badsubs;
end
set(handles.dirfound,'String',handles.dirs)
set(handles.pthfound,'String',handles.pths)
handles.subjdir=subjdir;
handles.bsubind=bsubind;

[handles.T1f,~,subs]=GetSubjectImgs(subjdir,240,5,'','','struc'); 
handles.subs=subs;
set(handles.T1,'String',length(handles.T1f));
set(handles.ready,'String',length(subjdir)-length(handles.T1f));




% Choose default command line output for VBM
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VBM wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VBM_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ViewDirListBsubs(handles.bsubpath);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ViewDirListBsubs(handles.T1f);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newsubjdir=ViewDirList(handles.subjdir, handles.bsubind);
handles.subjdir=newsubjdir;

display('Scanning directories.....')
handles.dirfound=length(handles.subjdir);
%%Add subexist to global path
[~,goodsubs,badsubs,bsubind]=evalc('subexist(handles.subjdir)');
if isempty(badsubs)
    handles.pthfound=0;
else
    handles.pthfound=length(badsubs);
    subjdir=goodsubs;
end
set(handles.dirfound,'String',handles.dirfound)
set(handles.pthfound,'String',handles.pthfound)
handles.subjdir=subjdir;
handles.bsubind=bsubind;
[handles.T1,~,subs]=GetSubjectImgs(subjdir,240,5,'','','struc'); 
handles.subs=subs;
set(handles.T1,'String',length(handles.T1));
set(handles.ready,'String',length(subjdir)-length(handles.T1));

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
preproc_root=fileparts(fileparts(which('VBM.m')));
handles.opt.preproc_root=preproc_root;
for x=1:length(handles.subjdir)
    subjlist=handles.subs{x};
    Outstring='SPM12_SEG_Full';
    strucdir=[fileparts(regexprep(handles.subjdir{x,1},'rsfmri/','rsfmri')),'/struc'];
    handles.subjdirStruc{x,1}=strucdir;
    outdir=[strucdir,'/',Outstring,'/log/'];
    outdirRoot=[strucdir,'/',Outstring];
    lockedfile=[outdir,'subjectLocked'];
    if exist(outdir) 
        unix(['rm -r ',outdirRoot]);
        cmd=['mkdir -p ', outdir];
        unix(cmd)
        save([outdir,'vbmSetup.mat'],'subjlist');
    elseif ~exist(outdir)
        cmd=['mkdir -p ', outdir];
        unix(cmd)
        save([outdir,'vbmSetup.mat'],'subjlist');
    end
end
fid=fopen([preproc_root,'/proc/subjdirVBM.txt'],'w+','n', 'US-ASCII');
fprintf(fid,'%s\n%s\n',Outstring, handles.subjdirStruc{:});
fclose(fid);
unix([preproc_root,'/grid/RunSGE_spm12_Seg ',preproc_root])
display('Jobs sent to SGE') 
