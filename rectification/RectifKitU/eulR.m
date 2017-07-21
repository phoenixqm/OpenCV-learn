function R = eulR(a)
%eulR compure a rotation matrix given three Euler angles
%
% Rotations are applied in the order y-z-x (first y, last x)

xa = a(1); % rotation angle around x
ya = a(2); % rotation angle around y
za = a(3); % rotation angle around z


R =  [1         0    0
    0  cos(xa)  -sin(xa)
    0  sin(xa)   cos(xa)]*...
    [cos(za)  -sin(za) 0
    sin(za)   cos(za) 0
    0             0     1]*...
    [cos(ya)  0 sin(ya)
    0         1    0
    -sin(ya) 0 cos(ya)];

%
%
%  R =[ cos(za)*cos(ya),      -sin(za),        cos(za)*sin(ya)
%        cos(xa)*sin(za)*cos(ya)+sin(xa)*sin(ya), cos(xa)*cos(za), cos(xa)*sin(za)*sin(ya)-sin(xa)*cos(ya)
%        sin(xa)*sin(za)*cos(ya)-cos(xa)*sin(ya), sin(xa)*cos(za), sin(xa)*sin(za)*sin(ya)+cos(xa)*cos(ya)]
%
