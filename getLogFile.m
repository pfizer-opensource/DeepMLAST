% Function to parse log file from scan directory
function file = getLogFile(dirName)
% Check input
checkDir(dirName,'getLogFile');

% Get all files
allFileStruct = dir(fullfile(dirName));
allFiles = cell(numel(allFileStruct),1);
for i = 1:numel(allFileStruct); allFiles{i} = allFileStruct(i).name; end

% Check if any files have .log extension
% Select file with .log extension
logs = contains(allFiles,'.log');
if ~max(logs>0)
    error('getLogFile:NoLogFound',['No log file found in ' dirName]);
end
logName = allFiles{logs};

% Return full file name
file = fullfile(dirName,logName);
end