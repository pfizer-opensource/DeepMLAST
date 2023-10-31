% test checkFile
function tests = checkImTest
tests = functiontests(localfunctions);
end

function testBaseCase(testCase)
% 2D
im = zeros([128,128]);
verifyWarningFree(testCase,@() checkIm(im,2,'Test'));
% 3D
im = zeros([128,128,100]);
verifyWarningFree(testCase,@() checkIm(im,3,'Test'));
end

function testBadInputs(testCase)
im = zeros([128,128]);
expErr = 'Test:InvalidInput';
% Wrong dim
verifyError(testCase,@() checkIm(im,3,'Test'),expErr);
% Non-numeric im
verifyError(testCase,@() checkIm('image',3,'Test'),expErr);
% Non-numeric dsize
verifyError(testCase,@() checkIm(im,'3','Test'),'checkIm:InvalidInput');
end