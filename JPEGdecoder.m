function RGB= JPEGdecoder(Y_READ,U_READ,V_READ,y_expand,x_expand)
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
RGB = cat(3,R,G,B);
end