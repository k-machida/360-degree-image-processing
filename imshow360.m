function f = imshow360(I)

% 正距円筒図法のxy座標点を作成 
h = size(I,2);
w = size(I,1);
[xe,ye] = meshgrid(linspace(-1,1,h),linspace(-1,1,w));

% 正距円筒図法から球体座標に変換
[xs,ys,zs] = equ2sph(xe,ye);

% マウスの移動量計測用の変数
dragging = [];
orPos = [];

% Figure の作成
f = figure('WindowButtonUpFcn',@dropObject,'units','normalized','WindowButtonMotionFcn',@moveObject,'ButtonDownFcn',@dragObject);

% テキストボックス(Annotationオブジェクト)の作成
annotation('textbox','position',[0 0 1 1],'ButtonDownFcn',@dragObject);;

% 球面のプロット 
ax = axes(f);
surf(ax,xs,ys,zs,I,'EdgeColor','flat');

% カメラ視点に設定
axis(ax, 'off');
ax.Projection = 'perspective';
ax.CameraPosition = [0 0 0];
ax.CameraViewAngleMode = 'manual';
ax.CameraViewAngle = 100;
ax.CameraTarget = [1 0 0];
ax.CameraUpVector = [0 0 -1];

    function dragObject(hObject,eventdata)
        % Annotation の ButtonDownFcn コールバック
        dragging = hObject; % Annotation のハンドルを格納
        orPos = get(f,'CurrentPoint'); % Figure 上でマウス選択した位置を取得 
    end

    function dropObject(hObject,eventdata)
        % WindowButtonUpFcn コールバック(ドロップしたタイミングでコール)
        dragging = []; % 初期化
    end
    function moveObject(hObject,eventdata)
        % WindowButtonMotionFcn コールバック（マウスが Figure 上を移動したタイミングでコール）
        if ~isempty(dragging) % ドラッグされていたら
            newPos = get(f,'CurrentPoint'); % Figure 上でマウス選択した位置を取得
            posDiff = newPos - orPos; % 移動量を計算
            orPos = newPos;           % orPos を新しい値に更新
            
            % 視点の移動
            wh = f.Position(3:4);
            thetaZ  = posDiff(1)/wh(1)*90; % Z軸に対する回転量
            thetaY = posDiff(2)/wh(2)*90;  % Y軸に対する回転量
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