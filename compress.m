function varargout = compress(varargin)
% COMPRESS MATLAB code for compress.fig
%      COMPRESS, by itself, creates a new COMPRESS or raises the existing
%      singleton*.
%
%      H = COMPRESS returns the handle to a new COMPRESS or the handle to
%      the existing singleton*.
%
%      COMPRESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPRESS.M with the given input arguments.
%
%      COMPRESS('Property','Value',...) creates a new COMPRESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before compress_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to compress_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help compress

% Last Modified by GUIDE v2.5 07-Apr-2017 14:57:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @compress_OpeningFcn, ...
                   'gui_OutputFcn',  @compress_OutputFcn, ...
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


% --- Executes just before compress is made visible.
function compress_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to compress (see VARARGIN)

% Choose default command line output for compress
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes compress wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global sprite
global obj
%------read sprite images
sprite=uint8(zeros(100,100,3,8));
for i=1:8
    of=[num2str(i) '.jpg'];
    sprite(:,:,:,i)=imread(of);                       
end
%------read video
obj = VideoReader('test1.mp4');
axes(handles.axes1);
imshow(sprite(:,:,:,1));
axes(handles.axes2);
imshow(read(obj,1));
pause(0.001)


% --- Outputs from this function are returned to the command line.
function varargout = compress_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sprite
global obj

set(handles.pushbutton3,'visible','off');
set(handles.pushbutton4,'visible','off');
%------setup parameters
totalFrame=obj.NumberOfFrames;
height=obj.Height;
width=obj.Width;
N=16;
p=15;
GOP=4;
TotalIFrame=ceil(totalFrame/GOP);
TotalPFrame=totalFrame-TotalIFrame;
Predic_error=zeros(height,width,3,TotalPFrame);%prediction errors 
MVs=zeros(height/N,width/N,2,TotalPFrame);%motion vectors 
I_frames=zeros(height,width,3,TotalIFrame);%I frames 
%------movie compressing
set(handles.text2,'string', 'Doing Motion Estimation')
pause(0.005);
P_count=1;
for I_pic=1:GOP:totalFrame%for every GOP
    Iframe_index=(I_pic-1)/GOP+1;
    I_frames(:,:,:,Iframe_index)=double(read(obj,I_pic));%store the I frame
    %insert sprite to I frame
    for i=1:100
        for j=1:100
           if sprite(i,j,1,mod(I_pic-0,8)+1)~=0 && sprite(i,j,2,mod(I_pic-0,8)+1)~=0 && sprite(i,j,3,mod(I_pic-0,8)+1)~=0
               I_frames(i,j,1,Iframe_index)=sprite(i,j,1,mod(I_pic-0,8)+1);
               I_frames(i,j,2,Iframe_index)=sprite(i,j,2,mod(I_pic-0,8)+1);
               I_frames(i,j,3,Iframe_index)=sprite(i,j,3,mod(I_pic-0,8)+1);
           end
        end
    end
    %achieve Y channel of result I frame 
    Ycbcr=rgb2ycbcr(I_frames(:,:,:,Iframe_index));
    Iframe=Ycbcr(:,:,1);
    %motion estimation
    for P_pic=I_pic+1:I_pic+GOP-1%for every P frames in the GOP
        if P_pic>totalFrame
            break;
        end
        P_frame=double(read(obj,P_pic));
        %insert sprite to P frame
        for i=1:100
            for j=1:100
               if sprite(i,j,1,mod(P_pic-0,8)+1)~=0 && sprite(i,j,2,mod(P_pic-0,8)+1)~=0 && sprite(i,j,3,mod(P_pic-0,8)+1)~=0
                   P_frame(i,j,1)=sprite(i,j,1,mod(P_pic-0,8)+1);
                   P_frame(i,j,2)=sprite(i,j,2,mod(P_pic-0,8)+1);
                   P_frame(i,j,3)=sprite(i,j,3,mod(P_pic-0,8)+1);
               end
            end
        end
        %convert RGB to YCbCr
        Ycbcr=rgb2ycbcr(P_frame);
        Pframe=Ycbcr(:,:,1);
        %MV based on Y channel
        for y0=1:N:height
            for x0=1:N:width
                min_MAD=intmax;
                offset=ceil(p/2);
                    while offset~=1
                        for j=-1:1
                            for i=-1:1
                                if j+y0+N-1<=height && i+x0+N-1<=width && j+y0>0 && i+x0>0
                                    cur_MAD=sum(sum(abs(Pframe(y0:y0+N-1,x0:x0+N-1)-Iframe(y0+j*offset:y0+j*offset+N-1,x0+i*offset:x0+i*offset+N-1))));
                                    cur_MAD=cur_MAD/(N*N);
                                    if cur_MAD<min_MAD 
                                       min_MAD=cur_MAD;
                                       v=j*offset;
                                       u=i*offset;
                                    end
                                end
                            end
                        end
                        offset=ceil(offset/2);
                    end
            end
        end
        %MC
        prediction=zeros(height,width,3);
        for y0=1:N:height
            for x0=1:N:width
                v=MVs((y0-1)/N+1,(x0-1)/N+1,1,P_count);
                u=MVs((y0-1)/N+1,(x0-1)/N+1,2,P_count);
                prediction(y0:y0+N-1,x0:x0+N-1,:)=I_frames(y0+v:y0+N-1+v,x0+u:x0+N-1+u,:,Iframe_index);
            end
        end
        %prediction error
        Predic_error(:,:,:,P_count)=P_frame-prediction;
        P_count=P_count+1;
    end
end
%I frame encoding
I_Yencode=zeros(height,width,TotalIFrame);
I_Uencode=zeros(height/2,width/2,TotalIFrame);
I_Vencode=zeros(height/2,width/2,TotalIFrame);
for i_encode=1:TotalIFrame
    [I_Y I_U I_V I_y_expand I_x_expand]=JPEGencoder(I_frames(:,:,:,i_encode));
    I_Yencode(:,:,i_encode)=I_Y;
    I_Uencode(:,:,i_encode)=I_U;
    I_Vencode(:,:,i_encode)=I_V;
    set(handles.text2,'string',[num2str(i_encode) '/' num2str(TotalPFrame) ' I frames encoding'])
    pause(0.005);
end
%Error encoding
err_Yencode=zeros(height,width,TotalPFrame);
err_Uencode=zeros(height/2,width/2,TotalPFrame);
err_Vencode=zeros(height/2,width/2,TotalPFrame);
for e_encode=1:TotalPFrame
    [err_Y err_U err_V err_y_expand err_x_expand]=JPEGencoder(Predic_error(:,:,:,e_encode));
    err_Yencode(:,:,e_encode)=err_Y;
    err_Uencode(:,:,e_encode)=err_U;
    err_Vencode(:,:,e_encode)=err_V;
    set(handles.text2,'string',[num2str(e_encode) '/' num2str(TotalPFrame) ' Errors encoding'])
    pause(0.005);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%write file
dlmwrite('data.mv',[height width TotalIFrame TotalPFrame]);
for p=1:TotalPFrame
    for i=1:2
        dlmwrite('data.mv',MVs(:,:,i,p),'-append');
    end
    dlmwrite('data.mv',err_Yencode(:,:,p),'-append');
    dlmwrite('data.mv',err_Uencode(:,:,p),'-append');
    dlmwrite('data.mv',err_Vencode(:,:,p),'-append');
    set(handles.text2,'string',[num2str(p) '/' num2str(TotalPFrame) ' Error writing'])
    pause(0.005);
end
for p=1:TotalIFrame
    dlmwrite('data.mv',I_Yencode(:,:,p),'-append');
    dlmwrite('data.mv',I_Uencode(:,:,p),'-append');
    dlmwrite('data.mv',I_Vencode(:,:,p),'-append');
    set(handles.text2,'string',[num2str(p) '/' num2str(TotalPFrame) ' I frames writing'])
    pause(0.005);
end
set(handles.text2,'string','The video file is saved as data.mv')


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sprite
global obj
totalFrame=obj.NumberOfFrames;

for i=1:totalFrame
    axes(handles.axes1);
    imshow(sprite(:,:,:,mod(i-1,8)+1));
    axes(handles.axes2);
    imshow(read(obj,i));
    pause(0.001)
end
