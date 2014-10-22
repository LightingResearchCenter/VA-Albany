clear
close all
clc

initializedependencies;

import daysimeter12.*;

Paths = initializepaths;

filePathArray = crawldir(Paths.originalData,'.cdf');

for i1 = 1:numel(filePathArray)
    % Read the data from file
    cdfData = readcdf(filePathArray{i1});
    
    [absTime,relTime,epoch,light,activity,masks] = convertcdf(cdfData);
    
    sheetTitle  = ['VA-Albany, Subject: ',cdfData.GlobalAttributes.subjectID,' preliminary'];
    fileID      = ['preliminaryDaysigram_subject',cdfData.GlobalAttributes.subjectID];
    
    generatedaysigram(sheetTitle,absTime.localDateNum,activity,...
        light.cs,'cs',[0,1],17,Paths.plots,fileID);
    
end
