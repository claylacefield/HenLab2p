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

% Last Modified by GUIDE v2.5 13-Mar-2018 16:00:56

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
handles.plotPos = 0;
handles.plotVel = 0;
handles.plotDff = 0;

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


try
handles.sAll = sAll;
handles.out = out;

handles.binVel = binByLocation(vel, treadPos, 100);
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

try
sAll = handles.sAll; out = handles.out;
plot(handles.posTuneAxes, out.Shuff.ThreshRate(segNum,:));
hold(handles.posTuneAxes, 'on');
plot(handles.posTuneAxes, handles.binVel/2000, 'g.');
plot(handles.posTuneAxes, out.posRates(segNum,:));
hold(handles.posTuneAxes, 'off');
catch
end

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
plotPopTuning(hObject, handles);
set(handles.goodSegTxt, 'String', num2str(goodSeg));
guidata(hObject, handles);


% --- Executes on button press in clearGoodSegButton.
function clearGoodSegButton_Callback(hObject, eventdata, handles)
handles.goodSeg = [];
plotPopTuning(hObject, handles);
set(handles.goodSegTxt, 'String', 'none');
guidata(hObject, handles);


% --- Executes on button press in loadGoodSegButton.
function loadGoodSegButton_Callback(hObject, eventdata, handles)
[file, path] = uigetfile('*goodSeg*');
load([path file]);
handles.goodSeg = goodSeg;

set(handles.goodSegTxt, 'String', num2str(goodSeg));

plotPopTuning(hObject, handles);

guidata(hObject, handles);


function plotPopTuning(hObject, handles);

goodSeg = handles.goodSeg;

try
posRates = handles.out.posRates(goodSeg, :);
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
catch
end

guidata(hObject, handles);


% --- Executes on button press in plotVelCheckbox.
function plotVelCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to plotVelCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotVelCheckbox
handles.plotVel = int32(get(handles.plotVelCheckbox, 'Value'));

plotTemp(hObject, handles);

guidata(hObject, handles);

% --- Executes on button press in plotPosCheckbox.
function plotPosCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to plotPosCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotPosCheckbox
handles.plotPos = int32(get(handles.plotPosCheckbox, 'Value'));

plotTemp(hObject, handles);

guidata(hObject, handles);


% --- Executes on button press in dffCheckbox.
function dffCheckbox_Callback(hObject, eventdata, handles)
handles.plotDff = int32(get(handles.dffCheckbox, 'Value'));

plotTemp(hObject, handles);

guidata(hObject, handles);


%% 
function plotTemp(hObject, handles)

c = handles.C(handles.segNum,:);

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
hold(handles.temporalAxes, 'off');


%%
function calcTransientsGui(hObject, handles)

C = handles.C;

disp('Calculating transients');
tic;
for seg = 1:size(C,1)
handles.pksCell{seg} = clayCaTransients(C(seg,:), 15);
end
toc;
guidata(hObject, handles);



