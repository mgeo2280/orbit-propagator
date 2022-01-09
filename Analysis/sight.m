function LOS = sight(r1, r2)
% Function determines if two vectors r1 and r1 are within line of sight of
% eachother around the Earth. Input units are in meters.
% Mark George

% Earth radius
Re = 6371e3;

% Algorithm is in units of earth radii, so convert
r1 = r1/Re;
r2 = r2/Re;

% Check if we have an array with a vector
% if size(r1, 2) == 1 && size(r2, 2) > 1
%     r1 = repmat(r1, 1, size(r2, 2));
% elseif size(r2, 2) == 1 && size(r1, 2) > 1
%     r2 = repmat(r2, 1, size(r1, 2));
% elseif size(r2, 2) ~= size(r1, 2)
%     error('Invalid dimensions for vectors r1 and r2')
% end

% Algorithm for determining line of sight
Tmin = ( vecnorm(r1).^2 - dot(r1, r2))./( vecnorm(r1).^2 + vecnorm(r2).^2 - 2*dot(r1, r2) );
LOS = false(size(Tmin));
for i = 1:length(Tmin)
    if (Tmin(i) < 0) || (Tmin(i) > 1)
        LOS(i) = true;
    elseif ((1 - Tmin(i))*vecnorm(r1(:,i))^2+dot(r1(:,i), r2(:,i))*Tmin(i)) >= 1
        LOS(i) = true;
    end
end
   
end
