function wrapCueTaskTuning()


%% USAGE: wrapCueTaskTuning();
% Clay 101818
% For a given cue task folder, plot the place cell tuning for normal cue
% and cue shift laps (but needs to have goodSeg already chosen)

load(findLatestFilename('_goodSeg_'));

[treadBehStruc] = procHen2pBehav('auto', 'cue');

[unitTuningStruc] = wrapTuningNewClay(pksCell(goodSeg), 15, 1, 0);

plotLapTypeTuning(unitTuningStruc, treadBehStruc, goodSeg, 1, 3);