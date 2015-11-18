function [mean_displace,std_displace,max_displace,sum_displace,n_spikes,mean_transrms,std_transrms,max_transrms,sum_transrms,max_trans,mean_euler,std_euler,max_euler,sum_euler,max_rot,spike_trs]=motion_qa(motparams_file,show_plot,fsl_style,varargin)
% motion_qa.m
% Jesse Brown, Andrew Trujillo
% 04/2014

% calculate the following based on FSL mcflirt/SPM realign motion parameters:
% mean/max/summed displacelacement as combination of translation and rotation
% mean/max/summed translation:
% 'max_trans' is largest translation in a single direction;
% 'max_trans_rms' is largest translation combining all three directions
% mean/max/summed rotation
% 'max_rot' is largest rotation in a single direction;
% 'max_euler' is largest rotation combining all three directions
% number of spikes

% par file is something like: /data5/patientNIC/6259/6259_20100423/rsfmri/rsfmri_closed/interfmri_RTCbNSFmDiI/melodic.ica/mc/prefiltered_func_data_mcf.par

if length(varargin)==2
    n_scans=varargin{1};
    spike_cutoff=varargin{2};
elseif length(varargin)==3
    n_scans=varargin{1};
    spike_cutoff=varargin{2};    
    plot_filename=varargin{3};
else
    n_scans=235; % number of fmri volumes
    spike_cutoff=1; % amount of motion displacelacement in mm above which to flag a motion spike
end

head_radius=80;
radian_to_deg=180/pi;

% load motion parameters
%motparams=load('/data5/patientNIC/3936/3936_20100624/rsfmri/interfmri_RTCbNSFmDiI/melodic.ica/mc/prefiltered_func_data_mcf.par');
%motparams_file='~/Desktop/mc/prefiltered_func_data_mcf.par'; % '~/Desktop/rp_RestingStatephysio25x25x3_006.txt'
motparams_orig=load(motparams_file);
%fsl_style=true; % change to false for SPM rp file

% FSL mcflirt .par file has rotations then translations; if FSL, switch order
% SPM realign rp file has translations then rotations; if SPM, preserve order
motparams=zeros(n_scans,6);
if fsl_style
    motparams(:,1:3)=motparams_orig(:,4:6);
    motparams(:,4:6)=motparams_orig(:,1:3);
else
    motparams=motparams_orig;
end

%% displacement
motparams_diffs=diff(motparams); % calculate backward-looking differences

for i=1:n_scans-1
    trans_x=motparams_diffs(i,1);
    trans_y=motparams_diffs(i,2);
    trans_z=motparams_diffs(i,3);
    phi=motparams_diffs(i,4);
    theta=motparams_diffs(i,5);
    psi=motparams_diffs(i,6);

    % formula adapted from https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=FSL;2ce58db1.1202
    displace(i) = sqrt(0.2*head_radius^2*((cos(phi)-1)^2+(sin(phi))^2 + (cos(theta)-1)^2 + (sin(theta))^2 + (cos(psi)-1)^2 + (sin(psi)^2)) + trans_x^2+trans_y^2+trans_z^2);
end
displace=[0 displace];

mean_displace=mean(displace);
std_displace=std(displace);
max_displace=max(displace);
sum_displace=sum(displace);
n_spikes=length(find(displace>spike_cutoff));
spike_trs=find(displace>spike_cutoff);

%% translation and rotation
max_trans=max(max(abs(motparams_diffs(:,1:3))));
max_rot=max(max(abs(motparams_diffs(:,4:6))))*radian_to_deg;
for i=1:n_scans-1
    trans_rms(i)=sqrt(sum(motparams_diffs(i,1:3).^2));

    a=prod(cos(motparams_diffs(i,[4 5]))) + prod(cos(motparams_diffs(i,[4 6]))) + prod(cos(motparams_diffs(i,[5 6])));
    b=prod(sin(motparams_diffs(i,4:6)))-1;
    rot_euler(i)=acos((a+b)/2);
end

mean_transrms=mean(trans_rms);
std_transrms=std(trans_rms);
max_transrms=max(trans_rms);
sum_transrms=sum(trans_rms);

mean_euler=mean(rot_euler.*radian_to_deg);
std_euler=std(rot_euler.*radian_to_deg);
max_euler=max(rot_euler.*radian_to_deg);
sum_euler=sum(rot_euler.*radian_to_deg);

%% plotting
if show_plot
    figure
    subplot(3,1,1)
    plot(motparams(:,1:3));
    title(sprintf('Motion.par file: %s\n\nTranslation | max trans: %0.2fmm | sum RMS: %0.2fmm | mean RMS: %0.2fmm',motparams_file,max_trans,sum_transrms,mean_transrms),'Interpreter','none');ylabel('mm')
    subplot(3,1,2)
    plot(motparams(:,4:6));
    title(sprintf('Rotation | max rot: %0.2f%c | sum Euler: %0.2f%c | mean Euler: %0.2f%c',max_rot,char(176),sum_euler,char(176),mean_euler,char(176)));ylabel('radians')
    subplot(3,1,3)
    plot(displace)
    title(sprintf('Displacement | max displace: %0.2fmm | sum displace: %0.2fmm | # spikes: %2.0f',max_displace,sum_displace,n_spikes));xlabel('time');ylabel('mm')
    hold on
    scatter(find(displace>spike_cutoff),displace(find(displace>spike_cutoff)),'red','filled')
elseif exist(sprintf('%s','plot_filename'),'var')
    h=figure('visible','off');
    subplot(3,1,1)
    plot(motparams(:,1:3));
    title(sprintf('Motion.par file: %s\n\nTranslation | max trans: %0.2fmm | sum RMS: %0.2fmm | mean RMS: %0.2fmm',motparams_file,max_trans,sum_transrms,mean_transrms),'Interpreter','none');ylabel('mm');
    subplot(3,1,2)
    plot(motparams(:,4:6));
    title(sprintf('Rotation | max rot: %0.2f%c | sum Euler: %0.2f%c | mean Euler: %0.2f%c',max_rot,char(176),sum_euler,char(176),mean_euler,char(176)));ylabel('radians');
    subplot(3,1,3)
    plot(displace)
    title(sprintf('Displacement | max displace: %0.2fmm | sum displace: %0.2fmm | # spikes: %2.0f',max_displace,sum_displace,n_spikes));xlabel('time');ylabel('mm');
    hold on
    scatter(find(displace>spike_cutoff),displace(find(displace>spike_cutoff)),'red','filled');
    print(h,'-dpng','-r300',plot_filename)
end
