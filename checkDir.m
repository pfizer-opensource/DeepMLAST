% Check if input is valid directory
function checkDir(dirName,funcName)
% Check inputs
checkFuncName(funcName);

% Check if directory exists
if ~(ischar(dirName) && (exist(dirName,'dir')==7))
    error([funcName ':InvalidDirectory'],...
        ['Invalid directory: ' dirName ' does not exist']);
end
end