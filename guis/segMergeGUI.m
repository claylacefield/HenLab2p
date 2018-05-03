function varargout = segMergeGUI(varargin)
% SEGMERGEGUI MATLAB code for segMergeGUI.fig
%      SEGMERGEGUI, by itself, creates a new SEGMERGEGUI or raises the existing
%      singleton*.
%
%      H = SEGMERGEGUI returns the handle to a new SEGMERGEGUI or the handle to
%      the existing singleton*.
%
%      SEGMERGEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEGMERGEGUI.M with the given input arguments.
%
%      SEGMERGEGUI('Property','Value',...) creates a new SEGMERGEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before segMergeGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to segMergeGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help segMergeGUI

% Last Modified by GUIDE v2.5 03-May-2018 16:20:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @segMergeGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @segMergeGUI_OutputFcn, ...
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


% --- Executes just before segMergeGUI is made visible.
function segMergeGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to segMergeGUI (see VARARGIN)

% Choose default command line output for segMergeGUI
handles.output = hObject;


% init some vars
handles.dispSeg = 1;
handles.pairRow = 1;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes segMergeGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = segMergeGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in loadSegDictButton.
function loadSegDictButton_Callback(hObject, eventdata, handles)
[file, path] = uigetfile('*.mat', 'Select segDict file to process');
cd(path);
load([path file]); % load goodSeg file
handles.file = file;
handles.path = path;
set(handles.segDictTxt, 'String', file);
disp(['Loading ' file]);

[file, path] = uigetfile('*.mat', 'Select corresponding goodSeg file to process');
cd(path);
load([path file]); % load goodSeg file
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
handles.greatSeg = greatSeg;
handles.okSeg = okSeg;
handles.inSeg = inSeg;
handles.pksCell = pksCell;
handles.segSdThresh = segSdThresh;
handles.segPkMethod = segPkMethod;
handles.posRates = posRates;
handles.deconvC = deconvC;
handles.posDeconv = posDeconv;


dupPairs = findDuplSeg(A,C,d1,d2, 0);
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
set(handles.pairNumTxt, 'String', ['Group ' num2str(pairRow) ' out of ' num2str(length(handles.dupSegGroup))]);
handles.pairRow=pairRow;

plotSpatial(hObject, handles);
plotTemporal(hObject, handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function dupPairSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dupPairSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


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


% --- Executes on slider movement.
function dispSegSlider_Callback(hObject, eventdata, handles)
% hObject    handle to dispSegSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dispSeg = int32(get(handles.dispSegSlider, 'Value'));
set(handles.segTxt, 'String', ['Seg ' num2str(dispSeg) ' out of ' num2str(length(handles.dupSegGroup{handles.pairRow}))]);
handles.dispSeg = dispSeg;

plotSpatial(hObject, handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function dispSegSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dispSegSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in discardSegButton.
function discardSegButton_Callback(hObject, eventdata, handles)
% hObject    handle to discardSegButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dupSegGroup = handles.dupSegGroup;
pairRow = handles.pairRow;
dispSeg = handles.dispSeg;
dupSegList = dupSegGroup{pairRow};
discardSegNum = dupSegList(dispSeg); % get number of seg to discard (one currently selected)

handles.dupSegGroup{pairRow} = dupSegList(dupSegList ~= discardSegNum);
handles.goodSeg = handles.goodSeg(handles.goodSeg ~= discardSegNum);
handles.greatSeg = handles.greatSeg(handles.greatSeg ~= discardSegNum);

set(handles.dispSegSlider, 'Value', 1);
handles.dispSeg=1;

plotSpatial(hObject, handles);
plotTemporal(hObject, handles);

guidata(hObject, handles);


% --- Executes on button press in mergeButton.
function mergeButton_Callback(hObject, eventdata, handles)
% hObject    handle to mergeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in dispMergeCheckbox.
function dispMergeCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to dispMergeCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dispMergeCheckbox



% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
file = handles.file;
path = handles.path;
goodSeg = handles.goodSeg;
greatSeg = handles.greatSeg;
pksCell = handles.pksCell;
segSdThresh = handles.segSdThresh;
segPkMethod = handles.segPkMethod;
posRates = handles.posRates;

okSeg = handles.okSeg;
inSeg = handles.inSeg;

deconvC = handles.deconvC;
posDeconv = handles.posDeconv;

try
save([handles.fileBasename '_goodSeg_' date '.mat'], 'file', 'path', 'okSeg', 'goodSeg', 'greatSeg', 'inSeg', 'pksCell', 'segSdThresh', 'segPkMethod', 'posRates', 'deconvC', 'posDeconv');
catch
    [savFile, savPath] = uiputfile('*.mat', 'Save goodSegs to file location', [handles.fileBasename '_goodSeg_' date '.mat']);
    save([savPath savFile '_goodSeg_' date '.mat'], 'file', 'path', 'okSeg', 'goodSeg', 'greatSeg', 'inSeg', 'pksCell', 'segSdThresh', 'segPkMethod', 'posRates', 'deconvC', 'posDeconv');
end

guidata(hObject, handles);

function editBasename_Callback(hObject, eventdata, handles)
% hObject    handle to editBasename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editBasename as text
%        str2double(get(hObject,'String')) returns contents of editBasename as a double


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