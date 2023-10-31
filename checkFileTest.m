% test checkFile
function tests = checkFileTest
tests = functiontests(localfunctions);
end

function testBaseCase(testCase)
fileName = 'UnitTesting/Sample.log';
verifyWarningFree(testCase,@() checkFile(fileName,'Test'));
end

function testBadInputs(testCase)
expErr = 'Test:InvalidFile';
verifyError(testCase,@() checkFile('E:/FakeFile.txt','Test'),expErr);
verifyError(testCase,@() checkFile('E:/','Test'),expErr);
verifyError(testCase,@() checkFile(NaN,'Test'),expErr);
% Test with incorrect folder naming format
verifyError(testCase,@() checkFile('D:\Test','Test'),'checkFile:FormatError');
end