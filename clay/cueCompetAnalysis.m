function [cueCellInd2] = cueCompetAnalysis()




% 1. find cue cells (vs. omit) for each cue
% 2. run avgCueTrigSigNew
% 3. compare avg amplitudes

load(findLatestFilename('cueShiftStruc'));
segDictName = findLatestFilename('segDict');
[refLapType] = findRefLapType(cueShiftStruc);


cueType1 = 'olf';
cueType2 = 'led';
cuePos1 = 500;
cuePos2 = 1150;


%% now shuffle on shift amplitudes

eventName = cueType1;

try
    %if length(numLapType)==3 % if there are 3 lap types (thus shift)
    cueCellInd2 = [];
    for i = 1:length(cueShiftStruc.pksCell)
        try
            % calc avgCueTrigSig for each middle cell
            %         try
            [cueTrigSigStruc] = avgCueTrigSigNew(i, eventName, 0, segDictName); % cueTrigSigStruc.
            % NOTE: need to fix this to do omit pos correctly
            
            %         catch
            %             [cueTrigSigStruc] = avgCueTrigSig(inds(i), eventName, 0);
            %         end
            
            evTrigSigCell = cueTrigSigStruc.evTrigSigCell;
            refLapEvTrigSig = evTrigSigCell{refLapType}; % refLapType
            omitTrigSig = cueTrigSigStruc.omitTrigSig;
            
            % find max event amplitude following cue (minus baseline) for norm laps
            for j=1:size(refLapEvTrigSig,2)
                try
                    cueAmp(j) = max(refLapEvTrigSig(30:130,j)-refLapEvTrigSig(30,j)); % findpeaks(refLapEvTrigSig(30:100,j),'MinPeakDistance', 69)-refLapEvTrigSig(30,j); % max(refLapEvTrigSig(30:130,j)-refLapEvTrigSig(30,j)); % or sum?
                catch
                    cueAmp(j) = 0;
                end
            end
            
            % and omit laps
            for j=1:size(omitTrigSig,2)
                try
                    omitCueAmp(j) = max(omitTrigSig(30:100,j)-omitTrigSig(30,j)); % findpeaks(omitTrigSig(30:100,j),'MinPeakDistance',69)-omitTrigSig(30,j); %  % or sum?
                catch
                    omitCueAmp(j) = 0;
                end
            end
            
            % ttest2 on event amplitudes
            [h,p,ci,stats] = ttest2(cueAmp, omitCueAmp);
            [h2,p,ci,stats] = ttest2(mean(refLapEvTrigSig(50:100,:),1), mean(refLapEvTrigSig(1:30,:),1));
            
            
            if h==1 && h2==1 && mean(cueAmp)>mean(omitCueAmp)
                cueCellInd2 = [cueCellInd2 i];
            end
            
            %         % shuffle
            %         allAmps = [cueAmp omitCueAmp];
            %         for j = 1:100
            %             % resample laps
            %
            %             refLapRes = randsample(length(cueAmp)+length(omitCueAmp), length(cueAmp));
            %             omitLapRes = setdiff(1:(length(cueAmp)+length(omitCueAmp)),refLapRes);
            %
            %             avCueAmpRes(j) = mean(allAmps(refLapRes));
            %             avOmitCueAmpRes(j) = mean(allAmps(omitLapRes));
            %
            %         end
            %
            %         % if cue event amplitudes signif > omit, then add cell to list
            %         avCueAmp(i) = mean(cueAmp); avOmitCueAmp(i) = mean(omitCueAmp);
            %         if length(find(abs(avCueAmpRes-avOmitCueAmpRes)>=abs(avCueAmp(i)-avOmitCueAmp(i))))<=5
            %             cueCellInd2 = [cueCellInd2 inds(i)];
            %         end
        catch
        end
        
    end
catch
end
    
%     % plot
%     if toPlot
%         try
%         figure('Position', [100,150,800,800]);
%         subplot(2,2,1);
%         [sortInd] = plotUnitsByTuning(posRatesRef(cueCellInd2,:), 0, 1);
%         cl = caxis;
%         title('midShiftCell (evAmp shuff) cueLaps');
%         subplot(2,2,3);
%         colormap(jet); imagesc(posRatesShift(cueCellInd2(sortInd),:)); caxis(cl);
%         title('midShiftCell ShiftLaps');
%         subplot(2,2,4);
%         colormap(jet); imagesc(posRatesOmit(cueCellInd2(sortInd),:)); caxis(cl);
%         title('midShiftCell omitLaps');
%         
%         subplot(2,2,2);
%         plot(mean(posRatesRef(cueCellInd2,:),1), 'b');
%         hold on;
%         plot(mean(posRatesOmit(cueCellInd2,:),1), 'r');
%         title('avgs');
%         xlabel('pos');
%         ylabel('mean rate (Hz)');
%         legend('cue laps', 'Shift laps');
%         catch
%         end
%     end
