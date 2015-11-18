function [goodsubs,badsubs,bsubind]=subexist(subjdir)
badsubs={};
goodsubs={};
bsubind=[];
for x=1:length(subjdir)
    subjdir{x,1}=regexprep(subjdir{x,1},',1','');
    if ~exist(subjdir{x,1})
        display(subjdir{x,1})
        badsubs{length(badsubs)+1,1}=subjdir{x,1};
        bsubind(length(bsubind)+1,1)=x;
    else
        goodsubs{size(goodsubs,1)+1,1}=subjdir{x,1};
    end
end
if isempty(badsubs)
    display('All files or folders exist.')
else
    display('One or more files is missing.')
end