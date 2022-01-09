function [xe, ye, ze, props] = createEarthSphere()
    % Initialises Topological Earth sphere for surface plotting.
    % Mark George
    
    % Load topographical Earth map
    load('topo.mat','topo','topomap1');
    
    % Rotate to be consitant with ECEF definition
    topo = [topo(:,181:360) topo(:,1:180)]; 

    % Create a sphere, make it earth sized (in meters)
    [xe,ye,ze] = sphere(50);
    xe = xe.*6378000;
    ye = ye.*6378000;
    ze = ze.*6378000;

    % Set visual properties for plot
    props.AmbientStrength = 0.1;
    props.DiffuseStrength = 1;
    props.SpecularColorReflectance = .5;
    props.SpecularExponent = 20;
    props.SpecularStrength = 1;
    props.FaceColor= 'texture';
    props.EdgeColor = 'none';
    props.FaceLighting = 'phong';
    props.Cdata = topo;

end