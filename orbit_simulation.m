% Calculate orbit trajectory and display orbit information
% mission
%
% Mark George

%% Initial Orbit Propagation

clear;
clc;
close all;

% Function paths
addpath('Coordinate Transformations', 'Orbit Propagation', 'Graphical', 'Analysis');

% Constants
mu = 3.986004418e14;

% Get initial orbital parameters
OE0 = getOrbitalParameters();
h = OE0(1);
e = OE0(2);
RA0 = OE0(3);
incl = OE0(4);
w0 = OE0(5);
a = OE0(6);
t0 = OE0(7);
M0 = OE0(8);
n = OE0(9);
JDN = OE0(10);

% Duration to run simulation, and timestep.
Torb = (2*pi/sqrt(mu))*a^(3/2);         % Orbital Period
tYear = 365*24*60*60;                   % Seconds in a year
nOrbs = 10;                % Numbger of orbits to run
tRun = nOrbs*Torb;                      % Plot orbits over a year
dt = 10;                               % Timestep

% Run simulation and obtain classical orbital parameters as funciton of
% time
perturbations = true;
[TA, RA, w, t] = propagateOrbit(OE0, tRun, dt, perturbations);

%% Eclipse Periods

% Convert classical orbital parameters to ECI coordinates
[xECI, yECI, zECI, vxECI, vyECI, vzECI] = oe2ECI(h, e, RA, incl, w, TA);
rECI = [xECI; yECI; zECI];

% Calculate eclipses
rSun = getSunVector(JDN, t);
beta = betaAngle(incl, RA, rSun);
LOS = sight(rSun, rECI);
feclipse = sum(~LOS)/numel(LOS);
disp(['Orbit Eclipse Fraction:', num2str(feclipse)])


%% ECI Plot

% Get blank sphere (represents the rotating Earth)
[xs, ys, zs, props] = createBlankSphere();

% Plot Earth and satellite trajectory
figure(); hold on; box on;
surface(xs, ys, zs, props);
plot3(xECI(LOS), yECI(LOS), zECI(LOS), 'r.');
plot3(xECI(~LOS), yECI(~LOS), zECI(~LOS), 'k.');
plot3(xECI(1), yECI(1), zECI(1), 'go')
set(gca,'XTick',[], 'YTick', [], 'ZTick', [])

% Format Plot
title('Orbit in ECI Frame')
axis equal; grid on
xlabel('x'); ylabel('y'); zlabel('z');

%% ECEF Plot

% Hour Angles then compute ECEF Trajectory
theta = jd2gmst(JDN, t);
[xECEF, yECEF, zECEF] = eci2ecef(xECI, yECI, zECI, theta);

% Ground station locaiton (Sydney CDB), convert to cartesian coordinates (in ECEF)
phiGs = deg2rad(151.2073); lambdaGs = deg2rad(-33.8708); hGs = 100;
[xGs, yGs, zGs] = llh2ecef(lambdaGs, phiGs, hGs);

% Get Earth sphere
[xe, ye, ze, props] = createEarthSphere();

% Plot Earth and satellite trajectory, aswell as ground station marker
figure(2); hold on; box on;
surface(xe, ye, ze, props);
plot3(xECEF(LOS), yECEF(LOS), zECEF(LOS), 'r.');
plot3(xECEF(~LOS), yECEF(~LOS), zECEF(~LOS), 'k.');
plot3(xECEF(1), yECEF(1), zECEF(1), 'ro')
plot3(1.015*xGs, 1.015*yGs, 1.015*zGs, 'kx', 'MarkerSize', 7, 'LineWidth', 1.2)
set(gca,'XTick',[], 'YTick', [], 'ZTick', [])

% Format Plot
title('Orbit in ECEF Frame')
axis equal; grid on
xlabel('x'); ylabel('y'); zlabel('z');

%% Ground Trace Plot

% Get lat, long, alt coordinates using ECEF coordinates
[lambdaSat, phiSat, hSat] = ecef2llh(xECEF, yECEF, zECEF);

% Read Earth Map
em = imread('earthmap1.png');

% Plot Earth map
figure(3); hold on; box on;
image([-180,180],[90,-90],em);

% Plot ground trace
plot(phiSat(LOS), lambdaSat(LOS), 'r.', 'MarkerSize', 3.5)
plot(phiSat(~LOS), lambdaSat(~LOS), 'k.', 'MarkerSize', 3.5)
plot(rad2deg(phiGs), rad2deg(lambdaGs), 'kx', 'MarkerSize', 8, 'LineWidth', 1.5)

axis xy; grid on;
title('Ground Trace of Orbit')
xlabel('Longitude (degrees)'); ylabel('Latitude (degrees)')
axis([-180, 180, -90, 90])
xticks([-180:30:180]); yticks([-90:30:90]);


