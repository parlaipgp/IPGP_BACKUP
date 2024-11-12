clc; clear; close all;
cd /media/rajesh/LaCie/SLABS/CUBIT/create_jou/
disp 'Tomo file for model without crust and trans_layer'
load uniform_xyz.mat;  % Load your xyz data
ss = uniform_xyz;   %% slab skin
tic
dist = 80;     % Find indices of all points within distance 

dx = 40;
dy = 40;
dz = 40;
% Define grid parameters
x = -780:dx:780;
y = -780:dy:780;
z = -1000:10:-24;
[X, Y, Z] = meshgrid(x, y, z);

% Initialize grids with NaN outside the parfor loop
Vp_grid = NaN(size(X));  % Initialize Vp grid as NaN
Vs_grid = NaN(size(Y));  % Initialize Vs grid as NaN
Rho_grid = NaN(size(Z)); % Initialize Rho grid as NaN

%% slab
% Known coordinates
tic
ss10 = [ss(:,1), ss(:,2), ss(:,3)-10];
ss20 = [ss(:,1), ss(:,2), ss(:,3)-20];
ss30 = [ss(:,1), ss(:,2), ss(:,3)-30];
ss40 = [ss(:,1), ss(:,2), ss(:,3)-40];
ss50 = [ss(:,1), ss(:,2), ss(:,3)-50];
ss60 = [ss(:,1), ss(:,2), ss(:,3)-60];
ss70 = [ss(:,1), ss(:,2), ss(:,3)-70];
ss80 = [ss(:,1), ss(:,2), ss(:,3)-80];
ss90 = [ss(:,1), ss(:,2), ss(:,3)-90];
ss100 = [ss(:,1), ss(:,2), ss(:,3)-100];

known_coords = [ss; ss20; ss30; ss40; ss50; ss60; ss80; ss90; ss100];  % Use the combined slab coordinates

% Fixed values for Vp, Vs, and Rho
vp_value = 1;  % Example Vp value
vs_value = 1;  % Example Vs value
rho_value = 1; % Example Rho value
%%
% Parallelize the loop
parfor i = 1:size(known_coords, 1)  % Loop through each known coordinate
    % Initialize local grids inside the loop
    local_Vp_grid = NaN(size(X));  
    local_Vs_grid = NaN(size(Y));  
    local_Rho_grid = NaN(size(Z)); 
    
    known_x = known_coords(i, 1);  % x coordinate
    known_y = known_coords(i, 2);  % y coordinate
    known_z = known_coords(i, 3);  % z coordinate

    % Calculate the distances from the known coordinate to all grid points
    distances = sqrt((X - known_x).^2 + (Y - known_y).^2 + (Z - known_z).^2);
    
    % Find indices of all points within 1 unit distance
    indices_within_one_unit = distances <= dist;

    % Replace NaN values in the local grids at the found indices
    local_Vp_grid(indices_within_one_unit) = vp_value;
    local_Vs_grid(indices_within_one_unit) = vs_value;
    local_Rho_grid(indices_within_one_unit) = rho_value;
    
    % Accumulate the results back into the global grid
    Vp_grid = Vp_grid + local_Vp_grid;
    Vs_grid = Vs_grid + local_Vs_grid;
    Rho_grid = Rho_grid + local_Rho_grid;
end

disp 'SLAB = DONE'
toc


%%
tic
parfor i = 1:size(known_coords, 1)  % Loop through each known coordinate
    % Initialize local grids inside the loop
    local_Vp_grid = NaN(size(X));  
    local_Vs_grid = NaN(size(Y));  
    local_Rho_grid = NaN(size(Z)); 
    
    known_x = known_coords(i, 1);  % x coordinate
    known_y = known_coords(i, 2);  % y coordinate
    known_z = known_coords(i, 3);  % z coordinate

    % Calculate the distances from the known coordinate to all grid points
    distances = sqrt((X - known_x).^2 + (Y - known_y).^2 + (Z - known_z).^2);
    
    % Debugging: check the distance range
    if i == 1
        disp(['Max distance for i = 1: ', num2str(max(distances(:)))])
    end

    % Find indices of all points within the threshold distance
    indices_within_one_unit = distances <= dist;

    % Check if any points meet the condition
    if any(indices_within_one_unit(:))
        disp(['Updating grid at i = ', num2str(i)])
    end

    % Replace NaN values in the local grids at the found indices
    local_Vp_grid(indices_within_one_unit) = vp_value;
    local_Vs_grid(indices_within_one_unit) = vs_value;
    local_Rho_grid(indices_within_one_unit) = rho_value;
    
    % Accumulate the results back into the global grid
    Vp_grid = Vp_grid + local_Vp_grid;
    Vs_grid = Vs_grid + local_Vs_grid;
    Rho_grid = Rho_grid + local_Rho_grid;
end
toc