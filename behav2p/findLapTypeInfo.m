function findLapTypeInfo(settingsString)

% Clay 2020
% Construct lapTypeInfo from settings string


info = jsondecode(settingsString); % NEW read JSON settings string
%syncPin = info.settings.sync_pin; % read sync pin

% read info about contexts
contexts = info.settings.contexts;
for ctx = 1:length(contexts)
    id = contexts{ctx}.id;
    idCell{ctx,1} = id;
end

% drop "dummy" context?
% (sometimes blank context necessary for BeMate to work correctly)


% contextStruc (but errors if some fields missing)
n=0;
for ctx = 1:length(contexts)
    try; repeat = info.settings.contexts{ctx}.decorators.repeat; %catch; contextStruc(ctx).repeat = []; end
        n=n+1;
        contextStruc(n).name = contexts{ctx}.id;
    try; contextStruc(n).pin = info.settings.contexts{ctx}.valves; catch; contextStruc(ctx).pin = []; end
    try; contextStruc(n).lapList = info.settings.contexts{ctx}.decorators.lap_list; catch; contextStruc(ctx).lapList = []; end
    try; contextStruc(n).repeat = info.settings.contexts{ctx}.decorators.repeat; catch; contextStruc(ctx).repeat = []; end
    try; contextStruc(n).locations = info.settings.contexts{ctx}.locations; catch; contextStruc(ctx).locations = []; end
    try; contextStruc(n).duration = info.settings.contexts{ctx}.durations; catch; contextStruc(ctx).duration = []; end
    try; contextStruc(n).radius = info.settings.contexts{ctx}.radius; catch; contextStruc(ctx).radius = []; end
    try; contextStruc(n).freq = info.settings.contexts{ctx}.frequency; catch; contextStruc(ctx).freq = []; end
%     contextStruc(ctx).startTimes = []; contextStruc(ctx).startPos = [];
%     contextStruc(ctx).endTimes = []; contextStruc(ctx).endPos = [];
    catch
    end
end
%settingsString.contextStruc = contextStruc;

 = [contextStruc.locations];

% construct lap pattern from settings
repeatArr = [contextStruc.repeat];
%repeat = contextStruc(2).repeat;
lapListCell = {contextStruc.lapList};
cuePosLap = zeros(ctx,contextStruc(2).repeat);
%lapContextArr = zeros(ctx,contextStruc(2).repeat);
n=0;
for ctx=1:length(lapListCell)
    if ~isempty(lapListCell{ctx})
        n = n +1;
        repeat = contextStruc(ctx).repeat;
        lapList = lapListCell{ctx};
        lapContextArr(n,1:repeat) = 0;
        lapContextArr(n,lapList+1) = 1;
    end
end