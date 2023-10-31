% test calcResults
function tests = calcResultsTest
tests = functiontests(localfunctions);
end

function testBadInputs(testCase)
labelIm = zeros([256,256,100]);
numLabels = 7;
volFactor = 1;
expErr = 'calcResults:InvalidInput';
% labelIm
verifyError(testCase,@() calcResults(NaN,numLabels,volFactor),expErr);
verifyError(testCase,@() calcResults('image',numLabels,volFactor),expErr);
% numLabels
verifyError(testCase,@() calcResults(labelIm,NaN,volFactor),expErr);
verifyError(testCase,@() calcResults(labelIm,'number',volFactor),expErr);
verifyError(testCase,@() calcResults(labelIm,1.5,volFactor),expErr);
% volFactor
verifyError(testCase,@() calcResults(labelIm,numLabels,NaN),expErr);
verifyError(testCase,@() calcResults(labelIm,numLabels,'number'),expErr);
end