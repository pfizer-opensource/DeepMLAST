% Function to sort cell list of file names in numerical order based on the
% numeric portions of the file names. Returns the sorted list.
% Significantly expanded functionality of original sortFileList() to better
% account for non-numerical information such as 'Baseline' groups and
% timepoints.
function [listOut, sortOrder] = sortFileList2(listIn)
checkArgs(listIn);
% Preallocate
data = cell(numel(listIn),3);

% Parse each file
for f = 1:numel(listIn)
    fName = listIn{f};
    data(f,:) = parseFile(fName);
end

% Sort parsed information
[~,sortOrder] = sortrows(data);
% Apply sort to original file names
listOut = listIn(sortOrder);
end

function data = parseFile(fName)
% Remove spaces
fName = strrep(fName,' ','');
for i = 1:3
% Parse flags
switch i
    case 1 
        flags = {'Baseline','Group'};
    case 2 
        flags = 'Subject';
    case 3
        flags = {'Day','Week','Baseline'};
end
% Get part of name
part = parseName({fName},flags);
part = part{1};
% Get number part of that
numPart = parseNum(part);
num = part(numPart);
% Add any extra zeros
paddedNum = cat(2,repmat('0',[1,3-length(num)]),num);
% Put final part back together
finalPart = strrep(part,num,paddedNum);
data(i) = {finalPart};
end
end

function numPart = parseNum(fName)
numPart = zeros(size(fName),'logical');
for letter_ind = 1:numel(fName)
    if strcmp(fName(letter_ind),'i') || strcmp(fName(letter_ind),'j')
        numPart(letter_ind) = 0;
    else
        numPart(letter_ind) = ~isnan(str2double(fName(letter_ind)));
    end
end
end

function checkArgs(listIn)
% Check input is list
if ~iscell(listIn)
    error('sortFileList:InvalidInput',...
        'Invalid Input: listIn must be a cell');
end
% Check all items in list are files
for i = 1:numel(listIn)
    if ~ischar(listIn{i})
        error('sortFileList:InvalidInput',...
            'Invalid Input: all items in listIn must be characters');
    end
end
end