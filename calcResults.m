% Function to calculate resulting volumes for various labels from label
% image
function results = calcResults(labelIm,numLabels,volFactor)
checkArgs(labelIm,numLabels,volFactor);

% Preallocate
results = zeros(1,numLabels);


% Calculate volumes
for n = 1:numLabels
    results(n) = sum(sum(sum(labelIm==n)))*volFactor;
end
% Convert to cell
results = num2cell(results);
end

function checkArgs(labelIm,numLabels,volFactor)
checkIm(labelIm,3,'calcResults');
% Check numLabels is integer
if ~isnumeric(numLabels) || ~(floor(numLabels)==numLabels)
    error('calcResults:InvalidInput','Invalid Input: numLabels must be an integer');
end
% Check volFactor is numeric
if ~isnumeric(volFactor) || isnan(volFactor)
    error('calcResults:InvalidInput','Invalid Input: volFactor must be numeric');
end
end