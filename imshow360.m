function f = imshow360(I)

% �����~���}�@��xy���W�_���쐬 
h = size(I,2);
w = size(I,1);
[xe,ye] = meshgrid(linspace(-1,1,h),linspace(-1,1,w));

% �����~���}�@���狅�̍��W�ɕϊ�
[xs,ys,zs] = equ2sph(xe,ye);

% �}�E�X�̈ړ��ʌv���p�̕ϐ�
dragging = [];
orPos = [];

% Figure �̍쐬
f = figure('WindowButtonUpFcn',@dropObject,'units','normalized','WindowButtonMotionFcn',@moveObject,'ButtonDownFcn',@dragObject);

% �e�L�X�g�{�b�N�X(Annotation�I�u�W�F�N�g)�̍쐬
annotation('textbox','position',[0 0 1 1],'ButtonDownFcn',@dragObject);;

% ���ʂ̃v���b�g 
ax = axes(f);
surf(ax,xs,ys,zs,I,'EdgeColor','flat');

% �J�������_�ɐݒ�
axis(ax, 'off');
ax.Projection = 'perspective';
ax.CameraPosition = [0 0 0];
ax.CameraViewAngleMode = 'manual';
ax.CameraViewAngle = 100;
ax.CameraTarget = [1 0 0];
ax.CameraUpVector = [0 0 -1];

    function dragObject(hObject,eventdata)
        % Annotation �� ButtonDownFcn �R�[���o�b�N
        dragging = hObject; % Annotation �̃n���h�����i�[
        orPos = get(f,'CurrentPoint'); % Figure ��Ń}�E�X�I�������ʒu���擾 
    end

    function dropObject(hObject,eventdata)
        % WindowButtonUpFcn �R�[���o�b�N(�h���b�v�����^�C�~���O�ŃR�[��)
        dragging = []; % ������
    end
    function moveObject(hObject,eventdata)
        % WindowButtonMotionFcn �R�[���o�b�N�i�}�E�X�� Figure ����ړ������^�C�~���O�ŃR�[���j
        if ~isempty(dragging) % �h���b�O����Ă�����
            newPos = get(f,'CurrentPoint'); % Figure ��Ń}�E�X�I�������ʒu���擾
            posDiff = newPos - orPos; % �ړ��ʂ��v�Z
            orPos = newPos;           % orPos ��V�����l�ɍX�V
            
            % ���_�̈ړ�
            wh = f.Position(3:4);
            thetaZ  = posDiff(1)/wh(1)*90; % Z���ɑ΂����]��
            thetaY = posDiff(2)/wh(2)*90;  % Y���ɑ΂����]��
            ax.CameraTarget = xyzrotate(ax.CameraTarget,[0 thetaY, thetaZ]);

        end
    end
end



%%
function [xs,ys,zs] = equ2sph(xe,ye)
    thetaE = xe*180; % longitude
    phiE   = ye*90;  % latitude

    xs = cosd(phiE).*cosd(thetaE);
    ys = cosd(phiE).*sind(thetaE);
    zs = sind(phiE);
end

function [xyznew] = xyzrotate(xyz,thetaXYZ)

    tX =  thetaXYZ(1);
    tY =  thetaXYZ(2);
    tZ =  thetaXYZ(3);
    
    rotx   = @(tX) [1 0 0; 0 cosd(tX) -sind(tX) ; 0 sind(tX) cosd(tX)] ;
    roty   = @(tY) [cosd(tY) 0 sind(tY) ; 0 1 0 ; -sind(tY) 0  cosd(tY)] ;
    rotz   = @(tZ) [cosd(tZ) -sind(tZ) 0 ; sind(tZ) cosd(tZ) 0 ; 0 0 1] ;

    xyznew = xyz*rotx(tX)*roty(tY)*rotz(tZ);
    
           
end

% function [xyznew] = yzrotate(xyz,theta)
%     tY = theta(1);
%     tZ = theta(2);
% 
%     xyz1 = [xyz, ones(size(xyz,1))]';
% 
%     tform = [cosd(tY)*cosd(tZ)  cosd(tY)*sind(tZ)  -sind(tY)  0;
%              -sind(tZ)             cosd(tZ)            0      0;
%              sind(tY)*cosd(tZ)  sind(tY)*sind(tZ)  cosd(tY)   0;
%                    0                  0                0      1];
%     xyznew = tform*xyz1;
%     xyznew = xyznew(1:3,:)';
% end