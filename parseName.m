% Get group name from scan name
function parsed = parseName(names,fields)
% Expects cell for names (ie output of Table.Name)
% Expects either character with single field or cell of multiple fields
[names, fields] = checkArgs(names,fields);

% Set default value to None
parsed = repmat({'None'},height(names),1);
% Parse multiple fields in order
for f = 1:numel(fields)
    field = fields{f};
    for n = 1:numel(names)
        % Break name up by underscores
        name = names{n};
        nameParts = strsplit(name,'_');
        % Search for field in name parts
        itemIdx = find(contains(nameParts,field));
        
        if isempty(itemIdx)
            continue;
        end
        % Identify and save to output
        itemName = nameParts{itemIdx};
        parsed{n} = itemName;
    end
end
end

function [names,fields] = checkArgs(names,fields)
% Check names is nx1 cell
if ~iscell(names) || (numel(size(names)) > 2)
    error('parseName:InvalidInput',...
        'Invalid Input: names must be an n x 1 cell');
end
if size(names,2) ~= 1
    if size(names,1) == 1
        names = names';
    else
        error('parseName:InvalidInput',...
            'Invalid Input: names must be an n x 1 cell');
    end
end

% Check fields is cell
if ~iscell(fields)
    if ischar(fields)
        fields = {fields};
    else
        error('parseName:InvalidInput',...
            'Invalid Input: fields must be a character or a cell');
    end
end
end
