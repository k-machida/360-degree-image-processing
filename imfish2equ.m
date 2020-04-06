function imgE = imfish2equ(imgF,varargin)
% ------------------------------------
% [Syntax]
% imgE = imfish2equ(imgF);
% imgE = imfish2equ(imgF,fov,roll,tilt,pan);
%
% [Description]
% imgF: input fisyeye image
% fov : field of view [degrees]
% roll: value of roll [degrees]
% tilt: value of tilt [degrees]
% pan : value of pan  [degrees]
% imgE: output equirectangular image
% ------------------------------------

% Input Parser
p = inputParser;
addRequired(p,'imgF');
addOptional(p,'fov' ,180); % defaul value of fov
addOptional(p,'roll',  0); % defaul value of roll
addOptional(p,'tilt',  0); % defaul value of tilt
addOptional(p,'pan' ,  0); % defaul value of pan
parse(p,imgF,varargin{:});

% ------
% Step1. Parameter setting
% ------

% Input fisheye image size
wf = size(imgF,2);
hf = size(imgF,1);
ch = size(imgF,3);

% Output equirectangular image size
we = wf*2;
he = hf;

% Field of view and rotation
fov  = p.Results.fov;
roll = p.Results.roll;
tilt = p.Results.tilt;
pan  = p.Results.pan;

% ------
% Step2. Create equirectangular xy coordinate points
% ------

% Create equirectangular xy coordinate points
[xe,ye] = meshgrid(1:we,1:he);

% Convert to normalized unit
xe = 2*((xe-1)/(we-1)-0.5); % rescale to -1~1
ye = 2*((ye-1)/(he-1)-0.5); % rescale to -1~1

% ------
% Step3. Calculate fisyeye xy points which coincide with equirectangular xy points
% ------
[xf,yf] = equ2fish(xe,ye,fov,roll,tilt,pan);

% Remove invalid fisheye image area 
idx = sqrt(xf.^2+yf.^2) <=1; % index of valid fisyeye image area
xf = xf(idx); 
yf = yf(idx); 
xe = xe(idx);
ye = ye(idx);

% Convert normalized unit to pixel
Xe = round((xe+1)/2*(we-1)+1); % rescale to 1~we
Ye = round((ye+1)/2*(he-1)+1); % rescale to 1~he
Xf = round((xf+1)/2*(wf-1)+1); % rescale to 1~wf
Yf = round((yf+1)/2*(hf-1)+1); % rescale to 1~hf

% ------
% Step4. Create fisheye image
% ------
Ie = reshape(imgF,[],ch);
If = zeros(he*we,ch,'uint8');

idnf = sub2ind([hf,wf],Yf,Xf);
idne = sub2ind([he,we],Ye,Xe);
If(idne,:) = Ie(idnf,:);

imgE = reshape(If,he,we,3);

end

% Convert equirectangular xy points to sphere xyz points
function [xf,yf] = equ2fish(xe,ye,fov,roll, tilt, pan)
    % xe  : normalized equirectangular width = -2~2
    % ye  : normalized equirectangular heigh = -1~1
    % xf  : normalized fisheye image width   = -2~2         
    % yf  : normalized fisheye image heigh   =-2~2    
    % fov : field of view
    % roll: value of roll
    % tilt: value of tilt
    % pan : value of pan
    
    % Equirectangular -->Sphere
    thetaE = xe*180; % longitude [degees]
    phiE   = ye*90;  % latitude  [degees]
    cosdphiE = cosd(phiE);
    xs = cosdphiE.*cosd(thetaE);
    ys = cosdphiE.*sind(thetaE);
    zs = sind(phiE);   
    
    % Rotation by roll,tilt and pan
    xyzsz = size(xs);
    xyz = xyzrotate([xs(:),ys(:),zs(:)],[roll tilt pan]);
    xs = reshape(xyz(:,1),xyzsz(1),[]);
    ys = reshape(xyz(:,2),xyzsz(1),[]);
    zs = reshape(xyz(:,3),xyzsz(1),[]);
    
    % Sphere --> Fisheye
    thetaF = atan2d(zs,ys);
    r = 2*atan2d(sqrt(ys.^2+zs.^2),xs)/fov;

    xf = r.*cosd(thetaF);
    yf = r.*sind(thetaF);
    

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
