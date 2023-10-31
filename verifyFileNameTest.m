% test verifyFileName
function tests = verifyFileNameTest
tests = functiontests(localfunctions);
end

function testBadInputs(testCase)
verifyError(testCase,@() verifyFileName(NaN),'verifyFileName:InvalidInput');
end

function testValidName(testCase)
fileName = 'UnitTesting/Test Scan/Subject2_Day3_rec00000267.tif';
verifyEqual(testCase,verifyFileName(fileName),fileName);
end

function testLongName(testCase)
fileName = 'UnitTesting/Long Name Testing/Looooooooooooooooooooooooooooooooooooooooooooooooooong File Path/Looooooooooooooooooooooooooooooong/This is my very long file name it is over two hundred and sixty characters can you believe it – it is ar difficult to make a file name this long.tif';
nameOut = 'UnitTesting/Long Name Testing/Looooooooooooooooooooooooooooooooooooooooooooooooooong File Path/Looooooooooooooooooooooooooooooong/g file name it is over two hundred and sixty characters can you believe it – it is ar difficult to make a file name this long.tif';
verifyEqual(testCase,verifyFileName(fileName),nameOut);
end

function testLongPath(testCase)
fileName = 'UnitTesting/Long Name Testing/Looooooooooooooooooooooooooooooooooooooooooooooooooong File Path/Loooooooooooooooooooooong Looooooooooooooooooooooooooooong Looooooooooooong Loooooooooooooooooooooooooooooooooooong Looooooooooooooooooooooong Loooooooooooooooooooooooooooooooooooooong File Path/FileName.txt';
verifyError(testCase,@() verifyFileName(fileName),'verifyFileName:PathTooLong');
end

function testSpecCharName(testCase)
fileName = 'UnitTesting/Long Name Testing/Looooooooooooooooooooooooooooooooooooooooooooooooooong File Path/Looooooooooooooooooooooooooooooong/This is my very #*!)@(#$^)**)))_long name it is over two hundred and sixty characters can you believe it – it is actually difficult to make a file name this long.tif';
nameOut = 'UnitTesting/Long Name Testing/Looooooooooooooooooooooooooooooooooooooooooooooooooong File Path/Looooooooooooooooooooooooooooooong/name it is over two hundred and sixty characters can you believe it – it is actually difficult to make a file name this long.tif';
verifyEqual(testCase,verifyFileName(fileName),nameOut);
end