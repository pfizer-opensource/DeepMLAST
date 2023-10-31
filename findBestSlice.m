% Function to ID representative slices to use for QC of a 3D image
function sliceNums = findBestSlice(imIn)
% Check inputs
checkIm(imIn,3,'findBestSlice');
% Preallocate
dims = 1:3;
sliceNums = zeros(3,1);

if sum(sum(sum(imIn))) == 0
    for d = 1:numel(size(imIn))
        % If all zeros, use center slice
        sliceNums(d) = round(size(imIn,d)/2);
    end
    return
end

for d = dims
    dimsNot = dims; dimsNot(d) = [];
    % Otherwise use slice w/ fewest pixels that = 0
    [~, sliceNums(d)] = min(squeeze(sum(sum(imIn==0,dimsNot(1)),dimsNot(2))));
end
end