clc; clear;close all;
cd /media/rajesh/LaCie/SLABS/CUBIT/create_jou
%cd E:/SLABS/CUBIT/create_jou/
disp 'Tomo file for model without crust and trans_layer'

load xyz_smooth.mat;
ss = xyz_smooth;   %% slab skin


disp(['top of slab at Z = ', num2str(max(ss(:,3)))]);
disp(['bottom of slab at Z = ', num2str(min(ss(:,3)))]);


tic


dist = 10;     % Find indices of all points within distance 

dx = 10;
dy = 10;
dz = 10;
% Define grid parameters
x = -1000:dx:1000;
y = -1000:dy:1000;
z = -1000:dz:0;
[X, Y, Z] = meshgrid(x, y, z);


% Initialize grids with NaN
Vp_grid = NaN(size(X));  % Initialize Vp grid as NaN
Vs_grid = NaN(size(Y));  % Initialize Vs grid as NaN
Rho_grid = NaN(size(Z)); % Initialize Rho grid as NaN

%% slab
% Known coordinates
tic
ss10 = [ss(:,1),ss(:,2),ss(:,3)-10];
ss20 = [ss(:,1),ss(:,2),ss(:,3)-20];
ss30 = [ss(:,1),ss(:,2),ss(:,3)-30];
ss40 = [ss(:,1),ss(:,2),ss(:,3)-40];
ss50 = [ss(:,1),ss(:,2),ss(:,3)-50];
ss60 = [ss(:,1),ss(:,2),ss(:,3)-60];
ss70 = [ss(:,1),ss(:,2),ss(:,3)-70];
ss80 = [ss(:,1),ss(:,2),ss(:,3)-80];
ss90 = [ss(:,1),ss(:,2),ss(:,3)-90];
ss100 = [ss(:,1),ss(:,2),ss(:,3)-100];

known_coords = [ss;ss10;ss20;ss30;ss40;ss50;ss60;ss70;ss80;ss90;ss100];  % Use the combined slab coordinates

% Fixed values for Vp, Vs, and Rho
vp_value = 9000;  % Example Vp value
vs_value = 4000;  % Example Vs value
rho_value = 3800; % Example Rho value

% Loop through each known coordinate
for i = 1:size(known_coords, 1)  % Loop through each known coordinate
    known_x = known_coords(i, 1);  % x coordinate
    known_y = known_coords(i, 2);  % y coordinate
    known_z = known_coords(i, 3);  % z coordinate

    % Calculate the distances from the known coordinate to all grid points
    distances = sqrt((X - known_x).^2 + (Y - known_y).^2 + (Z - known_z).^2);
    
    % Find indices of all points within 1 unit distance
    indices_within_one_unit = distances <= dist;

    % Replace NaN values in the grids at the found indices
    Vp_grid(indices_within_one_unit) = vp_value;
    Vs_grid(indices_within_one_unit) = vs_value;
    Rho_grid(indices_within_one_unit) = rho_value;
    i
end

disp 'SLAB = DONE'

toc
save xyz_slab
%% Oceanic mantle 
% Known coordinates
b_slabskin = min(ss(:,3));  % lowest z value on skin surface

ss100 = [ss(:,1),ss(:,2),ss(:,3)-100];   % thickness of slab = 100; so s-100km
ss110 = [ss(:,1),ss(:,2),ss(:,3)-110];

ss120 = [ss(:,1),ss(:,2),ones(length(ss110),1)*b_slabskin-120]; % slab is flatten at -120km below ss or -20km bottom of slab
ss130 = [ss(:,1),ss(:,2),ones(length(ss110),1)*b_slabskin-130];
ss140 = [ss(:,1),ss(:,2),ones(length(ss110),1)*b_slabskin-140];
bott_mod = [ss(:,1),ss(:,2),ones(length(ss110),1)*-1000]; % bottom of model z = -500 km


known_coords = [ss110;ss120;ss130;ss140;bott_mod];  % Use the combined slab coordinates

% Fixed values for Vp, Vs, and Rho
vp_value = 10300;  % Example Vp value
vs_value = 4700;  % Example Vs value
rho_value = 4400; % Example Rho value


% Loop through each known coordinate
for i = 1:size(known_coords, 1)  % Loop through each known coordinate
    known_x = known_coords(i, 1);  % x coordinate
    known_y = known_coords(i, 2);  % y coordinate
    known_z = known_coords(i, 3);  % z coordinate

    % Calculate the distances from the known coordinate to all grid points
    distances = sqrt((X - known_x).^2 + (Y - known_y).^2 + (Z - known_z).^2);
    
    % Find indices of all points within 1 unit distance
    indices_within_one_unit = distances <= dist;

    % Replace NaN values in the grids at the found indices
    Vp_grid(indices_within_one_unit) = vp_value;
    Vs_grid(indices_within_one_unit) = vs_value;
    Rho_grid(indices_within_one_unit) = rho_value;
    i
end

disp 'OCEANIC MANTLE = DONE'
disp(['* * * bottom of model at Z = ', num2str(bott_mod(1,3))]);


save xyz_slab_om_2

%% continental plate
% Known coordinates
cp0 = [ss(:,1),ss(:,2),ones(length(ss),1)*-24];   % top of continental plate at Z = -24km (0km below crust)
cp30 = [ss(:,1),ss(:,2),ones(length(ss),1)*-30]; 
cp40 = [ss(:,1),ss(:,2),ones(length(ss),1)*-40]; 
cp60 = [ss(:,1),ss(:,2),ones(length(ss),1)*-60]; 
cp80 = [ss(:,1),ss(:,2),ones(length(ss),1)*-80]; 
cp100 = [ss(:,1),ss(:,2),ones(length(ss),1)*-100]; 
bott_cp = [ss(:,1),ss(:,2),ones(length(ss),1)*-124]; % bottom of continental plate at z = - 124km

known_coords = [cp0;cp30;cp40;cp60;cp80;cp100;bott_cp];  % Use the combined slab coordinates

% Fixed values for Vp, Vs, and Rho
vp_value = 6000;  % Example Vp value
vs_value = 3300;  % Example Vs value
rho_value = 3000; % Example Rho value



% Loop through each known coordinate
for i = 1:size(known_coords, 1)  % Loop through each known coordinate
    known_x = known_coords(i, 1);  % x coordinate
    known_y = known_coords(i, 2);  % y coordinate
    known_z = known_coords(i, 3);  % z coordinate

    % Calculate the distances from the known coordinate to all grid points
    distances = sqrt((X - known_x).^2 + (Y - known_y).^2 + (Z - known_z).^2);
    
    % Find indices of all points within 1 unit distance
    indices_within_one_unit = distances <= dist;

    % Replace NaN values in the grids at the found indices
    Vp_grid(indices_within_one_unit) = vp_value;
    Vs_grid(indices_within_one_unit) = vs_value;
    Rho_grid(indices_within_one_unit) = rho_value;
    
end


disp 'CONTINENTAL PLATE = DONE'
disp(['* * * top of continental plate at Z = ', num2str(cp0(1,3))]);
disp(['* * * bottom of continental plate at Z = ', num2str(bott_cp(1,3))]);

save xyz_slab_om_cp_2

%% continental mantle
% Known coordinates
cm0 = [ss(:,1),ss(:,2),ones(length(ss),1)*-124];   % top of continental mantle at Z = -124km (0km below cp)
cm130 = [ss(:,1),ss(:,2),ones(length(ss),1)*-130]; 
bott_cm20 = [ss(:,1),ss(:,2),ss(:,3)+20]; % top of slab skin + 20km
bott_cm10 = [ss(:,1),ss(:,2),ss(:,3)+10]; % top of slab skin + 10km
bott_cm = [ss(:,1),ss(:,2),ss(:,3)];      % top of slab skin 

known_coords = [cm0;cm130;bott_cm20;bott_cm10;bott_cm];  % Use the combined slab coordinates

% Fixed values for Vp, Vs, and Rho
vp_value = 8000;  % Example Vp value
vs_value = 3500;  % Example Vs value
rho_value = 3300; % Example Rho value



% Loop through each known coordinate
for i = 1:size(known_coords, 1)  % Loop through each known coordinate
    known_x = known_coords(i, 1);  % x coordinate
    known_y = known_coords(i, 2);  % y coordinate
    known_z = known_coords(i, 3);  % z coordinate

    % Calculate the distances from the known coordinate to all grid points
    distances = sqrt((X - known_x).^2 + (Y - known_y).^2 + (Z - known_z).^2);
    
    % Find indices of all points within 1 unit distance
    indices_within_one_unit = distances <= dist;

    % Replace NaN values in the grids at the found indices
    Vp_grid(indices_within_one_unit) = vp_value;
    Vs_grid(indices_within_one_unit) = vs_value;
    Rho_grid(indices_within_one_unit) = rho_value;
   i 
end

save xyz_slab_om_cp_cm_2

disp 'CONTINENTAL MANTLE = DONE'
disp(['* * * top of continental mantle at Z = ', num2str(cm0(1,3))]);
disp(['* * * bottom of continental mantle at Z = ', num2str(bott_cm(1,3))]);

%%

save all_grid_without_fillings_2
% Fill remaining NaN values in Vp_grid using nearest neighbor interpolation
Vp_grid_filled = fillmissing(Vp_grid, 'nearest');

% Similarly, fill NaN values in Vs_grid and Rho_grid, if needed
Vs_grid_filled = fillmissing(Vs_grid, 'nearest');
Rho_grid_filled = fillmissing(Rho_grid, 'nearest');

% Check if any NaN values are left
nan_count_vp = sum(isnan(Vp_grid_filled(:)));
disp(['Number of NaN values left in Vp_grid after nearest interpolation: ', num2str(nan_count_vp)]);

%%
% Flatten each 3D grid into a column vector
X_flat = X(:);
Y_flat = Y(:);
Z_flat = Z(:);

Vp_flat = Vp_grid_filled(:);
Vs_flat = Vs_grid_filled(:);
Rho_flat = Rho_grid_filled(:);

data_matrix = [X_flat, Y_flat, Z_flat, Vp_flat, Vs_flat, Rho_flat];
xyzvpvsrho = data_matrix(~any(isnan(data_matrix), 2), :);                % removing rows with NaN. We need layers of 
                                                                         % material properties not whole 3D grid of tomo points

save xyzvpvsrho_2.mat xyzvpvsrho
%% Visualization

figure;
scatter3(X_flat, Y_flat, Z_flat, 30, Vp_flat, 'filled');
title('3D Scatter Plot of Coordinates with Color Representing Vp');
xlabel('X Coordinate');
ylabel('Y Coordinate');
zlabel('Z Coordinate');
colorbar;
grid on;
% 
% print('check_tomo','-dpng','-r300');
% savefig('check_tomo.fig');  % Save the current figure as 'check.fig'


