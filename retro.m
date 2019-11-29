%色阶
clc;
close all;
clearvars;
%调整图像---色阶调整算法
img = imread('tn01.jpg');
[row,col,~] = size(img);
PixelAmount = row * col;
HighCut = 0.01;
LowCut = 0.01;
rimg = img(:,:,1);
gimg = img(:,:,2);
bimg = img(:,:,3);
rhist = imhist(rimg,256);
ghist = imhist(gimg,256);
bhist = imhist(bimg,256);
%red channel image
MinRed = 0;MaxRed = 255;
MinGreen = 0;MaxGreen = 255;
MinBlue = 0;MaxBlue = 255;
sumval = 0;
for ii = 0:255
    sumval = sumval + rhist(ii + 1);
    if sumval >= PixelAmount * LowCut
        MinRed = ii;
        break;
    end
end
sumval = 0;
for ii = 255:-1:0
    sumval = sumval + rhist(ii + 1);
    if sumval >= PixelAmount * HighCut
        MaxRed = ii;
        break;
    end
end

%green channel image
sumval = 0;
for ii = 0:255
    sumval = sumval + ghist(ii + 1);
    if sumval >= PixelAmount * LowCut
        MinGreen = ii;
        break;
    end
end
sumval = 0;
for ii = 255:-1:0
    sumval = sumval + ghist(ii + 1);
    if sumval >= PixelAmount * HighCut
        MaxGreen = ii;
        break;
    end
end

%blue channel image
sumval = 0;
for ii = 0:255
    sumval = sumval + bhist(ii + 1);
    if sumval >= PixelAmount * LowCut
        MinBlue = ii;
        break;
    end
end
sumval = 0;
for ii = 255:-1:0
    sumval = sumval + bhist(ii + 1);
    if sumval >= PixelAmount * HighCut
        MaxBlue = ii;
        break;
    end
end

RedMap = zeros(1,256);
GreenMap = zeros(1,256);
BlueMap = zeros(1,256);
for ii = 0:255
    if ii <MinRed
        RedMap(ii + 1) = 0;
    elseif ii>MaxRed
        RedMap(ii + 1) = 255;
    else
        RedMap(ii + 1) = round((ii - MinRed)/(MaxRed - MinRed) * 255);
    end
    
    if ii <MinGreen
        GreenMap(ii + 1) = 0;
    elseif ii>MaxGreen
        GreenMap(ii + 1) = 255;
    else
        GreenMap(ii + 1) = round((ii - MinGreen)/(MaxGreen - MinGreen) * 255);
    end
    
    if ii <MinBlue
        BlueMap(ii + 1) = 0;
    elseif ii>MaxBlue
        BlueMap(ii + 1) = 255;
    else
        BlueMap(ii + 1) = round((ii - MinBlue)/(MaxBlue - MinBlue) * 255);
    end
end
dst_3map = img;
for ii =1:row
    for jj = 1:col
        temp =double( dst_3map(ii,jj,1) );
        dst_3map(ii,jj,1) = RedMap(temp + 1);
        temp =double( dst_3map(ii,jj,2) );
        dst_3map(ii,jj,2) = GreenMap(temp + 1);
        temp =double( dst_3map(ii,jj,3) );
        dst_3map(ii,jj,3) = BlueMap(temp + 1);
    end
end
figure;
subplot(2,3,1);imshow(img);title('original image');
subplot(2,3,2);imshow(dst_3map);title('processed image');
subplot(2,3,3);stem(0:255,RedMap,'marker','none');title('red channel map function');
subplot(2,3,4);stem(0:255,GreenMap,'marker','none');title('green channel map function');
subplot(2,3,5);stem(0:255,BlueMap,'marker','none');title('blue channel map function');
%%
%调整图像---自动对比度算法
if MinBlue < MinGreen
    Min = MinBlue;
else
    Min = MinGreen;
end

if MinRed < Min
    Min = MinRed;
end
if MaxBlue > MaxGreen
    Max = MaxBlue;
else
    Max = MaxGreen;
end
if MaxRed > Max
    Max = MaxRed;
end
Map = zeros(1,256);
for ii = 0:255
    if ii < Min
        Map(ii + 1) = 0;
    elseif ii>Max
        Map(ii + 1) = 255;
    else
        Map(ii + 1) = round((ii - Min)/(Max - Min) * 255);
    end
end
% dst_1map = img;
dst_1map = dst_3map;
for ii =1:row
    for jj = 1:col
        temp =double( dst_1map(ii,jj,1) );
        dst_1map(ii,jj,1) = Map(temp + 1);
        temp =double( dst_1map(ii,jj,2) );
        dst_1map(ii,jj,2) = Map(temp + 1);
        temp =double( dst_1map(ii,jj,3) );
        dst_1map(ii,jj,3) = Map(temp + 1);
    end
end
figure;
subplot(2,2,1);imshow(img);title('original image');
subplot(2,2,2);imshow(dst_1map);title('processed image');
subplot(2,2,3);stem(0:255,Map,'marker','none');title('map function');



[h ,w ,k]=size(dst_1map);
% imshow(img);

R=double(dst_1map(:,:,1));
G=double(dst_1map(:,:,2));
B=double(dst_1map(:,:,3));

rR=R*0.393+G*0.769+B*0.198;
rG=R*0.349+G*0.686+B*0.168;
rB=R*0.272+G*0.534+B*0.131;

randR=rand()*0.5+0.5;
randG=rand()*0.5+0.5;
randB=rand()*0.5+0.5;

imgn=zeros(h,w,k);
imgn(:,:,1)=randR*rR+(1-randR)*R;
imgn(:,:,2)=randG*rG+(1-randG)*G;
imgn(:,:,3)=randB*rB+(1-randB)*B;
i = uint8(imgn);
sigma=10;%添加噪声的标准差
imgnoise=imnoise(i,'gaussian',0,(sigma/255)^2); %添加均值为0，
% img = dark_corner(imgnoise);
%image = multiScaleSharpen(img,0.5)
figure;imshow(imgnoise);
imwrite(imgnoise,'result03.jpg')


