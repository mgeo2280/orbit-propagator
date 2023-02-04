function gmst = jd2gmst(jdn, t)
% Function converts Julian Date (jd) to Greenwich Mean Sidereal Time,
% returning the hour angle in radians (gmst). jdn is the Julian Day 
% Number, t is the time vector since previous midnight in seconds.
%
% Mark George

% Convert time to day fractions
t = t./(24*60*60);

% Create array of julian dates
jd = t + jdn;

%Find the Julian Date of the previous midnight, jd0
jd0 = zeros(size(jd));
jdMin = floor(jd)-.5;
jdMax = floor(jd)+.5;
jd0(jd > jdMin) = jdMin(jd > jdMin);
jd0(jd > jdMax) = jdMax(jd > jdMax);

% Time since previous midnight in hours
H = (jd-jd0).*24;   

% Number of days since J2000
D = jd - 2451545.0;  
D0 = jd0 - 2451545.0;  

% Number of centuries since J2000
T = D./36525;   

%Calculate GMST in hours (0h to 24h)
gmst = mod(6.697374558 + 0.06570982441908.*D0  + 1.00273790935.*H + ...
    0.000026.*(T.^2), 24);

% Convert the hour angle to radians
gmst = (gmst./24)*2*pi;
    
end








