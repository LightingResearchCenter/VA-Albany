function cropdata
%CROPDATA Summary of this function goes here
%   Detailed explanation goes here

% Enable dependecies
% Find full path to github directory
[githubDir,~,~] = fileparts(pwd);

% Construct repo paths
circadianPath = fullfile(githubDir,'circadian');

% Enable repos
addpath(circadianPath);

% Import daysimeter12
import daysimeter12.*

% Construct project paths
Paths = initializepaths;

% Find CDFs in folder
filterSpec = [Paths.originalData,filesep,'*.cdf'];
dialogTitle = 'Select the files to crop.';
[fileNames,containingDir,filterIndex] = uigetfile(filterSpec,dialogTitle,'MultiSelect','on');

if ~iscell(fileNames)
    fileNames = {fileNames};
end

nFile = numel(fileNames);
for i1 = 1:nFile
    % New File set up
    cdfPath = fullfile(containingDir,fileNames{i1});
    [~,cdfName,cdfExt] = fileparts(cdfPath);
    newName = [cdfName,cdfExt];
    newPath = fullfile(Paths.editedData,newName);
    % Perform cropping
    daysimeter12.cropcdf(cdfPath,newPath,Paths.logs)
end

close all;

end

