
clc; clear all;
DATA = readtable("Tohoku_freesurf.csv");
%

% Original grid and data
X = DATA.Points_0; % X coordinates
Y = DATA.Points_1; % Y coordinates
Z = DATA.Points_2; % Z coordinates (if applicable)
Ux = DATA.displacement_0; % Ux displacement
Uy = DATA.displacement_1; % Uy displacement
Uz = DATA.displacement_2; % Uz displacement
gx = DATA.gravity_acceleration_0; % gx component
gy = DATA.gravity_acceleration_1; % gy component
gz = DATA.gravity_acceleration_2; % gz component
gp = DATA.gravity_potential; % gp component

% New expanded grid
new_grid = -3000000:30000:3000000; % Define the new grid
[X_new, Y_new] = meshgrid(new_grid, new_grid); % Create the meshgrid for the new grid

% Interpolate each variable onto the new grid using scatteredInterpolant
F_Ux = scatteredInterpolant(X, Y, Ux, 'linear', 'nearest');
F_Uy = scatteredInterpolant(X, Y, Uy, 'linear', 'nearest');
F_Uz = scatteredInterpolant(X, Y, Uz, 'linear', 'nearest');
F_gx = scatteredInterpolant(X, Y, gx, 'linear', 'nearest');
F_gy = scatteredInterpolant(X, Y, gy, 'linear', 'nearest');
F_gz = scatteredInterpolant(X, Y, gz, 'linear', 'nearest');
F_gp = scatteredInterpolant(X, Y, gp, 'linear', 'nearest');

% Interpolate the data onto the new grid
Ux_new = F_Ux(X_new, Y_new);
Uy_new = F_Uy(X_new, Y_new);
Uz_new = F_Uz(X_new, Y_new);
gx_new = F_gx(X_new, Y_new);
gy_new = F_gy(X_new, Y_new);
gz_new = F_gz(X_new, Y_new);
gp_new = F_gp(X_new, Y_new);

% Fill NaN values with 0 for all variables
Ux_new(isnan(Ux_new)) = 0;
Uy_new(isnan(Uy_new)) = 0;
Uz_new(isnan(Uz_new)) = 0;
gx_new(isnan(gx_new)) = 0;
gy_new(isnan(gy_new)) = 0;
gz_new(isnan(gz_new)) = 0;
gp_new(isnan(gp_new)) = 0;

% Calculate the distance from the center of the original grid (using X and Y as the reference)
center_x = mean(DATA.Points_0);
center_y = mean(DATA.Points_1);
distance_from_center = sqrt((X_new - center_x).^2 + (Y_new - center_y).^2);

% Define the decay distance for gradual decay

% Apply exponential decay function
% Define decay parameters
start_decay_distance = 1000 * 1000;  % 1500 km in meters
full_decay_distance = 3000 * 1000;   % 1000 km linear decay range
end_decay_distance = start_decay_distance + full_decay_distance;

% Compute the linear decay factor
decay_factor = ones(size(distance_from_center)); % Default: No decay

% Apply decay only for distances beyond start_decay_distance
decay_indices = distance_from_center > start_decay_distance;
decay_factor(decay_indices) = max(0, 1 - (distance_from_center(decay_indices) - start_decay_distance) / full_decay_distance);

% Apply the decay factor to all variables
Ux_decayed = Ux_new .* decay_factor;
Uy_decayed = Uy_new .* decay_factor;
Uz_decayed = Uz_new .* decay_factor;
gx_decayed = gx_new .* decay_factor;
gy_decayed = gy_new .* decay_factor;
gz_decayed = gz_new .* decay_factor;
gp_decayed = gp_new .* decay_factor;

%% Visualize one of the decayed variables (e.g., Ux)
figure
h=surf(X_new, Y_new, gp_decayed);
title('Gradually Decayed Ux on Expanded Uniform Grid');
xlabel('X');
ylabel('Y');
zlabel('Ux');
set(h, 'EdgeColor', 'none');
view(0,0);

Gp_max = max(max(gp_decayed))
%%
%Concatenate the decayed variables into a single matrix

% Create a matrix where each column represents one of the decayed variables
data_matrix = [X_new(:), Y_new(:), X_new(:), Ux_decayed(:), Uy_decayed(:), Uz_decayed(:), ...
               gx_decayed(:), gy_decayed(:), gz_decayed(:), gp_decayed(:)];

% Column headers for clarity (optional, if you want to include them in the CSV)
headers = {'Points_0', 'Points_1', 'Points_2', 'displacement_0', 'displacement_1', 'displacement_2', 'gravity_acceleration_0',...
    'gravity_acceleration_1', 'gravity_acceleration_2', 'gravity_potential'};

% Specify the filename for saving
filename = 'Tohoku_freesurf_extrapolated.csv';

writecell([headers; num2cell(data_matrix)], filename);

disp 'extrapolated to larger grid'
disp '.csv file saved at'
pwd


