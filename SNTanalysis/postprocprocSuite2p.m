

%%load temporal factor
F = readNPY('F.npy');
isCell = readNPY('iscell.npy');
C = [];
C = F(isCell(:, 1) == 1, :);

%% downsample by 2 and filter C


CIn={};
for i = 1:size(C,1)
    CIn{i} = C(i,:);
end

parfor i=1:length(CIn)
    COut{i} = wden(double(CIn{i}), 'modwtsqtwolog', 's', 'mln', 5, 'sym4');
end
Csm=[];
for i = 1:length(CIn)
    Csm=[Csm; COut{i}];
end
Csm = single(Csm);

Cds=[];

for i = 1:size(Csm,1)
    Cds = [Cds; downsample(Csm(i,:),2)];
end


%% get transients
pksCell={};
for seg = 1:size(Cds,1)
pksCell{seg} = clayCaTransients(Cds(seg,:), 15);
end