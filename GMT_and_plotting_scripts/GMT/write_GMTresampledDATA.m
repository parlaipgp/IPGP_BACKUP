
clear;close all;

disp 'we are at'
pwd 

ux = readmatrix('ux_rsGMT.dat', 'NumHeaderLines', 1);
uy = readmatrix('uy_rsGMT.dat', 'NumHeaderLines', 1);
uz = readmatrix('uz_rsGMT.dat', 'NumHeaderLines', 1);
gd = readmatrix('gd_rsGMT.dat', 'NumHeaderLines', 1);


lon = ux(:,1); lat = ux(:,2); 
ux = ux(:,3);
uy = uy(:,3);
uz = uz(:,3);
gd = gd(:,3);



nn = rand(length(ux), 1);  % Random vector with the same length as ux
B = [lat lon ux uy uz nn nn nn nn nn nn nn nn nn gd nn];
B = sortrows(B,1,"ascend");
B = sortrows(B,2,"ascend");

data_matrix = B;

%%
writeDataMatrixToFile(data_matrix);


%%====================================================================================
function writeDataMatrixToFile(data_matrix)
    % Input:
    %   data_matrix: An M-by-N matrix where M is the number of rows and N is the number of columns.

    % Ensure that the number of columns in data_matrix is 16
    expected_num_columns = 16;
    if size(data_matrix, 2) ~= expected_num_columns
        error('data_matrix must have %d columns.', expected_num_columns);
    end
    
    % Define the header and format specification
    header = sprintf('%12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s %12s', ...
        'Lat[deg]', 'Lon[deg]', 'Ux', 'Uy', 'Uz', 'Sxx', 'Syy', 'Szz', 'Sxy', 'Syz', 'Szx', 'Tx', 'Ty', 'Rot', 'Gd', 'Gr');
    
    formatSpec = '%12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f\n';

    % Open file for writing
    fileID = fopen('coseis.dat', 'w');
    if fileID == -1
        error('Cannot open file for writing.');
    end

    % Write the header and data to the file
    fprintf(fileID, '%s\n', header);
    for i = 1:size(data_matrix, 1)
        fprintf(fileID, formatSpec, data_matrix(i, :));
    end

    % Close the file
    fclose(fileID);
    disp ' '
    disp ' '
    disp '------------- Data is saved as "coseis.dat". Can be rename inside function if needed ----------------------'
    disp '------------- It can be direct or resampled/ Linear interpolated results----------------------'

end

