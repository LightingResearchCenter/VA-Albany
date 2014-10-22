function filePathArray = crawldir(directory,fileExtArray)
%CRAWLDIR Recursively crawls a directory and all sub directories
%   Will match files that follow the specified naming pattern
 
Listing = dir(directory);
nFiles = numel(Listing);
filePathArray = cell(nFiles,1);
for iFile = 1:nFiles
    [~,~,thatExt] = fileparts(Listing(iFile).name);
    if any(strcmpi(thatExt,fileExtArray))
        filePathArray{iFile} = fullfile(directory,Listing(iFile).name);
    end
end

idxEmpty = cellfun(@isempty,filePathArray);
filePathArray(idxEmpty) = [];

SubDirListing = Listing([Listing(:).isdir]);
 
for iSubFold = 1:numel(SubDirListing)
   if ~strcmp(SubDirListing(iSubFold).name,'.') && ~strcmp(SubDirListing(iSubFold).name,'..')
       subFilePathArray = crawldir(fullfile(directory,SubDirListing(iSubFold).name),fileExtArray);
       filePathArray = [filePathArray;subFilePathArray];
   end
end


end

