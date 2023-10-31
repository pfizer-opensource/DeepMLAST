% test writeImgStack
function tests = writeImgStackTest
tests = functiontests(localfunctions);
end

% Input tests
function testValidImage(testCase)
fileName = 'M1';
savePath = 'UnitTesting/WriteTest';
imType = '.bmp';
expErr = 'writeImgStack:InvalidInput';
verifyError(testCase,@() writeImgStack('image',fileName,savePath,imType),expErr);
verifyError(testCase,@() writeImgStack(zeros([256,256]),fileName,savePath,imType),expErr);
end

function testValidFileName(testCase)
im = zeros([256,256,100]);
savePath = 'UnitTesting/WriteTest';
imType = '.bmp';
expErr = 'writeImgStack:InvalidFileName';
verifyError(testCase,@() writeImgStack(im,0,savePath,imType),expErr);
end

function testValidSavePath(testCase)
im = zeros([256,256,100]);
fileName = 'M1';
imType = '.bmp';
expErr = 'writeImgStack:InvalidDirectory';
verifyError(testCase,@() writeImgStack(im,fileName,0,imType),expErr);
verifyError(testCase,@() writeImgStack(im,fileName,'E:/Fake',imType),expErr);
end
