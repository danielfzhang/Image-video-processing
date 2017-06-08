function [Y_QUAN U_QUAN V_QUAN y_expand x_expand] = JPEGencoder(img_scene)
R = img_scene(:,:,1);
G = img_scene(:,:,2);
B = img_scene(:,:,3);
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
end
