function varargout = A2(varargin)
% A2 MATLAB code for A2.fig
%      A2, by itself, creates a new A2 or raises the existing
%      singleton*.
%
%      H = A2 returns the handle to a new A2 or the handle to
%      the existing singleton*.
%
%      A2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in A2.M with the given input arguments.
%
%      A2('Property','Value',...) creates a new A2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before A2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to A2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help A2

% Last Modified by GUIDE v2.5 13-Mar-2017 17:46:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @A2_OpeningFcn, ...
                   'gui_OutputFcn',  @A2_OutputFcn, ...
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


% --- Executes just before A2 is made visible.
function A2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to A2 (see VARARGIN)

% Choose default command line output for A2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes A2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = A2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.axes1);
cla(handles.axes2);
set(handles.axes1,'visible','off');
set(handles.axes2,'visible','off');
global scene
global sprite
% merge 2 images and display merged image
img_scene=imread(scene);
img_sprite=imread(sprite);
[x_scene,y_scene,z_scene]=size(img_scene);
[x_sprite,y_sprite,z_sprite]=size(img_sprite);

%if sprite image is bigger than scene, switch them
if x_sprite>x_scene && y_sprite>y_scene
    temp=img_scene;
    img_scene=img_sprite;
    img_sprite=temp;
    [x_scene,y_scene,z_scene]=size(img_scene);
    [x_sprite,y_sprite,z_sprite]=size(img_sprite);
end
rowshift=str2num(get(handles.edit4,'string'));
colshift=str2num(get(handles.edit3,'string'));
%if the pixel in sprite is not black, merge the pixel to scene
for i=1:x_sprite
    for j=1:y_sprite
       if img_sprite(i,j,1)>60 || img_sprite(i,j,2)>50 || img_sprite(i,j,3)>50
           img_scene(i+rowshift,j+colshift,1)=img_sprite(i,j,1);
           img_scene(i+rowshift,j+colshift,2)=img_sprite(i,j,2);
           img_scene(i+rowshift,j+colshift,3)=img_sprite(i,j,3);
       end
    end
end
%display merged image
axes(handles.axes3);
imshow(img_scene);
axis off
%write merged image as .mrg file
%-------------------JPEG encoding---------------
%convert RGB to YUV
RGB=double(img_scene);
R = RGB(:,:,1);
G = RGB(:,:,2);
B = RGB(:,:,3);
Y = 0.299*R + 0.587*G + 0.114*B;
U = -0.14713*R - 0.28886*G + 0.436*B;
V = 0.615*R - 0.51499*G - 0.10001*B;
%expand matrixes if them cannot be exactly divided into 8*8 blocks 
%result(Y U V)
[x y]=size(Y);
x_expand=0;
y_expand=0;
if mod(x,8)~=0%expand rows
    x_expand=8-mod(x,8);
    x0_expand=repmat(0,x_expand,y);
    Y=[Y;x0_expand];
    U=[U;x0_expand];
    V=[V;x0_expand];
end
[x y]=size(Y);
if mod(y,8)~=0%expand cols
    y_expand=8-mod(y,8);
    y0_expand=repmat(130,x,y_expand);
    Y=[Y y0_expand];
    U=[U y0_expand];
    V=[V y0_expand];
end
%4:2:0 chroma subsampling 
%result(Y_420 U_420 V_420)
[x y]=size(Y);
Y_420=Y;
U_420=zeros(x/4,y/4);
V_420=zeros(x/4,y/4);
x_index=1;
for i=1:2:x
    y_index=1;
    for j=1:2:y
        U_420(x_index,y_index)=U(i,j);%U downsampling
        V_420(x_index,y_index)=V(i+1,j+1);%V downsampling
        y_index=y_index+1;
    end
    x_index=x_index+1;
end
%DCT transform 
%result(Y_DCT U_DCT V_DCT)
fundct = @(block_struct) dct2(block_struct.data);
Y_DCT=blockproc(Y_420,[8 8],fundct);
U_DCT=blockproc(U_420,[8 8],fundct);
V_DCT=blockproc(V_420,[8 8],fundct);
%Quantization with quantization matrix
%result(Y_QUAN U_QUAN V_QUAN)
quan_table_Y=[16 11 10 16 24 40 51 61;
    12 12 14 19 26 58 60 55;
    14 13 16 24 40 57 69 56;
    14 17 22 29 51 87 80 62;
    18 22 37 56 68 109 103 77;
    24 35 55 64 81 104 113 92;
    49 64 78 87 103 121 120 101;
    72 92 95 98 112 100 103 99];
quan_table_UV=[17 18 24 47 99 99 99 99;
    18 21 26 66 99 99 99 99;
    24 26 56 99 99 99 99 99;
    47 66 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99;
    99 99 99 99 99 99 99 99];
[x y]=size(Y_DCT);
Y_QUAN=zeros(x,y);
for i=1:x
    for j=1:y
        Y_QUAN(i,j)=round(Y_DCT(i,j)/quan_table_Y(mod(i-1,8)+1,mod(j-1,8)+1));% Y quantization
    end
end
[x y]=size(U_DCT);
U_QUAN=zeros(x,y);
V_QUAN=zeros(x,y);
for i=1:x
    for j=1:y
        U_QUAN(i,j)=round(U_DCT(i,j)/quan_table_UV(mod(i-1,8)+1,mod(j-1,8)+1));%U quantization
        V_QUAN(i,j)=round(V_DCT(i,j)/quan_table_UV(mod(i-1,8)+1,mod(j-1,8)+1));%V quantization
    end
end
%scan quan_table_Y,quan_table_UV,Y_QUAN,U_QUAN,V_QUAN,x_expand,y_expand to make them 1-d array 
output=[];
[x y]=size(quan_table_Y);%quan_table_Y
output=[output x y];
for i=1:x
    output=[output quan_table_Y(i,:)];
end
[x y]=size(quan_table_UV);%quan_table_UV
output=[output x y];
for i=1:x
    output=[output quan_table_UV(i,:)];
end
[x y]=size(Y_QUAN);%Y_QUAN
output=[output x y];
for i=1:x
    output=[output Y_QUAN(i,:)];
end
[x y]=size(U_QUAN);%U_QUAN
output=[output x y];
for i=1:x
    output=[output U_QUAN(i,:)];
end
output=[output x y];%V_QUAN
for i=1:x
    output=[output V_QUAN(i,:)];
end
output=[output x_expand y_expand];
%write file (*.mrg)
fp = fopen('result.mrg','wt');
fprintf(fp, '%d ',output);
fclose(fp);



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.axes3);
set(handles.axes3,'visible','off');
%using dialog box to select a scene image, and display it
global scene
scene=uigetfile('*.*');
axes(handles.axes1);
imshow(scene);
axis off

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cla(handles.axes3);
set(handles.axes3,'visible','off');
%using dialog box to select a sprite image, and display it
global sprite
sprite=uigetfile('*.*');
axes(handles.axes2);
imshow(sprite);
axis off
