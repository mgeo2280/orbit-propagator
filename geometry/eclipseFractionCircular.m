function feclipse = eclipseFractionCircular(beta, h)
% Function calculate eclipse fraction assuming circular orbit. Uses formula
% from Sumanth R M (2019) "Computation of Eclipse Time for Low-Earth Orbiting Small
% Satellites".
% Mark George
%
% Input Arguments:
% beta        - beta angle
% h           - Orbital altitude
%
% Output Arguments:
% feclipse    - Eclipse fraction for time in t

% Earth radius
Re = 6371e3;

% Calculate the eclipse fraction for each beta
betaStar = asin(Re./(Re+h));
feclipse = acos(sqrt(h.^2 + 2*Re*h)./((Re+h).*cos(beta)))/pi;
feclipse(abs(beta)>betaStar) = 0;

end