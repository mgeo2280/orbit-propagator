function deg = dms2deg(d, m, s)
% Convert degrees minutes seconds to degrees
deg = d + m/60 + s/3600;
end