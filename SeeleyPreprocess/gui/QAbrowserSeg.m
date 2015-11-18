function varargout = QAbrowserSeg(varargin)
% QABROWSERSEG MATLAB code for QAbrowserSeg.fig
%      QABROWSERSEG, by itself, creates a new QABROWSERSEG or raises the existing
%      singleton*.
%
%      H = QABROWSERSEG returns the handle to a new QABROWSERSEG or the handle to
%      the existing singleton*.
%
%      QABROWSERSEG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in QABROWSERSEG.M with the given input arguments.
%
%      QABROWSERSEG('Property','Value',...) creates a new QABROWSERSEG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before QAbrowserSeg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to QAbrowserSeg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help QAbrowserSeg

% Last Modified by GUIDE v2.5 14-Oct-2014 13:41:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @QAbrowserSeg_OpeningFcn, ...
    'gui_OutputFcn',  @QAbrowserSeg_OutputFcn, ...
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


% --- Executes just before QAbrowserSeg is made visible.
function QAbrowserSeg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to QAbrowserSeg (see VARARGIN)
ROOT_DIR=regexprep(which('QAbrowserSeg'),'/gui/QAbrowserSeg.m','/proc/');
handles.start_dir=pwd;

[file,path] = uigetfile('*.mat','Select a list of subject directories');
a=[path,file];
load(a);


% chdir(subjdir{1})
% [file,path] = uigetfile('*.mat','Select sample preproc setup file');
% a=[path,file];
% load(a)
% handles.opt =subjlist.opt; 
handles.numScans=3;%num2str(length(subjlist.fname));
handles.imgNumber=3;%handles.numScans;
handles.imgIndex=1;




for x=1:length(subjdir)
    handles.Log{x,1}='Not yet checked.';
end
set(handles.edit1,'String','')

handles.subjdir=subjdir;
handles.templateImage=[ROOT_DIR,'T1.nii'];
handles.index=1;


set(handles.edit2,'String',handles.index)
set(handles.skipimgedit,'String', num2str(handles.imgIndex))
set(handles.numSubs,'String',[num2str(length(subjdir)),' Subjects'])
set(handles.numImgs,'String',[handles.numScans,' Images'])

%preprocsuffix='SPM12_SEG_Full';%handles.opt.outstring;
strucdir=regexprep(handles.subjdir{handles.index},'rsfmri', 'struc/SPM12_SEG_Full/'); 
procfiles=dir([strucdir,'mwc*.nii']);
if ~isempty(procfiles)
    exampProc=procfiles(1).name;
   handles.imgFilePrefix='mwc'; %regexprep(exampProc,'_.*','');
% else
%     procfiles=dir([handles.subjdir{handles.index+1},'/processedfmri_',preprocsuffix,'/images/*filteredf*.nii']);
%     exampProc=procfiles(1).name;
%   handles.imgFilePrefix='mwc1'; %regexprep(exampProc,'_.*','');
end
%preprocsuffix=handles.opt.outstring;   
unix(['mricron ', strucdir,procfiles(handles.imgIndex).name,'&']);

set(handles.subfile,'String',[num2str(handles.index),'):',handles.subjdir{handles.index}])
set(handles.infile,'String',[num2str(handles.imgNumber),'):',strucdir,procfiles(handles.imgIndex).name]);
%fslRegFile=[handles.subjdir{handles.index},'/interfmri_',preprocsuffix,'/example_func2standard.png'];
%handles.registerFig=figure;
%[I,map]=imread(fslRegFile,'png');
%imshow(I,map,'InitialMagnification',67,'Border','tight'); 
%movegui(handles.registerFig,'southeast') 
%motionFigFile=[handles.subjdir{handles.index},'/interfmri_',preprocsuffix,'/motion_corr/motion_report.png'];
%handles.motionFig=figure;
%movegui(handles.motionFig,'northeast') 
%I,map]=imread(motionFigFile,'png');
%imshow(I,map,'Border','tight'); 
unix('wmctrl -r "-2x0x0=" -e 0,0,0,600,700')
unix('wmctrl -r "0x0x0=" -e 0,0,0,600,700')



%movegui(hObject,'north') 
%Choose default command line output for QAbrowserSeg
handles.Log{handles.index,1}='OK';
handles.output = hObject;
%handles.imgIndex=handles.imgNumber;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes QAbrowserSeg wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = QAbrowserSeg_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.Log;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.index>=2
    set(handles.edit1,'String','')
    handles.index=handles.index-1;
    handles.newInd=handles.index; 
    set(handles.edit2,'String',handles.index)
    unix('pkill -f mricron');
    
   %     if handles.imgIndex~=handles.numScans-1
%     
%             imgIndex2=handles.imgIndex-1; 
%         
%     else 
%         imgIndex2=handles.imgIndex;
%     end
imgIndex2=handles.imgIndex; 
%     

   

    strucdir=regexprep(handles.subjdir{handles.index},'rsfmri', 'struc/SPM12_SEG_Full/');
    procfiles=dir([strucdir,'c*.nii']);
    unix(['mricron ', strucdir,procfiles(imgIndex2).name,'&']);
%     set(handles.subfile,'String',[num2str(handles.index),'):',handles.subjdir{handles.index}])
%     set(handles.infile,'String',[num2str(handles.imgIndex),'):','/processedfmri_',preprocsuffix,'/images/',handles.imgFilePrefix,'_filteredf_0',imgIndex2,'.nii']);
    set(handles.subfile,'String',[num2str(handles.index),'):',handles.subjdir{handles.index}])
set(handles.infile,'String',[num2str(handles.imgIndex),'):',strucdir,procfiles(imgIndex2).name]);
    handles.Log{handles.index,1}='OK';
    
    guidata(hObject, handles);
    
    
    
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.index < length(handles.subjdir)
    set(handles.edit1,'String','')
    handles.index=handles.index+1;
    handles.newInd=num2str(handles.index);
    set(handles.edit2,'String',handles.index)
    unix('pkill -f mricron')
    
     
%     if handles.imgIndex~=handles.numScans-1
%     
%             imgIndex2=handles.imgIndex-1; 
%         
%     else 
%         imgIndex2=handles.imgIndex;
%     end
imgIndex2=handles.imgIndex; 
%     
    strucdir=regexprep(handles.subjdir{handles.index},'rsfmri', 'struc/SPM12_SEG_Full/');
     procfiles=dir([strucdir,'c*.nii']);
    unix(['mricron ', strucdir,procfiles(imgIndex2).name,'&']);
%     set(handles.subfile,'String',[num2str(handles.index),'):',handles.subjdir{handles.index}])
%     set(handles.infile,'String',[num2str(handles.imgIndex),'):','/processedfmri_',preprocsuffix,'/images/',handles.imgFilePrefix,'_filteredf_0',imgIndex2,'.nii']);
    set(handles.subfile,'String',[num2str(handles.index),'):',handles.subjdir{handles.index}])
set(handles.infile,'String',[num2str(handles.imgIndex),'):',strucdir,procfiles(imgIndex2).name]);
    handles.Log{handles.index,1}='OK';
    
    guidata(hObject, handles);
    
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Log{handles.index,1}='Flag';
try
handles.Log{handles.index,2}=['Notes: ',handles.notes];
set(handles.edit1,'String','Image flagged!')
catch
    handles.Log{handles.index,2}='Notes: ';
    set(handles.edit1,'String','Image flagged!')
end
    
guidata(hObject, handles);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
unix('pkill -f mricron')
close('all'); 
chdir(handles.start_dir) 
close



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
handles.notes=get(hObject,'String');
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


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
QALog(handles.Log)


% --------------------------------------------------------------------
function Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function new_image_Callback(hObject, eventdata, handles)
% hObject    handle to new_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ROOT_DIR=regexprep(which('QAbrowserTest'),'QAbrowserTest.m','');

[file,path] = uigetfile('*.mat','Select a list of subject directories');
a=[path,file];
load(a);


chdir(subjdir{1})
[file,path] = uigetfile('*.mat','Select sample preproc setup file');
a=[path,file];
load(a)
handles.opt =subjlist.opt; 
handles.numScans=num2str(length(subjlist.fname));
handles.imgNumber=handles.numScans;
handles.imgIndex=num2str(length(subjlist.fname)-1);
if length(subjlist.fname)<100
    handles.imgIndex=['0',handles.imgIndex];
end


for x=1:length(subjdir)
    handles.Log{x,1}='Not yet checked.';
end
set(handles.edit1,'String','')

handles.subjdir=subjdir;
handles.templateImage=[ROOT_DIR,'MNI152_T1_2mm.nii.gz'];
handles.index=1;


set(handles.edit2,'String',handles.index)
set(handles.skipimgedit,'String', num2str(handles.imgIndex))
set(handles.numSubs,'String',[num2str(length(subjdir)),' Subjects'])
set(handles.numImgs,'String',[handles.numScans,' Images'])

preprocsuffix=handles.opt.outstring;
procfiles=dir([handles.subjdir{handles.index},'/processedfmri_',preprocsuffix,'/images/*filteredf*.nii']);
if ~isempty(procfiles)
    exampProc=procfiles(1).name;
 handles.imgFilePrefix='wdsau'; %regexprep(exampProc,'_.*','');
else
    procfiles=dir([handles.subjdir{handles.index+1},'/processedfmri_',preprocsuffix,'/images/*filteredf*.nii']);
    exampProc=procfiles(1).name;
  handles.imgFilePrefix='wdsau'; %regexprep(exampProc,'_.*','');
end
preprocsuffix=handles.opt.outstring;   
unix(['mricron ', handles.templateImage,' -o ',handles.subjdir{handles.index},'/processedfmri_',preprocsuffix,'/images/',handles.imgFilePrefix,'_filteredf_0',handles.imgIndex,'.nii&']);
set(handles.subfile,'String',[num2str(handles.index),'):',handles.subjdir{handles.index}])
set(handles.infile,'String',[num2str(handles.imgNumber),'):','/processedfmri_',preprocsuffix,'/images/',handles.imgFilePrefix,'_filteredf_0',handles.imgIndex,'.nii']);



%Choose default command line output for QAbrowserSeg
handles.Log{handles.index,1}='OK';
handles.output = hObject;
handles.imgIndex=handles.imgNumber;
% Update handles structure
guidata(hObject, handles);



% --------------------------------------------------------------------
function save_log_Callback(hObject, eventdata, handles)
% hObject    handle to save_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function save_log_csv_Callback(hObject, eventdata, handles)
% hObject    handle to save_log_csv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uiputfile('*.csv','Save Workspace as .csv');

filename=[file,path];
fileID = fopen(filename,'wt');

Log=handles.Log;
[rows, columns] = size(Log);
for index = 1:rows    
    fprintf(fileID, '%s,', Log{index,1:end-1});
    fprintf(fileID, '%s\n', Log{index,end});
end 
fclose(fileID);

% --------------------------------------------------------------------
function save_log_mat_Callback(hObject, eventdata, handles)
% hObject    handle to save_log_mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uiputfile('*.mat','Save Workspace as .Mat');
Log=handles.Log;
save([path,file],'Log')


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if  isfield(handles,'newInd')
    set(handles.edit1,'String','')
    if str2num(handles.newInd)<=length(handles.subjdir) && str2num(handles.newInd)~=0
        handles.index=handles.newInd;
        handles.index=str2num(handles.index);
        
        set(handles.edit2,'String',handles.index)
        
        unix('pkill -f mricron')
        preprocsuffix=handles.opt.outstring;
        if str2num(handles.imgIndex) ~= str2num(handles.numScans)-1
            if str2num(handles.imgIndex)<100 && str2num(handles.imgIndex) >9
                imgIndex2=['0',num2str(str2num(handles.imgIndex)-1)];
            elseif str2num(handles.imgIndex)<10
                imgIndex2=['00',num2str(str2num(handles.imgIndex)-1)];
            else
                imgIndex2=num2str(str2num(handles.imgIndex)-1);
            end
        else
            imgIndex2=num2str(str2num(handles.imgIndex)-1);
        end
        
        
        unix(['mricron ', handles.templateImage,' -o ',handles.subjdir{handles.index},'/processedfmri_',preprocsuffix,'/images/',handles.imgFilePrefix,'_filteredf_0',imgIndex2,'.nii&']);
        set(handles.subfile,'String',[num2str(handles.index),'):',handles.subjdir{handles.index}])
        set(handles.infile,'String',[num2str(handles.imgIndex),'):','/processedfmri_',preprocsuffix,'/images/',handles.imgFilePrefix,'_filteredf_0',imgIndex2,'.nii']);
        handles.Log{handles.index,1}='OK';

        
        
    else
        set(handles.edit2,'String',handles.index)
    end
    %Choose default command line output for QAbrowserSeg
    handles.output = hObject;
    
    % Update handles structure
    guidata(hObject, handles);
end


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
handles.newInd=get(hObject,'String');
if isempty(handles.newInd)
    handles.newInd=num2str(handles.index);
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in skipimage.
function skipimage_Callback(hObject, eventdata, handles)
% hObject    handle to skipimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if  isfield(handles,'newImg')
handles.newImg=str2num(handles.newImg);
if handles.newImg<=str2num(handles.numScans) && handles.newImg~=0

if handles.newImg<100 && handles.newImg >9
    handles.imgIndex=['0',num2str(handles.newImg-1)];
elseif handles.newImg<10
    handles.imgIndex=['00',num2str(handles.newImg-1)];
else 
handles.imgIndex=num2str(handles.newImg-1);
end

set(handles.skipimgedit,'String',num2str(handles.newImg))

unix('pkill -f mricron')
preprocsuffix=handles.opt.outstring;
unix(['mricron ', handles.templateImage,' -o ',handles.subjdir{handles.index},'/processedfmri_',preprocsuffix,'/images/',handles.imgFilePrefix,'_filteredf_0',handles.imgIndex,'.nii&']);
set(handles.subfile,'String',[num2str(handles.index),'):',handles.subjdir{handles.index}])
set(handles.infile,'String',[num2str(handles.newImg),'):','/processedfmri_',preprocsuffix,'/images/',handles.imgFilePrefix,'_filteredf_0',handles.imgIndex,'.nii']);
handles.Log{handles.index,1}='OK';
handles.imgIndex=num2str(handles.newImg);
handles.newImg=num2str(handles.newImg);
else
   set(handles.skipimgedit,'String',handles.imgIndex)
end
%Choose default command line output for QAbrowserSeg
handles.output = hObject;
unix('wmctrl -r "0x0x0=" -e 0,0,0,600,700')
unix('wmctrl -r "-2x0x0=" -e 0,0,0,600,700')

% Update handles structure
guidata(hObject, handles);
end


function skipimgedit_Callback(hObject, eventdata, handles)
% hObject    handle to skipimgedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of skipimgedit as text
%        str2double(get(hObject,'String')) returns contents of skipimgedit as a double
handles.newImg=get(hObject,'String');
if isempty(handles.newImg)
    handles.newImg=handles.imgIndex; 
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function skipimgedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to skipimgedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
