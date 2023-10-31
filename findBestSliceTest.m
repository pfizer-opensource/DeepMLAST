% test findBestSlice
function tests = findBestSliceTest
tests = functiontests(localfunctions);
end

% Input checks
function testBadInput(testCase)
expErr = 'findBestSlice:InvalidInput';
% Wrong data type (string instead of image)
verifyError(testCase,@() findBestSlice('image'),expErr);
% Wrong dimensionality (2D instead of 3D)
verifyError(testCase,@() findBestSlice(zeros(256,256)),expErr);
end

% Base case
function testBaseCase(testCase)
imIn = zeros(100,100,10);
% Central slice
verifyEqual(testCase,findBestSlice(imIn),[50;50;5]);
% Best slice
imIn(30,30,3) = 1;
verifyEqual(testCase,findBestSlice(imIn),[30;30;3]);
end