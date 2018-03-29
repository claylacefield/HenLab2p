function varargout = zivCaimanSegComparison(varargin)
% ZIVCAIMANSEGCOMPARISON MATLAB code for zivCaimanSegComparison.fig
%      ZIVCAIMANSEGCOMPARISON, by itself, creates a new ZIVCAIMANSEGCOMPARISON or raises the existing
%      singleton*.
%
%      H = ZIVCAIMANSEGCOMPARISON returns the handle to a new ZIVCAIMANSEGCOMPARISON or the handle to
%      the existing singleton*.
%
%      ZIVCAIMANSEGCOMPARISON('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ZIVCAIMANSEGCOMPARISON.M with the given input arguments.
%
%      ZIVCAIMANSEGCOMPARISON('Property','Value',...) creates a new ZIVCAIMANSEGCOMPARISON or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before zivCaimanSegComparison_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to zivCaimanSegComparison_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help zivCaimanSegComparison

% Last Modified by GUIDE v2.5 29-Mar-2018 17:55:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @zivCaimanSegComparison_OpeningFcn, ...
                   'gui_OutputFcn',  @zivCaimanSegComparison_OutputFcn, ...
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


% --- Executes just before zivCaimanSegComparison is made visible.
function zivCaimanSegComparison_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to zivCaimanSegComparison (see VARARGIN)

% Choose default command line output for zivCaimanSegComparison
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes zivCaimanSegComparison wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = zivCaimanSegComparison_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in loadDataButton.
function loadDataButton_Callback(hObject, eventdata, handles)

[file, path] = uigetfile('*.mat', 'Select multSessTuningStruc');
cd(path);
load([path file]);
handles.file = file;
handles.path = path;

basename = file(1:strfind(file,'.mat')-1);
%set(handles.editBasename, 'String', basename);
handles.basename = basename;

try
load(findLatestFilename('cellRegistered'));
catch
    disp('Cant find cellRegistered struc');
end

handles.d1 = multSessTuningStruc(1).d1;
handles.d2 = multSessTuningStruc(1).d2;

for i = 1:size(multSessTuningStruc,2)
handles.C{i} = multSessTuningStruc(i).C;
handles.A{i} = multSessTuningStruc(i).A;
end

handles.zivMat = cell_registered_struct.cell_to_index_map;

guidata(hObject, handles);


% --- Executes on slider movement.
function segSlider_Callback(hObject, eventdata, handles)
% hObject    handle to segSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

zivRow = int32(get(handles.segSlider, 'Value'));
set(handles.zivTxt, 'String', num2str(zivRow));
handles.zivRow = zivRow;

plotSegments(hObject, handles);

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function segSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to segSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%%
function plotSegments(hObject, handles)

zivRow = handles.zivRow;
zivMat = handles.zivMat;

A = handles.A;
C = handles.C;
d1 = handles.d1;
d2 = handles.d2;

try
    A1 = A{1};
    segNum1 = zivMat(zivRow,1);
    segA1 = A1(:, segNum1);
    imagesc(handles.axes1,reshape(segA1, d1, d2));
    C1 = C{1};
    segC1 = C1(segNum1,:);
    plot(handles.temporalAxes, segC1, 'r');
    hold(handles.temporalAxes, 'on');
catch
    cla(handles.axes1);
end

try
    A2 = A{2};
    segNum2 = zivMat(zivRow,2);
    segA2 = A2(:, segNum2);
    imagesc(handles.axes2,reshape(segA2, d1, d2));
    C2 = C{2};
    segC2 = C2(segNum2,:);
    plot(handles.temporalAxes, segC2, 'g');
    hold(handles.temporalAxes, 'on');
catch
    cla(handles.axes2);
end

try
    A3 = A{3};
    segNum3 = zivMat(zivRow,3);
    segA3 = A3(:, segNum3);
    imagesc(handles.axes3,reshape(segA3, d1, d2));
    C3 = C{3};
    segC3 = C3(segNum3,:);
    plot(handles.temporalAxes, segC3, 'b');
    hold(handles.temporalAxes, 'on');
catch
    cla(handles.axes3);
end

try
    A4 = A{4};
    segNum4 = zivMat(zivRow,4);
    segA4 = A4(:, segNum4);
    imagesc(handles.axes4,reshape(segA4, d1, d2));
    C4 = C{4};
    segC4 = C4(segNum4,:);
    plot(handles.temporalAxes, segC4, 'm');
    hold(handles.temporalAxes, 'on');
catch
    cla(handles.axes4);
end

hold(handles.temporalAxes, 'off');







guidata(hObject, handles);
