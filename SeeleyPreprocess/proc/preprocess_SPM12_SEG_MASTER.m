function preprocess_SPM12_SEG_MASTER()
preproc_root=regexprep(fileparts(which('preprocess_SPM12_SEG_MASTER.m')),'/proc','');
fid=fopen([preproc_root,'/Paths.txt']);
spmNewpath=textscan(fid,'%s');
spmNewpath=char(spmNewpath{1,1}); 

spmPath=which('spm');
if ~isempty(strfind(spmPath,'spm8'))
rmpath(genpath(fileparts(spmPath)));
end
addpath(genpath(spmNewpath));

files_dir=[preproc_root,'/proc'];

addpath(genpath(files_dir));

load('loadsubfile');
subjdir=subjlist.tname;
chdir(fileparts(subjdir{1,1}))

%COPY T1
if ~isempty(strfind(subjdir{1,1},'img'))
    unix(['cp',' ', regexprep(subjdir{1,1},'img',''),'* ../SPM12_SEG_Full/'])
    [~,t1file]=fileparts(subjdir{1,1});
    T1file=[t1file,'.img'];
else
    unix(['cp',' ',subjdir{1,1},' ../SPM12_SEG_Full/'])
    [~,t1file]=fileparts(subjdir{1,1});
    T1file=[t1file,'.nii'];
end
cd ../SPM12_SEG_Full

%RUN SEGMENTATION
newT1pth={[pwd,'/',T1file]};
load([files_dir,'/job_SPM12_SEG_Full.mat']);
matlabbatch{1,1}.spm.spatial.preproc.channel.vols=newT1pth;
 for m=1:6
 matlabbatch{1}.spm.spatial.preproc.tissue(1,m).tpm={[fileparts(which('spm')),'/tpm/TPM.nii,',num2str(m)]};
end
save('log/job_SPM12_SEG_Full','matlabbatch');
spm_jobman('run',matlabbatch);


% %RUN SMOOTHING
files=dir('mwc*.nii');
load([files_dir,'/job_spm12_smooth8mm.mat']);
matlabbatch{1,1}.spm.spatial.smooth.data={files(1).name;files(2).name;files(3).name};
save('log/job_spm12_smooth8mm','matlabbatch');
spm_jobman('run',matlabbatch);

