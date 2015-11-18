function [subjdir] = make_subjlist(subjdir_filename,outstring,outpath)

% make_subjlist.m
% JB 12/2014
% take matlab subjdir cell array in .mat file and create subjdir.txt

out_file=sprintf('%s/subjdir.txt',outpath);

load(subjdir_filename);
fid=fopen(out_file,'w+','n', 'US-ASCII');
fprintf(fid,'%s\n%s\n',outstring, subjdir{:});
fclose(fid);
