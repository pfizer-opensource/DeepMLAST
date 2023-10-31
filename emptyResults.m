% Function to generate an empty table with appropriate variable names and
% types for Deep MLAST results
function [results,varNames,varTypes] = emptyResults()
varNames = {'Name','Background','Bone','Normal Thoracic','Lung',...
    'Extra-Thoracic','Heart','Tumor'};
allVarNames = cat(2,varNames,{'Group','Subject','Time'});
varTypes = {'string','double','double','double','double','double','double','double'};
allVarTypes = cat(2,varTypes,{'string','string','string'});
    
results = table('Size',[0,numel(allVarNames)],'VariableNames',allVarNames,...
    'VariableTypes',allVarTypes);

end