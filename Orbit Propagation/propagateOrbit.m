function [TA, RA, w, t] = propagateOrbit(OE, tRun, dt, perturbations)
% Propagate orbit for given time tRun (s) and return ECI position and 
% velocity at each corresponding timepoint in t. Uses Keplarian Orbits.
% Mark George

% Constants
mu = 3.986004418e14;
Re = 6371e3;

% Put orbital parameters into variables
h = OE(1);
e = OE(2);
RA0 = OE(3);
incl = OE(4);
w0 = OE(5);
a = OE(6);
t0 = OE(7);
M0 = OE(8);
n = OE(9);
JDN = OE(10);

% Time array, increments of dt
t = t0:dt:(t0 + tRun);

% Arrays to store trajectory
TA = zeros(size(t));
% x = TA; y = x; z = x;
% vx = TA; vy = vx; vz = vx;
RA = TA; w = TA;

% J2 corrected mean motion
p  = a*(1 - e^2);
J2 = 0.00108263;

% Check if we would like to caluclate perturbations
if perturbations
    nbar = sqrt(mu/(a^3))*( 1 + (3*J2*Re^2/(2*p^2))*(1 - 3*sin(incl)/2)*(1 - e^2)^(1/2) );
    RAdot = -3*J2*Re^2*nbar*cos(incl)/( 2*p^2 );
    wdot = 3*J2*Re^2*nbar*(2 - 5*sin(incl)^2/2)/(2*p^2);
    
    % Dsiplay these values in degrees/day
    disp(['Right Ascension drift rate: ', num2str(rad2deg(RAdot)*60*60*24), ' degrees/day'])
    disp(['Argument of Perigee drift rate: ', num2str(rad2deg(wdot)*60*60*24), ' degrees/day'])
    disp(['Approximate Westward drift: '  num2str(Re*tRun*RAdot/1000), ' km'])
    fprintf('\n')
else 
    nbar = n;
    RAdot = 0;
    wdot = 0;
end




% Iterate time index
for i = 1:length(t)

    % Calculate mean anomaly at current time
    M = M0 + nbar*(t(i) - t0);

    % Get eccentric anomaly numerically
    E = getEccentricAnomaly(M, e);

    % Calculate and store the True anomaly
    TA(i) = 2*atan( sqrt((1+e)/(1-e))*tan(E/2) ); 

    % Calculate changes to RA due to orbital pertabations
    RA(i) = RA0 + RAdot*(t(i) - t0);

    % Changes to argument of perigee due to pertabations
    w(i) = w0 + wdot*(t(i) - t0);

end
    
end