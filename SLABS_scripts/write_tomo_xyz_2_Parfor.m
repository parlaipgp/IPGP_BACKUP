

cd /media/rajesh/LaCie/SLABS/CUBIT/tomo/tomo_layers_3000X3000

clear; clc; close all;
tic;

% Load data
load tomo_matrix_10kmGrid.mat;
data_matrix = tomo_matrix;

% Filter data to keep only rows where Z <= 0
rows_to_keep = data_matrix(:, 3) <= 0;
data_matrix = data_matrix(rows_to_keep, :);

%% Define the desired uniform grid spacing
dx = 20; dy = 20; dz = 20;

% Extract coordinates and data
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
%%
% Create the uniform 3D grid
xq = x_min:dx:x_max;
yq = y_min:dy:y_max;
zq = z_min:dz:z_max;
[Xq, Yq, Zq] = meshgrid(xq, yq, zq);

disp('3D XYZ grid DONE');

% Remove NaNs from input data
valid = ~isnan(vp) & ~isnan(vs) & ~isnan(rho);
x = x(valid); y = y(valid); z = z(valid);
vp = vp(valid); vs = vs(valid); rho = rho(valid);

% Set up scattered interpolants
F_vp = scatteredInterpolant(x, y, z, vp, 'nearest', 'none');
F_vs = scatteredInterpolant(x, y, z, vs, 'nearest', 'none');
F_rho = scatteredInterpolant(x, y, z, rho, 'nearest', 'none');

disp('Scattered interpolants DONE');

% Initialize output arrays
Vp_uniform = zeros(size(Xq));
Vs_uniform = zeros(size(Xq));
Rho_uniform = zeros(size(Xq));

%% Start parallel pool if not already started
if isempty(gcp('nocreate'))
    parpool; % Start a parallel pool
end

% Perform interpolation using parfor
disp('Starting interpolation with parfor...');
parfor k = 1:numel(zq)
    % Extract slices for the current z-level
    Xq_slice = Xq(:, :, k);
    Yq_slice = Yq(:, :, k);
    Zq_slice = Zq(:, :, k);
    
    % Interpolate for the current z-level
    Vp_uniform(:, :, k) = F_vp(Xq_slice, Yq_slice, Zq_slice);
    Vs_uniform(:, :, k) = F_vs(Xq_slice, Yq_slice, Zq_slice);
    Rho_uniform(:, :, k) = F_rho(Xq_slice, Yq_slice, Zq_slice);
end
disp('Interpolation with parfor DONE');

% Fill NaNs (if any)
Vp_uniform = fillmissing(Vp_uniform, 'nearest');
Vs_uniform = fillmissing(Vs_uniform, 'nearest');
Rho_uniform = fillmissing(Rho_uniform, 'nearest');

% Flatten the grid for output
x_flat = Xq(:);
y_flat = Yq(:);
z_flat = Zq(:);
vp_flat = Vp_uniform(:);
vs_flat = Vs_uniform(:);
rho_flat = Rho_uniform(:);

% Combine into an Nx6 matrix
uniform_grid = [x_flat, y_flat, z_flat, vp_flat, vs_flat, rho_flat];

% Count the number of NaN values before removal
num_NaN_before = sum(any(isnan(uniform_grid), 2));
disp(['Number of NaNs before removal: ', num2str(num_NaN_before)]);
disp('* * * Use different interpolation (nearest/linear/natural) if NaN comes * * *');

toc;
%%

figure;    
h = slice(Xq, Yq, Zq, Rho_uniform, mean(xq), mean(yq),mean(zq));
title('Rho (kg/m3)');
xlabel('X'); ylabel('Y'); zlabel('Z');
colorbar;
set(h, 'EdgeColor', 'none');
%view(0, 0);


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

filename = 'full_tomo_5km_grid_3000X3000.xyz';

fileID = fopen(filename, 'w');

fprintf(fileID, '%.0f %.0f %.0f %.0f %.0f %.0f\n', x0, y0, z0, xe, ye, ze);
fprintf(fileID, '%.0f %.0f %.0f\n', dx, dy, dz);
fprintf(fileID, '%.0f %.0f %.0f\n', nx, ny, nz);
fprintf(fileID, '%.0f %.0f %.0f %.0f %.0f %.0f %.0f %.0f %.0f %.0f\n', Vp_min, Vp_max, Vs_min, Vs_max, Rho_min, Rho_max, 9999, 9999, 9999, 9999);

for i = 1:size(mat, 1)
    fprintf(fileID, '%.0f %.0f %.0f %.0f %.0f %.0f\n', mat(i, 1)*1000, mat(i, 2)*1000, mat(i, 3)*1000, mat(i, 4), mat(i, 5), mat(i, 6));
end

fclose(fileID);


disp 'full_tomo_5km_grid_3000X3000.xyz file written at'
pwd

