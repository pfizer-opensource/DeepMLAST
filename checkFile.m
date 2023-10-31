% Check if file name is valid
function checkFile(fileName,funcName)
checkFuncName(funcName);
if ~(ischar(fileName) && (exist(fileName,'file')==2))
    if ischar(fileName) && contains(fileName,'\')
        error('checkFile:FormatError',...
            "FormatError: File names should be entered in '/' format, not '\'.");
    end
    error([funcName ':InvalidFile'],['Invalid file name: ' fileName ' does not exist']);
end
end