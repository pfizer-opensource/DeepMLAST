% Unit tests for readLogFile.m
function tests = readLogFileTest
tests = functiontests(localfunctions);
end

% Test base case(s)
function testBaseCase(testCase)
fName = 'UnitTesting/Sample.log';
expDat = 'SkyScan1278';
verifyEqual(testCase,readLogFile(fName,'Scanner','InstrumentS/N'),expDat);
% should ignore "="
verifyEqual(testCase,readLogFile(fName,'Scanner=','InstrumentS/N='),expDat);
% should ignore spaces
verifyEqual(testCase,readLogFile(fName,'Scanner','Instrument S/N'),expDat);
end

% Test study date and time
function testDateCase(testCase)
fName = 'UnitTesting/Sample.log';
flag1 = 'StudyDateandTime';
flag2 = 'Scanduration';
expDate = 'DD-Mon-YYYY 00:00:00';
actDate = readLogFile(fName,flag1,flag2);
verifyEqual(testCase,actDate,expDate);
end

% What if file doesn't exist
function testInvalidFile(testCase)
fName = 'E:/fake_file.log';
expErr = 'readLogFile:InvalidFile';
verifyError(testCase,@() readLogFile(fName,'',''),expErr);
verifyError(testCase,@() readLogFile(0,'',''),expErr);
end

% What if file doesn't exist
function testInvalidFlags(testCase)
fName = 'UnitTesting/Sample.log';
expErr = 'readLogFile:InvalidFlag';
verifyError(testCase,@() readLogFile(fName,0,'fake'),expErr);
verifyError(testCase,@() readLogFile(fName,'fake',0),expErr);
end

% What if the flag isn't in the text
function testFlagNotFound(testCase)
fName = 'UnitTesting/Sample.log';
flag1 = 'Scanner';
flag2 = 'Instrument S/N';
expErr = 'readLogFile:FlagNotFound';
verifyError(testCase,@() readLogFile(fName,'BadFlag',flag2),expErr);
verifyError(testCase,@() readLogFile(fName,flag1,'BadFlag'),expErr);
end