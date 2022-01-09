function OE = getOrbitalParameters()
% Orbital elements.
% OE = [h, e, RA, incl, w, a, t0, M0, n, JDN]
% where:
% h - Angular momentum of orbit (m^2/s)
% e - Eccentricity
% RA - Right ascention of ascending node (rad)
% incl - Inclination (rad)
% w - Argument of perigee (rad)
% a - Semimajor axis of orbit (m)
% t0 - Epoch time (time in seconds since midnight)
% M0 - Mean anomaly at Epoch (rad)
% n - mean motion (rad/s)
% JD - Julian Day number
%
% Mark George

% Gravitational parameter of Earth (m^2/s^2)
mu = 3.986004418e14;
Re = 6371e3;

% Orbital Elements from TLE
e = 0;
incl = deg2rad(7);
RA = deg2rad(85);
w = deg2rad(0);
Epoch = 0;
t0 = (Epoch - fix(Epoch))*24*60*60;
M0 = deg2rad(80);
n = 15.078;                             % rev/day

% Mean motion -> Semimajor axis
n = 2*pi*(n)/24/60/60;    % Convert to rad/s
a = (mu/(n^2))^(1/3);

% Angular momentum
h = sqrt( a*mu*(1 - e^2) );

% Julian date, first days since J2000
JDNJ2000 = 2451545;
daysJ2000 = daysact('01-Jan-2000', date) + fix(Epoch);
JDN = JDNJ2000 + daysJ2000;

% Store the orbital parameters
OE = [h, e, RA, incl, w, a, t0, M0, n, JDN];

% Display initial orbital parameters
disp(['Orbital Parameters at Epoch:'])
disp(['Eccentricity: ', num2str(e)])
disp(['Inclination: ' num2str(rad2deg(incl)), ' degrees'])
disp(['Right Ascension: ' num2str(rad2deg(RA)), ' degrees'])
disp(['Argument of Perigee: ' num2str(rad2deg(w)), ' degrees'])
disp(['Apoapsis altitude: ', num2str((a - Re)/1000), ' km'])
disp(['Periapsis altitude: ', num2str((a*sqrt(1 - e^2) - Re)/1000), ' km'])
disp(['Orbital Period: ', num2str(2*pi*a^(3/2)/sqrt(mu)), ' s'])
% fprintf('\n')
% lambda0 = pi/2 - asin(Re/a);
% disp(['View angle subtended by Earth''s surface: ', num2str(rad2deg(lambda0)), ' degrees'])
% disp(['Radius of visibility about nadir: ', num2str(Re*lambda0/1000), ' km'])
fprintf('\n')  
end