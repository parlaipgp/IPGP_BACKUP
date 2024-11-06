function uniform_xyz = irr2uniGrid(filename)
    % Load data from the specified .mat file
    data = load(filename);
    
    % Ensure the file has the required variables
    if ~isfield(data, 'xyz_rsGMT')
        error('The file must contain a variable named "xyz_rsGMT".');
    end
    
    % Extract x, y, z from the data
    x = data.xyz_rsGMT(:,1); 
    y = data.xyz_rsGMT(:,2);
    z = data.xyz_rsGMT(:,3);

    % Define a uniform grid in the range of x and y
    x_uniform = -50:2:50; 
    y_uniform = -50:2:50; 

    [X_grid, Y_grid] = meshgrid(x_uniform, y_uniform);
    disp('   ');
    disp(['Uniform grid between X = ', num2str(min(x_uniform)), ' and ', num2str(max(x_uniform))]);
    disp(['Uniform grid between Y = ', num2str(min(y_uniform)), ' and ', num2str(max(y_uniform))]);
    disp('   ');

    disp(' * * * change these values in irr2uniGrid.m if needed * * *');

    disp('   ');

    % Interpolate z values onto the uniform grid
    Z_grid = griddata(x, y, z, X_grid, Y_grid, 'linear');

    % Handle NaN values if any exist in the interpolated grid
    Z_grid = fillmissing(Z_grid, 'linear', 2); % Fill NaNs by interpolating along columns

    % Convert the grids to column vectors
    x_col = X_grid(:);
    y_col = Y_grid(:);
    z_col = Z_grid(:);

    % Combine into a single matrix with 3 columns
    uniform_xyz = [x_col, y_col, z_col];
    save uniform_xyz.mat uniform_xyz;

end
