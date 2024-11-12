
function xyz_smooth = smoothXYZ(xyz, sigma)
% smoothXYZ applies Gaussian smoothing to a 3D dataset.
%
% Inputs:
%   xyz   - A Nx3 matrix with columns representing x, y, and z coordinates
%   sigma - Standard deviation for Gaussian smoothing
%
% Output:
%   xyz_smooth - A Nx3 matrix with smoothed z values

    % Extract x, y, and z columns
    x = xyz(:, 1);
    y = xyz(:, 2);
    z = xyz(:, 3);

    % Determine the grid dimensions
    nx = numel(unique(x));  % Number of unique x values
    ny = numel(unique(y));  % Number of unique y values

    % Reshape z to a 2D matrix based on the grid dimensions
    Z = reshape(z, ny, nx);  % Assuming y varies faster than x

    % Apply Gaussian smoothing
    Z_smooth = imgaussfilt(Z, sigma);

    % Reshape the smoothed Z back to a column vector
    z_smooth = reshape(Z_smooth, [], 1);

    % Reassemble the smoothed data
    xyz_smooth = [x, y, z_smooth];

    % Optionally save the output
    save('xyz_smooth.mat', 'xyz_smooth');

    % Plot the original and smoothed surfaces for comparison (optional)
    % figure;
    % [X, Y] = meshgrid(unique(x), unique(y));
    % 
    % subplot(1, 2, 1);
    % surf(X, Y, Z);  % Original surface
    % title('Original Surface');
    % shading interp;
    % 
    % subplot(1, 2, 2);
    % surf(X, Y, Z_smooth);  % Smoothed surface
    % title('Smoothed Surface');
    % shading interp;
end
