function varargout = A2Decoder(varargin)
% A2DECODER MATLAB code for A2Decoder.fig
%      A2DECODER, by itself, creates a new A2DECODER or raises the existing
%      singleton*.
%
%      H = A2DECODER returns the handle to a new A2DECODER or the handle to
%      the existing singleton*.
%
%      A2DECODER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in A2DECODER.M with the given input arguments.
%
%      A2DECODER('Property','Value',...) creates a new A2DECODER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before A2Decoder_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to A2Decoder_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help A2Decoder

% Last Modified by GUIDE v2.5 15-Mar-2017 16:50:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @A2Decoder_OpeningFcn, ...
                   'gui_OutputFcn',  @A2Decoder_OutputFcn, ...
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


% --- Executes just before A2Decoder is made visible.
function A2Decoder_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to A2Decoder (see VARARGIN)

% Choose default command line output for A2Decoder
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes A2Decoder wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = A2Decoder_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

img_loc=uigetfile('*.mrg');
%------------------------JPEG decoding------------------
%read file
read_file=load(img_loc);
%read quantization table for Y
x=read_file(1);
y=read_file(2);
read_file(1:2)=[];
quan_table_Y=zeros(x,y);
cout=1;
for i=1:x
    for j=1:y
        quan_table_Y(i,j)=read_file(cout);
        cout=cout+1;
    end
end
read_file(1:x*y)=[];
%read quantization table for UV
x=read_file(1);
y=read_file(2);
read_file(1:2)=[];
quan_table_UV=zeros(x,y);
cout=1;
for i=1:x
    for j=1:y
        quan_table_UV(i,j)=read_file(cout);
        cout=cout+1;
    end
end
read_file(1:x*y)=[];
%read Y
x=read_file(1);
y=read_file(2);
read_file(1:2)=[];
Y_READ=zeros(x,y);
cout=1;
for i=1:x
    for j=1:y
        Y_READ(i,j)=read_file(cout);
        cout=cout+1;
    end
end
read_file(1:x*y)=[];
%read U
x=read_file(1);
y=read_file(2);
read_file(1:2)=[];
U_READ=zeros(x,y);
cout=1;
for i=1:x
    for j=1:y
        U_READ(i,j)=read_file(cout);
        cout=cout+1;
    end
end
read_file(1:x*y)=[];
%read V
x=read_file(1);
y=read_file(2);
read_file(1:2)=[];
V_READ=zeros(x,y);
cout=1;
for i=1:x
    for j=1:y
        V_READ(i,j)=read_file(cout);
        cout=cout+1;
    end
end
read_file(1:x*y)=[];
%read x_expand and y_expand
x_expand=read_file(1);
y_expand=read_file(2);
%Dequantization with quantization matrix
%result(Y_READ U_READ V_READ)
[x y]=size(Y_READ);
for i=1:x
    for j=1:y
        Y_READ(i,j)=Y_READ(i,j)*quan_table_Y(mod(i-1,8)+1,mod(j-1,8)+1);%Y dequantization with quantization matrix
    end
end
[x y]=size(U_READ);
for i=1:x
    for j=1:y
        U_READ(i,j)=U_READ(i,j)*quan_table_UV(mod(i-1,8)+1,mod(j-1,8)+1);
        V_READ(i,j)=V_READ(i,j)*quan_table_UV(mod(i-1,8)+1,mod(j-1,8)+1);
    end
end
%IDCT transform
%result(Y_IDCT U_IDCT V_IDCT)
funidct = @(block_struct) idct2(block_struct.data);
Y_IDCT=blockproc(Y_READ,[8 8],funidct);
U_IDCT=blockproc(U_READ,[8 8],funidct);
V_IDCT=blockproc(V_READ,[8 8],funidct);
%make 4 copies of chroma sample for 4 luma sample
[x y]=size(Y_IDCT);
Y=Y_IDCT;
U=zeros(x,y);
V=zeros(x,y);
x_index=1;
for i=1:2:x
    y_index=1;
    for j=1:2:y
        U(i,j)=U_IDCT(x_index,y_index);
        U(i+1,j)=U_IDCT(x_index,y_index);
        U(i,j+1)=U_IDCT(x_index,y_index);
        U(i+1,j+1)=U_IDCT(x_index,y_index);
        V(i,j)=V_IDCT(x_index,y_index);
        V(i+1,j)=V_IDCT(x_index,y_index);
        V(i,j+1)=V_IDCT(x_index,y_index);
        V(i+1,j+1)=V_IDCT(x_index,y_index);
        y_index=y_index+1;
    end
    x_index=x_index+1;
end
%remove pixel complements
[x y]=size(Y);
for i=1:x_expand
    Y(x,:)=[];
    U(x,:)=[];
    V(x,:)=[];
    x=x-1;
end
for i=1:y_expand
    Y(:,y)=[];
    U(:,y)=[];
    V(:,y)=[];
    y=y-1;
end
%convert yuv to rgb
R = Y + 1.139834576*V;
G = Y -.3946460533*U -.58060*V;
B = Y + 2.032111938*U;
RGB = cat(3,R,G,B)./255;

axes(handles.axes1);
imshow(RGB);
axis off
