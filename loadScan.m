% Function to load all images in a scan
function resultImage = loadScan(fileLoc, fileList, fileType)
checkArgs(fileLoc,fileList,fileType)
strrep(fileType,'.','');

dz = numel(fileList);
% Read image stack
if strcmp(fileType,'.dcm') % If dicom format
    tempImage = dicomread([fileLoc '\' fileList{1}]);
    [dy, dx] = size(tempImage);
    resultImage = zeros([dy, dx, dz]);
    for z = 1:dz
        resultImage(:,:,z) = dicomread([fileLoc '\' fileList{z}]);
    end
else % If non-dicom format
    tempImage = imread([fileLoc '\' fileList{1}]);
    [dy, dx] = size(tempImage);
    resultImage = zeros([dy, dx, dz]);
    for z = 1:dz
        resultImage(:,:,z) = imread([fileLoc '\' fileList{z}]);
    end
end
end

function checkArgs(fileLoc, fileList, fileType)
% File Location
checkDir(fileLoc,'loadScan');

% File list
if ~iscell(fileList)
    error('loadScan:InvalidFileList','Error: fileList must be of type cell')
end
if isempty(fileList)
    error('loadScan:InvalidFileList','Error: fileList is empty')
end

% File Type
checkImType(fileType,'loadScan');
end