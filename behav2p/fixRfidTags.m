function [rfidPosCell, rfidTimeCell, rfidListCell] = fixRfidTags(treadBehStruc)

% Clay 2020
% Fix RFID reads (mostly from context task sessions)
% Sometimes certain tags don't get read on some laps, so estimate their
% time from pos 
%
% 051320: I was previously going to fill in the RFID tags that were missed
% (and eliminate double reads), however I think I should just find the
% typical positions of the tags and then just estimate when they should
% encounter each of these tags on each lap based upon these positions and the pos array
% BUT crap, lots of the context data is freely running, so there are a lot
% of problems with the position readings. So now modified to fixPos2 in
% order to fix this.
%
% In free running data there are often periods of non-running around cues,
% so I don't know if I want to choose the period at the beginning or end of
% this, in case an event falls around here.
% Wait, maybe I should just take the posRates at these positions, because
% these are already corrected for movement.
%

% find lap RFID tag string
settingsString = treadBehStruc.settingsString;
lapTagSet = strfind(settingsString, "lap_reset_tag");
lapTagString= settingsString(lapTagSet+17:lapTagSet+28); % lap tag, e.g. '7F001B633235'
tagLength = length(lapTagString); % usu 12 char in tags
tagList = {lapTagString};


% extract pos and frTimes
frTimes = treadBehStruc.adjFrTimes;
pos = treadBehStruc.resampY;

% fix pos (this new version seems to work pretty well with test data)
pos = fixPos2(pos);

% current RFID info in treadBehStruc
rfidName = treadBehStruc.rfidName;
rfidTime = treadBehStruc.rfidTime;
rfidPos = treadBehStruc.rfidPos;
rfidLap = treadBehStruc.rfidLap;

% find lap tags in list
lapTagInds = find(contains(rfidName, lapTagString));

dLapInds = diff(lapTagInds); % # tags between lap tags
[N,edges,bin] = histcounts(dLapInds, [1,2,3,4,5,6]); % hist num RFID tags between lap tags

maxNumRfidTags = edges(max(find(N~=0))); % most RFID tags/lap (but could be double reads)
[val, ind] = max(N);
mostRfidTags = edges(ind); % most frequent # RFID tags/lap (most likely lap pattern)

goodLaps = find(dLapInds==mostRfidTags); % "laps" with good(?) RFID reads
firstGoodLapRfidInds = lapTagInds(goodLaps(1)):lapTagInds(goodLaps(1)+1)-1; % rfid inds of first good lap
goodLapRfidTags = rfidName(firstGoodLapRfidInds); % and their names

% find all unique tags, starting with lap tag (but might not be in correct
% order)
for i = 1:length(rfidName)
    tag = rfidName{i};
    if ~strcmp(tagList, tag)
        tagList = [tagList tag];
    end
end
rfidListCell = tagList;

rfidPosCell = cell(length(tagList),1);
for i=1:length(rfidName)
    tag = rfidName{i};
    whichRfid = find(strcmp(tagList, tag));
    
    rfidPosCell{whichRfid} = [rfidPosCell{whichRfid} rfidPos(i)]; % for each rfid tag/read, find pos for this type

end

% find avg pos for each tag
for i=1:length(tagList)
    tagPos = rfidPosCell{i};
    [N, edges, bin] = histcounts(tagPos);
    [val, ind] = max(N);
    mostFreqPos(i) = mean(tagPos(bin==ind));
end


% find laps, look thru pos for each lap, and estimate rfid tag position
% based upon avg pos.

[lapFrInds, lapEpochs] = findLaps(pos);

for i=1:size(lapEpochs,1)
    
end


% % make list of most probable order of all tags (unique)
% startTag = 0;
% for i = 1:length(rfidName)
%     if startTag==0 && strcmp(rfidName{i}, lapTagString)
%         firstLapInd = i;
%         startTag = 1;
%     end
%         
%     if startTag==1
%         if strcmp(rfidName{i}, lapTagString)
%             newLap = 1;
%         end
%     end
% end








