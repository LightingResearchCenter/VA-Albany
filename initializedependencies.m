function initializedependencies
%INITIALIZEDEPENDENCIES Add necessary repos to working path
%   Detailed explanation goes here

% Find full path to github directory
[githubDir,~,~] = fileparts(pwd);

% Construct repo paths
circadian = fullfile(githubDir,'circadian');

% Enable repos
addpath(circadian);

end

