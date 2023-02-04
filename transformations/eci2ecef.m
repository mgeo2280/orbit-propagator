function [xECEF, yECEF, zECEF] = eci2ecef(xECI, yECI, zECI, theta)
% Converts ECI trajectory coordinates to ECEF. Takes an array of
% coordinate and time values. theta is the angle since last crossing of
% Greenwhich Meridian with Vernal Equinox
%
% Mark George

% Earth angular rate (rad/s)
omega = 7.292115e-5;

% Initialise arrays to return
xECEF = zeros(size(xECI)); yECEF = xECEF; zECEF = xECEF;

% Iterate times
for i = 1:length(theta)

    % Transformation matrix for this time
    C = [cos(theta(i)), sin(theta(i)), 0;
        -sin(theta(i)), cos(theta(i)), 0;
        0, 0, 1];

    % Position vector in ECI
    rECI = [xECI(i); yECI(i); zECI(i)];
    rECEF = C*rECI;
    xECEF(i) = rECEF(1); yECEF(i) = rECEF(2); zECEF(i) = rECEF(3);

end
    

end