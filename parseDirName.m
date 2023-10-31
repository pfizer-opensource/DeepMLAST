% Function to parse scan name from directory
function scanName = parseDirName(dirName,parentDirName)
[dirName,parentDirName] = checkArgs(dirName,parentDirName);



dirSplit = strsplit(dirName,'/');
parentSplit = strsplit(parentDirName,'/'); scanName = [];

% If scan directly in folder, just give scan name of folder
if strcmp(dirName,parentDirName)
    scanName = dirSplit{end};
end

for d = 1:numel(dirSplit)
    namePart = dirSplit{d};
    % Only use parts of directory not included in study folder
    if ~sum(strcmp(namePart,parentSplit))
        if isempty(scanName)
            scanName = namePart;
        else
            scanName = [scanName '_' namePart];
        end
    end
end
end

function [dirName, parentDirName] = checkArgs(dirName,parentDirName)
% Check these are valid directories
checkDir(dirName,'parseDirName');
checkDir(parentDirName,'parseDirName');

% Handle multiple slash types
dirName = strrep(dirName,'\','/');
parentDirName = strrep(parentDirName,'\','/');

% Confirm directory found inside parent
if ~(contains(dirName,parentDirName))
    error('parseDirName:InvalidDirectory',...
        ['Invalid directories: cannot find "' dirName '" inside of "' parentDirName]);
end
end