function OE = propagateOrbit(OE0, tRun, dt, perturbations)
% Propagate orbit for given time tRun (s) and return ECI position and 
% velocity at each corresponding timepoint in t. Uses Keplarian Orbits.
% 
% Mark George

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

% Time array, increments of dt
t = t0:dt:(t0 + tRun);

% Arrays to store trajectory
TA = zeros(size(t));
M = zeros(size(t));
RAAN = zeros(size(t)); 
w = zeros(size(t));

% J2 corrected mean motion
p  = a*(1 - e^2);
J2 = 0.00108263;

% Check if we would like to caluclate perturbations
if perturbations
    nbar = sqrt(mu/(a^3))*( 1 + (3*J2*Re^2/(2*p^2))*(1 - 3*sin(incl)/2)*(1 - e^2)^(1/2) );
    RAdot = -3*J2*Re^2*nbar*cos(incl)/( 2*p^2 );
    wdot = 3*J2*Re^2*nbar*(2 - 5*sin(incl)^2/2)/(2*p^2);
    
    % Dsiplay these values in degrees/day
    disp(['J2 perturbation drift rates'])
    disp(['  Right Ascension drift rate     : ', num2str(rad2deg(RAdot)*60*60*24), ' degrees/day'])
    disp(['  Argument of Perigee drift rate : ', num2str(rad2deg(wdot)*60*60*24), ' degrees/day'])
    disp(['  Approximate Westward drift     : '  num2str(Re*tRun*RAdot/1000), ' km'])
    fprintf('\n')
else 
    nbar = n;
    RAdot = 0;
    wdot = 0;
end


% Iterate time 
for i = 1:length(t)

    % Calculate mean anomaly at current time
    M(i) = M0 + nbar*(t(i) - t0);

    % Get eccentric anomaly numerically
    E = getEccentricAnomaly(M(i), e);

    % Calculate and store the True anomaly
    TA(i) = 2*atan( sqrt((1+e)/(1-e))*tan(E/2) ); 

    % Calculate changes to RA due to orbital pertabations
    RAAN(i) = RAAN0 + RAdot*(t(i) - t0);

    % Changes to argument of perigee due to pertabations
    w(i) = w0 + wdot*(t(i) - t0);

end

% Return time varying orbital elements
OE = OE0;
OE.RAAN = RAAN;
OE.argOfPerigee = w;
OE.trueAnomaly = TA;
OE.meanAnomaly = M;
OE.t = t;
    
end