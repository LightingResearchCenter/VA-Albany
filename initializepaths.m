function Paths = initializepaths
%INITIALIZEPATHS Prepare project folder and file paths
%   Detailed explanation goes here

% Preallocate output structure
Paths = struct(...
    'project'       ,'',...
    'originalData'  ,'',...
    'editedData'    ,'',...
    'analysis'      ,'',...
    'plots'         ,'',...
    'logs'          ,'');

% Set project parent directory
Paths.project = fullfile([filesep,filesep],'root','projects','VA-Albany','DaysimeterData');
% Check that it exists
if exist(Paths.project,'dir') ~= 7 % 7 = folder
    error(['Cannot locate the folder: ',Paths.project]);
end

% Specify sub-directories
Paths.originalData	= fullfile(Paths.project,'original');
Paths.editedData	= fullfile(Paths.project,'edited');
Paths.analysis      = fullfile(Paths.project,'analysis');
Paths.plots         = fullfile(Paths.project,'plots');
Paths.logs          = fullfile(Paths.project,'logs');

end

