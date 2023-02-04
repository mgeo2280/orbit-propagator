function [x, y, z] = ecef2lv(x0, y0, z0, lambda, phi, h)
% Position vectr in ECEF wrt to centre of Earth to position vector in
% LGCV or LGDC wrt. to ground station location (lat. long.). x0, y0, z0
% can be arrays. Angles in degrees.
% Mark George.

% Earth
a = 6378137;

% Transformation matrix
C = transpose([-sin(lambda)*cos(phi), -sin(phi), -cos(lambda)*cos(phi);
    -sin(lambda)*sin(phi), cos(phi), -cos(lambda)*sin(phi);
    cos(lambda), 0, -sin(lambda)]);

% Initialise output arrays
x = zeros(size(x0)); y = x; z = x;

% Iterate given ECEF coordinates, and transform
for i = 1:length(x0)
    recef = [x0(i); y0(i); z0(i)];
    rlv = C*recef;
    x(i) = rlv(1); y(i) = rlv(2); z(i) = rlv(3);
end
    
end