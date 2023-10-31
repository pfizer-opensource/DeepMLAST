% Function to remove file extension from a file name
function nameOut= rmFileExt(nameIn)
if ~ischar(nameIn)
    error('rmFileExt:InvalidInput',...
        'Invalid Input: nameIn must be character');
end
nameParts = strsplit(nameIn,'.');
nameOut = nameParts{1};
end