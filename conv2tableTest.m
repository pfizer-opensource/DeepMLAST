% test conv2table
function tests = conv2tableTest
tests = functiontests(localfunctions);
end

% Test base case
function testBaseCase(testCase)
X = {'Group1_Subject1_Week1',500,300,150,250,350,200,50;...
    'Group1_Subject1_Week2',550,350,200,150,400,250,200;...
    'Baseline_Subject2_Baseline',501,301,151,251,351,201,51;...
    'Group 2_Subject 3_Week 3',499,299,149,249,349,199,49};
Name={'Group1_Subject1_Week1';'Group1_Subject1_Week2';...
    'Baseline_Subject2_Baseline';'Group 2_Subject 3_Week 3'};
Background=[500;550;501;499];Bone=[300;350;301;299];
Normal_Thoracic=[150;200;151;149];Lung=[250;150;251;249];
Extra_Thoracic=[350;400;351;349];Heart=[200;250;201;199];Tumor=[50;200;51;49];
Group={'Group1';'Group1';'Baseline';'Group 2'};
Subject={'Subject1';'Subject1';'Subject2';'Subject 3'};
Time={'Week1';'Week2';'Baseline';'Week 3'};
expOut = table(Name,Background,Bone,Normal_Thoracic,Lung,Extra_Thoracic,Heart,Tumor,Group,Subject,Time);
expOut=renamevars(expOut,{'Normal_Thoracic','Extra_Thoracic'},{'Normal Thoracic','Extra-Thoracic'});

verifyEqual(testCase,conv2table(X),expOut);
end

% Input checks
function testBadInputs(testCase)
expErr = 'conv2table:InvalidInput';
verifyError(testCase,@() conv2table(zeros(10)),expErr);
verifyError(testCase,@() conv2table(cell([10,7])),expErr);
verifyError(testCase,@() conv2table(cell([10,8,2])),expErr);
end