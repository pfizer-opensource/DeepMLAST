%test parseName
function tests = rmFileExtTest
tests = functiontests(localfunctions);
end

% Test base case
function testBaseCase(testCase)
n1 = 'File Name.txt';
n2 = 'File Name';
expOut = n2;
verifyEqual(testCase,rmFileExt(n1),expOut);
verifyEqual(testCase,rmFileExt(n2),expOut);
end

% Input checks
function testBadInputs(testCase)
expErr = 'rmFileExt:InvalidInput';
verifyError(testCase,@() rmFileExt(NaN),expErr);
end