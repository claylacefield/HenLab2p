function varargout = segDictMergeGUI(varargin)
% SEGDICTMERGEGUI MATLAB code for segDictMergeGUI.fig
%      SEGDICTMERGEGUI, by itself, creates a new SEGDICTMERGEGUI or raises the existing
%      singleton*.
%
%      H = SEGDICTMERGEGUI returns the handle to a new SEGDICTMERGEGUI or the handle to
%      the existing singleton*.
%
%      SEGDICTMERGEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEGDICTMERGEGUI.M with the given input arguments.
%
%      SEGDICTMERGEGUI('Property','Value',...) creates a new SEGDICTMERGEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before segDictMergeGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to segDictMergeGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help segDictMergeGUI

% Last Modified by GUIDE v2.5 09-Feb-2019 01:27:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @segDictMergeGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @segDictMergeGUI_OutputFcn, ...
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


% --- Executes just before segDictMergeGUI is made visible.
function segDictMergeGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to segDictMergeGUI (see VARARGIN)

% Choose default command line output for segDictMergeGUI
handles.output = hObject;


% init some vars
handles.dispSeg = 1;
handles.pairRow = 1;

handles.mergC =[];
handles.mergA = [];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes segDictMergeGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = segDictMergeGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);


% Get default command line output from handles structure
varargout{1} = handles.output;


%% --- Executes on button press in loadSegDictButton.
function loadSegDictButton_Callback(hObject, eventdata, handles)
[file1, path] = uigetfile('*.mat', 'Select segDict file to process');
cd(path);
load([path file1]); % load goodSeg file
handles.segDictFile = file1;
handles.path = path;
set(handles.segDictTxt, 'String', file1);
disp(['Loading ' file1]);

% [file, path] = uigetfile('*.mat', 'Select corresponding goodSeg file to process');
% if file~=0
% cd(path);
% load([path file]); % load goodSeg file
% else
    file = file1;
    goodSeg = 1:size(C,1);
% end
basename = file(1:strfind(file,'.mat')-1);
set(handles.editBasename, 'String', basename);
handles.basename = basename;
handles.fileBasename = basename;
disp(['Loading ' file]);

C = C(goodSeg,:);
A = A(:,goodSeg);

handles.C = C;
handles.A = A;
handles.d1 = d1;
handles.d2 = d2;

handles.goodSeg = goodSeg;
handles.goodSegOrig = goodSeg;
set(handles.goodSegTxt, 'String', num2str(handles.goodSeg));


dupPairs = findDuplSeg(A,C,d1,d2, 0); % note this is index of goodSegs now
dupSegGroup = findDupSegGroup(dupPairs);
handles.dupSegGroup = dupSegGroup;
% handles.seg1 = handles.dupPairs(1,1);
% handles.seg2 = handles.dupPairs(1,2);

plotSpatial(hObject, handles);
plotTemporal(hObject, handles);

guidata(hObject, handles);

% --- Executes on slider movement.
function dupPairSlider_Callback(hObject, eventdata, handles)
pairRow = int32(get(handles.dupPairSlider, 'Value'));
handles.pairRow=pairRow;
set(handles.pairNumTxt, 'String', ['Group ' num2str(pairRow) ' out of ' num2str(length(handles.dupSegGroup)) ': ' num2str(handles.goodSegOrig(handles.dupSegGroup{pairRow}))]);
set(handles.dispSegSlider, 'Value', 1);
handles.dispSeg=1;
set(handles.segTxt, 'String', ['Seg ' num2str(handles.dispSeg) ' out of ' num2str(length(handles.dupSegGroup{handles.pairRow})) ': #' num2str(handles.goodSegOrig(handles.dupSegGroup{handles.pairRow}(handles.dispSeg)))]);


plotSpatial(hObject, handles);
plotTemporal(hObject, handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function dupPairSlider_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%% Plotting functions

function plotSpatial(hObject, handles);
dupSegGroup = handles.dupSegGroup;
pairRow = handles.pairRow;
dupSegList = dupSegGroup{pairRow};
spatial = reshape(squeeze(full(handles.A(:,dupSegList(handles.dispSeg)))),handles.d1, handles.d2);
imagesc(handles.spatialAxes, spatial);


function plotTemporal(hObject, handles);
dupSegGroup = handles.dupSegGroup;
pairRow = handles.pairRow;
dupSegList = dupSegGroup{pairRow};

colors = {'r','g','b','c','m','y','k'};

for i=1:length(dupSegList)
plot(handles.temporalAxes, handles.C(dupSegList(i),:), colors{i});
hold(handles.temporalAxes, 'on');
end
hold(handles.temporalAxes, 'off');


%% --- Executes on slider movement.
function dispSegSlider_Callback(hObject, eventdata, handles)

dispSeg = int32(get(handles.dispSegSlider, 'Value'));
set(handles.segTxt, 'String', ['Seg ' num2str(dispSeg) ' out of ' num2str(length(handles.dupSegGroup{handles.pairRow})) ': #' num2str(handles.goodSegOrig(handles.dupSegGroup{handles.pairRow}(dispSeg)))]);
handles.dispSeg = dispSeg;

plotSpatial(hObject, handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function dispSegSlider_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


%% --- Executes on button press in discardSegButton.
function discardSegButton_Callback(hObject, eventdata, handles)

dupSegGroup = handles.dupSegGroup; % cell array of possibly dupl cells
pairRow = handles.pairRow;  % current row of dupSegGroup (all from one cell)
dispSeg = handles.dispSeg;
dupSegList = dupSegGroup{pairRow};
discardSegNum = dupSegList(dispSeg); % get number of seg to discard (one currently selected)
% note, if only goodSeg are used, this is index of orig goodSeg, thus
origDiscSegNum = handles.goodSegOrig(discardSegNum);

handles.dupSegGroup{pairRow} = dupSegList(dupSegList ~= discardSegNum);
handles.goodSeg(origDiscSegNum) = NaN;
set(handles.goodSegTxt, 'String', num2str(handles.goodSeg));

set(handles.dispSegSlider, 'Value', 1);
handles.dispSeg=1;

plotSpatial(hObject, handles);
plotTemporal(hObject, handles);

guidata(hObject, handles);


%% --- Executes on button press in mergeButton. (ToDo)
function mergeButton_Callback(hObject, eventdata, handles)
dupSegGroup = handles.dupSegGroup;
    pairRow = handles.pairRow;
    dupSegList = dupSegGroup{pairRow};
    
    % merge spatial and temporal, save (but need to append to list, and save)
    mergSpat = mean(handles.A(:,dupSegList),2);
    handles.mergA = [handles.mergA mergSpat];
    mergTemp = mean(handles.C(dupSegList,:),1);
    handles.mergC = [handles.mergC; mergTemp];
    
    %handles.dupSegGroup{pairRow} = {'merged', nRow} ;
    %handles.A = [handles.A mergSpat];
    %handles.C = [handles.C mergTemp];
    %plot (but have to change plot funcs a little)
    
    % ToDo:
    % 1.) append mergA/C to list (and add to save)
    % 2.) replace dupSegGroup/List with merged
    % 3.) think about option to only take spatial from one segment
    
    handles.dupSegGroup{pairRow} = []; % empty this duplicate seg group
    
    % delete these from goodSegs (or make NaN so number of segs doesn't
    % change)
    handles.goodSeg(dupSegList) = NaN;
    
    set(handles.goodSegTxt, 'String', num2str(handles.goodSeg));
    
    pairRow=pairRow+1;
    set(handles.dupPairSlider, 'Value', pairRow);
    
set(handles.pairNumTxt, 'String', ['Group ' num2str(pairRow) ' out of ' num2str(length(handles.dupSegGroup)) ': ' num2str(handles.goodSegOrig(handles.dupSegGroup{pairRow}))]);
set(handles.dispSegSlider, 'Value', 1);
handles.dispSeg=1;
set(handles.segTxt, 'String', ['Seg ' num2str(handles.dispSeg) ' out of ' num2str(length(handles.dupSegGroup{pairRow})) ': #' num2str(handles.goodSegOrig(handles.dupSegGroup{pairRow}(handles.dispSeg)))]);

handles.pairRow = pairRow;

plotSpatial(hObject, handles);
plotTemporal(hObject, handles);
    
    %handles.goodSeg = goodSeg;
    
    guidata(hObject, handles);


%% --- Executes on button press in dispMergeCheckbox.
function dispMergeCheckbox_Callback(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of dispMergeCheckbox
dispMerge = get(hObject, 'Value');
handles.dispMerge = dispMerge;

% display potential merge
if dispMerge == 1
    dupSegGroup = handles.dupSegGroup;
    pairRow = handles.pairRow;
    dupSegList = dupSegGroup{pairRow};
    
    % plot spatial merge
    spatial = reshape(squeeze(mean(full(handles.A(:,dupSegList)),2)),handles.d1, handles.d2);
    imagesc(handles.spatialAxes, spatial);
    
    % plot temporal merge
    colors = {'r','g','b','c','m','y','k'};
    
    for i=1:length(dupSegList)
        plot(handles.temporalAxes, handles.C(dupSegList(i),:), colors{i});
        hold(handles.temporalAxes, 'on');
    end
    plot(handles.temporalAxes, mean(handles.C(dupSegList,:),1), colors{i+1});
    hold(handles.temporalAxes, 'off');
    
else
    
plotSpatial(hObject, handles);
plotTemporal(hObject, handles);
end

guidata(hObject, handles);

% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
segDictFile = handles.segDictFile;
path = handles.path;
goodSeg = handles.goodSeg;

mergA = handles.mergA;
mergC = handles.mergC;

try
    greatSeg = handles.greatSeg;
    pksCell = handles.pksCell;
    segSdThresh = handles.segSdThresh;
    segPkMethod = handles.segPkMethod;
    posRates = handles.posRates;
    % try
    okSeg = handles.okSeg;
    inSeg = handles.inSeg;
    % catch
    % end
    
    deconvC = handles.deconvC;
    posDeconv = handles.posDeconv;
    
    try
        save([handles.editBasename '_merge_' date '.mat'], 'segDictFile', 'path', 'goodSeg', 'mergA', 'mergC');
    catch
        [savFile, savPath] = uiputfile('*.mat', 'Save goodSegs to file location', [handles.fileBasename '_goodSeg_' date '.mat']);
        save([savPath savFile '_goodSeg_' date '.mat'], 'segDictFile', 'path', 'goodSeg', 'mergA', 'mergC');
    end
    
catch
    
    try
        save([handles.editBasename '_merge_' date '.mat'], 'segDictFile', 'goodSeg', 'mergA', 'mergC');
    catch
        [savFile, savPath] = uiputfile('*.mat', 'Save goodSegs to file location', [handles.fileBasename '_goodSeg_' date '.mat']);
        save([savPath savFile '_merge_' date '.mat'], 'segDictFile', 'path','goodSeg', 'mergA', 'mergC');
    end
    
end

guidata(hObject, handles);

function editBasename_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of editBasename as text
%        str2double(get(hObject,'String')) returns contents of editBasename as a double


% --- Executes during object creation, after setting all properties.
function editBasename_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in dropSegButton.
function dropSegButton_Callback(hObject, eventdata, handles)
dupSegGroup = handles.dupSegGroup; % cell array of possibly dupl cells
pairRow = handles.pairRow;  % current row of dupSegGroup (all from one cell)
dispSeg = handles.dispSeg;
dupSegList = dupSegGroup{pairRow};
discardSegNum = dupSegList(dispSeg); % get number of seg to discard (one currently selected)

handles.dupSegGroup{pairRow} = dupSegList(dupSegList ~= discardSegNum);

set(handles.dispSegSlider, 'Value', 1);
handles.dispSeg=1;

set(handles.pairNumTxt, 'String', ['Group ' num2str(pairRow) ' out of ' num2str(length(handles.dupSegGroup)) ': ' num2str(handles.goodSegOrig(handles.dupSegGroup{pairRow}))]);
set(handles.dispSegSlider, 'Value', 1);
handles.dispSeg=1;
set(handles.segTxt, 'String', ['Seg ' num2str(handles.dispSeg) ' out of ' num2str(length(handles.dupSegGroup{pairRow})) ': #' num2str(handles.goodSegOrig(handles.dupSegGroup{pairRow}(handles.dispSeg)))]);


plotSpatial(hObject, handles);
plotTemporal(hObject, handles);

guidata(hObject, handles);