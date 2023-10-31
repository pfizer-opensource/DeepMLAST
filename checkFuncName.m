% Check if function name is valid
function checkFuncName(funcName)
if ~ischar(funcName)
    error('checkFuncName:InvalidFunctionName',...
        ['Cannot recognize ' funcName 'Please enter a valid function name']);
end