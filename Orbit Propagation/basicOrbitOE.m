function OE = basicOrbitOE(beta, hSat)
% Function returns equivelant Keplarian orbital elements to give a basic
% orbit defined by beta angle and altitude. Assumes the sun is in the +x
% direction and the orbit is circular.

% Constants
mu = 3.986004418e14;
Re = 6371e3;

% This is a circular obit
e = 0;
a = Re + hSat;
h = sqrt( a*mu*(1 - e^2) );
RA = pi/2;                      % Rotate the orbit so it faces the sun vector
incl = beta;                       % This is because we set RA = pi/2 and sun is in the +x
w = -pi/2;                      % Zero anomaly is in front of the sun
t0 = 0;
T = (2*pi/sqrt(mu))*a^(3/2);
n = 2*pi/T;
M0 = 0;
JDN = 0;                        % Doesn't matter here

% Store the orbital parameters
OE = [h, e, RA, incl, w, a, t0, M0, n, JDN];

end