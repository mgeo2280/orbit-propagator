function [xe, ye, ze, props] = createEarthSphere()
    % Initialise blank sphere with Earth Radius for plotting.
    % Mark George

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

end