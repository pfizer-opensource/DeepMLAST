% Function to write log file every time Deep MLAST app run
function writeDeepMLASTlog(fName,varIn,T,runStat,analysisTime)
checkArgs(fName,varIn,T,runStat,analysisTime)

% Get other info
D = datetime('now','TimeZone','local');
analysisTime = num2str(round(analysisTime/60,2));
compName = getenv('computername');
userName = getenv('username');
numScans = num2str(height(T));
numTimepoints = num2str(numel(unique(T.Time)));
numAnimals = num2str(numel(unique(T.Subject)));
numGroups = num2str(numel(unique(T.Group)));

% Open file
fid = fopen(fName,'a');

% Write header to separate from previous runs
fprintf(fid,'\r\n'); fprintf(fid,'\r\n'); fprintf(fid,'\r\n');
fprintf(fid,'%c','---------------------------------------'); fprintf(fid,'\r\n');
fprintf(fid,'%c',['Analysis run on ' datestr(D)]); fprintf(fid,'\r\n');
fprintf(fid,'%c','---------------------------------------'); fprintf(fid,'\r\n');
fprintf(fid,'%c','Analysis Parameters:'); fprintf(fid,'\r\n');

% Write info
fprintf(fid,'%c',['Study Directory = ' varIn.dirName]); fprintf(fid,'\r\n');
fprintf(fid,'%c',['User = ' userName]); fprintf(fid,'\r\n');
fprintf(fid,'%c',['Computer = ' compName]); fprintf(fid,'\r\n');
fprintf(fid,'%c',['TimeZone = ' D.TimeZone]); fprintf(fid,'\r\n');
fprintf(fid,'%c',['Number of Scans analyzed = ' numScans]); fprintf(fid,'\r\n');
fprintf(fid,'%c',['Number of Subjects analyzed = ' numAnimals]); fprintf(fid,'\r\n');
fprintf(fid,'%c',['Number of Groups analyzed = ' numGroups]); fprintf(fid,'\r\n');
fprintf(fid,'%c',['Number of Timepoints analyzed = ' numTimepoints]); fprintf(fid,'\r\n');
fprintf(fid,'%c',['Time to Analyze = ' analysisTime ' minutes']); fprintf(fid,'\r\n');
fprintf(fid,'%c',['Save Name = ' varIn.saveName]); fprintf(fid,'\r\n');
fprintf(fid,'%c',['Save QC = ' parseBinary(varIn.saveQC)]); fprintf(fid,'\r\n');
fprintf(fid,'%c',['Save Full Labels = ' parseBinary(varIn.saveFullLabels)]); fprintf(fid,'\r\n');

% Report Run Status
fprintf(fid,'%c',['Run Status: ' runStat.status ' ' runStat.errMsg]); fprintf(fid,'\r\n');

% Save and close text file
fclose(fid);
end

function out = parseBinary(in)
if in
    out  = 'Yes';
else
    out = 'No';
end
end

function checkArgs(fName,varIn,T,runStat,analysisTime)
% --- fName ---
if ~ischar(fName) || ~strcmp(fName(end-3:end),'.txt')
    error('writeDeepMLASTlog:InvalidInput',...
        'Invalid Input: fName must be the name of a text file');
end
% --- varIn ---
% dirName
if ~isfield(varIn,'dirName')
    error('writeDeepMLASTlog:InvalidInput',...
        'Invalid Input: varIn must contain a field called dirName');
elseif ~ischar(varIn.dirName)
        error('writeDeepMLASTlog:InvalidInput',...
        'Invalid Input: varIn.dirName must be a character');
end
% saveName
if ~isfield(varIn,'saveName')
    error('writeDeepMLASTlog:InvalidInput',...
        'Invalid Input: varIn must contain a field called saveName');
elseif ~ischar(varIn.saveName)
        error('writeDeepMLASTlog:InvalidInput',...
        'Invalid Input: varIn.saveName must be a character');
end
% saveQC
if ~isfield(varIn,'saveQC')
    error('writeDeepMLASTlog:InvalidInput',...
        'Invalid Input: varIn must contain a field called saveQC');
elseif isnan(varIn.saveQC) || (~(islogical(varIn.saveQC) || varIn.saveQC==0 || varIn.saveQC==1))
        error('writeDeepMLASTlog:InvalidInput',...
        'Invalid Input: varIn.saveQC must be logical (or 0 or 1)');
end
% saveFullLabels
if ~isfield(varIn,'saveFullLabels')
    error('writeDeepMLASTlog:InvalidInput',...
        'Invalid Input: varIn must contain a field called saveFullLabels');
elseif isnan(varIn.saveFullLabels) || (~(islogical(varIn.saveFullLabels) || varIn.saveFullLabels==0 || varIn.saveFullLabels==1))
        error('writeDeepMLASTlog:InvalidInput',...
        'Invalid Input: varIn.saveFullLabels must be logical (or 0 or 1)');
end
% --- T ---
if ~istable(T) || ~max(strcmp('Time',T.Properties.VariableNames)) || ~max(strcmp('Group',T.Properties.VariableNames)) || ~max(strcmp('Subject',T.Properties.VariableNames))
    error('writeDeepMLASTlog:InvalidInput',...
        'Invalid Input: T must be a table with columns Group, Subject, and Time');
end

% --- runStat ---
if (~isstruct(runStat)) || (~isfield(runStat,'status')) || (~isfield(runStat,'errMsg'))
    error('writeDeepMLASTlog:InvalidInput',...
        'Invalid Input: runStat must be a structure with fields "status" and "errMsg"');
end
if (~ischar(runStat.status))
    error('writeDeepMLASTlog:InvalidInput',...
        "Invalid Input: runStat's 'status' field must be a character");
end
if (~ischar(runStat.errMsg))
    error('writeDeepMLASTlog:InvalidInput',...
        "Invalid Input: runStat's 'errMsg' field must be a character");
end

% --- Analysis Time ---
if ~isnumeric(analysisTime)
    error('writeDeepMLASTlog:InvalidInput',...
        'Invalid Input: analysisTime must be numeric');
end
end
