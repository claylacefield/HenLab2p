function varargout = manualCellAlignGUI_112918a(varargin)
% MANUALCELLALIGNGUI_112918A MATLAB code for manualCellAlignGUI_112918a.fig
%      MANUALCELLALIGNGUI_112918A, by itself, creates a new MANUALCELLALIGNGUI_112918A or raises the existing
%      singleton*.
%
%      H = MANUALCELLALIGNGUI_112918A returns the handle to a new MANUALCELLALIGNGUI_112918A or the handle to
%      the existing singleton*.
%
%      MANUALCELLALIGNGUI_112918A('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUALCELLALIGNGUI_112918A.M with the given input arguments.
%
%      MANUALCELLALIGNGUI_112918A('Property','Value',...) creates a new MANUALCELLALIGNGUI_112918A or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before manualCellAlignGUI_112918a_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to manualCellAlignGUI_112918a_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help manualCellAlignGUI_112918a

% Last Modified by GUIDE v2.5 29-Nov-2018 18:08:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @manualCellAlignGUI_112918a_OpeningFcn, ...
                   'gui_OutputFcn',  @manualCellAlignGUI_112918a_OutputFcn, ...
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


% --- Executes just before manualCellAlignGUI_112918a is made visible.
function manualCellAlignGUI_112918a_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to manualCellAlignGUI_112918a (see VARARGIN)

% Choose default command line output for manualCellAlignGUI_112918a
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes manualCellAlignGUI_112918a wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = manualCellAlignGUI_112918a_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in tifSelectButton1.
function tifSelectButton1_Callback(hObject, eventdata, handles)
[tifName1, tifPath1] = uigetfile('*.tif', 'Select Tiff #1');
handles.tifName1 = tifName1; handles.tifPath1 = tifPath1;
im1 = imread([tifPath1 '/' tifName1]); handles.im1 = im1;
imagesc(handles.axes1, im1);

set(handles.tifNameTxt1, 'String', tifName1);

guidata(hObject, handles);


% --- Executes on button press in tifSelectButton2.
function tifSelectButton2_Callback(hObject, eventdata, handles)
[tifName2, tifPath2] = uigetfile('*.tif', 'Select Tiff #2');
handles.tifName2 = tifName2; handles.tifPath2 = tifPath2;
im2 = imread([tifPath2 '/' tifName2]); handles.im2 = im2;
imagesc(handles.axes2, im2);

set(handles.tifNameTxt2, 'String', tifName2);

guidata(hObject, handles);


% --- Executes on button press in clickCellButton1.
function clickCellButton1_Callback(hObject, eventdata, handles)
[x,y] = ginput;

handles.x1 = x; handles.y1=y;

hold(handles.axes1, 'on');
plot(handles.axes1, x, y, 'r*');
hold(handles.axes1, 'off');

set(handles.cellCoord1, 'String', ['cell1, x=' num2str(x) ', y=' num2str(y)]);

guidata(hObject, handles);

% --- Executes on button press in clickCellButton2.
function clickCellButton2_Callback(hObject, eventdata, handles)
[x,y] = ginput;

handles.x2 = x; handles.y2=y;

hold(handles.axes2, 'on');
plot(handles.axes2, x, y, 'r*');
hold(handles.axes2, 'off');

set(handles.cellCoord2, 'String', ['cell1, x=' num2str(x) ', y=' num2str(y)]);

guidata(hObject, handles);


% --- Executes on button press in alignButton.
function alignButton_Callback(hObject, eventdata, handles)

x1=handles.x1; y1=handles.y1; x2=handles.x2; y2=handles.y2;

if x1>x2
    x1range = [x1-x2, size(im1,2)];
    x2range = [1, x2+size(im1,2)-x1];
else
    x2range = [x2-x1, size(im2,2)];
    x1range = [1, x1+size(im2,2)-x2];
end

if y1>y2
    y1range = [y1-y2, size(im1,1)];
    y2range = [1, y2+size(im1,1)-y1];
else
    y2range = [y2-y1, size(im2,1)];
    y1range = [1, y1+size(im2,1)-y2];
end

im1b = im1(y1range(1):y1range(2), x1range(1):x1range(2));
im2b = im2(y2range(1):y2range(2), x2range(1):x2range(2));


guidata(hObject, handles);
