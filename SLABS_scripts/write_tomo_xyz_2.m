
cd /media/rajesh/LaCie/SLABS/CUBIT/tomo/tomo_layers_3000X3000/

clear; clc; close all
tic
load tomo_matrix_10kmGrid.mat;

data_matrix = tomo_matrix;


rows_to_keep = data_matrix(:, 3) <= 0;

% Filter the matrix to keep only rows Z<0 km
data_matrix = data_matrix(rows_to_keep, :);

%% uniform grid interpolation
% Define the desired uniform grid spacing
dx = 5;
dy = 5;
dz = 5;

x = data_matrix(:, 1);
y = data_matrix(:, 2);
z = data_matrix(:, 3);
vp = data_matrix(:, 4);
vs = data_matrix(:, 5);
rho = data_matrix(:, 6);

% Define the bounds of the grid
x_min = min(x); x_max = max(x);
y_min = min(y); y_max = max(y);
z_min = min(z); z_max = max(z);



% Create the uniform 3D grid
xq = x_min:dx:x_max;
yq = y_min:dy:y_max;
zq = z_min:dz:z_max;
%%
% interpolation
[Xq, Yq, Zq] = meshgrid(xq, yq, zq);

disp '3D XYZ grid DONE'

% Set up scattered interpolants for Vp, Vs, and Rho
F_vp = scatteredInterpolant(x, y, z, vp, 'linear', 'none'); disp '1'
F_vs = scatteredInterpolant(x, y, z, vs, 'linear', 'none'); disp '2'
F_rho = scatteredInterpolant(x, y, z, rho, 'linear', 'none'); disp '3'

disp 'scattered interpolants DONE'


% % Interpolate onto the uniform grid
Vp_uniform = F_vp(Xq, Yq, Zq); toc
Vs_uniform = F_vs(Xq, Yq, Zq); toc
Rho_uniform = F_rho(Xq, Yq, Zq); toc

disp ' interpolants GRID DONE'


% Display results (optional)
disp('Uniform grid created.');
disp(['Grid dimensions: ', num2str(length(xq)), ' x ', num2str(length(yq)), ' x ', num2str(length(zq))]);

%
disp('Filling NaN');

Vp_uniform = fillmissing(Vp_uniform, 'nearest');
Vs_uniform = fillmissing(Vs_uniform, 'nearest');
Rho_uniform = fillmissing(Rho_uniform, 'nearest');

x_flat = Xq(:);
y_flat = Yq(:);
z_flat = Zq(:);
vp_flat = Vp_uniform(:);
vs_flat = Vs_uniform(:);
rho_flat = Rho_uniform(:);

% Combine into an Nx6 matrix
uniform_grid = [x_flat, y_flat, z_flat, vp_flat, vs_flat, rho_flat];


% Count the number of NaN values before removal
num_NaN_before = sum(any(isnan(uniform_grid), 3))
disp '* * * Use different interpolation (nearest/linear/natural) if NaN comes * * *'


%save 5kmgrid_uni_interpolated.mat

%%
hFig = figure('Visible', 'off');
h = slice(Xq, Yq, Zq, Rho_uniform, mean(xq), mean(yq), mean(zq));
title('Rho (kg/m^3)');
xlabel('X'); ylabel('Y'); zlabel('Z');
colorbar;
set(h, 'EdgeColor', 'none');

% Save the figure as rho.fig
savefig(hFig, 'Rho_5kmGridLinear.fig');

% Close the figure
close(hFig);


%% write tomo.xyz
mat = uniform_grid;
mat = sortrows(mat,2,'ascend');
mat = sortrows(mat,3,'ascend');

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

disp 'check the name of .xyz file'

filename = 'tomo_5km_grid_3000X3000X1000_HeteroSlab.xyz';

fileID = fopen(filename, 'w');

fprintf(fileID, '%.0f %.0f %.0f %.0f %.0f %.0f\n', x0, y0, z0, xe, ye, ze);
fprintf(fileID, '%.0f %.0f %.0f\n', dx, dy, dz);
fprintf(fileID, '%.0f %.0f %.0f\n', nx, ny, nz);
fprintf(fileID, '%.0f %.0f %.0f %.0f %.0f %.0f %.0f %.0f %.0f %.0f\n', Vp_min, Vp_max, Vs_min, Vs_max, Rho_min, Rho_max, 9999, 9999, 9999, 9999);

for i = 1:size(mat, 1)
    fprintf(fileID, '%.0f %.0f %.0f %.0f %.0f %.0f\n', mat(i, 1)*1000, mat(i, 2)*1000, mat(i, 3)*1000, mat(i, 4), mat(i, 5), mat(i, 6));
end

fclose(fileID);


disp 'tomo.xyz file written at'
pwd

