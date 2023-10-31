% test_getLogFile
function tests = getLogFileTest
    tests = functiontests(localfunctions);
end

% Check base case
function testBaseCase(testCase)
scanDir = 'UnitTesting/Test Scan';
actFile = getLogFile(scanDir);
expFile = fullfile(scanDir,'Subject2_Day3.log');
verifyEqual(testCase,actFile,expFile);
end

% What if directory doesn't exist
function testBadDirectory(testCase)
badDir = 'E:/Fake Directory';
expErr = 'getLogFile:InvalidDirectory';
verifyError(testCase,@() getLogFile(badDir),expErr);
verifyError(testCase,@() getLogFile(0),expErr);
end

% What if directory doesn't contain log file
function testNoLogFile(testCase)
badDir = 'UnitTesting/Empty';
expErr = 'getLogFile:NoLogFound';
verifyError(testCase,@() getLogFile(badDir),expErr);
end