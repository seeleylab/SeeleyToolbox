function [] = build_contrasts_FuncConn(session, HRFflag)

% THIS VERSION: builds T-contrasts for seeded functional connectivity
% analysis for resting state fMRI. 
%Assumes you have *zero* task conditions; allows any number
% of additional regressors (ROI timeseries, global signal, etc), as
% long as only one is "of interest".
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: catie 2007-02-20
% Helen Juan Zhou 2009-03-20

% ORIGINAL VERSION:
% Function which creates contrasts for the statistical analysis.
% Author: Adnan Majid 2006-08-17
% Contact: dsamajid@stanford.edu

%keyboard;
contrastNames = {};
contrastVecs = {};
contrastTypes = {};
  
%%task_design = session.multi{1};

pwd
disp('load task design');
load('task_design.mat'); %load from current directory, which is wriiten from previous program task_design.m

if (isempty(names{1}))
    numConds=0; %resting state fMRI
else
    numConds=length(names);
end
numRegs = length(reg_vec); %number of regressors [1 1 1 ..1]

if (sum(HRFflag)==0)
    vecLength = numConds+numRegs + 1;
elseif (sum(HRFflag)==1)
    vecLength = 2*numConds+numRegs + 1; % time or dispersion deriv
elseif (sum(HRFflag)==2)
    vecLength = 3*numConds+numRegs + 1; % time and dispersion deriv
end

for i=1:vecLength-1
    contrastNames{i} = strcat('Condition ', num2str(i));
end

%basis function

if (sum(HRFflag)==0)
    base{1} = [1];  %reg_vec= [1 1 1 1 0] (numReg 1 plus 0)
elseif (sum(HRFflag)==1)
    base{1} = [1 0]; % time or dispersion deriv
    base{2} = [0 1];
elseif (sum(HRFflag)==2)
    base{1}= [1 0 0];
    base{2}= [0 1 0];
    base{3}= [0 0 1]; % time and dispersion deriv
end
b=length(base);
for i=1:numConds
    head=zeros(1,(i-1)*b);
    endd=zeros(1,(numConds-i)*b+1);
    for j=1:length(base)
        ck=b*(i-1)+j;
        contrastVecs{ck}=[head base{j} endd];
    end
    clear head
    clear endd
end
for i=1:numRegs
    head=zeros(1,i-1);
    endd=zeros(1,numRegs-i+1);
    contrastVecs{numConds*b+i}=[head 1 endd];
    clear head
    clear endd
end

contrastVecs

length(contrastVecs)
numTContrasts = length(contrastNames)
  
os = fopen('contrasts.txt', 'w');
fprintf(os, 'Contrasts for (functional connectivity) Statistical Analysis\n');
fprintf(os, 'Session: %s\n', sess_name);
for i=1:length(contrastNames)

  type = 'T';

  fprintf(os, '\n%s%d:\t%s\n', type, i, contrastNames{i});
  for j=1:length(contrastVecs{i}(:,1))
    fprintf(os, '\t[');
    fprintf(os, ' %d', contrastVecs{i}(j,:));
    fprintf(os, ' ]\n');
  end
end

fclose(os);
pwd

save contrasts.mat contrastNames contrastVecs numTContrasts;
