% test writeDeepMLASTlog
function tests = writeDeepMLASTlogTest
tests = functiontests(localfunctions);
end

function testBadInputs(testCase)
% Define valid inputs
fName = 'UnitTesting/Sample.log';
varIn0 = struct;
varIn0.dirName = 'UnitTesting/Test image';
varIn0.saveName = 'Deep MLAST';
varIn0.saveQC = 1;
varIn0.saveFullLabels = 1;
varIn = varIn0;
Name={'Group1_Subject1_Week1';'Group1_Subject1_Week2'};Background=[500;550];
Bone=[300;350];Normal_Thoracic=[150;200];Lung=[250;150];
Extra_Thoracic=[350;400];Heart=[200;250];Tumor=[50;200]; 
Group={'Group1';'Group1'};Subject={'Subject1';'Subject1'};
Time={'Week1';'Week2'};
T = table(Name,Background,Bone,Normal_Thoracic,Lung,Extra_Thoracic,Heart,Tumor,Group,Subject,Time);
T=renamevars(T,{'Normal_Thoracic','Extra_Thoracic'},{'Normal Thoracic','Extra-Thoracic'});
runStat = struct; runStat.errMsg=''; runStat.status='Successful';
analysisTime=100;
% Expected error
expErr = 'writeDeepMLASTlog:InvalidInput';
%fName
verifyError(testCase,@() writeDeepMLASTlog(NaN,varIn,T,runStat,analysisTime),expErr);
verifyError(testCase,@() writeDeepMLASTlog('File.xlsx',varIn,T,runStat,analysisTime),expErr);
% varIn
varIn.dirName = NaN;
verifyError(testCase,@() writeDeepMLASTlog(fName,varIn,T,runStat,analysisTime),expErr);
varIn = varIn0; varIn.saveName = NaN;
verifyError(testCase,@() writeDeepMLASTlog(fName,varIn,T,runStat,analysisTime),expErr);
varIn = varIn0; varIn.saveQC = NaN;
verifyError(testCase,@() writeDeepMLASTlog(fName,varIn,T,runStat,analysisTime),expErr);
varIn.saveQC = 2;
verifyError(testCase,@() writeDeepMLASTlog(fName,varIn,T,runStat,analysisTime),expErr);
varIn = varIn0; varIn.saveFullLabels = NaN;
verifyError(testCase,@() writeDeepMLASTlog(fName,varIn,T,runStat,analysisTime),expErr);
varIn.saveFullLabels = 2;
verifyError(testCase,@() writeDeepMLASTlog(fName,varIn,T,runStat,analysisTime),expErr);
% runStat
runStat = 'Success';
verifyError(testCase,@() writeDeepMLASTlog(fName,varIn,T,runStat,analysisTime),expErr);
runStat = struct;
verifyError(testCase,@() writeDeepMLASTlog(fName,varIn,T,runStat,analysisTime),expErr);
runStat.errMsg = NaN; runStat.status = 'Successful';
verifyError(testCase,@() writeDeepMLASTlog(fName,varIn,T,runStat,analysisTime),expErr);
runStat.status = NaN; runStat.errMsg = 'No Error';
verifyError(testCase,@() writeDeepMLASTlog(fName,varIn,T,runStat,analysisTime),expErr);
runStat.status = 0; 
verifyError(testCase,@() writeDeepMLASTlog(fName,varIn,T,runStat,analysisTime),expErr);
runStat.status = 'Success'; runStat.errMsg = 0;
verifyError(testCase,@() writeDeepMLASTlog(fName,varIn,T,runStat,analysisTime),expErr);
end