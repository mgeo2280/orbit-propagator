function OE = tle2oe(TLE)
% Convert TLE data to classical oribal elements for use in orbit propgator.
%
% Assumed dimensions:
% TLE.epochYear    - Year e.g. 2018
% TLE.epochDay     - Days, including fractional time of day
% TLE.inclination  - degrees
% TLE.eccentricity - dimensionless
% TLE.RAAN         - degrees
% TLE.argOfPerigee - degrees
% TLE.meanAnomaly  - degrees
% TLE.meanMotion   - revolutions/day
%
% Returned dimensions are in SI units
%
% Mark George

% Earths gravitational parameter
mu = 3.986004418e14;

% Classical orbital parameters
M = deg2rad(TLE.meanAnomaly);
e = TLE.eccentricity;
n = 2*pi*(TLE.meanMotion)/24/60/60;    % rev/day -> rad/s
a = (mu/(n^2))^(1/3);                  % semi-major axis
h = sqrt( a*mu*(1 - e^2) );            % specific angular momentum
E = getEccentricAnomaly(M, e);
TA = 2*atan( sqrt((1+e)/(1-e))*tan(E/2) ); 

% Julian day number
JDNSinceJ2000 = 2451545;                     % Days since J2000
epochDate = datetime('01-Jan-0000') + calyears(TLE.epochYear) + days(fix(TLE.epochDay));
daysSinceJ2000 = caldays(between(datetime('01-Jan-2000'), epochDate, 'days'));
JDN = JDNSinceJ2000 + daysSinceJ2000;

% Time of day in seconds
t0 = (TLE.epochDay - TLE.epochDay)*24*60*60;


% Pack it up
OE.eccentricity    = TLE.eccentricity;
OE.RAAN            = deg2rad(TLE.RAAN);
OE.inclination     = deg2rad(TLE.inclination);
OE.semimajorAxis   = a;
OE.angularMomentum = h;
OE.argOfPerigee    = deg2rad(TLE.argOfPerigee);
OE.meanAnomaly     = M;
OE.trueAnomaly     = TA;
OE.meanMotion      = n;
OE.t               = t0;
OE.JDN             = JDN;


end