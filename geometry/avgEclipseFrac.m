function [feclipse, tfe] = avgEclipseFrac(LOS, t, Torb, dt, orbStep)
% Function returns average eclipse fraction over time.
% Mark George
%
% Input Arguments:
% LOS         - Array of booleans, with 1 meaning the satellite is in view
%               of the sun, and 0 meaning it is in eclipse.
% t           - Times corresponding to the array LOS
% Torb        - Orbital period
% dt          - Timestep in array t
% orbStep     - Number of orbits to average over
%
% Output Arguments:
% feclipse   - Eclipse fraction
% tfe        - Start time of where average ecliipse fraction is calculated
%              at.

% Total number of orbits (rounded down)
nOrbs = fix(t(end)/Torb);

feclipse = [];
tfe = [];
for i = orbStep:orbStep:nOrbs
   orbIndx = ((i-orbStep+1)*fix(Torb/dt)):i*fix(Torb/dt);
   feclipse(end+1) = mean(~LOS(orbIndx));
   tfe(end+1) = t(orbIndx(1));
end

end