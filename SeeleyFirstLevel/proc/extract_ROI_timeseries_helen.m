function [timeseries, roi_name] = extract_ROI_timeseries_helen(ROIs, imgs, filter)
% function timeseries = extract_ROI_timeseries(ROIs, imgdir, filter);
%
% Able to extract multiple ROIs

% ROIs (string or cell array): Pathname to folder containing the
% *roi.mat files or a cell array of pathnames to those files
%
% imgdir: directory of images to extract from (full path)
%
% filter: '1' to zero-mean and detrend the extracted
% timeseries. '0' for no filtering. (default: '0')
%
% timeseries: matrix of timeseries from each ROI in ROI_list; one
% per row. (nROI x nimgs)
%
% author: catie 9/12/06

% Modifications:
%
% 10/13/2006: (catie) got rid of the silly routine for zip/unzip;
% now just uses the one-line unix command
%
% 2006/11/03: (adnan) Uses two helper functions: get_images to get
% a character matrix of image pathnames that can be used by the
% get_marsy object and get_roilist to get a cell array of roi pathnames.

%2009/3/20: Helen Juan Zhou, 

%-------------------------------------------------------
% must add paths in this order!

addpath /usr/local/spm/spm8/toolbox/marsbar;
addpath /usr/local/spm/spm8;
addpath /usr/local/spm/spm8/toolbox/marsbar/@maroi



% %--------------------------------------------------------
% % Get ROI list
% %keyboard;
% ROI_list = get_roilist(ROIs);
nrois = size(ROIs,1);
% if nrois==0
%   error('no ROIs specified');
% end

%-------------------------------------------------------
% Get Timeseries for each ROI
timeseries = [];
for j=1:nrois
    
    
  roi_obj = maroi(deblank(ROIs(j,:)));
  roi_name{j} = label(roi_obj);
  roi_data_obj = get_marsy(roi_obj,imgs,'mean');
  roi_ts = summary_data(roi_data_obj);

  if filter % zero-mean and linear detrend
    roi_ts = roi_ts - mean(roi_ts);
    roi_ts = detrend(roi_ts);
  end
 
  timeseries = [timeseries; roi_ts']; %append the row
end

%-------------------------------------------------------
% Zip up files
%display('Zipping images....');
%unix(['gzip ', imgdir, '/*']);
display('Done.');
