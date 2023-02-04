function [lambda, phi, h] = ecef2llh(xECEF, yECEF, zECEF)
% Converts positition vector in ECEF frame to Geodetic Latitude,
% Longitude and height. Angles in Degrees.
% lambda = latitude
% phi = longitude
% h = height
%
% Mark George

% Parameters
tol = 1e-6;
a = 6378137; % Earth semimajor axis (m)
e = 0.08181919; % Earth eccentricity
w = 7.292115e-5; % Earth rotation rate (rad/s)

% initial values
h = zeros(size(xECEF));
N = a;
p = sqrt(xECEF.^2 + yECEF.^2);
lprev = 0;
lambda = 100*ones(size(xECEF));

% iterate to solve for lat,long,alt
for i = 1:length(xECEF)
    for j = 1:100
        sinlambda = zECEF(i)/(N*(1 - e^2) + h(i));
        lambda(i) = atan((zECEF(i) + (e^2)*N*sinlambda)/p(i));
        N = a/sqrt(1 - (e^2)*(sin(lambda(i))^2));
        Nprev = N;
        h(i) = p(i)/cos(lambda(i)) - N;
    end
end

% Longitude
phi = atan2(yECEF,xECEF);

% Put angles in degrees
lambda = rad2deg(lambda); phi = rad2deg(phi);
    
end
