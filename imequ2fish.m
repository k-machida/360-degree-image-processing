function imgF = imequ2fish(imgE,varargin)
% ------------------------------------
% [Syntax]
% imgF = imequ2fish(imgE);
% imgF = imequ2fish(imgE,roll,tilt,pan);
%
% [Description]
% imgF: input equirectangular image
% roll: value of roll [degrees]
% tilt: value of tilt [degrees]
% pan : value of pan  [degrees]
% imgE: output 360 fisyeye image
% ------------------------------------

% Input Parser
p = inputParser;
addRequired(p,'imgE');
addOptional(p,'roll',  0); % defaul value of roll
addOptional(p,'tilt',  0); % defaul value of tilt
addOptional(p,'pan' ,  0); % defaul value of pan
parse(p,imgE,varargin{:});

% ------
% Step1. Parameter setting
% ------

% Input equirectangular image size
we = size(imgE,2);
he = size(imgE,1);
ch = size(imgE,3);

% Output fisheye image size
wf = round(we/2);
hf = he;

% Rotation
roll = p.Results.roll;
tilt = p.Results.tilt;
pan  = p.Results.pan;

% ------
% Step2. Create fisyeye xy coordinate points
% ------
[xf,yf] = meshgrid(1:wf,1:hf);

% Convert to normalized unit
xf = 2*((xf-1)/(wf-1)-0.5); % rescale to -1~1
yf = 2*((yf-1)/(hf-1)-0.5); % rescale to -1~1

% Get index of valid fisyeye image area
idx = sqrt(xf.^2+yf.^2) <= 1; 
xf = xf(idx);
yf = yf(idx);

% ------
% Step3. Calculate equitangular xy points which coincide with fisyeye xy points
% ------
[xe,ye] = fish2equ(xf,yf,roll,tilt,pan);

% Convert normalized unit to pixel
Xe = round((xe+1)/2*(we-1)+1); % rescale to 1~we
Ye = round((ye+1)/2*(he-1)+1); % rescale to 1~he
Xf = round((xf+1)/2*(wf-1)+1); % rescale to 1~wf
Yf = round((yf+1)/2*(hf-1)+1); % rescale to 1~hf

% ------
% Step4. Create fisheye image
% ------
Ie = reshape(imgE,[],ch);
If = zeros(hf*wf,ch,'uint8');

idnf = sub2ind([hf,wf],Yf,Xf);
idne = sub2ind([he,we],Ye,Xe);
If(idnf,:) = Ie(idne,:);
imgF = reshape(If,hf,wf,3);

end


%% Support Functions

% Equirectanglar to Fisheye xy coordinate points
function [xe,ye] = fish2equ(xf,yf,roll,tilt,pan)

    % Field of view of equirectangular image
    fov = 360; 
    
    % Convert Fisheye xy points to Sphere xyz points
    thetaS = atan2d(yf,xf);
    phiS   = sqrt(yf.^2+xf.^2)*fov/2;
    sindphiS = sind(phiS);
    xs = sindphiS.*cosd(thetaS);
    ys = sindphiS.*sind(thetaS);
    zs = cosd(phiS);

    % Rotation by roll,tilt and pan
    xyzsz = size(xs);
    xyz = xyzrotate([xs(:),ys(:),zs(:)],[roll tilt pan]);
    xs = reshape(xyz(:,1),xyzsz(1),[]);
    ys = reshape(xyz(:,2),xyzsz(1),[]);
    zs = reshape(xyz(:,3),xyzsz(1),[]);

    % Convert Sphere xyz points to Equirectangular xy points
    thetaE = atan2d(xs,zs);
    phiE   = atan2d(ys,sqrt(xs.^2+zs.^2));
    xe = thetaE/180;
    ye = 2*phiE/180;

end


% Rotate xyz points 
function [xyznew] = xyzrotate(xyz,thetaXYZ)

    tX =  thetaXYZ(1);
    tY =  thetaXYZ(2);
    tZ =  thetaXYZ(3);
    
    T = [                              cosd(tY)*cosd(tZ),                             -cosd(tY)*sind(tZ),           sind(tY); ...
          cosd(tX)*sind(tZ) + cosd(tZ)*sind(tX)*sind(tY), cosd(tX)*cosd(tZ) - sind(tX)*sind(tY)*sind(tZ), -cosd(tY)*sind(tX); ...
          sind(tX)*sind(tZ) - cosd(tX)*cosd(tZ)*sind(tY), cosd(tZ)*sind(tX) + cosd(tX)*sind(tY)*sind(tZ),  cosd(tX)*cosd(tY)];
    
    xyznew = xyz*T;
    
    %rotx   = @(tX) [1 0 0; 0 cosd(tX) -sind(tX) ; 0 sind(tX) cosd(tX)] ;
    %roty   = @(tY) [cosd(tY) 0 sind(tY) ; 0 1 0 ; -sind(tY) 0  cosd(tY)] ;
    %rotz   = @(tZ) [cosd(tZ) -sind(tZ) 0 ; sind(tZ) cosd(tZ) 0 ; 0 0 1] ;
    %xyznew = xyz*rotx(tX)*roty(tY)*rotz(tZ); 
    
end