function [phi, theta, psi] = eulerSatAlign(rECI, psi)
% Function returns euler angles phi (x), theta (y), psi (z) for rotations
% in that order to align the positive z axis in the body frame, with the
% vector rECI in the ECI frame of the satellite. The rotation psi is an
% additional degree of freedom, which can input optionally. Angles in
% radians.
% Mark George

% Check if psi, has been given
if ~exist('psi', 'var')
    psi = 0;
end

% The side which the y component of the rECI vector is on determines which
% direction we should rotate about x
if rECI(2) > 0 && rECI(3) > 0
    phi = atan(-rECI(2)/rECI(3));
elseif rECI(2) > 0 && rECI(3) < 0
    phi = atan(-rECI(2)/rECI(3)) - pi;
elseif rECI(2) < 0 && rECI(3) > 0
    phi = atan(-rECI(2)/rECI(3));
elseif rECI(2) < 0 && rECI(3) < 0
    phi = atan(-rECI(2)/rECI(3)) + pi;
else
    phi = 0;
end
   
% The side which the x component is on determines which direction we should
% rotate about y, this is automatically satisfied after the above
theta = atan(rECI(1)/sqrt(rECI(2)^2 + rECI(3)^2));
    
end