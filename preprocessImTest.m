% test preprocessIm
function tests = preprocessImTest
tests = functiontests(localfunctions);
end

function testInvalidInput(testCase)
im = imread('UnitTesting/Test Scan/Subject2_Day3_rec00000267.tif');
im3 = cat(3,im,zeros(size(im)));
expErr = 'preprocessIm:InvalidInput';
% verifyWarningFree(testCase,@() preprocessIm(im));
verifyError(testCase,@() preprocessIm('image'),expErr);
verifyError(testCase,@() preprocessIm(im3),expErr);
end