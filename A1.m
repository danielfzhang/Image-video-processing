function varargout = A1(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @A1_OpeningFcn, ...
                   'gui_OutputFcn',  @A1_OutputFcn, ...
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


% --- Executes just before A1 is made visible.
function A1_OpeningFcn(hObject, eventdata, handles, varargin)

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to A1 (see VARARGIN)

% Choose default command line output for A1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes A1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%as program being executed, show original color image
set(handles.pushbutton1,'visible','off');
set(handles.pushbutton2,'visible','off');
set(handles.pushbutton3,'visible','off');
set(handles.pushbutton4,'visible','off');
set(handles.pushbutton5,'visible','off');
set(handles.pushbutton6,'visible','off');





% --- Outputs from this function are returned to the command line.
function varargout = A1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global orimg
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%clean exes2
cla(handles.axes2);
set(handles.axes2,'visible','off');
%1.display original color image on axes1
axes(handles.axes1)
imshow(orimg)
title('Original Color Image');


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global grayimg
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%clean axes2
cla(handles.axes2);
set(handles.axes2,'visible','off');
%2.display grayscale image on axes1
axes(handles.axes1)
imshow(grayimg)
title('Grayscale Image');


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global grayimg
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%calculate histogram
hist_gray=imhist(grayimg);
%clean axes2
cla(handles.axes2);
set(handles.axes2,'visible','off');
%3.draw histogram on axes1
axes(handles.axes1)
bar(hist_gray)
title('Histogram of The Gray Levels');


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
global grayimg
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%perform gamma correction
gammagray=imadjust(grayimg,[],[],0.5);
%calculate histogram of gamma corrected garyscale image
hist_gammagray=imhist(gammagray); 
%show gamma corrected image on axes1
axes(handles.axes1)
imshow(gammagray)
title('Gamma Corrected Gray Image');
%4.draw histogram of gamma corrected garyscale image on axes2
axes(handles.axes2)
bar(hist_gammagray)
title('Histogram of Gamma Corrected Gray Levels');


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
global grayimg
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Image Negation
%perform imcomplementation to grayscale image 
[max_x,max_y]=size(grayimg);%number of pixels in a row and a column
for x=1:max_x
    for y=1:max_y
        %for every pixel
        negimg(x,y)=255-grayimg(x,y);% subtracted from maximal grey levels
    end
end
%calculate histogram of Negtive Transfered Gray Levels
hist_neg=imhist(negimg);
%show negtive transfered grayscale image on axes1
axes(handles.axes1)
imshow(negimg)
title('Negtive Transfered Gray Image');
%draw Histogram of Negtive Transfered Gray Levels on axes2
axes(handles.axes2)
bar(hist_neg)
title('Histogram of Negtive Transfered Gray Levels');


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
global grayimg
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%n*n dithering matrix
n=4;
%D dither matrixes
D1= [0,8,2,10;12,4,14,6;3,11,1,9;15,7,13,5];
D2= [0,14,3,13;11,5,8,6;12,2,15,1;7,9,4,10];
D3= [0,1,2,3;4,5,6,7;8,9,10,11;12,13,14,15];
D4= [0,11,6,13;12,7,9,2;3,8,5,14;15,4,10,1];
D5= [13,0,11,6;2,12,7,9;14,3,8,5;1,15,4,10];
D6= [6,7,8,9;5,0,1,10;4,3,2,11;15,14,13,12];
%remap image
I=grayimg .* ((n*n+1)/256);
%perform ordered dithering
[max_x,max_y]=size(grayimg);
for x = 0:max_x-1
    for y = 0:max_y-1
        i=mod(x,n);
        j=mod(y,n);
        if I(x+1,y+1)>D1(i+1,j+1)
            O(x+1,y+1)=1;
        else
            O(x+1,y+1)=0;
        end
    end
end
%clean axes2
cla(handles.axes2);
set(handles.axes2,'visible','off');
%show ordered image on axes1
axes(handles.axes1)
imshow(O)
title('Ordered Dithering with matrix 1');


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global orimg
global grayimg
imgfile=uigetfile('*.jpg; *.JPG; *.jpeg; *.JPEG;*.png;*.PNG');
orimg=imread(imgfile);
grayimg=rgb2gray(orimg);
axes(handles.axes1)
imshow(orimg)
title('Original Color Image');
set(handles.pushbutton1,'visible','on');
set(handles.pushbutton2,'visible','on');
set(handles.pushbutton3,'visible','on');
set(handles.pushbutton4,'visible','on');
set(handles.pushbutton5,'visible','on');
set(handles.pushbutton6,'visible','on');