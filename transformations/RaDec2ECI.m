function rECI = RaDec2ECI(RA, DEC)
% Converts Right ascension (RA) and Declination (DEC) of an object to a
% unit position vector in ECI coordinates. Angles input in radians.
% Mark George

rECI = [cos(DEC).*cos(RA);
        cos(DEC).*sin(RA);
        sin(DEC)];
rECI = rECI./vecnorm(rECI);

end