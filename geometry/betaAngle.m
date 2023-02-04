function beta = betaAngle(OE, rSun)
% Function calculates beta angle for given orbit and sun vector in ECI
% frame.

% Unpack
incl = OE.inclination;
RAAN = OE.RAAN;

% Normalise sun vector 
rSun = rSun./vecnorm(rSun);

% Calculate the beta angle over time
% First get unit vector perpendicular to the orbital plane
nhat = [sin(incl).*sin(RAAN);
    -sin(incl).*cos(RAAN);
    cos(incl)*ones(size(RAAN))];

% Get angle between the sun vector and the normal vector to the orbit
phi = acos(dot(nhat, rSun));

% Now the beta angle
beta = phi - pi/2;
