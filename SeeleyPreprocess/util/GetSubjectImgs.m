function [bsubsT1,bsubsfMRI,subs]=GetSubjectImgs(subjdir,numTRs,delscans,rsfmriSuf,t1Suf,mode)
bsubsT1={};
bsubsfMRI={};
badT1=false;
badfMRI=false;

startdir=pwd;
subs={};

for x=1:length(subjdir)
    subjlist.fname={};
    subjlist.tname={};
    t1nam={};
    chdir(subjdir{x,1})
    try
        cd rawfmri %change to rawfmri
    end
    rawfmri=dir([rsfmriSuf,'*.nii']);
    for y=1:length(rawfmri)
        subjlist.fname{y,1}=[pwd,'/',rawfmri(y).name];
    end
    try
        cd ../../struc/strucraw
    catch
        try
            cd ../../../struc/strucraw
        catch
            cd ../struc/strucraw
        end
    end
    t1nam=dir([t1Suf,'*.nii']);
    if isempty(t1nam)
        t1nam=dir([t1Suf,'*.img']);
    end
     
    subjlist.tname={[pwd,'/',t1nam.name]};
    if length(subjlist.fname)~=numTRs
        bsubsfMRI{length(bsubsfMRI)+1,1}=subjdir{x,1};
        badfMRI=true;
    end
    if isempty(t1nam) || length(t1nam)>1
        bsubsT1{length(bsubsT1)+1,1}=subjdir{x,1};
        badT1=true;
    end
    if strcmp(mode,'rsfmri')
    if ~badT1 && ~badfMRI
        subjlist.fname(1:delscans)=[];
        subs{x,1}=subjlist;
    end
    elseif strcmp(mode,'rsfmri_nongui')
        subjlist.fname(1:delscans)=[];
        subs{x,1}=subjlist;
        chdir(subjdir{x,1})
        cd rawfmri
        save('preprocSetup.mat','subjlist')
        
    elseif strcmp(mode,'struc')
       subs{x,1}=subjlist;
    end
    
end
chdir(startdir)
