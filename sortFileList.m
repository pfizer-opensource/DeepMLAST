% Function to sort cell list of file names in numerical order based on the
% numeric portions of the file names. Returns the sorted list.
function [listOut, sortOrder] = sortFileList(listIn)
checkArgs(listIn);

% Preallocate
numPart_all = zeros(numel(listIn),3);

% Get numeric portion of each file name
for file_ind = 1:numel(listIn)
    fName = listIn{file_ind};
    numPart = zeros(size(fName),'logical');
    for letter_ind = 1:numel(fName)
        if strcmp(fName(letter_ind),'i') || strcmp(fName(letter_ind),'j')
            numPart(letter_ind) = 0;
        else
            numPart(letter_ind) = ~isnan(str2double(fName(letter_ind)));
        end
    end
    % Set numeric portions to be used in sorting
    numPart1 = str2double(fName(bwlabel(numPart)==1)); %sort by 1st numerical part
    numPart2 = str2double(fName(bwlabel(numPart)==2)); %sort by 2nd numerical part
    numPart3 = str2double(fName(bwlabel(numPart)==3)); %sort by 3rd numerical part
    % Put files w/ few numerical parts at beginning of list
    if isnan(numPart3)
        numPart3 = numPart2; numPart2 = numPart1; numPart1 = 0;
    end
    numPart_all(file_ind,:) = [numPart1 numPart2 numPart3];
    clear numPart fName
end

% Sort first by 1st numerical part, then by 2nd, then by 3rd
[~,sortOrder] = sortrows(numPart_all,[1,2,3],'ascend','MissingPlacement','first');
listOut = listIn(sortOrder);
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