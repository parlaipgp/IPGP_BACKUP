function [slipX, slipY, slipZ] = calculateSlip(strike, dip, rake)
    % Convert angles from degrees to radians
    % This function takes the strike, dip, and rake angles (in degrees) and 
    % returns the slip vector components in the X, Y, and Z directions.
    % The angles are first converted from degrees to radians because MATLABTs trigonometric functions use radians.
    strike = deg2rad(strike);
    dip = deg2rad(dip);
    rake = deg2rad(rake);
    
    % Calculate slip components
    slipX = cos(rake) * cos(strike) + sin(rake) * sin(strike) * cos(dip);
    slipY = cos(rake) * sin(strike) - sin(rake) * cos(strike) * cos(dip);
    slipZ = -sin(rake) * sin(dip);
end
