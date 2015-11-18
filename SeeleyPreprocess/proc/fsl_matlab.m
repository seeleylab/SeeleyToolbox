function [w1,vargout]=fsl_matlab(call,varargin)
%FSL_MATLAB   Execute FSL functions from within MATLAB
%
%   [w1]=fsl_matlab(CALL)
%   Execute the FSL command in the string CALL
%   Return the STDOUT
%
%   fsl_matlab(CALL,GZIP)
%   Execute the FSL command in the string CALL and set the output type for
%   any .nii file to not be gzipped (for SPM compatibility)
%
%   [DATA,HEADER] = fsl_matlab(CALL,GZIP,OUTDIR)
%   Execute the FSL command in the string CALL and store the resultant
%   output in DATA as a N-dimensional matrix for a .nii file
%   Looks for DATA in current directory unless specified by OUTDIR
%
%   Examples:
%      fsl_matlab('bet T1 T1_brain -B -f 0.05 -g')
%      fsl_matlab('fslinfo T1')
%      fsl_matlab('fslstats T1_brain -V')
%      data = fsl_matlab('fslmaths T1_brain -bin T1_brain_mask',false,'~/analyzed')
%
%   Wishlist:
%      - Detect if .nii file is created, provide option to read in that file
%      - Submit to a node if in a multicore/grid environment
%
%   Jesse Brown 05/2013

% Configure FSL environment variables
fsldir=getenv('FSLDIR');
fslbin=sprintf('%s/bin',fsldir); % FSL bin directory

if nargin > 1 % if optional second argument is true
    gunzip=varargin{1};
    if gunzip
        setenv('FSLOUTPUTTYPE','NIFTI_GZ'); 
    else
        setenv('FSLOUTPUTTYPE','NIFTI'); 
    end
end

% Execute the FSL command
% This currently only works for single created files, not for multiple files
cmd1 = sprintf('%s/%s',fslbin,call);
[s1,w1]=unix(cmd1);

% Read in .nii data and header
if nargout > 1
    if nargin > 2
        outdir=varargin{2};
        cmd3=sprintf('ls -t %s/* | head -1',outdir);
    else
        cmd3='ls -t | head -1';
    end
    
    [s2,w2]=unix(cmd3);

    [pathstr,name,ext] = fileparts(w2);
    vargout{1}=[];
    vargout{2}=[];
    %if strcmp(EXT,'.nii')
        V=spm_vol(w2); % read in file header with SPM
        [Y,XYZ] = spm_read_vols(V); % read in file data with SPM
        vargout{2}=Y;
        vargout{3}=V;
    %end
end
