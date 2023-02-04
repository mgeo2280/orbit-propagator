function [x, y, z, vx, vy, vz] = oe2ECI(OE)
% Convert orbtal elements to ECI position and velocity. TA can be an
% array of values.
%
% Mark George

% Unpack
h    = OE.angularMomentum;
e    = OE.eccentricity;
RAAN = OE.RAAN;
incl = OE.inclination;
w    = OE.argOfPerigee;
TA   = OE.trueAnomaly;

% Constants
mu = 3.986004418e14;

% Initialise outputs
x = zeros(size(RAAN)); y = x; z = x;
vx = x; vy = x; vz = x;

% Iterate through all elements
for i = 1:length(TA)
    
    % Perifocal velocity and position vectors
    rp = (h^2/mu) * (1/(1 + e*cos(TA(i)))) * (cos(TA(i))*[1;0;0] ... 
        + sin(TA(i))*[0;1;0]); 
    vp = (mu/h) * (-sin(TA(i))*[1;0;0] + (e + cos(TA(i)))*[0;1;0]);

    % Rotation matrix about RA
    R3W = [cos(RAAN(i)), sin(RAAN(i)), 0;
          -sin(RAAN(i)), cos(RAAN(i)), 0;
           0           , 0           , 1];

    % Rotation about i
    R1i = [1, 0         , 0        ;
           0, cos(incl) , sin(incl);
           0, -sin(incl), cos(incl)];

    % Rotation aobut w
    R3w = [cos(w(i)), sin(w(i)), 0;
          -sin(w(i)), cos(w(i)), 0;
           0        , 0        , 1];

    % Perifocal to Geocentric transformation matrix
    Qpx = R3W'*R1i'*R3w';

    % Now convert the perifocal vectors into geocentric ECI
    r = Qpx*rp;
    v = Qpx*vp;

    % Output
    x(i)  = r(1); y(i)  = r(2); z(i) = r(3);
    vx(i) = v(1); vy(i) = v(2); vz(i) = v(3);
    
end

end