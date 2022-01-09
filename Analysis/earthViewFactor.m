function F = earthViewFactor(h, lambda)
% Calculates the view factor between a single side of a flat plate orbiting
% the earth. Assumes the radius of the Earth is much larger than the plate.
% Equations taken from E. Thornton "Thermal Structures for Aerospace 
% Applications".
% Mark George
%
% Input Arguments
% h       - Orbital Altitude
% lambda  - Angle between surface normal, and ray direction through center
%           of Earth.
%
% Output Arguments
% F       - View factor of Earth from plate

% Earth radius (m)
Re = 6371e3;

% Intermediate value
H = (Re + h)/Re;

% Check if the entire Earth is visible or not, and calculate accordingly
gamma = acos(1/H);
if lambda>=0 && lambda<=gamma
    F = cos(lambda)/H^2;
elseif lambda>gamma && lambda<(pi-gamma)
    F = pi/4 - asin(sqrt(H^2 - 1)/(H*sin(lambda)))/2 + ...
        ( cos(lambda)*acos(-sqrt(H^2-1)*cot(lambda)) - sqrt(H^2-1)*sqrt(1-H^2*cos(lambda)^2))/(2*H^2);
    F = 2*F/pi;
else
    F = 0;
end

end