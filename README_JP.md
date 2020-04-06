# 2�̋��჌���Y�ɂ��360�x�摜�̍쐬
This software is released under the MIT License, see LICENSE.txt.

���̃X�N���v�g�ł�2�̋��჌���Y�𓋍ڂ���360�x�J�����f�o�C�X����擾�����摜�ɑ΂��A360�x�摜�i�����~���摜�j�̍쐬���s���܂��B


### 360�x�J�����Ŏ擾�����摜�̓ǂݍ���


�ŏ��ɉ摜��ǂݍ��݂܂��B360�J��������擾�����摜�́A2�̋��჌���Y�摜�����E�Ɍ�������1�̉摜�Ƃ��Ĉ����܂��B


```matlab
I = imread('sample.png');
I = imresize(I,[500 1000]);
imshow(I)
```

![figure_0.png](doc_images/figure_0.png)

### 2�̋���摜�͈͎̔w��


�e�X�̉摜�ɕ������邽�߂ɔ͈͂��w�肵�܂��B


```matlab
h = int16(size(I,1));
w = int16(size(I,2));

imshow(I)
c1 = drawcircle('Center',[  w/4,h/2],'Radius',h/2,'Color','blue');
c2 = drawcircle('Center',[3*w/4,h/2],'Radius',h/2,'Color','red');
```

![figure_1.png](doc_images/figure_1.png)

### �摜�̕���


�͈͎w�肵�����ʂɊ�Â��A�摜�̕������s���܂��B


```matlab
% �摜�̕���
xy1 = c1.Center-c1.Radius;
xy2 = c2.Center-c2.Radius;

IL = imcrop(I,[c1.Center-c1.Radius, c1.Radius*2, c1.Radius*2]);
%IL(repmat(~msk1,[1 1 3])) = 0;
IR = imcrop(I,[c2.Center-c2.Radius, c2.Radius*2, c2.Radius*2]);
%IR(repmat(~msk1,[1 1 3])) = 0;

IR = imresize(IR,size(IL,[1 2]));

% ���������摜�̊m�F
figure
montage({IL,IR},'BackgroundColor','white','BorderSize',30)
```

![figure_2.png](doc_images/figure_2.png)

### �����~���摜(Equirectangular Image)�ւ̕ϊ��Ɗm�F


�����̉摜�ɑ΂��Đ����~���}�ւ̓��e������֐����g���čs���܂��B���̊֐��͋���摜�̍��W�����̍��W�ɕϊ����A�p�p�����[�^�̉�]�������s������ɁA�����~�����W�ɕϊ����܂��B�ȉ��̃p�����[�^��ύX���A�����~���摜�̕ω����m�F���Ă݂܂��B



   -  fov�F���჌���Y�̎���p�x 
   -  roll�F�摜�̉�] 
   -  tilt�F���������̈ړ� 
   -  pan�F���������̈ړ� 

```matlab
% �p�����[�^�̐ݒ�
fov  = 180; % [�x]
roll = 1;   % [�x]
tilt = 0;   % [�x]
pan  = 2;   % [�x]

% ����֐��ɂ�鐳���~���}�ւ̓��e
EL = imfish2equ(IL,fov,roll,tilt,pan);

% ����
imshow(EL)
```

![figure_3.png](doc_images/figure_3.png)

### 2�̐����~���摜�̈ʒu�����i�X�e�B�b�`���O�j


�e�X�̉摜�𐳋��~���摜�ɕϊ����A2�̉摜�̃Y�������Ȃ��Ȃ�悤�ɏd�ˍ��킹(�X�e�B�b�`���O)���s���܂��B�X�e�B�b�`���O�ɂ͊e�X�̉摜��������ʒ��o���s���}�b�`���O���Ƃ��@������悤�ł����A����͊e�p�����[�^���}�j���A���Œ������Ă����܂��B���̃Z�N�V���������s��A���̃Z�N�V�������J��Ԃ����s���A2�̉摜���悭�d�Ȃ�悤�Ɋe�p�����[�^�𒲐����Ă��������B




�}�j���A����������x���s���ꍇ�́A[App Designer](https://jp.mathworks.com/help/matlab/app-designer.html)���g���Ă����̏������A�v��������ƕ֗��ł��B��x�A�v�����쐬����΁A�v���O���~���O�m�����Ȃ����ł��}�E�X����œ������������s�ł��܂��B




�܂��A[MATLAB Compiler�E](https://jp.mathworks.com/help/compiler/index.html)���i�����p���邱�ƂŁA�쐬�����A�v�������s�`���t�@�C�������AMATLAB���C�Z���X�̖�������PC�ւ̔z�z�Ǝ��s���\�ɂȂ�܂��B


```matlab
% �摜�m�F�p��Figure������
% ���J����Window�͕����Ɏ��̃Z�N�V���������s
figure
p1 = uipanel('Position',[0 0 0.5 0.7]);
p2 = uipanel('Position',[0.5,0,0.5 0.7]);
p3 = uipanel('Position',[0,0.7,1, 0.3]);
ax1 = axes(p1);
ax2 = axes(p2);
ax3 = axes(p3);
ax1.NextPlot="replacechildren";
ax2.NextPlot="replacechildren";
ax3.NextPlot="replacechildren";
title('Left Overlapped Image','Parent',ax1);
title('Right Overlapped Image','Parent',ax2);
title('Overlapped Image','Parent',ax3);
```

![figure_4.png](doc_images/figure_4.png)



�O�̃Z�N�V�����ŊJ����Figure�����Ȃ���e�p�����[�^��ύX���A��̉摜���悭�d�Ȃ�悤�ɒ������Ă��������B




��x���߂��p�����[�^�͓���360�x�J�����Ŏ擾�������̉摜�ɂ��̂܂ܓK�p�����邱�Ƃ��ł��܂��B


```matlab
% �摜�i���j�̃p�����[�^�ݒ�
fovL  = 190; % [�x]
rollL = 1; % [�x]
tiltL = 0; % [�x]
panL  = 2; % [�x]
% �摜�i�E�j�̃p�����[�^�ݒ�
fovR  = 195; % [�x]
rollR = 3.5; % [�x]
tiltR = -2; % [�x]
panR  = 180; % [�x]

% �����̃��\�b�h��I��
method = 'blend';

% �����~���摜�ւ̕ϊ�
EL = imfish2equ(IL,fovL,rollL,tiltL,panL);
ER = imfish2equ(IR,fovR,rollR,tiltR,panR);
% �]���ȗ̈�̍폜
[EL,maskL] = trimImageByFov(EL,fovL,panL);
[ER,maskR] = trimImageByFov(ER,fovR,panR);
% ���E�̉摜���d�˂ĕ\��
Efused = imfuse(EL,ER,method);
wrange = round(size(Efused,2)*0.5);
imshow(Efused(:,1:wrange,:),'Parent',ax1);
imshow(Efused(:,wrange:end,:),'Parent',ax2);
imshow(Efused,'Parent',ax3);
```

![figure_5.png](doc_images/figure_5.png)

### �摜�̍����i�u�����f�B���O�j


�������I����2�摜�ɑ΂��A�d�Ȃ荇�����̈���������Ă����܂��B�P���ȃA���t�@�u�����f�B���O�ł͋��E�ł̋}�ȋP�x�ω��ɂ��؂��������悤�ȉ摜�ɂȂ��Ă��܂����߁A�A���t�@�̒l���d�Ȃ荇���������Ő��`�ɕω����Ă����悤�ɂ��܂�[1]�B


```matlab
% �d�Ȃ蕔���̃C���f�b�N�X���擾
maskB = maskL & maskR;

% ���`�ɕω�����A���t�@�l�̍쐬
stat = regionprops('table',maskB,'Area','PixelIdxList','Image');
alpha = zeros(size(maskB));
idx = stat.PixelIdxList{1};
alpha(idx) = 1/size(stat.Image{1},2); 
idx = stat.PixelIdxList{2};
alpha(idx) = -1/size(stat.Image{2},2); 
alpha = cumsum(alpha,2);
figure

imshow(alpha);
axis on;
title('Alpha Image');
```

![figure_6.png](doc_images/figure_6.png)

```matlab
% �쐬�����A���t�@�l��p���ĉ摜������
ELR = alpha.*double(EL) + (1-alpha).*double(ER);
ELR = uint8(ELR);

% �����摜�̊m�F
figure
imshow(ELR)
```

![figure_7.png](doc_images/figure_7.png)

### �J�������_�ł�360�x�摜�̊m�F


���L�̎���֐����R�}���h�E�B���h�E�Ŏ��s�����Ă��������B�}�E�X�̃h���b�O�A���h�h���b�v����ŃJ�������_�𓮂������Ƃ��ł��܂��B




�����̎���֐��ɂ�R2019b���_��LiveScrip�ɖ��Ή��̋@�\�����邽�߁A���s�́h�R�}���h���C����h�������́h.m�t�@�C���`���h�ł��������������B


```matlab
% imshow360(ELR)
```
### Reference


[1] Tuan Ho, Madhukar Budagavi,  "2DUAL-FISHEYE LENS STITCHING FOR 360-DEGREE IMAGING" ([https://arxiv.org/ftp/arxiv/papers/1708/1708.08988.pdf](https://arxiv.org/ftp/arxiv/papers/1708/1708.08988.pdf))


  
### �T�|�[�g�֐�

\hfill \break

```matlab
function [IE2,mask] = trimImageByFov(IE,fov,pan)
    w  = int16(size(IE,2));
    we = w*(fov/360)/2; % half widht
    ce = mod(w*(0.5+pan/360),w);

    idx = [ones(1,we),zeros(1,w-2*we),ones(1,we)];
    idx = circshift(idx,ce);

    IE2 = IE;
    IE2(:,~idx,:) = 0;
    mask = repmat(idx,[size(IE2,1), 1, size(IE2,3)]);
end
```


Copy right 2020 The MathWorks, Inc.


