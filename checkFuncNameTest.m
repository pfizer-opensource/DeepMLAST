% test checkFile
function tests = checkFuncNameTest
tests = functiontests(localfunctions);
end

function testBaseCase(testCase)
funcName = 'testFunction';
verifyWarningFree(testCase,@() checkFuncName(funcName));
end

function testBadInputs(testCase)
expErr = 'checkFuncName:InvalidFunctionName';
verifyError(testCase,@() checkFuncName(NaN),expErr);
end