function [] = make_subjdir_txt(subjdir_filename,varargin)

% make_subjdir_txt.m
% JB 03/2015
% take matlab subjdir cell and create column text file

load(subjdir_filename);

if nargin > 1
    out_filename=varargin{1};
else
    strs=strsplit(subjdir_filename,'.mat');
    subjdir_filename_pref=strs{1};
    out_filename=sprintf('%s.txt',subjdir_filename_pref);
end

fileID=fopen(out_filename,'w');
[r,c]=size(subjdir);
for i=1:r
    fprintf(fileID ,'%s\n', subjdir{i});
end
fclose(fileID);