function varargout = GeometryLab2D(varargin)
% GEOMETRYLAB2D MATLAB code for GeometryLab2D.fig
%      GEOMETRYLAB2D, by itself, creates a new GEOMETRYLAB2D or raises the existing
%      singleton*.
%
%      H = GEOMETRYLAB2D returns the handle to a new GEOMETRYLAB2D or the handle to
%      the existing singleton*.
%
%      GEOMETRYLAB2D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GEOMETRYLAB2D.M with the given input arguments.
%
%      GEOMETRYLAB2D('Property','Value',...) creates a new GEOMETRYLAB2D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GeometryLab2D_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GeometryLab2D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GeometryLab2D

% Last Modified by GUIDE v2.5 08-Dec-2019 20:14:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GeometryLab2D_OpeningFcn, ...
                   'gui_OutputFcn',  @GeometryLab2D_OutputFcn, ...
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

% --- Executes just before GeometryLab2D is made visible.
function GeometryLab2D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GeometryLab2D (see VARARGIN)

% Choose default command line output for GeometryLab2D
handles.output = hObject;
handles.lines = [];
handles.circles = [];
handles.plottedLines = [];
handles.plottedCircs = [];
handles.LLplot = [];
handles.LCplot = [];
handles.CCplot = [];

% % shows the axes toolbar when mouse hovers the axes
tb = axtoolbar('default');
tb.Visible = 'on';

% enbling axes interactivity
ax = handles.axes2;
ax.Interactions = [dataTipInteraction panInteraction zoomInteraction];
% enableDefaultInteractivity(ax);
guidata(hObject, handles);

% UIWAIT makes GeometryLab2D wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = GeometryLab2D_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in polygonButton.
function polygonButton_Callback(hObject, eventdata, handles)
% hObject    handle to polygonButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
posSize = get(handles.figure1, 'Position');
[userSelection, numSides] = polyDiaBox('Title', 'Plotting Polygon');

switch userSelection
    case 'Cancel'
        % Do Nothing
    case 'OK'
        axes(handles.axes2);
        axis manual;
        hold on;
        hideInterPoints_Callback(handles.hideInterPoints, eventdata, handles);
        % gets x y from user's mouse click on the axes
        [x y] = ginput(str2num(numSides));
        xy = [x y];
        for i = 1:size(xy, 1)-1
            for j = i + 1:size(xy, 1)
                if xy(i, :) == xy(j, :)
                    msgbox('Don''t click on the same point!', 'Alert');
                    return
                end
            end
        end
        xy = [x y];
        polyDraw= [];

        for i = 1:size(xy, 1)
            if size(xy, 1) == i
                polyDraw = [polyDraw; [xy(i, :) xy(1, :)]];
            else
                polyDraw = [polyDraw; [xy(i, :) xy(i+1, :)]];
            end
        end
        handles.lines = [handles.lines; polyDraw];
        if size(polyDraw, 1) > 0
            handles.plottedLines = [handles.plottedLines; drawPolys(polyDraw)];
        end        
        guidata(hObject,handles);
end

% --- Executes on button press in circlesButton.
function circlesButton_Callback(hObject, eventdata, handles)
% hObject    handle to circlesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
posSize = get(handles.figure1, 'Position');
userSelection = circleDiaBox('Title', 'Plotting Circle');

switch userSelection
    case 'Cancel'
        % Do Nothing
    case 'OK'
        axes(handles.axes2);
        axis manual;
        hold on;
        hideInterPoints_Callback(handles.hideInterPoints, eventdata, handles);
        [x y] = ginput(2);

        if [x(1) y(1)] == [x(2) y(2)]
            msgbox('Don''t click on the same point!', 'Alert');
            return
        end
        n= 360;
        center = [x(1) y(1)];
        r = norm([x(2) - x(1), y(2) - y(1)]);
        circle = [center r];
        handles.circles = [handles.circles; circle];
        handles.plottedCircs = [handles.plottedCircs; drawCircs(handles.circles)];
        guidata(hObject,handles);
end

% --- Executes on button press in showIntersectPointsButton.
function showIntersectPointsButton_Callback(hObject, eventdata, handles)
% hObject    handle to showIntersectPointsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[LL, LC, CC] = intersects(handles.lines, handles.circles);

delete(handles.LLplot);
delete(handles.LCplot);
delete(handles.CCplot);

%plotting lines interserction
for i = 1:size(LL, 1)
    handles.LLplot = [handles.LLplot; plot(LL(i,1), LL(i,2), 'o',...
        'MarkerFaceColor','g','MarkerEdgeColor','b', 'LineWidth', 1.5)];
end
% plotting lines circles intersection
for i = 1:size(LC, 1)
    handles.LCplot = [handles.LCplot; plot(LC(i,1), LC(i,2), 'o',...
        'MarkerFaceColor','y','MarkerEdgeColor','r', 'LineWidth', 1.5)];
end
% plotting circles intersection 
for i = 1:size(CC, 1)
    handles.CCplot = [handles.CCplot; plot(CC(i,1), CC(i,2), 'o',...
        'MarkerFaceColor','c','MarkerEdgeColor','m', 'LineWidth', 1.5)];
end

guidata(hObject,handles);

% --- Executes on button press in hideInterPoints.
function hideInterPoints_Callback(hObject, eventdata, handles)
% hObject    handle to hideInterPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.LLplot);
delete(handles.LCplot);
delete(handles.CCplot);
handles.LLplot = [];
handles.LCplot = [];
handles.CCplot = [];
guidata(hObject, handles);

% --- Executes on button press in saveShapes.
function saveShapes_Callback(hObject, eventdata, handles)
% hObject    handle to saveShapes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

lines = handles.lines;
circles = handles.circles;
% opens a dialog box for user to enter filename in a specific folder
[file path] = uiputfile('*.mat', 'Save Shapes As');
% joins the path and filenames together and converts this to string scalar.
filename = convertCharsToStrings(fullfile(path, file));
%disp(path);
% disp(file)
% whos file
% disp(filename);
%whos filename;
if ~isequal(file, 0)
    save(filename, 'lines', 'circles');
end

% --- Executes on button press in loadShapes.
function loadShapes_Callback(hObject, eventdata, handles)
% hObject    handle to loadShapes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes2);
axis manual;
hold on;
lines = [];
circles = [];
lineRsize = size(lines, 1);
circRsize = size(circles, 1);
noShapesMsg = "No shapes found on the file!. Continue with your current shapes.";
% warning message before continuing
waitfor(warndlg('Loading shapes from file may overwrite the current shapes', 'Warning'));

[file path] = uigetfile('*.mat', 'Select a .mat file to open');
% if user selected a file and not cancelled
if ~isequal(file, 0)
    filename = convertCharsToStrings(fullfile(path, file));
    %clear all;
    loadvarShapes = load(filename);
    % check the variables in the file
    varList = who('-file', filename);    
    % checks if lines and circles variable exist on file
    checkVarOnFile = [ismember('lines', varList) ismember('circles', varList)];
    
    % assigning values to lines and circle when either/both exist in file
    if (checkVarOnFile == [1 1])
        lines = loadvarShapes.lines;
        lineRsize = size(lines, 1);
        circles = loadvarShapes.circles;
        circRsize = size(circles, 1);
    elseif (checkVarOnFile == [0 1])
        circles = loadvarShapes.circles;
        circRsize = size(circles, 1);
    elseif (checkVarOnFile == [1 0])
        lines = loadvarShapes.lines;
        lineRsize = size(lines, 1);
    end
    
    % clears the shapes on the axes when either/both variables is not empty
    if ((lineRsize > 0) & (circRsize == 0)) | ((lineRsize == 0) & (circRsize > 0)) | ...
            ((lineRsize > 0) & (circRsize > 0))
        cla(handles.axes2);
    end
    
    % plots the polygons
    if lineRsize > 0
        handles.lines = lines;
        delete(handles.plottedLines);
        handles.plottedLines = drawPolys(handles.lines);
    end
    % plots the circles
    if circRsize > 0
        handles.circles = circles;
        delete(handles.plottedCircs);
        handles.plottedCircs = drawCircs(handles.circles);
    end        

    if (checkVarOnFile == [0 0]) | ((lineRsize == 0) & (circRsize == 0))
        msgbox(noShapesMsg, 'Alert');
    end
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function polygonButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to polygonButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over circlesButton.
function circlesButton_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to circlesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in clearAxes.
function clearAxes_Callback(hObject, eventdata, handles)
% hObject    handle to clearAxes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warnDeletion = questdlg({'This action is irreversible!';'Do you want to continue?'},...
    'Warning!', 'OK', 'Cancel', 'Cancel');
switch warnDeletion
    case 'OK'
        cla(handles.axes2);
        handles.lines = [];
        handles.circles = [];
        handles.LLplot = [];
        handles.LCplot = [];
        handles.CCplot = [];
        guidata(hObject, handles);
    case 'Cancel'
        %do nothing
end
% --- Executes on button press in deleteLines.
function deleteLines_Callback(hObject, eventdata, handles)
% hObject    handle to deleteLines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warnDeletion = questdlg({'This action is irreversible!';'Do you want to continue?'},...
    'Warning!', 'OK', 'Cancel', 'Cancel');
switch warnDeletion
    case 'OK'
        delete(handles.plottedLines);
        handles.plottedLines = [];
        handles.lines = [];
        delete(handles.LLplot);
        delete(handles.LCplot);
        handles.LLplot = [];
        handles.LCplot = [];
        guidata(hObject, handles);
    case 'Cancel'
        %do nothing
end

% --- Executes on button press in deleteCircs.
function deleteCircs_Callback(hObject, eventdata, handles)
% hObject    handle to deleteCircs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
warnDeletion = questdlg({'This action is irreversible!';'Do you want to continue?'},...
    'Warning!', 'OK', 'Cancel', 'Cancel');
switch warnDeletion
    case 'OK'
        delete(handles.plottedCircs);
        handles.plottedCircs = [];
        handles.circles = [];
        delete(handles.LCplot);
        delete(handles.CCplot);
        handles.LCplot = [];
        handles.CCplot = [];
        guidata(hObject, handles);
    case 'Cancel'
        %do nothing
end

% --- Executes on button press in upLines.
function upLines_Callback(hObject, eventdata, handles)
% hObject    handle to upLines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
proUp = [1 0; 0 2];
hideInterPoints_Callback(handles.hideInterPoints, eventdata, handles);
delete(handles.plottedLines);
handles.lines = transformShapes(proUp, handles.lines);
handles.plottedLines = drawPolys(handles.lines);
guidata(hObject, handles);

% --- Executes on button press in downLines.
function downLines_Callback(hObject, eventdata, handles)
% hObject    handle to downLines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
proDown = [1 0; 0 0.5];
hideInterPoints_Callback(handles.hideInterPoints, eventdata, handles);
delete(handles.plottedLines);
handles.lines = transformShapes(proDown, handles.lines);
handles.plottedLines = drawPolys(handles.lines);
guidata(hObject, handles);

% --- Executes on button press in leftLines.
function leftLines_Callback(hObject, eventdata, handles)
% hObject    handle to leftLines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
proLeft = [0.5 0;0 1];
hideInterPoints_Callback(handles.hideInterPoints, eventdata, handles);
delete(handles.plottedLines);
handles.lines = transformShapes(proLeft, handles.lines);
handles.plottedLines = drawPolys(handles.lines);
guidata(hObject, handles);

% --- Executes on button press in rghtLines.
function rghtLines_Callback(hObject, eventdata, handles)
% hObject    handle to rghtLines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
proRight = [2 0; 0 1];
hideInterPoints_Callback(handles.hideInterPoints, eventdata, handles);
delete(handles.plottedLines);
handles.lines = transformShapes(proRight, handles.lines);
handles.plottedLines = drawPolys(handles.lines);
guidata(hObject, handles);

% --- Executes on button press in rot90circs.
function rot90circs_Callback(hObject, eventdata, handles)
% hObject    handle to rot90circs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% rotate by 90° anti clockwise
rot90AntiC = [0 -1; 1 0];
hideInterPoints_Callback(handles.hideInterPoints, eventdata, handles);
delete(handles.plottedCircs);
handles.circles = transformShapes(rot90AntiC, handles.circles);
handles.plottedCircs = drawCircs(handles.circles);
guidata(hObject, handles);

% --- Executes on button press in rot180Circ.
function rot180Circ_Callback(hObject, eventdata, handles)
% hObject    handle to rot180Circ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rot180AntiC = [-1 0; 0 -1];
hideInterPoints_Callback(handles.hideInterPoints, eventdata, handles);
delete(handles.plottedCircs);
handles.circles = transformShapes(rot180AntiC, handles.circles);
handles.plottedCircs = drawCircs(handles.circles);
guidata(hObject, handles);

% --- Executes on button press in horFlipCirc.
function horFlipCirc_Callback(hObject, eventdata, handles)
% hObject    handle to horFlipCirc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% horizontal flip
horFlip = [-1 0; 0 1];
hideInterPoints_Callback(handles.hideInterPoints, eventdata, handles);
delete(handles.plottedCircs);
handles.circles = transformShapes(horFlip, handles.circles);
handles.plottedCircs = drawCircs(handles.circles);
guidata(hObject, handles);

% --- Executes on button press in verFlipCircs.
function verFlipCircs_Callback(hObject, eventdata, handles)
% hObject    handle to verFlipCircs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% vertical flip
verFlip = [1 0; 0 -1];
hideInterPoints_Callback(handles.hideInterPoints, eventdata, handles);
delete(handles.plottedCircs);
handles.circles = transformShapes(verFlip, handles.circles);
handles.plottedCircs = drawCircs(handles.circles);
guidata(hObject, handles);

% --- Executes on button press in upCircs.
function upCircs_Callback(hObject, eventdata, handles)
% hObject    handle to upCircs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% projection up y-axis
proUp = [1 0; 0 2];
hideInterPoints_Callback(handles.hideInterPoints, eventdata, handles);
delete(handles.plottedCircs);
handles.circles = transformShapes(proUp, handles.circles);
handles.plottedCircs = drawCircs(handles.circles);
guidata(hObject, handles);

% --- Executes on button press in downCircs.
function downCircs_Callback(hObject, eventdata, handles)
% hObject    handle to downCircs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% projection down y-axis
proDown = [1 0; 0 0.5];
hideInterPoints_Callback(handles.hideInterPoints, eventdata, handles);
delete(handles.plottedCircs);
handles.circles = transformShapes(proDown, handles.circles);
handles.plottedCircs = drawCircs(handles.circles);
guidata(hObject, handles);

% --- Executes on button press in leftCircs.
function leftCircs_Callback(hObject, eventdata, handles)
% hObject    handle to leftCircs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%projection left x-axis
proLeft = [0.5 0;0 1];
hideInterPoints_Callback(handles.hideInterPoints, eventdata, handles);
delete(handles.plottedCircs);
handles.circles = transformShapes(proLeft, handles.circles);
handles.plottedCircs = drawCircs(handles.circles);
guidata(hObject, handles);

% --- Executes on button press in rightCircs.
function rightCircs_Callback(hObject, eventdata, handles)
% hObject    handle to rightCircs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%projection right x-axis
proRight = [2 0; 0 1];
hideInterPoints_Callback(handles.hideInterPoints, eventdata, handles);
delete(handles.plottedCircs);
handles.circles = transformShapes(proRight, handles.circles);
handles.plottedCircs = drawCircs(handles.circles);
guidata(hObject, handles);  


% --- Executes on button press in rot90Lines.
function rot90Lines_Callback(hObject, eventdata, handles)
% hObject    handle to rot90Lines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% rotate by 90 anti clockwise
rot90AntiC = [0 -1; 1 0];
hideInterPoints_Callback(handles.hideInterPoints, eventdata, handles);
delete(handles.plottedLines);
handles.lines = transformShapes(rot90AntiC, handles.lines);
handles.plottedLines = drawPolys(handles.lines);
guidata(hObject, handles);

% --- Executes on button press in rot180Lines.
function rot180Lines_Callback(hObject, eventdata, handles)
% hObject    handle to rot180Lines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% rotate by 180 anti clockwise
rot180AntiC = [-1 0; 0 -1];
hideInterPoints_Callback(handles.hideInterPoints, eventdata, handles);
delete(handles.plottedLines);
handles.lines = transformShapes(rot180AntiC, handles.lines);
handles.plottedLines = drawPolys(handles.lines);
guidata(hObject, handles);

% --- Executes on button press in horFlipLines.
function horFlipLines_Callback(hObject, eventdata, handles)
% hObject    handle to horFlipLines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% horizontal flip
horFlip = [-1 0; 0 1];
hideInterPoints_Callback(handles.hideInterPoints, eventdata, handles);
delete(handles.plottedLines);
handles.lines = transformShapes(horFlip, handles.lines);
handles.plottedLines = drawPolys(handles.lines);
guidata(hObject, handles);

% --- Executes on button press in verFlipLines.
function verFlipLines_Callback(hObject, eventdata, handles)
% hObject    handle to verFlipLines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% vertical flip
verFlip = [1 0; 0 -1];
hideInterPoints_Callback(handles.hideInterPoints, eventdata, handles);
delete(handles.plottedLines);
handles.lines = transformShapes(verFlip, handles.lines);
handles.plottedLines = drawPolys(handles.lines);
guidata(hObject, handles);


% --- Executes on button press in incSizePoly.
function incSizePoly_Callback(hObject, eventdata, handles)
% hObject    handle to incSizePoly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% increase size
incSize = [2 0; 0 2];
hideInterPoints_Callback(handles.hideInterPoints, eventdata, handles);
delete(handles.plottedLines);
handles.lines = transformShapes(incSize, handles.lines);
handles.plottedLines = drawPolys(handles.lines);
guidata(hObject, handles);

% --- Executes on button press in decSizePoly.
function decSizePoly_Callback(hObject, eventdata, handles)
% hObject    handle to decSizePoly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% decrease size
decSize = [0.5 0; 0 0.5];
delete(handles.plottedLines);
handles.lines = transformShapes(decSize, handles.lines);
handles.plottedLines = drawPolys(handles.lines);
guidata(hObject, handles);
