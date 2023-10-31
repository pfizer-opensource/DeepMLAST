% Function to ID scan information from host directory
function [imageList, mNum, scanDate, fileType] = scanInfo(dirName, allScanDirs)
% Check inputs
if ~(ischar(dirName) && (exist(dirName,'dir') == 7))
    error('scanInfo:InvalidDirectory',['Invalid scan directory: ' dirName ' does not exist']);
end
if (exist('allScanDirs','var') && ~iscell(allScanDirs))
    error('scanInfo:InvalidInput','Please enter a cell of characters for "allScanDirs"');
end

filt = 'rec0';

% Mouse ID
mNum = dirName;

% Update user
if exist('allScanDirs','var')
    thisScanInd = find(strcmp(dirName,allScanDirs));
    disp(['Analyzing scan # ' num2str(thisScanInd) ' of ' num2str(numel(allScanDirs))]);
else
    disp(['Loading ' num2str(mNum)]);
end

% Scan Date
scanDate = readLogFile(getLogFile(dirName),'StudyDateandTime','Scanduration');

% File List
allFileStruct = dir(fullfile(dirName));
allFiles = cell(numel(allFileStruct),1);
for i = 1:numel(allFileStruct); allFiles{i} = allFileStruct(i).name; end
fileList = allFiles(contains(allFiles,filt));

% Check some files found
if isempty(fileList)
    error('scanInfo:NoFilesFound',['No files matching filter "' filt '" in ' dirName]);
end

% Get File Type
fileTypeAll = cell(size(fileList)); for j = 1:numel(fileList); fileTypeAll{j} = fileList{j}(end-3:end); end
fileTypeAll_mat = cell2mat(fileTypeAll);
fileType = mode(fileTypeAll_mat);
if max(~strcmp(fileType,fileTypeAll))
    warning('scanInfo:MultipleFileTypes',['Warning: Multiple imaging types located for "' mNum '" Will use files with extension: ' fileType]);
end

% Take only image files
imageList = fileList(contains(fileList,fileType));
end