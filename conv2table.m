% Function to reformat results into table
function out = conv2table(allResults)
checkArgs(allResults);

[~,varNames,~] = emptyResults();
out = cell2table(allResults,'VariableNames',varNames);
% Get group name
out.Group = parseName(out.Name,{'Baseline','Group'});
% Get subject name
out.Subject = parseName(out.Name,'Subject');
% Get timepoint
out.Time = parseName(out.Name,{'Day','Week','Baseline'});
end

function checkArgs(allResults)
if ~iscell(allResults) || (size(allResults,2) ~= 8) || (numel(size(allResults)) ~= 2)
    error('conv2table:InvalidInput',...
        'Invalid Input: allResults must be an nx8 cell');
end
end