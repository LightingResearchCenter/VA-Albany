function cropdata
%CROPDATA Summary of this function goes here
%   Detailed explanation goes here

% Enable dependecies
% Find full path to github directory
[githubDir,~,~] = fileparts(pwd);

% Construct repo paths
cdfPath         = fullfile(githubDir,'LRC-CDFtoolkit');
phasorPath      = fullfile(githubDir,'PhasorAnalysis');
sleepPath       = fullfile(githubDir,'DaysimeterSleepAlgorithm');
daysigramPath   = fullfile(githubDir,'DaysigramReport');
lightHealthPath = fullfile(githubDir,'LHIReport');
croppingPath    = fullfile(githubDir,'DaysimeterCropToolkit');
dfaPath         = fullfile(githubDir,'DetrendedFluctuationAnalysis');

% Enable repos
addpath(cdfPath,phasorPath,sleepPath,daysigramPath,lightHealthPath,croppingPath,dfaPath);

% Construct project paths
Paths = initializepaths;

% Perform cropping
cropping(Paths.originalData,Paths.editedData,Paths.logs);

end

