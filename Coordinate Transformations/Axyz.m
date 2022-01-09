function rB = Axyz(r, phi, theta, psi)
% Function performs rotation to vector r with Euler angles about the x, y,
% and z angles succesively in that order. Input Euler angles in radians.
% Mark George

% Calculate the transition matrix (Michael J. Rycroft & Robert F. Stengel 
% "Spacecraft Dynamics and Control")
A = [... 
    cos(psi)*cos(theta), cos(psi)*sin(theta)*sin(phi)+sin(psi)*cos(phi), -cos(psi)*sin(theta)*cos(phi)+sin(psi)*sin(phi);
    -sin(psi)*cos(theta), -sin(psi)*sin(theta)*sin(phi)+cos(psi)*cos(phi), sin(psi)*sin(theta)*cos(phi)+cos(psi)*sin(phi);
    sin(theta), -cos(theta)*sin(phi), cos(theta)*cos(phi)];

% Perform rotation
rB = A*r;

end