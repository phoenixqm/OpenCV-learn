function [Hl,Hr] = compRectif(ml,mr,width,height,cntr)
%compRectif compute the rectifying transformations
%
% Hl,Hr are the collineations that rectify the left and right images
% respectively
%
% ml,mr are coresponding point in the images 
%
% width, height are the dimensions of the image (used to imfer the focal
% and the image centre)
% 
% cntr 'on' enables the automatic centering; 'off' disables it.



% default
if nargin == 4
    cntr='on';
end

% use jacobian?
options = optimset('Jacobian','off');

a0 = [0 0 0 0 0, 0];
[af,resnorm,residual,exitflag,output,lambda,jacobian] = lsqnonlin(@(x) costRectif(x,width,height,ml,mr), a0,...
    [-pi/2, -pi/2, -pi/2, -pi/2, -pi/2, -1.5], [pi/2, pi/2, pi/2, pi/2, pi/2, 1.5],options);


%err = sqrt(sum(residual))/(length(ml));
%fprintf('Sampson RMS: %0.5g pixel \n',err);


counter = 0;
while af(6)>1 || af(6)<-1
    counter = counter+1;

    disp('focal out of range; trying a random restart...');

    a0 = [0 0 0 0 0, 2*rand-1.0];

    [af,resnorm] = lsqnonlin(@(x) costRectif(x,width,height,ml,mr), a0,...
        [-pi/2, -pi/2, -pi/2, -pi/2, -pi/2, -1.5], [pi/2, pi/2, pi/2, pi/2, pi/2, 1.5],options);

    if counter > 20
        warning('Cannot find a focal in the range')
        break
    end

end

yl=af(1);
zl=af(2);
xr=af(3);
yr=af(4);
zr=af(5);
f =3^af(6)*(width+height)

% old intrinsics
Kol = [f, 0, width/2;
    0, f, height/2;
    0, 0, 1];

Kor = [f, 0, width/2;
    0, f, height/2;
    0, 0, 1];

% rotations
Rl = eulR([0,yl,zl]);
Rr = eulR([xr,yr,zr]);

% new intrinsics: arbitrary
Knl = (Kol+Kor)/2;
Knr = Knl;

% compute collineations
Hr = Knr*Rr*inv(Kor);
Hl = Knl*Rl*inv(Kol);


if strcmp(cntr,'on')
% automatic centering on

    % centering LEFT image
    px = Hl * [width/2; height/2; 1];
    dl = [width/2; height/2] - px(1:2)./px(3);

    % centering RIGHT image
    px = Hr * [width/2; height/2; 1];
    dr = [width/2; height/2] - px(1:2)./px(3);

    % vertical diplacement must be the same
    dr(2) = dl(2);

    % modify new intrinsic
    Knl(1,3)=Knl(1,3)+dl(1);
    Knl(2,3)=Knl(2,3)+dl(2);
    Knr(1,3)=Knr(1,3)+dr(1);
    Knr(2,3)=Knr(2,3)+dr(2);

    % re-compute collineations with centering
    Hr = Knr*Rr*inv(Kor);
    Hl = Knl*Rl*inv(Kol);

elseif strcmp(cntr,'off')
    % automatic centering off
    % nothing to do
else
    error('Valid options are [on,off]');

end


