% Check if input is a valid imaging file extension
function checkImType(fType,funcName)
% Check inputs
checkFuncName(funcName);

if ~ischar(fType)
    error([funcName ':InvalidFileType'],...
        ['Invalid file type: Cannot load images with extension "' fType '". Please use an imaging format in the Matlab image file format registry']);
end
% Remove dot
fType = strrep(fType,'.','');
% Get list of image types
I = imformats; imTypes = {}; ct = 1;
for i = 1:numel(I)
    exts = I(i).ext;
    for j = 1:numel(exts)
        imTypes{ct} = exts{j};
        ct = ct+1;
    end
end
% Check fileType in list
if ~max(strcmp(fType,imTypes))
    error([funcName ':InvalidFileType'],...
        ['Invalid file type: Cannot load images with extension "' fType '". Please use an imaging format in the Matlab image file format registry']);
end
end