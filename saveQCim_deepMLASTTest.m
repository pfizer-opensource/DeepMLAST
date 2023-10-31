% test saveQCim_deepMLAST
function tests = saveQCim_deepMLASTTest
tests = functiontests(localfunctions);
end

% Input checks
function testInvalidDir(testCase)
saveFileName = 'M1';
rawIm = zeros([256,256,100]);
labelIm = zeros([256,256,100]);
expErr = 'saveQCim_deepMLAST:InvalidDirectory';
verifyError(testCase,@() saveQCim_deepMLAST(0,saveFileName,rawIm,labelIm),expErr);
verifyError(testCase,@() saveQCim_deepMLAST('E:/Fake',saveFileName,rawIm,labelIm),expErr);
end

function testInvalidSaveName(testCase)
dirName = 'UnitTesting/Empty';
rawIm = zeros([256,256,100]);
labelIm = zeros([256,256,100]);
expErr = 'saveQCim_deepMLAST:InvalidSaveName';
verifyError(testCase,@() saveQCim_deepMLAST(dirName,0,rawIm,labelIm),expErr);
end

function testInvalidImages(testCase)
saveFileName = 'M1';
dirName = 'UnitTesting/Empty';
rawIm = zeros([256,256,100]);
labelIm = zeros([256,256,100]);
expErr = 'saveQCim_deepMLAST:InvalidInput';
verifyError(testCase,@() saveQCim_deepMLAST(dirName,saveFileName,0,labelIm),expErr);
verifyError(testCase,@() saveQCim_deepMLAST(dirName,saveFileName,rawIm,0),expErr);
end

function testMismatchedImages(testCase)
saveFileName = 'M1';
dirName = 'UnitTesting/Empty';
rawIm = zeros([128,128,100]);
labelIm = zeros([256,256,100]);
expErr = 'saveQCim_deepMLAST:DimensionMismatch';
verifyError(testCase,@() saveQCim_deepMLAST(dirName,saveFileName,rawIm,labelIm),expErr);
end