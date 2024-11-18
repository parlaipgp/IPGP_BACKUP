
cd /media/rajesh/LaCie/SLABS/CUBIT/create_jou/
clear; clc; close all

load tomo_matrix.mat;
data_matrix = tomo_matrix;

% Assume your original matrix is called data_matrix with columns [x, y, z, vp, vs, rho]

x = data_matrix(:, 1);
y = data_matrix(:, 2);
z = data_matrix(:, 3);
vp = data_matrix(:, 4);
vs = data_matrix(:, 5);
rho = data_matrix(:, 6);

% Step 1: Find unique values of x, y, and z
x_unique = unique(x);
y_unique = unique(y);
z_unique = unique(z);

%%
% Step 2: Create a full grid of (x, y, z) combinations
[X_grid, Y_grid, Z_grid] = meshgrid(x_unique, y_unique, z_unique);

% Flatten the grids to create a full list of (x, y, z) points
x_full = X_grid(:);
y_full = Y_grid(:);
z_full = Z_grid(:);

% Step 3: Interpolate vp, vs, and rho values onto this complete grid
vp_full = griddata(x, y, z, vp, x_full, y_full, z_full, 'linear');
vs_full = griddata(x, y, z, vs, x_full, y_full, z_full, 'linear');
rho_full = griddata(x, y, z, rho, x_full, y_full, z_full, 'linear');

% Step 4: Combine into a single matrix [x, y, z, vp, vs, rho] with no missing combinations
data_matrix_full = [x_full, y_full, z_full, vp_full, vs_full, rho_full];

% Display the size of the full matrix
disp('Size of data_matrix_full:');
disp(size(data_matrix_full));


%%
figure;
scatter3(x_full, y_full, z_full, 30, vp_full, 'filled');
title('3D Scatter Plot of Coordinates with Color Representing Vp');
xlabel('X Coordinate');
ylabel('Y Coordinate');
zlabel('Z Coordinate');
colorbar;
grid on;
%%

mat = data_matrix_full;

x0 = min(mat(:,1))*1000;
xe = max(mat(:,1))*1000;
y0 = min(mat(:,2))*1000;
ye = max(mat(:,2))*1000;
z0 = min(mat(:,3))*1000;
ze = max(mat(:,3))*1000;

dx = dx*1000;
dy = dy*1000;
dz = dz*1000;


% Extract x, y, z columns 
x_values = mat(:, 1);
y_values = mat(:, 2);
z_values = mat(:, 3);

nx = numel(unique(x_values));
ny = numel(unique(y_values));
nz = numel(unique(z_values));


Vp_min = min(mat(:,4));
Vp_max = max(mat(:,4));
Vs_min = min(mat(:,5));
Vs_max = max(mat(:,5));
Rho_min = min(mat(:,6));
Rho_max = max(mat(:,6));


filename = 'full_tomo.xyz';

fileID = fopen(filename, 'w');

fprintf(fileID, '%.0f %.0f %.0f %.0f %.0f %.0f\n', x0, y0, z0, xe, ye, ze);
fprintf(fileID, '%.0f %.0f %.0f\n', dx, dy, dz);
fprintf(fileID, '%.0f %.0f %.0f\n', nx, ny, nz);
fprintf(fileID, '%.0f %.0f %.0f %.0f %.0f %.0f %.0f %.0f %.0f %.0f\n', Vp_min, Vp_max, Vs_min, Vs_max, Rho_min, Rho_max, 9999, 9999, 9999, 9999);

for i = 1:size(mat, 1)
    fprintf(fileID, '%.0f %.0f %.0f %.0f %.0f %.0f\n', mat(i, 1)*1000, mat(i, 2)*1000, mat(i, 3)*1000, mat(i, 4), mat(i, 5), mat(i, 6));
end

fclose(fileID);


