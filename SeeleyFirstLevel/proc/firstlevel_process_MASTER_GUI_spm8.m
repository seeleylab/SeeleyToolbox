%function roi_process()

% Calculate voxelwise seed connectivity maps with task-free fMRI data
% Input: roi.mat marsbar file specifying seed region, fully preprocessed fMRI images
% Output: roi-based stats_FC folder

% v1: Juan Zhou (Helen), PhD, 2009-03-02  Email: zhoujuan227@gmail.com
% v2: Cong Christine Guo 12-2010
% v3/current version: Jesse Brown + Andrew Trujillo 04/2014

% Directories/files created
% stats_FC: directory where all SPM statistics files, job files are saved
% stats_FC/timeseries: directory where seed + nuisance timeseries txt file is saved
spmPath=which('spm');
if ~isempty(strfind(spmPath,'spm12'))
rmpath(genpath(fileparts(spmPath)));
end
clear classes

firstlevel_root=regexprep(fileparts(which('firstlevel_process_MASTER_GUI.m')),'/proc','');


addpath(genpath('/usr/share/spm8/'));
%addpath('/usr/share/spm8/toolbox/marsbar/'); % marsbar ROI functions



addpath([firstlevel_root,'/util/marsbar-0.44/']); % marsbar ROI functions



files_dir=[firstlevel_root,'/proc']; % directory where all support files are

load('loadsubfile'); % import 'subjlist' variable
% fMRI specifications
TR=subjlist.opt.tr; % this should be a vector with each subject's TR

% Nuisance signal regional masks (marsbar format)
csf_mask=sprintf('%s/csf_ant_post_bilateral_roi.mat',files_dir);
whitematter_mask=sprintf('%s/avg152T1_white_mask.mat',files_dir);
wholeimage_mask=sprintf('%s/avg152T1_wholeimage_mask_roi.mat',files_dir);
brain_mask=sprintf('%s/MNI152_T1_2mm_brain_mask_roi.mat',files_dir);
nonbrain_mask=sprintf('%s/avg152T1_nonbrain_mask.mat',files_dir);
brain_mask_explicit=sprintf('%s/MNI152_T1_2mm_brain_mask_dilated.nii,1',files_dir);

nuisance_masks={csf_mask;whitematter_mask}; % only the nuisance mask files listed in this array are used

% Nuisance processing flags
motparams=true; % true movement flag: include motion parameters in statistical model
global_ts=false; % global_ts signal flag: include global_ts signal in statistical model
bptfilter_nuisance=subjlist.opt.mfilter; % if nuisance parameters (motion and/or ica components) have been bandpass filtered
interleave=false;%subjlist.opt.ileave; % if add interleave component timeseries to model
temp_derivs=true;%true; % add temporal derivative for each nuisance parameter
quadratic=true; % if add square of each nuisance parameter
motion_spikes=false; % if add motion spikes to model
scale_regs=false; % if convert all regressors to Z scores

% Seed ROI in marsbar format; can take multiple ROIs and generate multiple
% seed connectivity directories/maps
%seed_mask={'/data/mridata/jbrown/brains/rois/44rvFI_vAt12_C2vx123_roi.mat','/data/mridata/nic/Stats/PSP_2010/rois/Boxer_DMidbrainTeg_sphere_3-5_-15_-8_roi.mat'};
seed_mask=subjlist.opt.seeds;%{'/data/mridata/nic/Stats/PSP_2010/rois/Boxer_DMidbrainTeg_sphere_3-5_-15_-8_roi.mat'};
%seed_mask={'/data/mridata/jbrown/brains/rois/44rvFI_vAt12_C2vx123_roi.mat','/data/mridata/jbrown/brains/rois/rPCC_sphere_roi.mat'};

% Statistics input files + options
global_ts_mat=sprintf('%s/job_stats_global_spm8.mat',files_dir);
stats_mat=sprintf('%s/job_stats_spm8.mat',files_dir);
run_nuisance_contrasts=false; % if false, only run seed t-contrast; if true, run all t-contrasts
mask_threshold=false;% if false, look at all voxels; if true, look at top 80% intensity voxels
explicit_mask=true; % if true, only run stats on voxels in brain_mask_explicit
runfALFF=subjlist.opt.fALFF; 

% Input/Output directories
rawfmri_dir='rawfmri'; % directory where raw fmri data are stored
interfmri_dir='interfmri'; % directory where all processed data up to normalized images are stored
processedfmri_dir='processedfmri'; % directory where processed data for bandpass filtered images are stored
log_dir='log';
melodic_dir='melodic.ica';
filtered_filename='swua_filteredf'; %'wdsau_filteredf'; %'swbbrdau_filteredf';
dir_suffix=subjlist.opt.outstring;%'RTCsNsnSFmDiI'; %'RTCbNflSFmDiI'; %'RTCsNsSFmDiI'; %'RTCbNSFmDiI';
timeseries_dir='timeseries';
stats_dir_suffix=''; % option suffix attached to output stats directory


%% Start processing


processedfmri_dir=strcat(processedfmri_dir,'_',dir_suffix);
main_dir=regexprep(subjlist.fname{1,1:end},'/rawfmri.*','');
interfmri_dir_fullpth=strcat(main_dir,'/',interfmri_dir,'_',dir_suffix);
processedfmri_dir_fullpth=strcat(main_dir,'/',processedfmri_dir);
processedfmri_imgs_dir_fullpth=strcat(main_dir,'/',processedfmri_dir,'/images');

% get list of processed fmri files, store in cell array
fmri_file_struc=dir([sprintf('%s/%s*.nii',processedfmri_imgs_dir_fullpth,filtered_filename)]);
fmri_files={};
for t=1:length(fmri_file_struc)
    fmri_files{t,1}=[processedfmri_imgs_dir_fullpth,'/',fmri_file_struc(t).name];
end

n_seeds=size(seed_mask,2);

cd(processedfmri_dir_fullpth);

% Loop for each seed ROI
for r=1:n_seeds
    seed_nuisance_masks=[seed_mask{r};nuisance_masks];
    [pth2,roi_name,ext2]=fileparts(seed_mask{r});

    % Directory where statistics files are output
    % Format is: stats_FC_<roi_name><optional_suffix>
    stats_dir=strcat('stats_FC_',roi_name,stats_dir_suffix);
    stats_dir_fullpth=sprintf('%s/%s',processedfmri_dir_fullpth,stats_dir);
    if ~exist(stats_dir_fullpth);cmd=sprintf('mkdir %s',stats_dir_fullpth);unix(cmd);end
    timeseries_dir_fullpth=sprintf('%s/%s',stats_dir_fullpth,timeseries_dir);
    if ~exist(timeseries_dir_fullpth);cmd=sprintf('mkdir %s',timeseries_dir_fullpth);unix(cmd);end

    % remove previous SPM.mat files
    if exist([stats_dir_fullpth,'/SPM.mat']); unix(['rm',' ',stats_dir_fullpth,'/SPM.mat']); end
    
    %% 1. Obtain timeseries for all seed + nuisance regressors
    % use marsbar to extract mean timeseries from each roi mask
    seed_nuisance_ts=[];
    demean_detrend_ts=true; % NOTE: this was previously set to true
    for j=1:size(seed_nuisance_masks,1)
        roi_obj=maroi(seed_nuisance_masks{j,:});
        roi_data_obj = get_marsy(roi_obj,char(fmri_files),'mean');
        roi_ts = summary_data(roi_data_obj);
        if demean_detrend_ts
            roi_ts=roi_ts-mean(roi_ts);
            roi_ts=detrend(roi_ts);
        end
        seed_nuisance_ts=[seed_nuisance_ts roi_ts];
    end
    
    n_regressors=size(seed_nuisance_ts,2);
    seed_regressor=seed_nuisance_ts(:,1);
    nuisance_regressors=seed_nuisance_ts(:,2:n_regressors);

    % if add global_ts signal to model
    if global_ts
        % set up and run dummy model to get global timeseries
        load(global_ts_mat);
        matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR;
        matlabbatch{1}.spm.stats.fmri_spec.sess.scans = {};
        for n=1:size(fmri_files,1)
            matlabbatch{1}.spm.stats.fmri_spec.sess.scans{n}=fmri_files{1,:};
        end
        matlabbatch{1}.spm.stats.fmri_spec.sess.scans=matlabbatch{1}.spm.stats.fmri_spec.sess.scans';
        matlabbatch{1}.spm.stats.fmri_spec.dir{1}=stats_dir_fullpth;

        save(sprintf('%s/job_stats_global_ts.mat',stats_dir_fullpth),'matlabbatch');
        spm_jobman('run',matlabbatch);
        
        % extract global timeseries from SPM.mat file
        spm_mat_file=sprintf('%s/SPM.mat',stats_dir_fullpth);
        load(spm_mat_file);
        global_ts = SPM.xGX.rg(:,1);
        nuisance_regressors=[nuisance_regressors global_ts];
    end

    % if add motion parameters to model
    if motparams
        if bptfilter_nuisance
            motparams_file=sprintf('%s/motion_params_filtered.txt',processedfmri_dir_fullpth);
        else
            motparams_file=sprintf('%s/motion_params.txt',processedfmri_dir_fullpth);
        end
        
        motparams_data=load(motparams_file);
        n_params=size(motparams_data);
        nuisance_regressors=[nuisance_regressors motparams_data];
    end

    % save nuisance timeseries' in text file
    nuisance_file=sprintf('%s/nuisance_regressors.txt',timeseries_dir_fullpth);
    save(nuisance_file,'nuisance_regressors','-ascii');

    % if add temporal derivatives to model
    if temp_derivs
        ld_path=getenv('LD_LIBRARY_PATH'); % matlab workaround for calling python
        setenv('LD_LIBRARY_PATH','');
        % calculate temporal derivatives
        cmd=sprintf('python %s/tempderiv.py %s',files_dir,nuisance_file);
        unix(cmd); % outputfile will be *_tempderiv.txt
        setenv('LD_LIBRARY_PATH',ld_path);
        nuisance_file=sprintf('%s/nuisance_regressors_tempderiv.txt',timeseries_dir_fullpth);
        % Load in file nuisance regressors + tempderivs, append to all regressors
        nuisance_regressors=load(nuisance_file);
    end

    % if add square of each regressor
    if quadratic
        nuisance_regressors=[nuisance_regressors nuisance_regressors.*nuisance_regressors];
    end

    % if add motion spike regressors to model
    if motion_spikes
        spike_regressors_file=sprintf('%s/motion_corr/spike_regressors.txt',interfmri_dir_fullpth);
        spike_regressors = load([main_dir '/' origdir '/' 'mc/spike_regressors.txt']);
        spike_regressors=load(spike_regressors_file);
        nuisance_regressors=[nuisance_regressors spike_regressors];
    end

    % if add ica bad component regressors to model
    if (interleave)
        if bptfilter_nuisance
            ica_regressors_file=sprintf('%s/bad_components_filtered.txt',processedfmri_dir_fullpth);
        else
            ica_regressors_file=sprintf('%s/bad_components.txt',processedfmri_dir_fullpth);
        end
        if exist(ica_regressors_file,'file');
            ica_regressors=load(ica_regressors_file);
            nuisance_regressors=[nuisance_regressors ica_regressors];
        end
    end

    n_nuisance_regressors=size(nuisance_regressors,2);

    % save seed + nuisance timeseries' in text file
    all_regressors=[seed_regressor nuisance_regressors];
    if scale_regs
        all_regressors=zscore(all_regressors);
    end
    all_regressors_file=sprintf('%s/seed_nuisance_regressors.txt',timeseries_dir_fullpth);
    save(all_regressors_file,'all_regressors','-ascii');

    %% 2. Build statistical model
    cd(stats_dir_fullpth);
    if exist([stats_dir_fullpth,'/SPM.mat']); unix(['rm',' ',stats_dir_fullpth,'/SPM.mat']); end
    con=zeros(1,n_nuisance_regressors)+1;

    names{1} = [];
    onsets{1} = [];
    durations{1} = [];
 
    reg_file={all_regressors_file};
    reg_names={strcat(num2str(n_seeds),'_Regs') 'SPMxGx_ts'};
    reg_vec = [1 0];

    task_design_file=sprintf('%s/task_design.mat',stats_dir_fullpth);
    save(task_design_file,'roi_name','reg_file','reg_names','reg_vec','names','onsets','durations');

    %% 3. Run statistics
    % fmri specifications
    load(stats_mat);
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR;
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = {};
    
    for n=1:size(fmri_files,1)
        matlabbatch{1}.spm.stats.fmri_spec.sess.scans{n}=fmri_files{n,:};
    end

    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = matlabbatch{1}.spm.stats.fmri_spec.sess.scans';
    %matlabbatch{1}.spm.stats.fmri_spec.sess.multi{1} = {};
    
    reg_file = {''};
    load(task_design_file);
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = reg_file;
    matlabbatch{1}.spm.stats.fmri_spec.dir{1} = stats_dir_fullpth;
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0,0];
    
    if explicit_mask
        matlabbatch{1}.spm.stats.fmri_spec.mask={brain_mask_explicit};
    end
    
    % fmri estimation
    matlabbatch{2}.spm.stats.fmri_est.spmmat=[];
    matlabbatch{2}.spm.stats.fmri_est.spmmat{1} = strcat(stats_dir_fullpth,'/SPM.mat');
    %jobs{1}.stats{2}.fmri_est.method = 'Classical';
    
    matlabbatch{3}.spm.stats.con.spmmat=[];
    matlabbatch{3}.spm.stats.con.spmmat{1} = strcat(stats_dir_fullpth,'/SPM.mat');
    
    contrastVecs={};
    contrastNames={};
    
    if run_nuisance_contrasts
        n_contrasts=n_nuisance_regressors+1
    else
        n_contrasts=1;
    end
    
    % specify contrast vectors
    for j=1:n_contrasts
        contrastVecs{j}=zeros(1,n_nuisance_regressors+2);
        contrastVecs{j}(j)=1;
        contrast_name=sprintf('Condition%d',j);
        contrastNames{j}=contrast_name;
        matlabbatch{3}.spm.stats.con.consess{j}.tcon.name = contrastNames{j};
        matlabbatch{3}.spm.stats.con.consess{j}.tcon.convec = contrastVecs{j};
    end
    
    contrast_mat_file=sprintf('%s/job_stats.mat',stats_dir_fullpth);
    save(contrast_mat_file,'contrastNames','contrastVecs');
    job_stats_file=sprintf('%s/job_stats.mat',stats_dir_fullpth);
    save(job_stats_file,'matlabbatch');
    % run fmri_specification job
    matlabbatch_fmri_spec={matlabbatch{1}};
    spm_jobman('run',matlabbatch_fmri_spec)
    
    % load SPM.mat and change mask threshold to -Inf
    if ~mask_threshold
        spm_mat_file=strcat(stats_dir_fullpth,'/SPM.mat');
        load(spm_mat_file);
        inds=find(SPM.xM.TH);
        SPM.xM.TH(inds)=-Inf;
        save(spm_mat_file,'SPM');
    end
    
    % run fmri_estimation and contrasts
    matlabbatch_fmri_est_con={matlabbatch{2} matlabbatch{3}};
    spm_jobman('run',matlabbatch_fmri_est_con)
end

%%RUN fALFF
if strcmp(runfALFF, 'fALFFon')
    smoothed_norm_dir=[interfmri_dir_fullpth,'/images'];
    
    
    addpath(genpath([firstlevel_root,'/util/REST_V1.6_110505/']));
    
    
    
    HB = [];%input('Frequency for high boundry (defaults 0.08)');
    if isempty(HB)
        HB = 0.08;
    end
    
    LB = [];%input('Frequency for low boundry (defaults 0.01)');
    if isempty(LB)
        LB = 0.01;
    end
    
    mapname = [];%input('prefix for ALFF map: (defaults ALFFMap_detrend_LF)');
    if isempty(mapname)
        mapname = 'ALFFMap_detrend_LF';
    end
    
    DIR = smoothed_norm_dir; %spm_select(inf, 'dir', 'select smoothed (not filtered) directory to process ALFF')
    try
        
        
        Adir = 'ALFF_results';
        TR = 2;
        
        Retrend = 'Yes';
        MaskFile =[files_dir,'/ravg152T1_brain_BB.img'];
        % GMFile = '/data/mridata/cguo/standard/tissuepriors/avg152T1_gray_03_BB.img';
        % WMFile = '/data/mridata/cguo/standard/tissuepriors/avg152T1_white_07_BB.img';
        % CSFFile = '/data/mridata/cguo/standard/tissuepriors/avg152T1_csf_05_BB.img';
        ClusterCount = 27;
        
        for i = 1:length(DIR(:,1))
            
            %     subjdir{i} = regexprep(subjdir{i}, '''','');
            tmp = deblank(DIR(i,:));
            subjdir2{i} = tmp;
            display(['Working on ' subjdir2{i}])
            Apth = [subjdir2{i} '/' Adir];
            
            if exist([Apth '/' mapname '.img'], 'file') == 2
                
                continue
            else
                mkdir(Apth)
            end
            
            cd(subjdir2{i})
            
            TR =2;
            try
                gzip('swua_merged*');
                unix('rm swua_merged*');
            end
            f = dir('swua*img');
            if length(f) < 5
                f = dir('swua*.nii');
                for p = 1:length(f)
                    unix(['fslchfiletype NIFTI_PAIR ' f(p).name]);
                end
            elseif length(f) > 235
                display('wrong images');
                pause
            end
            
            cd ..
            
            if exist([subjdir2{i} '_detrend'], 'dir') ~= 7
                rest_detrend(subjdir2{i}, '_detrend');
            end
            
            cd(subjdir2{i})
            
            fq = 1;
            
            ALFF.BandHigh = HB(fq);
            ALFF.BandLow = LB(fq);
            
            mapnam = mapname;
            if ~exist(['ALFF_results/' mapnam '.img'])
                
                theDstFile=fullfile(Apth,mapnam);
                
                alff([subjdir2{i}  '_detrend'], ...
                    TR, ...
                    ALFF.BandHigh, ...
                    ALFF.BandLow, ...
                    MaskFile, ...
                    theDstFile);
                
                theOrigMap = theDstFile;
                theMeanMap = fullfile(Apth,['m' mapnam]);
                rest_DivideMeanWithinMask(theOrigMap, theMeanMap, MaskFile);
            end
            
            mapnam = ['f' mapname];
            if ~exist(['ALFF_results/' mapnam '.img'])
                
                theDstFile=fullfile(Apth,mapnam);
                
                f_alff_CG([subjdir2{i}  '_detrend'], ...
                    TR, ...
                    ALFF.BandHigh, ...
                    ALFF.BandLow, ...
                    MaskFile, ...
                    theDstFile);
                
                theOrigMap = theDstFile;
                theMeanMap = fullfile(Apth,['m' mapnam]);
                rest_DivideMeanWithinMask(theOrigMap, theMeanMap, MaskFile);
            end
            
        end
    end
end

