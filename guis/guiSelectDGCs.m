function varargout = guiSelectDGCs(varargin)
% GUISELECTDGCS MATLAB code for guiSelectDGCs.fig
%      GUISELECTDGCS, by itself, creates a new GUISELECTDGCS or raises the existing
%      singleton*.
%
%      H = GUISELECTDGCS returns the handle to a new GUISELECTDGCS or the handle to
%      the existing singleton*.
%
%      GUISELECTDGCS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUISELECTDGCS.M with the given input arguments.
%
%      GUISELECTDGCS('Property','Value',...) creates a new GUISELECTDGCS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiSelectDGCs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiSelectDGCs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiSelectDGCs

% Last Modified by GUIDE v2.5 16-Mar-2018 13:05:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiSelectDGCs_OpeningFcn, ...
                   'gui_OutputFcn',  @guiSelectDGCs_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before guiSelectDGCs is made visible.
function guiSelectDGCs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiSelectDGCs (see VARARGIN)

% Choose default command line output for guiSelectDGCs
handles.output = hObject;

handles.goodSeg = [];
handles.greatSeg = [];
handles.plotPos = 0;
handles.plotVel = 0;
handles.plotDff = 0;
handles.sdThresh = 6;
handles.plotPks = 0;
handles.pksCell = {};
handles.plotTuning = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiSelectDGCs wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiSelectDGCs_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in loadDataButton.
function loadDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[file, path] = uigetfile('*.mat');
cd(path);
load([path file]);
handles.file = file;
handles.path = path;

try
load(findLatestFilename('treadBehStruc'));
catch
    disp('Cant find treadBehStruc file so calculating');
    [treadBehStruc] = procHen2pBehav(1);
end
treadPos = treadBehStruc.resampY(1:2:end);

C = C/max(C(:));

handles.C = C;
handles.A = A;
handles.d1 = d1;
handles.d2 = d2;
handles.treadBehStruc = treadBehStruc;

vel = fixVel(treadBehStruc.vel(1:2:end));
vel = vel/max(vel(:));
handles.vel = vel;

treadPos = treadPos/max(treadPos(:));
handles.treadPos = treadPos; 
%handles.

try
    dff = dff/max(dff(:));
    handles.dff = dff;
catch
    disp('No dF/F calc');
end

calcTransientsGui(hObject, handles);

disp('Calculating transients');
tic;
for seg = 1:size(C,1)
pksCell{seg} = clayCaTransients(C(seg,:), 15);
end
toc;
handles.pksCell = pksCell;

handles.segSdThresh = 6*ones(size(C,1),1);
set(handles.pkSlider, 'Value', 6);

handles.binVel = binByLocation(vel, treadPos, 100);

try
handles.sAll = sAll;
handles.out = out;
catch
    disp('No tuning info');
end

guidata(hObject, handles);

% --- Executes on slider movement.
function segNumSlider_Callback(hObject, eventdata, handles)
% hObject    handle to segNumSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

segNum = int32(get(handles.segNumSlider, 'Value'));
set(handles.segTxt, 'String', num2str(segNum));
handles.segNum = segNum;

A = handles.A; C = handles.C;
aSeg = reshape(full(A(:,segNum)),handles.d1,handles.d2);
imagesc(handles.spatialAxes, aSeg);

plotTemp(hObject, handles);

%try
plotSegTuning(hObject, handles);
plotPopTuning(hObject, handles);
% catch
%     disp('Cant plot tuning');
% end

set(handles.pkSlider, 'Value', handles.segSdThresh(segNum));
set(handles.sdTxt, 'String', num2str(handles.segSdThresh(segNum)));

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function segNumSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in addSegButton.
function addSegButton_Callback(hObject, eventdata, handles)

segNum = handles.segNum;
goodSeg = [handles.goodSeg segNum];
goodSeg = sort(goodSeg);
goodSeg = unique(goodSeg);
handles.goodSeg = goodSeg;

set(handles.goodSegTxt, 'String', num2str(goodSeg));

plotPopTuning(hObject, handles);

guidata(hObject, handles);

% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

goodSeg = handles.goodSeg;
save([handles.fileBasename '_goodSeg_' date '.mat'], 'goodSeg');

guidata(hObject, handles);

function editBasename_Callback(hObject, eventdata, handles)
% hObject    handle to editBasename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.fileBasename = get(handles.editBasename, 'String');

% Hints: get(hObject,'String') returns contents of editBasename as text
%        str2double(get(hObject,'String')) returns contents of editBasename as a double

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function editBasename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editBasename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in removeGoodSegButton.
function removeGoodSegButton_Callback(hObject, eventdata, handles)
segNum = handles.segNum;

goodSeg = handles.goodSeg;
goodSeg = goodSeg(goodSeg ~= segNum);
handles.goodSeg = goodSeg;
set(handles.goodSegTxt, 'String', num2str(goodSeg));

greatSeg = handles.greatSeg;
greatSeg = greatSeg(greatSeg ~= segNum);
handles.greatSeg = greatSeg;
set(handles.greatSegTxt, 'String', num2str(greatSeg));

%try
plotSegTuning(hObject, handles);
plotPopTuning(hObject, handles);
% catch
%     disp('Cant plot tuning');
% end

guidata(hObject, handles);


% --- Executes on button press in clearGoodSegButton.
function clearGoodSegButton_Callback(hObject, eventdata, handles)
handles.goodSeg = [];
handles.greatSeg = [];
plotPopTuning(hObject, handles);
set(handles.goodSegTxt, 'String', 'none');
set(handles.greatSegTxt, 'String', 'none');
guidata(hObject, handles);


% --- Executes on button press in loadGoodSegButton.
function loadGoodSegButton_Callback(hObject, eventdata, handles)
[file, path] = uigetfile('*goodSeg*');
load([path file]);
handles.goodSeg = goodSeg;
handles.greatSeg = greatSeg;
handles.pksCell = pksCell;
handles.sdThresh = sdThresh;

set(handles.goodSegTxt, 'String', num2str(goodSeg));
set(handles.greatSegTxt, 'String', num2str(greatSeg));

%try
plotSegTuning(hObject, handles);
plotPopTuning(hObject, handles);
% catch
%     disp('Cant plot tuning');
% end

guidata(hObject, handles);



%% Plot animal velocity on temporal axes checkbox
% --- Executes on button press in plotVelCheckbox.
function plotVelCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to plotVelCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotVelCheckbox
handles.plotVel = int32(get(handles.plotVelCheckbox, 'Value'));

plotTemp(hObject, handles);

guidata(hObject, handles);

%% Plot animal position on temporal axes checkbox
% --- Executes on button press in plotPosCheckbox.
function plotPosCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to plotPosCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotPosCheckbox
handles.plotPos = int32(get(handles.plotPosCheckbox, 'Value'));

plotTemp(hObject, handles);

guidata(hObject, handles);

%% Plot dF/F on temporal axes checkbox
% --- Executes on button press in dffCheckbox.
function dffCheckbox_Callback(hObject, eventdata, handles)
handles.plotDff = int32(get(handles.dffCheckbox, 'Value'));

plotTemp(hObject, handles);

guidata(hObject, handles);

%% This just a quick initial transient detection with default parameters upon data loading
function calcTransientsGui(hObject, handles)

C = handles.C;

disp('Calculating transients');
tic;
for seg = 1:size(C,1)
pksCell{seg} = clayCaTransients(C(seg,:), 15);
end
toc;
handles.pksCell = pksCell;

guidata(hObject, handles);

%% 
function plotTemp(hObject, handles)
segNum = handles.segNum;
c = handles.C(segNum,:);

if handles.plotPos == 1
plot(handles.temporalAxes, max(c)*handles.treadPos, 'm');
hold(handles.temporalAxes, 'on');
end
if handles.plotVel == 1
plot(handles.temporalAxes, max(c)*handles.vel, 'c');
hold(handles.temporalAxes, 'on');
end
if handles.plotDff == 1
plot(handles.temporalAxes, handles.dff(handles.segNum,:), 'g');
hold(handles.temporalAxes, 'on');
end
plot(handles.temporalAxes, c);
hold(handles.temporalAxes, 'on');

if handles.plotPks == 1
    pks = handles.pksCell{segNum};
    t = 1:length(c);
    plot(handles.temporalAxes, t(pks), c(pks), 'r*');
    %hold(handles.temporalAxes, 'on');
    
    for i = 1:length(pks)
        try
            caPks(:,i) = c(pks(i)-100:pks(i)+300)-c(pks(i)-15);
        catch
        end
    end
    try
    plot(handles.spkWavAxes, caPks);
    hold(handles.spkWavAxes, 'on');
    plot(handles.spkWavAxes, mean(caPks,2), 'r', 'Linewidth', 2);
    set(handles.spkWavAxes, 'XLim',[0 400]);
    hold(handles.spkWavAxes, 'off');
    catch
    end
    
end
hold(handles.temporalAxes, 'off');

guidata(hObject, handles);

% --- Executes on button press in pksCheckbox.
function pksCheckbox_Callback(hObject, eventdata, handles)
handles.plotPks = int32(get(handles.pksCheckbox, 'Value'));
set(handles.pkSlider, 'Value', handles.segSdThresh(handles.segNum));
set(handles.sdTxt, 'String', num2str(handles.segSdThresh(handles.segNum)));
plotTemp(hObject, handles);

%try
plotSegTuning(hObject, handles);
plotPopTuning(hObject, handles);
% catch
%     disp('Cant plot tuning');
% end

guidata(hObject, handles);


% --- Executes on slider movement.
function pkSlider_Callback(hObject, eventdata, handles)
sdThresh = get(handles.pkSlider, 'Value');
set(handles.sdTxt, 'String', num2str(sdThresh));

segNum = handles.segNum;
C = handles.C;
handles.pksCell{segNum} = clayCaTransients(C(segNum,:), 15, 0, sdThresh);
handles.segSdThresh(segNum) = sdThresh;

plotTemp(hObject, handles);

numBins = 100;
pos = handles.treadPos;
segNum = handles.segNum;
c = handles.C(segNum, :); t = 1:length(c);
binCa = binByLocation(c, pos, numBins);
pks = handles.pksCell{segNum};
spks = zeros(1,length(c));
spks(pks) = 1;
binSpks = binByLocation(spks, pos, numBins);
handles.posRates(segNum,1:numBins) = binSpks;

%try
plotSegTuning(hObject, handles);
plotPopTuning(hObject, handles);
% catch
%     disp('Cant plot tuning');
% end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function pkSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pkSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in addGreatSegButton.
function addGreatSegButton_Callback(hObject, eventdata, handles)
segNum = handles.segNum;

goodSeg = [handles.goodSeg segNum];
goodSeg = sort(goodSeg);
goodSeg = unique(goodSeg);
handles.goodSeg = goodSeg;
set(handles.goodSegTxt, 'String', num2str(goodSeg));

greatSeg = [handles.greatSeg segNum];
greatSeg = sort(greatSeg);
greatSeg = unique(greatSeg);
handles.greatSeg = greatSeg;
set(handles.greatSegTxt, 'String', num2str(greatSeg));


plotSegTuning(hObject, handles);
plotPopTuning(hObject, handles);

guidata(hObject, handles);


% --- Executes on button press in plotTunCheckbox.
function plotTunCheckbox_Callback(hObject, eventdata, handles)
handles.plotTuning = int32(get(handles.plotTunCheckbox, 'Value'));
if handles.plotTuning ~= 0
plotSegTuning(hObject, handles);
plotPopTuning(hObject, handles);
end
guidata(hObject, handles);


%% plot all tuning data
function plotPopTuning(hObject, handles);

if handles.plotTuning ~= 0
pksCell = handles.pksCell;
goodSeg = handles.goodSeg;

if length(goodSeg)>0
    disp(['Plotting popTuning for segNum ' num2str(handles.segNum) ', ' num2str(length(pksCell{handles.segNum})) ' spikes']);
%try
posRates = handles.posRates(goodSeg, :);
disp(['Max rate= ' num2str(max(posRates(:)))]);
for i = 1:length(goodSeg)
    rates = posRates(i,:);
    [val maxInd(i)] = max(rates);
    posRates(i,:) = rates/max(rates);
end

[b,inds]=sort(maxInd);
posRates = posRates(inds,:);
plot(handles.popAvgAxes, handles.binVel/20, 'g.');
hold(handles.popAvgAxes, 'on');
plot(handles.popAvgAxes, mean(posRates,1));
hold(handles.popAvgAxes, 'off');
imagesc(handles.goodPosTuneAxes, posRates);
%catch
%end
end

%% plot 
greatSeg = handles.greatSeg;
if ~isempty(greatSeg)
%try
posRates = handles.posRates(greatSeg, :);
for i = 1:length(greatSeg)
    rates = posRates(i,:);
    [val2 maxInd2(i)] = max(rates);
    posRates(i,:) = rates/max(rates);
end

[b2,inds2]=sort(maxInd2);
posRates = posRates(inds2,:);   % getting error in this right now
plot(handles.greatPopAvgAxes, handles.binVel/20, 'g.');
hold(handles.greatPopAvgAxes, 'on');
plot(handles.greatPopAvgAxes, mean(posRates,1));
hold(handles.greatPopAvgAxes, 'off');
imagesc(handles.greatPosTunAxes, posRates);
%catch
%end
end
end

guidata(hObject, handles);

%%
function plotSegTuning(hObject, handles)
if handles.plotTuning ~= 0
numBins = 100;
pos = handles.treadPos;
segNum = handles.segNum;
c = handles.C(segNum, :); t = 1:length(c);
binCa = binByLocation(c, pos, numBins);
pks = handles.pksCell{segNum};
spks = zeros(1,length(c));
spks(pks) = 1;
binSpks = binByLocation(spks, pos, numBins);
handles.posRates(segNum,1:numBins) = binSpks;

%handles.binVel = binByLocation(handles.vel, pos, numBins);

%try
plot(handles.posTuneAxes, handles.binVel/5, 'c.');
hold(handles.posTuneAxes, 'on');
plot(handles.posTuneAxes, binCa/2, 'g');
plot(handles.posTuneAxes, binSpks);
hold(handles.posTuneAxes, 'off');
%catch
%end


disp(['Plotting seg ' num2str(segNum) ' tuning']);
end

guidata(hObject, handles);