function [cueTypes] = findCueTypes(treadBehStruc)

% Takes treadBehStruc and gives cell array of cueTypes

fields = fieldnames(treadBehStruc);

cueTypes = {}; olf = 0; tone = 0; led = 0; tact = 0;
for i=1:length(fields)
    if contains(fields{i}, 'olf') && olf==0 && ~isempty(treadBehStruc.(fields{i}))
        olf = 1;
        cueTypes = [cueTypes 'olf'];
    elseif contains(fields{i}, 'tone') && tone==0 && ~isempty(treadBehStruc.(fields{i}))
        tone = 1;
        cueTypes = [cueTypes 'tone'];
    elseif contains(fields{i}, 'led') && led==0 && ~isempty(treadBehStruc.(fields{i}))
        led = 1;
        cueTypes = [cueTypes 'led'];
    elseif contains(fields{i}, 'tact') && tact==0 && ~isempty(treadBehStruc.(fields{i}))
        tact = 1;
        cueTypes = [cueTypes 'tact'];
    end
end












