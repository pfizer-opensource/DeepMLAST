% test checkDir
function tests = checkDirTest
tests = functiontests(localfunctions);
end

% Base case
function testValidDir(testCase)
dirName = 'UnitTesting';
verifyWarningFree(testCase, @() checkDir(dirName,'test'));
end

% Invalid inputs
function testBadInputs(testCase)
expErr = 'Test:InvalidDirectory';
fileName = 'UnitTesting/Sample.log';
verifyError(testCase, @() checkDir(NaN','Test'),expErr);
verifyError(testCase, @() checkDir('E:/FakeDir','Test'),expErr);
verifyError(testCase, @() checkDir(fileName,'Test'),expErr);
end