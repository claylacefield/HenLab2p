function plotSpatialByTuningColor(A, C, d1, d2, posRates, goodSeg, varargin);

%% USAGE: plotSpatialByTuningColor(A, C, d1, d2, posRates, goodSeg, varargin);

% Clay 2018
% plot spatial profiles of place cells based upon their tuning (posRates)
% NOTE: posRates has to be from goodSeg

% take subset of goodSegs (like PCs, etc.)
if nargin == 7
    goodSegSubset = varargin{1};
else
    goodSegSubset = 1:length(goodSeg);
end

% orig C/A ind of goodSeg subset
origCAinds = goodSeg(goodSegSubset);

% Sort cells based upon tuning position
posRates = posRates(goodSegSubset,:); % posRates for goodSeg subset (not sorted)
[maxRates, maxRatePos] = max(posRates,[],2); % rate peak and position (inds)
[sortedPFpeakPos, sortInds] = sort(maxRatePos); % indices of goodSegSubset, sorted by tuning

origCAindsSort = origCAinds(sortInds); % and keep track of their original indices

%% Now find spatial and temporal profiles of these cells (sorted by tuning pos)

gsA = A(:,origCAindsSort); % goodSeg subset spatial/A (sorted)
gsC = C(origCAindsSort, :); gsC = gsC/max(gsC(:)); % temporal
numCells = length(origCAindsSort); % numCells

gsA2 = reshape(full(gsA),d1,d2,numCells); % reshaped spatial for all cells

%% Plot color rgb components based upon tuning pos

%color = jet(numCells);
color = autumn(size(posRates,2));
rgb = zeros(d1,d2,3); % initialize final color matrix (mxnx3)

for i = 1:numCells
    segSpat = gsA2(:,:,i); % single seg spatial (sorted)
    segSpat = segSpat/max(segSpat(:)); % normalize
    ga3(:,:,i) = segSpat; % not used?
    
    % make RGB color matrix for each cell (now sorted by tuning)
    for j = 1:3
    segRgb(:,:,j) = segSpat*color(sortedPFpeakPos(i),j);
    end
    
    rgb = rgb + segRgb; % and add to total RGB
    
    gc2(i,:) = gsC(i,:)/max(gsC(i,:)); % and just normalize temporal
    
end

%% PLOT
figure; 
subplot(1,2,1); 
image(rgb);

subplot(1,2,2);
imagesc(posRates(sortInds,:));
