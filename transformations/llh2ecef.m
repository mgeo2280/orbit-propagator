function [x, y, z] = llh2ecef(lambda, phi, h)
% Fucntion converts geodetic latitude, longitude and height to ECEF
% cartesian coordinates. Angles in radians.
% Mark George

% Earth radius and eccentricity
a = 6378137;
e = 0.081819;

N = a/sqrt( 1 - e^2*sin(lambda)^2 );
x = (N + h).*cos(lambda).*cos(phi);
y = (N + h).*cos(lambda).*sin(phi);
z = ( N*(1 - e^2)+ h ).*sin(lambda);

end