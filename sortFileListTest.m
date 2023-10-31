%test sortFileList
function tests = sortFileListTest
tests = functiontests(localfunctions);
end

% Test base case
function testBaseCase(testCase)
validList = { 'Group2_Subject 2 _ Week3'; 'Group 1_Subject1_Week2';...
    'Group1_Subject1_Week10';...
    'Group 1_Subject1_Week1'; 'Group 3_Subject 1_Week5';...
    'Baseline_Subject2_Baseline'; 'Baseline_Subject1_Week1'};
expOut = {'Baseline_Subject1_Week1';'Baseline_Subject2_Baseline';...
    'Group 1_Subject1_Week1'; 'Group 1_Subject1_Week2';...
    'Group1_Subject1_Week10';'Group2_Subject 2 _ Week3';...
    'Group 3_Subject 1_Week5'};
verifyEqual(testCase,sortFileList(validList),expOut);
end

% Input checks
function testBadInputs(testCase)
badList = {'Group 1_Subject1_Week1'; 'Group 1_Subject1_Week2';...
    'Group1_Subject1_Week10';'Group2_Subject 2 _ Week3';...
    NaN};
expErr = 'sortFileList:InvalidInput';
verifyError(testCase,@() sortFileList(badList), expErr);
verifyError(testCase,@() sortFileList(NaN), expErr);

end