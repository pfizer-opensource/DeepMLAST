% test write2Excel
function tests = write2ExcelTest
tests = functiontests(localfunctions);
end

% Input checks
function testsBadInputs(testCase)
fName = 'UnitTesting/WriteTest';
Name={'Group1_Subject1_Week1';'Group1_Subject1_Week2'};Background=[500;550];
Bone=[300;350];Normal_Thoracic=[150;200];Lung=[250;150];
Extra_Thoracic=[350;400];Heart=[200;250];Tumor=[50;200];
Group={'Group1';'Group1'};Subject={'Subject1';'Subject1'};
Time={'Week1';'Week2'};
T = table(Name,Background,Bone,Normal_Thoracic,Lung,Extra_Thoracic,Heart,Tumor,Group,Subject,Time);
T=renamevars(T,{'Normal_Thoracic','Extra_Thoracic'},{'Normal Thoracic','Extra-Thoracic'});
saveVars = {'Lung','Tumor'};
expErr = 'write2Excel:InvalidInput';
% fName
verifyError(testCase,@() write2Excel(NaN,T,saveVars),expErr);
verifyError(testCase,@() write2Excel(0,T,saveVars),expErr);
% T
verifyError(testCase,@() write2Excel(fName,NaN,saveVars),expErr);
verifyError(testCase,@() write2Excel(fName,'table',saveVars),expErr);
% saveVars
verifyError(testCase,@() write2Excel(fName,T,'Tumor'),expErr);
verifyError(testCase,@() write2Excel(fName,T,NaN),expErr);
end