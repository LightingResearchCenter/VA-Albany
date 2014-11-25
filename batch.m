function batch

initializedependencies;

import daysimeter12.*

Paths = initializepaths;

filePathArray = crawldir(Paths.editedData,'.cdf');

% Preallocate Output
Output = struct(...
    'subject',               {[]},...
    'phasorMagnitude',       {[]},...
    'phasorAngleHrs',        {[]},...
    'interdailyStability',   {[]},...
    'intradailyVariability', {[]},...
    'averageActivity',       {[]},...
    'averageCS',             {[]},...
    'averageIlluminance',    {[]});

for i1 = 1:numel(filePathArray)
    % Read the data from file
    cdfData = daysimeter12.readcdf(filePathArray{i1});
    
    [absTime,relTime,epoch,light,activity,masks,subjectID,deviceSN] = convertcdf(cdfData);
    
    prepdaysigram(absTime,light,activity,masks,subjectID,Paths);
    
    [Phasor,Actigraphy,Average] = prepcomposite(absTime,relTime,epoch,light,activity,masks,subjectID,deviceSN,Paths);
    
    Output(i1,1).subject = subjectID;
    Output(i1,1).phasorMagnitude = Phasor.magnitude;
    Output(i1,1).phasorAngleHrs = Phasor.angle.hours;
    Output(i1,1).interdailyStability = Actigraphy.interdailyStability;
    Output(i1,1).intradailyVariability = Actigraphy.intradailyVariability;
    Output(i1,1).averageActivity = Average.activity;
    Output(i1,1).averageCS = Average.cs;
    Output(i1,1).averageIlluminance = Average.illuminance;
    
end

close all;

% Save summarized results to Excel file
OutputDataset = struct2dataset(Output);
outputCell = dataset2cell(OutputDataset);
xlsPath = fullfile(Paths.analysis,['va-albany_summary_',datestr(now,'yyyy-mm-dd_HH-MM-SS'),'.xlsx']);
xlswrite(xlsPath,outputCell);

end

function prepdaysigram(absTime,light,activity,masks,subject,Paths)

time2 = absTime.localDateNum(masks.observation);
startTime = floor(min(time2));
stopTime = ceil(max(time2));
displayIdx = absTime.localDateNum > startTime & absTime.localDateNum < stopTime;

time = absTime.localDateNum(displayIdx);
maskNames = fieldnames(masks);
for i1 = 1:numel(maskNames)
    masks.(maskNames{i1}) = masks.(maskNames{i1})(displayIdx);
end
cs = light.cs(displayIdx);
activity = activity(displayIdx);

sheetTitle  = ['VA-Albany, Subject: ',subject];
fileID      = ['daysigram_subject',subject];
reports.daysigram.daysigram(sheetTitle,time,masks,...
    activity,cs,'cs',[0,1],10,Paths.plots,fileID);

clf;
    
end

function [Phasor,Actigraphy,Average] = prepcomposite(absTime,relTime,epoch,light,activity,masks,subject,deviceSN,Paths)
import reports.composite.*

onSubject = masks.compliance & ~masks.bed;
activity(~onSubject) = 0;
light.cs(~onSubject) = 0;
light.illuminance(~onSubject) = 0;

Phasor = phasor.prep(absTime,epoch,light,activity,masks);

Actigraphy = struct;
activity2 = activity;
activity2(masks.bed) = 0;
activity2(~masks.observation) = [];
[Actigraphy.interdailyStability,Actigraphy.intradailyVariability] = isiv.isiv(activity2,epoch);
    
[         ~,millerCS] = millerize.millerize(relTime,light.cs,masks);
[millerTime,millerActivity] = millerize.millerize(relTime,activity,masks);
Miller = struct('time',millerTime,'cs',millerCS,'activity',millerActivity);

cs = light.cs(~masks.bed & masks.observation);
lux = light.illuminance(~masks.bed & masks.observation);
ai = activity(~masks.bed & masks.observation);

Average = reports.composite.daysimeteraverages(cs,lux,ai);
daysimeter = deviceSN(4:6);

figTitle  = ['VA-Albany, Subject: ',subject];
compositeReport(Paths.plots,Phasor,Actigraphy,Average,Miller,subject,daysimeter,figTitle);

clf;
end
