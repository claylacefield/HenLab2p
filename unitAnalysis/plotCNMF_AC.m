function plotCNMF_AC(A, C,d1,d2, toPlotAll, varargin)

%% USAGE: 

if length(varargin)==1
    goodSeg = varargin{1};
    A = A(:,goodSeg);
    C = C(goodSeg,:);
end

K = size(C,1);

if toPlotAll == 1
    if K > 25
        numPlots = ceil(K/25);
    else
        numPlots = 1;
    end
    
    for j = 1:numPlots
        
        figure;  % plot spatial components
        title([num2str((j-1)*25+1) ' to ' num2str((j-1)*25)]);
        
        for i = 1:25%max(K,25)
            
            
            try
                subplot(5,5,i); imagesc(reshape(A(:,((j-1)*25+i)),d1,d2)); axis equal; axis tight;
            catch
            end
            
            %         if i == 1
            %            title(['K = ' num2str(K) ' , beta = ' num2str(beta)]);
            %         end
            
        end
        
        figure;  % plot temporal components
        for i = 1:25%max(K,25)
            try
                subplot(5,5,i); plot(C((j-1)*25+i,:));
            catch
            end
        end
        
    end
    
end

%% Now plot all units together

C = C'; A=A';

% spatial
allSegIm = zeros(d1,d2);
for seg = 1:K
    allSegIm = allSegIm + reshape(A(seg,:),d1,d2);
end
figure; imagesc(allSegIm); hold on;

for seg = 1:K
    spat = A(seg,:);
    [pk, ind] = max(spat(:));
    [y,x] = ind2sub([d1 d2],ind);
    text(x,y, sprintf('%d', seg), 'Units', 'data');
end
%title(filename);

% timecourse

for seg = 1:K
    [val, ind] = max(C(:,seg));
    maxVal(seg) = val;
    maxInd(seg) = ind;
end

[vals, ord]= sort(maxInd);

C2 = C(:,ord);

scaleFact = 3;
figure; hold on;
for seg = 1:K
    plot(scaleFact*(C2(:,seg)/max(C2(:,seg)))+seg);
end
%title(filename);
avUnitCa = mean(C,2);
plot(20*avUnitCa/max(avUnitCa)-20, 'b');

%plot((frAv-min(frAv))*400-6, 'r');


