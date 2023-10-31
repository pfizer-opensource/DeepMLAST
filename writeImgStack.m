% writeImgStack()

% Function to write 3D volume to dicom stack contained within folder
function writeImgStack(im,fileName,savePath,imType)
checkArgs(im,fileName,savePath,imType);

% Create directory
[~,~,dz] = size(im);
mkdir(savePath,fileName);

% Write images slice by slice
for z = 1:dz
    fullFileName = verifyFileName(fullfile(savePath, fileName,[fileName '_' num2str(z) imType]));
    if strcmp(imType,'.tif')
        imwrite(double(im(:,:,z))/255,fullFileName,'Compression','none');
    else
    imwrite(im(:,:,z),fullFileName,'Mode','lossless');
    end
end

disp('Image Written to File');
end

function checkArgs(im, fileName, savePath, imType)
% im
checkIm(im,3,'writeImgStack');

% fileName
if ~ischar(fileName)
    error('writeImgStack:InvalidFileName','Invalid file name: must be a character');
end

% savePath
checkDir(savePath,'writeImgStack');

%imType
checkImType(imType,'writeImgStack');
end