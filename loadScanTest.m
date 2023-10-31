% test loadScan
function tests = loadScanTest
tests = functiontests(localfunctions);
end

% Not sure how to test base case since file loading is kinda large. Will
% simply test errors for now

function testInvalidDirectory(testCase)
fList = {'E:/Fake/scan1.tif'};
fType = '.tif';
expErr = 'loadScan:InvalidDirectory';
verifyError(testCase,@() loadScan('E:/Fake',fList,fType),expErr);
verifyError(testCase,@() loadScan(0,fList,fType),expErr);
end

function testInvalidFileList(testCase)
fLoc = 'UnitTesting/Test Scan';
fType = '.tif';
expErr = 'loadScan:InvalidFileList';
verifyError(testCase,@() loadScan(fLoc,0,fType),expErr);
verifyError(testCase,@() loadScan(fLoc,{},fType),expErr);
end

function testInvalidFileType(testCase)
fLoc = 'UnitTesting/Test Scan';
fList = {'Subject2_Day3_rec00000267.tif';'Subject2_Day3_rec00000268.tif'};
expErr = 'loadScan:InvalidFileType';
verifyError(testCase,@() loadScan(fLoc,fList,0),expErr);
verifyError(testCase,@() loadScan(fLoc,fList,'pdf'),expErr);
end