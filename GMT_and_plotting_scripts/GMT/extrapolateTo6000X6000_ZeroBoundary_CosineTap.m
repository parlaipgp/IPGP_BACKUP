warning('off', 'all');
clear all; 


disp 'zeros at boundaries for Ux Uy Uz and Cosine tapering';
% Load data
DATA = readtable("Tohoku_freesurf.csv");

% Original grid and data
X = DATA.Points_0; % X coordinates
Y = DATA.Points_1; % Y coordinates
Ux = DATA.displacement_0; % Ux displacement
Uy = DATA.displacement_1; % Uy displacement
Uz = DATA.displacement_2; % Uz displacement
gx = DATA.gravity_acceleration_0; % gx component
gy = DATA.gravity_acceleration_1; % gy component
gz = DATA.gravity_acceleration_2; % gz component
gp = DATA.gravity_potential; % gp component

% Define the new expanded grid
new_grid = -3000000:30000:3000000; % Define new grid range
[X_new, Y_new] = meshgrid(new_grid, new_grid); % Create the meshgrid

% Compute radial distance from center
R = sqrt(X_new.^2 + Y_new.^2);

% Define tapering parameters
R_inner = 1500000;  % Start of tapering (2000 km)
R_outer = 3000000;  % Full zero boundary (3000 km)

% Create a cosine taper function
T1 = ones(size(R));
taper_mask = (R > R_inner) & (R <= R_outer);  % Identify tapering region
T1(taper_mask) = 0.5 * (1 + cos(pi * (R(taper_mask) - R_inner) / (R_outer - R_inner)));  % Cosine taper
T1(R > R_outer) = 0;  % Full zero outside taper region

T2 = ones(size(R));
taper_mask = (R > R_inner) & (R <= R_outer);  % Identify tapering region
T2(taper_mask) = 0.5 * (1 + cos(pi * (R(taper_mask) - R_inner) / (R_outer - R_inner)));  % Cosine taper
T2(R > R_outer) = -0.5;  % Full zero outside taper region


% Use scatteredInterpolant with 'linear' interpolation and 'nearest' extrapolation
F_Ux = scatteredInterpolant(X, Y, Ux, 'linear', 'nearest');
F_Uy = scatteredInterpolant(X, Y, Uy, 'linear', 'nearest');
F_Uz = scatteredInterpolant(X, Y, Uz, 'linear', 'nearest');
F_gx = scatteredInterpolant(X, Y, gx, 'linear', 'nearest');
F_gy = scatteredInterpolant(X, Y, gy, 'linear', 'nearest');
F_gz = scatteredInterpolant(X, Y, gz, 'linear', 'nearest');
F_gp = scatteredInterpolant(X, Y, gp, 'linear', 'nearest');

% Interpolate onto the new grid
Ux_new = F_Ux(X_new, Y_new) .* T1;
Uy_new = F_Uy(X_new, Y_new) .* T1;
Uz_new = F_Uz(X_new, Y_new) .* T1;
gx_new = F_gx(X_new, Y_new) .* T1;
gy_new = F_gy(X_new, Y_new) .* T1;
gz_new = F_gz(X_new, Y_new) .* T1;
gp_new = F_gp(X_new, Y_new) .* T1;  disp '----> check tapering for gp/gd'

% Fill any remaining NaN values with nearest available data
Ux_new(isnan(Ux_new)) = mean(Ux, 'omitnan');
Uy_new(isnan(Uy_new)) = mean(Uy, 'omitnan');
Uz_new(isnan(Uz_new)) = mean(Uz, 'omitnan');
gx_new(isnan(gx_new)) = mean(gx, 'omitnan');
gy_new(isnan(gy_new)) = mean(gy, 'omitnan');
gz_new(isnan(gz_new)) = mean(gz, 'omitnan');
gp_new(isnan(gp_new)) = mean(gp, 'omitnan');


%% Visualize one of the decayed variables (e.g., Ux)
% figure
% h = surf(X_new./1000, Y_new./1000, gp_new); % Use gp_new instead of gp_decayed
% title({'Extrapolated Gp on Expanded Uniform Grid';'Tapering starts from 1500 km. Zeros at 3000km'});
% %title({'Extrapolated Gp on Expanded Uniform Grid';'No Tapering'});
% xlabel('X km');
% ylabel('Y km');
% zlabel('Gravitation potential');
% shading interp; % Smooth shading
% colorbar; % Add a color scale
% colormap(turbo(100)); 
% view(3); % Set to 3D view

%%
% Create a matrix where each column represents one of the extrapolated variables
data_matrix = [X_new(:), Y_new(:), X_new(:), Ux_new(:), Uy_new(:), Uz_new(:), ...
               gx_new(:), gy_new(:), gz_new(:), gp_new(:)];


% Column headers for clarity (optional, if you want to include them in the CSV)
headers = {'Points_0', 'Points_1', 'Points_2', 'displacement_0', 'displacement_1', 'displacement_2', 'gravity_acceleration_0',...
    'gravity_acceleration_1', 'gravity_acceleration_2', 'gravity_potential'};

% Specify the filename for saving
filename = 'Tohoku_freesurf_extrapolated.csv';

writecell([headers; num2cell(data_matrix)], filename);

disp 'extrapolated to larger grid'
disp '.csv file saved at'
pwd


