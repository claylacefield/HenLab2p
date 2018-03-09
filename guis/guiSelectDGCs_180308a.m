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

% Last Modified by GUIDE v2.5 09-Mar-2018 03:05:20

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

sAll = handles.sAll; out = handles.out;
plot(handles.posTuneAxes, out.Shuff.ThreshRate(segNum,:));
hold(handles.posTuneAxes, 'on');
plot(handles.posTuneAxes, out.posRates(segNum,:));
hold(handles.posTuneAxes, 'off');

guidata(hObject, handles);

% --- Executes on button press in loadDataButton.
function loadDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load(uigetfile('*.mat'));
handles.sAll = sAll;
handles.C = C;
handles.A = A;
handles.d1 = d1;
handles.d2 = d2;
handles.out = out;

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function segNumSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to segNumSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end





% --- Executes on button press in addSegButton.
function addSegButton_Callback(hObject, eventdata, handles)
% hObject    handle to addSegButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

segNum = handles.segNum;
goodSeg = [handles.goodSeg segNum];
goodSeg = sort(goodSeg);
handles.goodSeg = goodSeg;

set(handles.goodSegTxt, 'String', num2str(goodSeg));

posRates = handles.out.posRates(goodSeg, :);
for i = 1:length(goodSeg)
    rates = posRates(i,:);
    [val maxInd(i)] = max(rates);
    posRates(i,:) = rates/max(rates);
end

[b,inds]=sort(maxInd);
posRates = posRates(inds,:);

imagesc(handles.goodPosTuneAxes, posRates);

guidata(hObject, handles);
