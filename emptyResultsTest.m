% test emptyResults
function tests = emptyResultsTest()
tests = functiontests(localfunctions);
end

% Test base case
function testBaseCase(testCase)
[T,varNames,varTypes] = emptyResults();

% Confirm varNames & varTypes same size
verifyEqual(testCase,size(varNames),size(varTypes));
% Confirm table is table
verifyTrue(testCase,istable(T));
% Confirm table is empty
verifyTrue(testCase,isempty(T));
% Confirm table has correct variables
for v = 1:numel(varNames)
    verifyTrue(testCase,iscolumn(T(:,varNames{v})));
end
end