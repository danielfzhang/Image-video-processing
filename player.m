function varargout = player(varargin)
% PLAYER MATLAB code for player.fig
%      PLAYER, by itself, creates a new PLAYER or raises the existing
%      singleton*.
%
%      H = PLAYER returns the handle to a new PLAYER or the handle to
%      the existing singleton*.
%
%      PLAYER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PLAYER.M with the given input arguments.
%
%      PLAYER('Property','Value',...) creates a new PLAYER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before player_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to player_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help player

% Last Modified by GUIDE v2.5 07-Apr-2017 01:20:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @player_OpeningFcn, ...
                   'gui_OutputFcn',  @player_OutputFcn, ...
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


% --- Executes just before player is made visible.
function player_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to player (see VARARGIN)

% Choose default command line output for player
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes player wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = player_OutputFcn(hObject, eventdata, handles) 
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
set(handles.pushbutton1,'visible','off');
global totalFrame
global playVideo
%display the current info
set(handles.text2,'string','parameters reading')
pause(0.005);
%reading video file
N=16;
GOP=4;
height = dlmread('data.mv',',',[0 0 0 0]);
width = dlmread('data.mv',',',[0 1 0 1]);
TotalIFrame = dlmread('data.mv',',',[0 2 0 2]);
TotalPFrame = dlmread('data.mv',',',[0 3 0 3]);
h_COUNT=1;
totalFrame=TotalIFrame+TotalPFrame;
I_Yencode=zeros(height,width,TotalIFrame);
I_Uencode=zeros(height/2,width/2,TotalIFrame);
I_Vencode=zeros(height/2,width/2,TotalIFrame);
err_Yencode=zeros(height,width,TotalPFrame);
err_Uencode=zeros(height/2,width/2,TotalPFrame);
err_Vencode=zeros(height/2,width/2,TotalPFrame);
MVs=zeros(height/N,width/N,2,TotalPFrame);


for p=1:TotalPFrame
    for i=1:2
        MVs(:,:,i,p)=dlmread('data.mv',',',[h_COUNT 0 h_COUNT+height/N-1 width/N-1]);
        h_COUNT=h_COUNT+height/N;
    end
    err_Yencode(:,:,p)=dlmread('data.mv',',',[h_COUNT 0 h_COUNT+height-1 width-1]);
    h_COUNT=h_COUNT+height;
    err_Uencode(:,:,p)=dlmread('data.mv',',',[h_COUNT 0 h_COUNT+height/2-1 width/2-1]);
    h_COUNT=h_COUNT+height/2;
    err_Vencode(:,:,p)=dlmread('data.mv',',',[h_COUNT 0 h_COUNT+height/2-1 width/2-1]);
    h_COUNT=h_COUNT+height/2;
    set(handles.text2,'string',[num2str(p) '/' num2str(TotalPFrame) ' P frames reading'])
    pause(0.005);
end
for p=1:TotalIFrame
    I_Yencode(:,:,p)=dlmread('data.mv',',',[h_COUNT 0 h_COUNT+height-1 width-1]);
    h_COUNT=h_COUNT+height;
    I_Uencode(:,:,p)=dlmread('data.mv',',',[h_COUNT 0 h_COUNT+height/2-1 width/2-1]);
    h_COUNT=h_COUNT+height/2;
    I_Vencode(:,:,p)=dlmread('data.mv',',',[h_COUNT 0 h_COUNT+height/2-1 width/2-1]);
    h_COUNT=h_COUNT+height/2;
    set(handles.text2,'string',[num2str(p) '/' num2str(TotalPFrame) ' I frames reading'])
    pause(0.005);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.text2,'string','I frame decoding')
pause(0.005);
%I frame decoding
I_decoded=zeros(height,width,3,TotalIFrame); 
for i_decode=1:TotalIFrame
    RGB=JPEGdecoder(I_Yencode(:,:,i_decode),I_Uencode(:,:,i_decode),I_Vencode(:,:,i_decode),0,0);
    I_decoded(:,:,:,i_decode)=RGB;
end
set(handles.text2,'string','Error  decoding')
pause(0.005);
%error decoding
error_decoded=zeros(height,width,3,TotalPFrame); 
for e_decode=1:TotalPFrame
    RGB=JPEGdecoder(err_Yencode(:,:,e_decode),err_Uencode(:,:,e_decode),err_Vencode(:,:,e_decode),0,0);
    error_decoded(:,:,:,e_decode)=RGB;
end

set(handles.text2,'string','video recovering')
pause(0.005);
%decoding
playVideo=uint8(zeros(height,width,3,totalFrame));
v_count=1;
P_count=1;
for I_pic=1:GOP:totalFrame
    Iframe_index=(I_pic-1)/GOP+1;
    playVideo(:,:,:,v_count)=uint8(I_decoded(:,:,:,Iframe_index));
    v_count=v_count+1;
    for P_pic=I_pic+1:I_pic+GOP-1
        if P_pic>totalFrame
            break;
        end
        %MC
        prediction=zeros(height,width,3);
        for y0=1:N:height
            for x0=1:N:width
                v=MVs((y0-1)/N+1,(x0-1)/N+1,1,P_count);
                u=MVs((y0-1)/N+1,(x0-1)/N+1,2,P_count);
                prediction(y0:y0+N-1,x0:x0+N-1,:)=I_decoded(y0+v:y0+N-1+v,x0+u:x0+N-1+u,:,Iframe_index);
            end
        end
        %recover
        playVideo(:,:,:,v_count)=uint8(prediction+error_decoded(:,:,:,P_count));
        v_count=v_count+1;
        P_count=P_count+1;
    end
end
set(handles.text2,'string','Video is ready')
set(handles.pushbutton2,'visible','on');


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global totalFrame
global playVideo
axes(handles.axes1);
%play video
set(handles.text2,'string','Video is playing')
for i=1:totalFrame
    imshow(playVideo(:,:,:,i));
    pause(0.01);
end
set(handles.text2,'string','Video is over')
