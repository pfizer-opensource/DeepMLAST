% Function to resize, rescale, and normalize single 2D input image
function imOut = preprocessIm(im)
checkArgs(im)
% Resize
imOut = imresize(double(im),[256,256]);
% Rescale
imOut = 255*(imOut/65536);
% Normalize
imOut = (imOut - 39.8) / 24.2;
end

function checkArgs(im)
checkIm(im,2,'preprocessIm')
end