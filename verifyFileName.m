function nameOut = verifyFileName(nameIn)
% Function to confirm file name is less than 260 characters. If not,
% shortens name appropriately. Input name should include the full path as
% well as the file name & extension
charLimit = 260;

% Check input
if ~ischar(nameIn)
    error('verifyFileName:InvalidInput',...
        'Invalid Input: nameIn must be a character or string');
end

% Check if full name hits character limit, if not no changes made.
if length(nameIn) < charLimit
    nameOut = nameIn;
    return;
end

% Get file name separate from path
nameIn = strrep(nameIn,'\','/');
nameParts = strsplit(nameIn,'/');
fileName = nameParts{end};
pathOnly = [strjoin(nameParts(1:end-1),'/') '/'];
pathLen = length(pathOnly);
% Get file extension
fileParts = strsplit(fileName,'.');
fileExt = ['.' fileParts(end)];
tmpFileName = strjoin(fileParts(1:end-1));
% Break file name into parts
fileNameParts = strsplit(tmpFileName,'_');
minFileName = [fileNameParts(end) fileExt];

% Confirm will be able to rename file. If path length too long, raise error
% instead.
if pathLen >= (charLimit - length(minFileName))
    error('verifyFileName:PathTooLong',...
        'File Naming Error: Path name is longer than 259 characters.');
end

% Use as much of the file name as possible (crop characters from beginning
% of name)
newFileName = fileName(end-(charLimit-1-pathLen)+1:end);

% Drop any leading special characters
specChar = {'%','(',')','_','-','!','@','#','$','^','&','*','=','+',',','"','.','?',';',':','[',']','{','}','~','`',' '};
ct = 0;
while max(strcmp(newFileName(1),specChar))==1
    for c=specChar
        newFileName = strip(newFileName,c{1});
    end
    ct = ct + 1;
    if ct >300
        error('verifyFileName:WhileLoopError','Error:While loop not exiting')
    end
end

% Assign new full file name
nameOut = [pathOnly newFileName];
end