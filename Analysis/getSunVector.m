function rSun = getSunVector(JDN, t)
% Function calculates the sun vector, from the earth to the sun
% using the method in "Fundamentals of Astrodynamics and 
% Applications" by David A. Vallado.
% Mark George
%
% Input Arguments
% JDN      - Julian Day Number to start calculation
% t        - Array of times for the orbit in seconds. t = 0 corresponds to
%            the given JDN above.
%
% Output Arguments
% rSun    - Vector from center of ECI frame to the sun in meters.

% Astronomical units
AU = 1.496e11;


TUT1 = (JDN + t/60/60/24 - 2451545)/36528;
lambdaM = 280.4606184 + 36000.77005361*TUT1;
TTDB = TUT1;
Mcirc = 357.5277233 + 35999.05034*TTDB;
lambdaE = lambdaM + 1.914666471*sind(Mcirc) + 0.0019994643*sind(2*Mcirc);
rcirc = 1.000140612 - 0.016708617*cosd(Mcirc) - 0.000139589*cosd(2*Mcirc);
epsilon = 23.439291 - 0.0130042*TTDB;
rSun = [rcirc.*cosd(lambdaE);
    rcirc.*cosd(epsilon).*sind(lambdaE);
    rcirc.*sind(epsilon).*sind(lambdaE)];
rSun = rSun*AU;

