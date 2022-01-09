function E = getEccentricAnomaly(M, e)
    % Solves Keplers eqation for the Eccentric anomaly, given the mean
    % anomaly (M) and eccentricity of orbit (e). Uses Newton-Raphson
    % Method.
    %
    % Mark George
    
    % Set an error tolerence
    tol = 1e-8;
    
    % Initial guess for E
    if M < pi
        E = M + e/2;
    else
        E = M - e/2;
    end
    
    % Iterate for zero until E is found within the tolerence
    ratio = 1;
    while abs(ratio) > tol
        ratio = (E - e*sin(E) - M)/(1 - e*cos(E));
        E = E - ratio;
    end

end