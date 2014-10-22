function batch

initializedependencies;

import daysimeter12.*

Paths = initializepaths;

filePathArray = crawldir(Paths.editedData,'.cdf');

for i1 = 1:numel(filePathArray)
    % Read the data from file
    cdfData = daysimeter12.readcdf(filePathArray{i1});
    
    [absTime,relTime,epoch,light,activity,masks] = convertcdf(cdfData);
    
    subject = cdfData.GlobalAttributes.subjectID;
    
%     prepdaysigram(absTime,light,activity,masks,subject,Paths);
    
    prepcomposite(absTime,relTime,epoch,light,activity,masks,subject,Paths)
    
end

close all;

end

function prepdaysigram(absTime,light,activity,masks,subject,Paths)

sheetTitle  = ['VA-Albany, Subject: ',subject];
fileID      = ['daysigram_subject',subject];
inuse = masks.observation & masks.compliance & ~masks.bed;
reports.daysigram.daysigram(sheetTitle,absTime.localDateNum(inuse),...
    activity,light.cs(inuse),'cs',[0,1],7,Paths.plots,fileID);

clf;
    
end

function prepcomposite(absTime,relTime,epoch,light,activity,masks,subject,Paths)
import reports.composite.*

onSubject = masks.compliance & ~masks.bed;
activity(~onSubject) = 0;
light.cs(~onSubject) = 0;
light.illuminance(~onSubject) = 0;

[phasorVector,magnitudeHarmonics,firstHarmonic] = phasor.phasor(absTime.localDateNum(masks.observation),epoch,light.cs(masks.observation),activity(masks.observation));
[interdailyStability,intradailyVariability] = isiv.isiv(activity(masks.observation),epoch);
magnitude = abs(phasorVector);
angleHrs = angle(phasorVector)*24/(2*pi);
Phasor = struct('vector',phasorVector,'magnitude',magnitude,...
    'angleHrs',angleHrs,'interdailyStability',interdailyStability,...
    'intradailyVariability',intradailyVariability,...
    'magnitudeHarmonics',magnitudeHarmonics,'firstHarmonic',firstHarmonic);

Average = daysimeteraverages(light.cs(masks.observation),light.illuminance(masks.observation),activity(masks.observation));

[         ~,millerCS] = millerize.millerize(relTime,light.cs,masks);
[millerTime,millerActivity] = millerize.millerize(relTime,activity,masks);
Miller = struct('time',millerTime,'cs',millerCS,'activity',millerActivity);

figTitle  = ['VA-Albany, Subject: ',subject];
compositeReport(Paths.plots,Phasor,Average,Miller,subject,figTitle);

clf;
end
