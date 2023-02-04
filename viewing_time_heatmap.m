% Study of optical axis angles with sun and earth over time
% Creates heatmaps of viewing times to alpha-Cen by simulating
% orbit at each Solar Right Ascension (SRA) and Right Ascension of
% Ascending Node (RAAN). Viewing times are based on minimum permissible 
% angles between the optical axis and the Sun and Earth.
%
% Mark George

%% Initial Setup and Orbit Propagation

clear;
clc;
close all;
plotConfig()

% Function paths
addpath('propagator', 'transformations', 'geometry', 'graphics');

% Constants
mu = 3.986004418e14;
Re = 6371e3;
sigma = 5.670374419e-8;

% Get initial orbital parameters
% TLE set initial conditions
TLE.epochYear    = 2023;
TLE.epochDay     = 4;
TLE.inclination  = 15;
TLE.eccentricity = 0;
TLE.RAAN         = 85;
TLE.argOfPerigee = 10;
TLE.meanAnomaly  = 1;
TLE.meanMotion   = 15.2;
OE0 = tle2oe(TLE);

% Set to true if doing an SSO orbit, this will plot RAAN-SRA on the
% vertical axis instead of just RAAN.
SSO = false;

% Duration to run simulation, and timestep.
Torb = (2*pi/sqrt(mu))*OE0.semimajorAxis^(3/2);         % Orbital Period
tRun = Torb;                            % Plot orbits over a year
dt = 30;                                % Timestep, this needs to be small enough to give accurave viewing times
        
% Run simulation and obtain classical orbital parameters as funciton of
% time
perturbations = false;                  % Best leave these off for heatmap creation
OE = propagateOrbit(OE0, tRun, dt, perturbations);

% Minimum allowable angle between the optical axis and sun and earth
sunAngleMin = deg2rad(90);
earthAngleMin = deg2rad(110);


%% RA of sun

% Look at a range of RA of sun
sunRA = deg2rad(linspace(0, 360, 512));

% RA and DEC of alpha cen and the sun
[alphaCenRA, alphaCenDEC] = alphaCen();
sunDEC = asin(sin(deg2rad(23.44))*sin(sunRA));

% alpha cen and sun vectors
rSun = RaDec2ECI(sunRA, sunDEC);
rAlpha = repmat(RaDec2ECI(alphaCenRA, alphaCenDEC), 1, size(rSun, 2));

% Calulcate the sun angle
angleSun = acos( dot(rAlpha, rSun)./(vecnorm(rAlpha).*vecnorm(rSun)) );

% Plot
figure(); hold on;
plot(rad2deg(sunRA), rad2deg(angleSun))
xlabel('RA of the Sun'); ylabel('Angle between Sun and Optical Axis');
grid on; grid minor;
 

%% Viewing Times - Funtion of Solar RA

% Number of days, approximate that there is 360 days in a year, makes the 
% calculation easier
Ndays = 0:360;

% RA of sun
SRA = deg2rad(Ndays - 80);

% RA of ascending node
RA0 = deg2rad(linspace(0, 360, 360));

% Difference between RA0 and RAS (for looking at SSO orbit)
deltaRA = deg2rad(linspace(0, 360, numel(RA0)));

% Access times matrices
accessTimeSun = zeros([numel(SRA), numel(RA0)]);
accessTimeEclipse = zeros([numel(SRA), numel(RA0)]);
accessTimeTotal = zeros([numel(SRA), numel(RA0)]);

% Iterate the solar right ascensions
for i = 1:length(SRA)
    
    % Solve for each RA of ascending nodes
    for j = 1:length(RA0)
        
        % Set the orbital element
        if SSO
            OE0.RAAN = SRA(i) + deltaRA(j);
        else
            OE0.RAAN = RA0(j);
        end
        
        % Propagate the orbit
        OE = propagateOrbit(OE0, tRun, dt, perturbations);
        
        % Satellite in ECI Frame
        [xECI, yECI, zECI, vxECI, vyECI, vzECI] = oe2ECI(OE);
        rECI = [xECI; yECI; zECI];
        
        % RA and DEC of alpha cen and the sun
        [alphaCenRA, alphaCenDEC] = alphaCen();
        sunDEC = asin(sin(deg2rad(23.44))*sin(SRA(i)));

        % alpha cen and sun position vectors, make them as functions of
        % time for compatibility with other subroutines
        rAlpha = repmat(RaDec2ECI(alphaCenRA, alphaCenDEC), 1, size(rECI, 2));
        rSun = repmat(RaDec2ECI(SRA(i), sunDEC), 1, size(rECI, 2));
        
        % Earth and sun angles from the optical axis
        angleSun = acos( dot(rAlpha, rSun)./(vecnorm(rAlpha).*vecnorm(rSun)) );
        angleEarth = acos( dot(rAlpha, -rECI)./(vecnorm(rAlpha).*vecnorm(-rECI)) );
        
        % If it is in eclipse
        LOS = sight(rSun, rECI);
        
        % Calculate the access time for this case and add it to the average
        aTS = sum((angleEarth(LOS) >= earthAngleMin) & (angleSun(LOS) >= sunAngleMin))*dt;
        aTE = sum((angleEarth(~LOS) >= earthAngleMin))*dt;
        accessTimeSun(i, j) = aTS;
        accessTimeEclipse(i, j) = aTE;
        accessTimeTotal(i, j) = aTS + aTE;
               
    end

end

% Transpose them so solar right asciension is on the x axis
accessTimeSun = accessTimeSun';
accessTimeEclipse = accessTimeEclipse';
accessTimeTotal = accessTimeTotal';


%% Plotting

% Smooth the matrices, maintain the zeros
SunZeros = accessTimeSun==0;
EclipseZeros = accessTimeEclipse==0;
Nr = 0;
Nc = 0;
accessTimeSunSmooth = smooth2a(accessTimeSun,Nr,Nc);
accessTimeSunSmooth(SunZeros) = 0;
accessTimeEclipseSmooth = smooth2a(accessTimeEclipse,Nr,Nc);
accessTimeEclipseSmooth(EclipseZeros) = 0;

% Sun
tMax = 2300;            % Colourbar limit, set it for consistency between Sun and eclipse plots
titleString = 'In Sun';
plotHeatMap(accessTimeSunSmooth, RA0, SRA, titleString, tMax, SSO)
% saveas(gcf, 'sso_sun_heatmap.png')

% Eclipse
titleString = 'Eclipse';
plotHeatMap(accessTimeEclipseSmooth, RA0, SRA, titleString, tMax, SSO)
% saveas(gcf, 'sso_eclipse_heatmap.png')


%%
function plotHeatMap(accessTime, RA0, RAS, titleString, tMax, SSO)
% Plots viewing time matrix in a new figure

f = figure;
f.Position = [50, 50, 1800, 600];
imagesc(flipud(accessTime))
colormap(flipud(hot))
cb = colorbar();
cb.Label.Interpreter = 'latex';
cb.TickLabelInterpreter = 'tex';
set(cb, 'YTick', 0:300:tMax)
caxis([0, tMax])
ylabel(cb, 'Viewing Time (s)')
set(cb.Label,'FontSize',30)

% X label, add the approximate months correponding to each SRA
row1 = rad2deg(linspace(RAS(1), RAS(end), 13));
row2 = {'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', ...
        'Oct', 'Nov', 'Dec', 'Jan'};
labelArray = [compose('%.0f',row1); row2]; 
tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
tickLabels = strsplit(tickLabels);
ax = gca(); 
ax.XTick = linspace(0, size(accessTime, 2), 13); 
ax.XLim = [0, size(accessTime, 2)];
ax.TickLabelInterpreter = 'tex';
ax.XTickLabel = tickLabels; 

% Y label
tickLabels = rad2deg(linspace(RA0(1), RA0(end), 5));
ax.YTick = linspace(0, size(accessTime, 1), 5); 
ax.YLim = [0, size(accessTime, 1)];
ax.TickLabelInterpreter = 'tex';
ax.YTickLabel = tickLabels; 
set(gca,'YDir','normal')

ax.FontSize = 26;

% Y axis label string
if SSO
    ylabelString = 'RAAN - SRA (deg)';
else
    ylabelString = 'RAAN (deg)';
end

grid on;
%ax.GridColor = [1, 1, 1];  % [R, G, B]
ax.GridAlpha = 0.25;  % Make grid lines less transparent.
xlabel('SRA (deg)'); ylabel(ylabelString);
title(titleString, 'fontsize', 30)

end

