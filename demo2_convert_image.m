%% Read 360 degree equirectangular image
IE = imread('sample360equ.png');
imshow(IE)

%% Resize image to avoid degradation of the image
IE = imresize(IE,4);

%% Convert equirectangular image to 360 degree fisheye image
IF = imequ2fish(IE,0,0,0);
imshow(IF)

%% Convert 360 degree fisheye image to equirectangular image
IE = imfish2equ(IF,360,0,0,0);
IE = imresize(IE,1/4);
imshow(IE)
