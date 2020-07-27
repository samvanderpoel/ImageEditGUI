function varargout = ImageEditor(varargin)
% 

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImageEditor_OpeningFcn, ...
                   'gui_OutputFcn',  @ImageEditor_OutputFcn, ...
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


% --- Executes just before ImageEditor is made visible.
function ImageEditor_OpeningFcn(hObject, eventdata, handles, varargin) %#ok<*INUSL>
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImageEditor (see VARARGIN)

% Choose default command line output for ImageEditor
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImageEditor wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Remove numbers and ticks from axes
set(handles.Axis1, 'XTick', [], 'YTick', []);
set(handles.Axis2, 'XTick', [], 'YTick', []);

% Set empty image data records
setappdata(handles.Axis1, 'ImageStatus', []);
setappdata(handles.Axis1, 'RealImageStatus', []);
% Initialize 'RotateCount' of image zero
setappdata(handles.Axis2, 'RotateCount', 0);

% --- Outputs from this function are returned to the command line.
function varargout = ImageEditor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadImage.
function LoadImage_Callback(hObject, eventdata, handles)
% hObject    handle to LoadImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Prompty user to select image
[filename, pathname] = uigetfile('*.jpg;*.png;*.tiff;*.gif;*.jpeg',...
                                 'Pick an Image');
if filename == 0
    % If dialog box was cancelled
    return
else
    % Set 'Filename'
    setappdata(handles.Axis1,'Filename', filename);
    imgdir = fullfile(pathname, filename);
    % Read and display img data
    picData = imread(imgdir);
    image(picData, 'Parent', handles.Axis1);
    imgHandle = image(picData, 'Parent', handles.Axis2);
    % Remove numbers and ticks from axes
    set(handles.Axis1,'XTick', [], 'YTick', []);
    set(handles.Axis2,'XTick', [], 'YTick', []);
    % Store img handle and initial data
    handles.pic = imgHandle;
    guidata(hObject, handles);
    setappdata(handles.Axis1, 'CData', picData);
    setappdata(handles.Axis1, 'ImageStatus', picData);
    setappdata(handles.Axis1, 'RealImageStatus', picData);
    % Set sliders to neutral position
    set(handles.RedSlider,'Value',0.5);
    set(handles.GreenSlider,'Value',0.5);
    set(handles.BlueSlider,'Value',0.5);
    set(handles.BrightSlider,'Value',0.5);
    set(handles.ZoomSlider,'Value',0);
end


% --- Executes on slider movement.
function RedSlider_Callback(hObject, eventdata, handles)
% hObject    handle to RedSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Get img data
ImgCurrent = getappdata(handles.Axis1, 'RealImageStatus');
if ~isempty(ImgCurrent)
    % Get 'red' and 'brightness' slider info
    valueRed = get(handles.RedSlider, 'Value');
    valueBright = get(handles.BrightSlider, 'Value');
    % Alter current img data
    ImgData = get(handles.pic, 'CData');
    ImgData(:, :, 1) = ImgCurrent(:, :, 1) + 500*(valueRed + valueBright - 1);
    % Display imgdata on bottom GUI axis
    imgHandle = image(ImgData, 'Parent', handles.Axis2);
    % Remove numbers and ticks from axes
    set(handles.Axis2,'XTick', [], 'YTick', []);
    % Assign new img handle to field 'pic' in handles struct
    handles.pic = imgHandle;
    guidata(hObject, handles);
else
    return
end


% --- Executes during object creation, after setting all properties.
function RedSlider_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD>
% hObject    handle to RedSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function GreenSlider_Callback(hObject, eventdata, handles)
% hObject    handle to GreenSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Get img data
ImgCurrent = getappdata(handles.Axis1, 'RealImageStatus');
if ~isempty(ImgCurrent)
    % Get 'green' and 'brightness' slider info
    valueGreen = get(handles.GreenSlider, 'Value');
    valueBright = get(handles.BrightSlider, 'Value');
    % Alter current img data
    ImgData = get(handles.pic, 'CData');
    ImgData(:,:,2) = ImgCurrent(:,:,2) + 500*(valueGreen + valueBright - 1);
    % Display imgdata on bottom GUI axis
    imgHandle = image(ImgData, 'Parent', handles.Axis2);
    % Remove numbers and ticks from axes
    set(handles.Axis2, 'XTick', [], 'YTick', []);
    % Assign new img handle to field 'pic' in handles struct
    handles.pic = imgHandle;
    guidata(hObject,handles);
else
    return
end

% --- Executes during object creation, after setting all properties.
function GreenSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GreenSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function BlueSlider_Callback(hObject, eventdata, handles)
% hObject    handle to BlueSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Get img data
ImgCurrent = getappdata(handles.Axis1, 'RealImageStatus');
if ~isempty(ImgCurrent)
    % Get 'blue' and 'brightness' slider info
    valueBlue = get(handles.BlueSlider, 'Value');
    valueBright = get(handles.BrightSlider, 'Value');
    % Alter current img data
    ImgData = get(handles.pic, 'CData');
    ImgData(:,:,3) = ImgCurrent(:,:,3) + 500*(valueBlue + valueBright - 1);
    % Display imgdata on bottom GUI axis
    imgHandle = image(ImgData, 'Parent', handles.Axis2);
    % Remove numbers and ticks from axes
    set(handles.Axis2, 'XTick', [], 'YTick', []);
    % Assign new img handle to field 'pic' in handles struct
    handles.pic = imgHandle;
    guidata(hObject, handles);
else
    return
end


% --- Executes during object creation, after setting all properties.
function BlueSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BlueSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function BrightSlider_Callback(hObject, eventdata, handles)
% hObject    handle to BrightSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Get img data
ImgData = getappdata(handles.Axis1, 'RealImageStatus');
if ~isempty(ImgData)
    % Obtain red, green, blue, brightness slider info
    valueRed = get(handles.RedSlider, 'Value');
    valueGreen = get(handles.GreenSlider, 'Value');
    valueBlue = get(handles.BlueSlider, 'Value');
    valueBright = get(handles.BrightSlider, 'Value');
    % Alter current img data
    ImgData(:,:,1) = ImgData(:,:,1) + 500*(valueRed + valueBright - 1);
    ImgData(:,:,2) = ImgData(:,:,2) + 500*(valueGreen + valueBright - 1);
    ImgData(:,:,3) = ImgData(:,:,3) + 500*(valueBlue + valueBright - 1);
    % Display imgdata on bottom GUI axis
    imgHandle = image(ImgData,'Parent',handles.Axis2);
    % Remove numbers and ticks from axes
    set(handles.Axis2,'XTick',[], 'YTick', []);
    % Assign new img handle to field 'pic' in handles struct
    handles.pic = imgHandle;
    guidata(hObject,handles);
else
    return
end


% --- Executes during object creation, after setting all properties.
function BrightSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BrightSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function ZoomSlider_Callback(hObject, eventdata, handles)
% hObject    handle to ZoomSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Retrieve current 'ImageStatus' data, which tells us the
% orientation of the current image
ImgData = getappdata(handles.Axis1, 'ImageStatus');
% Obtain all slider data
valueZoom = get(handles.ZoomSlider, 'Value');
valueRed = get(handles.RedSlider, 'Value');
valueGreen = get(handles.GreenSlider, 'Value');
valueBlue = get(handles.BlueSlider, 'Value');
valueBright = get(handles.BrightSlider, 'Value');
% If zoom slider value  zero, upload original img data to
% 'RealImageStatus' property
if valueZoom == 0
    setappdata(handles.Axis1, 'RealImageStatus', ImgData);
    % Modify the img
    ImgData(:,:,1) = ImgData(:,:,1) + 500*(valueRed + valueBright - 1);
    ImgData(:,:,2) = ImgData(:,:,2) + 500*(valueGreen + valueBright - 1);
    ImgData(:,:,3) = ImgData(:,:,3) + 500*(valueBlue + valueBright - 1);
    % Upload this image to the axes
    imgHandle = image(ImgData,'Parent',handles.Axis2);
    % Remove ticks and tick labels
    set(handles.Axis2,'XTick',[], 'YTick', []);
    handles.pic = imgHandle;
    guidata(hObject,handles);
else
    % If ImgData is not empty, carry on with zoom modifications
    if ~isempty(ImgData)
        % Shape of current img
        [m, n, o] = size(ImgData);
        % Calculate new upper, lower bounds of indexes that will
        % be used to zoom in the image
        m_lower = floor( (9/10) * ceil(m*valueZoom/2) );
        m_upper = m - floor( (9/10) * ceil(m*valueZoom/2) );
        n_lower = floor( (9/10) * ceil(n*valueZoom/2) );
        n_upper = n - floor( (9/10) * ceil(n*valueZoom/2) );
        % Create new img arr by indexing the prior image
        NewImgData = ImgData(m_lower:m_upper,n_lower:n_upper,:);
        % Update this img data to 'RealImageStatus'
        setappdata(handles.Axis1, 'RealImageStatus', NewImgData);
        % Alter coloration according to current slider data
        NewImgData(:,:,1) = NewImgData(:,:,1) + 500*(valueRed + valueBright - 1);
        NewImgData(:,:,2) = NewImgData(:,:,2) + 500*(valueGreen + valueBright - 1);
        NewImgData(:,:,3) = NewImgData(:,:,3) + 500*(valueBlue + valueBright - 1);
        imgHandle = image(NewImgData, 'Parent', handles.Axis2);
        set(handles.Axis2,'XTick', [], 'YTick', []);
        handles.pic = imgHandle;
        guidata(hObject,handles);
    else
        return
    end
end


% --- Executes during object creation, after setting all properties.
function ZoomSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZoomSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in RotateImage.
function RotateImage_Callback(hObject, eventdata, handles)
% hObject    handle to RotateImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
temp = getappdata(handles.Axis1, 'ImageStatus');
if ~isempty(temp)
    % Rotate img data w/ nested for loops
    ImgData = get(handles.pic, 'CData');
    [m,n,o] = size(ImgData);
    NewImgData = zeros(n, m, o, 'uint8');
    for kk = 1:o
        for ii = 1:m
            for jj = 1:n
                hh = n-jj+1;
                NewImgData(hh, ii, kk) = ImgData(ii, jj, kk);
            end
        end
    end
    % Display resulting img to axes
    imgHandle = image(NewImgData, 'Parent', handles.Axis2);
    % Remove numbers and ticks from the axes
    set(handles.Axis2,'XTick', [], 'YTick', []);
    % Assign new img handle to 'pic' in handles struct
    handles.pic = imgHandle;
    guidata(hObject, handles);
    % Gather current rotate cnt
    currentRotateCount = getappdata(handles.Axis2, 'RotateCount');
    % Increment rotate cnt
    RotateCount = currentRotateCount + 1;
    % Update current rotate cnt using setappdata function
    setappdata(handles.Axis2,'RotateCount', RotateCount);
    ImgOrgnl = getappdata(handles.Axis1, 'CData');
    % Obtain size of original img data
    [m, n, o]=size(ImgOrgnl);
    if ~mod(RotateCount, 4)
        % Orientation is same as original
        setappdata(handles.Axis1, 'ImageStatus', ImgOrgnl);
    elseif mod(RotateCount, 4) == 1
        % Orientation 90 degs ccw
        NewImgData = zeros(n ,m, o, 'uint8');
        for kk = 1:o
            for ii = 1:m
                for jj = 1:n
                    hh = n-jj+1;
                    NewImgData(hh, ii, kk) = ImgOrgnl(ii, jj, kk);
                end
            end
        end
        setappdata(handles.Axis1, 'ImageStatus', NewImgData);
    elseif mod(RotateCount, 4) == 2
        % Orientation is a 180 deg rotation
        NewImgData = zeros(m,n,o,'uint8');
        for kk = 1:o
            for ii = 1:m
                for jj = 1:n
                    hh = m-ii+1;
                    ll = n-jj+1;
                    NewImgData(hh,ll,kk) = ImgOrgnl(ii, jj, kk);
                end
            end
        end
        setappdata(handles.Axis1, 'ImageStatus', NewImgData);
    else
        % Orientation is 270 deg ccw
        NewImgData = zeros(n,m,o,'uint8');
        for kk = 1:o
            for ii = 1:m
                for jj = 1:n
                    hh = m-ii+1;
                    NewImgData(jj, hh, kk) = ImgOrgnl(ii, jj, kk);
                end
            end
        end
        setappdata(handles.Axis1, 'ImageStatus', NewImgData);
    end
    % Update RealImageStatus
    RealImageStatus = getappdata(handles.Axis1, 'RealImageStatus');
    [m, n, o] = size(RealImageStatus);
    NewImgStatus = zeros(n, m, o, 'uint8');
    for kk = 1:o
        for ii = 1:m
            for jj = 1:n
                hh = n-jj+1;
                NewImgStatus(hh, ii, kk) = RealImageStatus(ii, jj, kk);
            end
        end
    end
    setappdata(handles.Axis1, 'RealImageStatus', NewImgStatus);
else
    return
end


% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Reset slider values to neutral positions
set(handles.RedSlider, 'Value', 0.5);
set(handles.GreenSlider, 'Value', 0.5);
set(handles.BlueSlider, 'Value', 0.5);
set(handles.BrightSlider, 'Value', 0.5);
set(handles.ZoomSlider, 'Value', 0);
ImgStatus = getappdata(handles.Axis1, 'ImageStatus');
if ~isempty(ImgStatus)
    ImgData = getappdata(handles.Axis1, 'CData');
    imgHandle = image(ImgData, 'Parent', handles.Axis2);
    % Remove numbers and ticks from the axes
    set(handles.Axis2, 'XTick', [], 'YTick', []);
    % Assign new img handle to field 'pic' in the handles struct
    handles.pic = imgHandle;
    guidata(hObject, handles);
    % Update user defined properties to initial conditions
    setappdata(handles.Axis1, 'ImageStatus', ImgData);
    setappdata(handles.Axis1, 'RealImageStatus', ImgData);
    setappdata(handles.Axis2, 'RotateCount', 0);
else
    return
end


% --- Executes on button press in SaveImage.
function SaveImage_Callback(hObject, eventdata, handles)
% hObject    handle to SaveImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
ImgStatus = getappdata(handles.Axis1, 'ImageStatus');
if ~isempty(ImgStatus)
    % Retrieve current img data from the handles struct
    ImgData = get(handles.pic, 'CData');
    % Get current file name, prepend 'EDIT_' for save file
    CurrentFileName = getappdata(handles.Axis1, 'Filename');
    NewFileName = strcat('EDIT_', CurrentFileName);
    % Let user select folder to save file
    saveDir = uigetdir();
    if saveDir == 0
        return
    else
        FilePath = fullfile(saveDir, NewFileName);
        imwrite(ImgData, FilePath);
    end
else
    return
end


% --- Executes on button press in ExitButton.
function ExitButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
ButtonName = questdlg('Are you sure? Your changes will be lost.', ...
                      'Warning', 'Yes', 'No', 'No');
switch ButtonName
    % If yes, closereq to close the GUI
    case 'Yes'
        closereq;
    % If no, return to continue the program
    case 'No'
        return
end


% --- Executes during object creation, after setting all properties.
function Axis1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Axis1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate Axis1
