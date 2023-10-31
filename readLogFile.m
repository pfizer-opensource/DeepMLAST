% Function to read data from a log file using flag (text before =)
function dat = readLogFile(fileName,flag1,flag2)

% Check inputs
checkVars(fileName,flag1,flag2);

% Read text file
fid = fopen(fileName,'r');
formatSpec = '%s';
rawTxt = fscanf(fid,formatSpec);
fclose(fid);

% Remove equals sign & spaces from flags
flag1 = strrep(strrep(flag1,'=',''),' ','');
flag2 = strrep(strrep(flag2,'=',''),' ','');

% Check flag in text
for f = 1:2
    switch f
        case 1
            flag = flag1;
        case 2
            flag = flag2;
    end
    if ~contains(rawTxt,flag)
        error('readLogFile:FlagNotFound',['Incorrect pattern match. Flag "' flag '" not found in file text']);
    end
end

% Parse scan info
idx1 = strfind(rawTxt,flag1);
idx2 = strfind(rawTxt,flag2);
dat = rawTxt(idx1+length(flag1)+1:idx2-1);

% If date, reformat
if strcmp(flag1,'StudyDateandTime')
    dat = insertAfter(dat,2,'-');
    dat = insertAfter(dat,6,'-');
    dat = insertAfter(dat,11,' ');
    dat(15) = '';
    dat(18) = '';
    dat(end) = '';
end
end

function checkVars(fileName,flag1,flag2)
checkFile(fileName,'readLogFile');
if ~(ischar(flag1))
    error('readLogFile:InvalidFlag',['Invalid flag: please enter a character for flag1']);
end
if ~(ischar(flag2))
    error('readLogFile:InvalidFlag',['Invalid flag: please enter a character for flag2']);
end
end