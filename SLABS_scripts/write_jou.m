 % Write cubit commands to a .jou file

clc; clear;close all;
load xyz_smooth.mat;
data_matrix = xyz_smooth;


    fileID = fopen('SKIN-SURF_slab_surf_smooth.jou', 'w');
    fprintf(fileID, 'journal off\n echo on\n info on\n');

    % Create vertices
    for i = 1:size(data_matrix, 1)
        fprintf(fileID, 'create vertex location %.7e %.7e %.7e\n', data_matrix(i, 1), data_matrix(i, 2), data_matrix(i, 3));
    end

    % Calculate number of longitudinal and latitudinal points
    n_lon = vertex_number;
    n_lat = vertex_number;

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
    fprintf(fileID, '\n\nsave cub5 "SKIN_JapanSlabSkin.cub5" overwrite journal\n\n');

    fclose(fileID);




    disp('Cubit commands written to * * * SKIN-SURF_slab_surf.jou * * *at');
    pwd    