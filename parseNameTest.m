%test parseName
function tests = parseNameTest
tests = functiontests(localfunctions);
end

% Test base case
function testBaseCase(testCase)
names = {'Group 1_Subject 1_Baseline';'Group 1_Subject 1_Week 4'};
fields1 = {'Day','Week','Baseline'};
fields2 = 'Group';
expOut1 = {'Baseline';'Week 4'};
expOut2 = {'Group 1';'Group 1'};
verifyEqual(testCase,parseName(names,fields1),expOut1);
verifyEqual(testCase,parseName(names,fields2),expOut2);
end

% Input checks
function testBadInputs(testCase)
names = {'Group 1_Subject 1_Baseline';'Group 1_Subject 1_Week 4'};
fields = {'Day','Week','Baseline'};
expErr = 'parseName:InvalidInput';
% names
verifyError(testCase,@() parseName({},fields),expErr);
verifyError(testCase,@() parseName('Group 1_Subject 1_Baseline',fields),expErr);
verifyError(testCase,@() parseName(NaN,fields),expErr);
verifyError(testCase,@() parseName(cell([10,2,2]),fields),expErr);
% fields
verifyError(testCase,@() parseName(names,NaN),expErr);
verifyError(testCase,@() parseName(names,5),expErr);
end