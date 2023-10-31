% check parseDirName
function tests = parseDirNameTest
tests = functiontests(localfunctions);
end

function testBaseCase(testCase)
parent1 = 'UnitTesting\Test Scan';
parent2 = 'UnitTesting/Test Scan';
dir1 = 'UnitTesting/Test Scan/Group 1/Subject 1/Day 1';
dir2 = 'UnitTesting\Test Scan\Group 1\Subject 1\Day 1';
expOut = 'Group 1_Subject 1_Day 1';
verifyEqual(testCase,parseDirName(dir1,parent1),expOut);
verifyEqual(testCase,parseDirName(dir2,parent2),expOut);
end

function testBadInputs(testCase)
dir1 = 'UnitTesting/Test Scan';
dir2 = 'UnitTesting/Test Scan/Group 1/Subject 1/Day 1';
fakeDir = 'E:/Fake';
expErr = 'parseDirName:InvalidDirectory';
verifyError(testCase,@() parseDirName(dir1,dir2),expErr);
verifyError(testCase,@() parseDirName(NaN,dir2),expErr);
verifyError(testCase,@() parseDirName(dir1,NaN),expErr);
verifyError(testCase,@() parseDirName(fakeDir,dir2),expErr);
verifyError(testCase,@() parseDirName(dir1,fakeDir),expErr);
end