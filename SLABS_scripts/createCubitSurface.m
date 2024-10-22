function createCubitSurface(lon, lat, grid_int)
    % Load the depth data
    disp 'loading depths_rsGMT.dat'
    
    load depths_rsGMT.dat;
    DATA = depths_rsGMT;

    % Convert longitude, latitude, and height to a local coordinate system
    llh = [DATA(:,1)'; DATA(:,2)'; DATA(:,3)'];
    
    disp(' * * * Origin is taken at (138.5 40) for llh2xyz * * *');

    xyz = llh2local(llh, [138.5, 40]);
    
    x = xyz(1, 1:end);
    y = xyz(2, 1:end);
    h = llh(3, 1:end);

    disp(['Degrees along Longitude = ', num2str(lon)]);
    disp(['Degrees along Latitude = ', num2str(lat)]);
    disp(['Grid intervals in degrees = ', num2str(grid_int)]);


    disp(['Number of vertex = ', num2str(length(x))]);

    % Write cubit commands to a .jou file
    data_matrix = [x', y', h'];

    fileID = fopen('slab_surf.jou', 'w');
    fprintf(fileID, 'journal off\n echo on\n info on\n');

    % Create vertices
    for i = 1:size(data_matrix, 1)
        fprintf(fileID, 'create vertex location %.7e %.7e %.7e\n', data_matrix(i, 1), data_matrix(i, 2), data_matrix(i, 3));
    end

    % Calculate number of longitudinal and latitudinal points
    n_lon = (lon / grid_int) + 1;
    n_lat = (lat / grid_int) + 1;

    % Create curves
    ii = 1; 
    jj = n_lon; % longitude points
    for k = 1:n_lat  % latitude points
        fprintf(fileID, 'create curve spline location vertex %d to %d\n', ii, jj);
        ii = ii + n_lon; 
        jj = jj + n_lon;
    end

    % Finalize the surface creation
    fprintf(fileID, '\n\ndelete vertex all \n\n');
    fprintf(fileID, '\n\ncreate surface skin curve 1 to %d \n\n', n_lat - 1);
    fprintf(fileID, '\n\ndelete curve all \n\n');
    fprintf(fileID, '\n\nsave cub5 "JapanSlabSkin.cub5" overwrite journal\n\n');

    fclose(fileID);
    
    disp('Cubit commands written to * * * slab_surf.jou * * *at');
    pwd
end
