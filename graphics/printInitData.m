function printInitData(OE0, TLE)

% Constants
mu = 3.986004418e14;
Re = 6371e3;

% Unpack variables needed
a     = OE0.semimajorAxis;
e     = OE0.eccentricity;
incl  = OE0.inclination;
t0    = OE0.t;
RAAN0 = OE0.RAAN;
w0    = OE0.argOfPerigee;
M0    = OE0.meanAnomaly;
n     = OE0.meanMotion;

disp(['============== Orbit Propagator Started =============='])
fprintf('\n') 
disp('Orbital Parameters at Epoch')
disp(['  Eccentricity        : ', num2str(e)])
disp(['  Inclination         : ' num2str(rad2deg(incl)), ' degrees'])
disp(['  Right Ascension     : ' num2str(rad2deg(RAAN0)), ' degrees'])
disp(['  Argument of Perigee : ' num2str(rad2deg(w0)), ' degrees'])
disp(['  Apoapsis altitude   : ', num2str((a - Re)/1000), ' km'])
disp(['  Periapsis altitude  : ', num2str((a*sqrt(1 - e^2) - Re)/1000), ' km'])
disp(['  Orbital Period      : ', num2str(2*pi*a^(3/2)/sqrt(mu)), ' s'])
% fprintf('\n')
% lambda0 = pi/2 - asin(Re/a);
% disp(['View angle subtended by Earth''s surface: ', num2str(rad2deg(lambda0)), ' degrees'])
% disp(['Radius of visibility about nadir: ', num2str(Re*lambda0/1000), ' km'])
fprintf('\n')  

end