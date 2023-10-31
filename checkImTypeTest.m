% test checkFile
function tests = checkImTypeTest
tests = functiontests(localfunctions);
end

function testBaseCase(testCase)
verifyWarningFree(testCase,@() checkImType('.bmp','Test'));
verifyWarningFree(testCase,@() checkImType('tif','Test'));
end

function testBadInputs(testCase)
expErr = 'Test:InvalidFileType';
verifyError(testCase,@() checkImType(NaN,'Test'),expErr);
verifyError(testCase,@() checkImType('pdf','Test'),expErr);
end