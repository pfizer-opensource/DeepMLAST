% Function to write table to Excel
function write2Excel(fName,T,saveVars)
%fName: text of file name
%T: data table in long format
%saveVars: cell of variable names to write
%
% Each item in saveVars will get its own sheet. Data will be sorted by
% group, then by subject and pivoted so repeated measurements are displayed
% in different columns

checkArgs(fName,T,saveVars);

% If file already exists, delete
if exist(fName,'file') == 2
    delete(fName);
end

% Write data
for v = 1:numel(saveVars)
    var = saveVars{v};
    if strcmp(var,'Non-Tumor Tissue')
        continue;
    end
    % ------ Prep Data -----
    % Select specific variable
    T1 = T(:,{'Group','Subject','Time',var});
    % Group & Pivot data
    T1 = unstack(T1,var,'Time','VariableNamingRule','preserve');
    % Transpose table
    T1 = rows2vars(T1);
    % ------ Write Sheet ------
    writetable(T1,fName,'Sheet',var,'WriteVariableNames',false);
end
end

function checkArgs(fName,T,saveVars)
% fName
if ~ischar(fName)
    error('write2Excel:InvalidInput',...
        'Invalid file: fName should be name of csv/xlsx to save to');
end
% T
if ~istable(T)
    error('write2Excel:InvalidInput','Invalid input: T must be a table');
end
% saveVars
if ~iscell(saveVars)
    error('write2Excel:InvalidInput','Invalid input: saveVars must be a cell');
end
end