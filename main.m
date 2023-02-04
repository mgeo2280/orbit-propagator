% Calculate orbit trajectory and display orbit information
%
% Mark George

%% Initial Orbit Propagation

clear;
clc;
close all;
addpath('propagator', 'transformations', 'geometry', 'graphics');

% Constants
mu = 3.986004418e14;

% TLE set initial conditions
TLE.epochYear    = 2023;
TLE.epochDay     = 4;
TLE.inclination  = 15;
TLE.eccentricity = 0.4;
TLE.RAAN         = 85;
TLE.argOfPerigee = 10;
TLE.meanAnomaly  = 1;
TLE.meanMotion   = 8;
OE0 = tle2oe(TLE);

% Duration to run simulation, and timestep.
Torb = (2*pi/sqrt(mu))*OE0.semimajorAxis^(3/2);  % Orbital Period
tYear = 365*24*60*60;                           % Seconds in a year
nOrbs = 10;                                     % Number of orbits to run
tRun = nOrbs*Torb;                              % Plot orbits over a year
dt = 10;                                        % Timestep
perturbations = true;

% Ground station location, geodetic lat. long. height (Sydney CBD)
latitudeGroundStation  = deg2rad(-33.8708);
longitudeGroundStation = deg2rad(151.2073);  
heightGroundStation    = 100;

% Propgate 
printInitData(OE0, TLE);
OE = propagateOrbit(OE0, tRun, dt, perturbations);

%% Eclipse Periods

% Convert classical orbital parameters to ECI coordinates
[xECI, yECI, zECI, vxECI, vyECI, vzECI] = oe2ECI(OE);
rECI = [xECI; yECI; zECI];

% Eclipse data
rSun = getSunVector(OE);
beta = betaAngle(OE, rSun);
LOS = sight(rSun, rECI);
feclipse = sum(~LOS)/numel(LOS);
disp(['Orbit Eclipse Fraction: ', num2str(feclipse)])


%% ECI Plot

% Get blank sphere (represents the rotating Earth)
[xBlankSphere, yBlankSphere, zBlankSphere, props] = createBlankSphere();

% Plot Earth and satellite trajectory
figure(1); hold on; box on;
    surface(xBlankSphere, yBlankSphere, zBlankSphere, props);
    plot3(xECI(LOS), yECI(LOS), zECI(LOS), 'r.');
    plot3(xECI(~LOS), yECI(~LOS), zECI(~LOS), 'k.');
    plot3(xECI(1), yECI(1), zECI(1), 'go')
    set(gca,'XTick',[], 'YTick', [], 'ZTick', [])
    title('Orbit in ECI Frame')
    axis equal; grid on
    xlabel('x'); ylabel('y'); zlabel('z');

%% ECEF Plot

% Hour Angles then compute ECEF Trajectory
theta = jd2gmst(OE.JDN, OE.t);
[xECEF, yECEF, zECEF] = eci2ecef(xECI, yECI, zECI, theta);

% Ground station locaiton (Sydney CDB), convert to cartesian coordinates (in ECEF)
[xGroundStation, yGroundStation, zGroundStation] = llh2ecef(latitudeGroundStation, longitudeGroundStation, heightGroundStation);

% Get Earth sphere
[xe, ye, ze, props] = createEarthSphere();

% Plot Earth and satellite trajectory, aswell as ground station marker
figure(2); hold on; box on;
    surface(xe, ye, ze, props);
    plot3(xECEF(LOS), yECEF(LOS), zECEF(LOS), 'r.');
    plot3(xECEF(~LOS), yECEF(~LOS), zECEF(~LOS), 'k.');
    plot3(xECEF(1), yECEF(1), zECEF(1), 'ro')
    plot3(1.015*xGroundStation, 1.015*yGroundStation, 1.015*zGroundStation, 'kx', 'MarkerSize', 7, 'LineWidth', 1.2)
    set(gca,'XTick',[], 'YTick', [], 'ZTick', [])
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
    plot(phiSat(LOS), lambdaSat(LOS), 'r.', 'MarkerSize', 3.5)
    plot(phiSat(~LOS), lambdaSat(~LOS), 'k.', 'MarkerSize', 3.5)
    plot(rad2deg(longitudeGroundStation), rad2deg(latitudeGroundStation), 'kx', 'MarkerSize', 8, 'LineWidth', 1.5)
    axis xy; grid on;
    title('Ground Trace of Orbit')
    xlabel('Longitude (degrees)'); ylabel('Latitude (degrees)')
    axis([-180, 180, -90, 90])
    xticks(-180:30:180); yticks(-90:30:90);
