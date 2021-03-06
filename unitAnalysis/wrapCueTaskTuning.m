function wrapCueTaskTuning(varargin)


%% USAGE: wrapCueTaskTuning();
% Clay 101818
% For a given cue task folder, plot the place cell tuning for normal cue
% and cue shift laps (but needs to have goodSeg already chosen)



load(findLatestFilename('_goodSeg_'));

[treadBehStruc] = procHen2pBehav('auto', 'cue');

if nargin>0
    unitTuningStruc = varargin{1};
else
    [unitTuningStruc] = wrapTuningNewClay(pksCell(goodSeg), 15, 1, 0);
end


plotLapTypeTuning(unitTuningStruc, treadBehStruc, goodSeg, 1, 3);