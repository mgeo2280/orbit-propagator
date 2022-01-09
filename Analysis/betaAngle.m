function beta = betaAngle(incl, RA, rSun)
% Function calculates beta angle for given orbit and sun vector in ECI
% frame.

% Normalise sun vector 
rSun = rSun./vecnorm(rSun);

% Calculate the beta angle over time
% First get unit vector perpendicular to the orbital plane
nhat = [sin(incl).*sin(RA);
    -sin(incl).*cos(RA);
    cos(incl)*ones(size(RA))];

% Get angle between the sun vector and the normal vector to the orbit
phi = acos(dot(nhat, rSun));

% Now the beta angle
beta = phi - pi/2;
