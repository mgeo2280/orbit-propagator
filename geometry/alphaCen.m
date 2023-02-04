function [RA, DEC] = alphaCen()
% Function returns Right Ascension and Declination of alpha Centauri star
% system in ECI frame in radians.
% Mark George

% Convert right ascension from hour angle
RA = 14*pi/12 + 39*pi/720 + 6.49400*pi/43200;

% Convert declination from DMS
DEC = deg2rad(dms2deg(-60, 50, 2.3737));

end