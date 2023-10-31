% test ScanInfo.m
function tests = scanInfoTest
tests = functiontests(localfunctions);
end

% test base case
function testBaseCase(testCase)
scanDir = 'UnitTesting/Test Scan';
[imgList, mNum, scanDate, fType] = scanInfo(scanDir);
verifyEqual(testCase,mNum,scanDir);
verifyEqual(testCase,scanDate,'DD-Mon-YYYY 00:00:00');
verifyEqual(testCase,fType,'.tif');
verifyEqual(testCase,numel(imgList),237)
end

% what if directory doesn't exist?
function testInvalidDirectory(testCase)
badDir = 'E:/Fake';
expErr = 'scanInfo:InvalidDirectory';
verifyError(testCase,@() scanInfo(badDir),expErr);
verifyError(testCase,@() scanInfo(0),expErr);
end

% what if provided list of scan directories is bad
function testInvalidInput(testCase)
scanDir = 'UnitTesting/Test Scan';
expErr = 'scanInfo:InvalidInput';
verifyError(testCase,@() scanInfo(scanDir,0),expErr);
end

% test mutliple file types
function testMultipleFileTypes(testCase)
scanDir = 'UnitTesting/Multiple image types';
expWarn = 'scanInfo:MultipleFileTypes';
verifyWarning(testCase,@() scanInfo(scanDir),expWarn)
end

% test no images found
function testNoFilesFound(testCase)
scanDir = 'UnitTesting';
expErr = 'scanInfo:NoFilesFound';
verifyError(testCase,@() scanInfo(scanDir),expErr);
end