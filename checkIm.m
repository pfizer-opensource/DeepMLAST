% Check if input is image of correct size
function checkIm(im,dsize,funcName)
checkArgs(dsize,funcName);
if ~isnumeric(im) && ~islogical(im)
    error([funcName ':InvalidInput'],...
        'Invalid input: im must be an image');
end
if numel(size(im)) ~= dsize
    error([funcName ':InvalidInput'],...
        ['Invalid input: im must be ' num2str(dsize) 'D']);
end
end

function checkArgs(dsize,funcName)
checkFuncName(funcName);

if ~isnumeric(dsize)
    error('checkIm:InvalidInput','Invalid Input: dsize must be a number');
end
end