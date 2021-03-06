function varargout = guiSelectDGCs_180308a(varargin)
% GUISELECTDGCS_180308A MATLAB code for guiSelectDGCs_180308a.fig
%      GUISELECTDGCS_180308A, by itself, creates a new GUISELECTDGCS_180308A or raises the existing
%      singleton*.
%
%      H = GUISELECTDGCS_180308A returns the handle to a new GUISELECTDGCS_180308A or the handle to
%      the existing singleton*.
%
%      GUISELECTDGCS_180308A('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUISELECTDGCS_180308A.M with the given input arguments.
%
%      GUISELECTDGCS_180308A('Property','Value',...) creates a new GUISELECTDGCS_180308A or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiSelectDGCs_180308a_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiSelectDGCs_180308a_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiSelectDGCs_180308a

% Last Modified by GUIDE v2.5 10-Mar-2018 00:21:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiSelectDGCs_180308a_OpeningFcn, ...
                   'gui_OutputFcn',  @guiSelectDGCs_180308a_OutputFcn, ...
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


% --- Executes just before guiSelectDGCs_180308a is made visible.
function guiSelectDGCs_180308a_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiSelectDGCs_180308a (see VARARGIN)

% Choose default command line output for guiSelectDGCs_180308a
handles.output = hObject;

handles.goodSeg = [];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiSelectDGCs_180308a wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiSelectDGCs_180308a_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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
plot(handles.temporalAxes, C(segNum,:));

try
sAll = handles.sAll; out = handles.out;
plot(handles.posTuneAxes, out.Shuff.ThreshRate(segNum,:));
hold(handles.posTuneAxes, 'on');

plot(handles.posTuneAxes, out.posRates(segNum,:));
hold(handles.posTuneAxes, 'off');
catch
end

guidata(hObject, handles);

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

handles.C = C;
handles.A = A;
handles.d1 = d1;
handles.d2 = d2;
handles.treadBehStruc = treadBehStruc;

handles.binVel = binByLocation(fixVel(treadBehStruc.vel(1:2:end)), pos, 100);

try
handles.sAll = sAll;
handles.out = out;
catch
    disp('No tuning info');
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
plot(handles.popAvgAxes, mean(posRates,1));
imagesc(handles.goodPosTuneAxes, posRates);
catch
end

guidata(hObject, handles);
