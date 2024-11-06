clc; clear;close all;
cd /media/rajesh/LaCie/SLABS/CUBIT/create_jou/
load uniform_xyz.mat;  % Load your xyz data
ss = uniform_xyz;   %% slab skin

dist = 2;     % Find indices of all points within distance      
% Define grid parameters
x = -50:2:50;
y = -50:2:50;
z = -400:2:0;
[X, Y, Z] = meshgrid(x, y, z);


% Initialize grids with NaN
Vp_grid = NaN(size(X));  % Initialize Vp grid as NaN
Vs_grid = NaN(size(Y));  % Initialize Vs grid as NaN
Rho_grid = NaN(size(Z)); % Initialize Rho grid as NaN

%% slab
% Known coordinates
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

known_coords = [ss;ss10;ss20;ss80;ss90;ss100];  % Use the combined slab coordinates

% Fixed values for Vp, Vs, and Rho
vp_value = 1111;  % Example Vp value
vs_value = 1111;  % Example Vs value
rho_value = 1111; % Example Rho value

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

disp 'SLAB = DONE'


%% Oceanic mantle 
% Known coordinates
b_slabskin = min(ss(:,3));  % lowest z value on skin surface

ss100 = [ss(:,1),ss(:,2),ss(:,3)-100];   % thickness of slab = 100; so s-100km
ss110 = [ss(:,1),ss(:,2),ss(:,3)-110];

ss120 = [ss(:,1),ss(:,2),ones(length(ss110),1)*b_slabskin-120]; % slab is flatten at -120km below ss or -20km bottom of slab
ss130 = [ss(:,1),ss(:,2),ones(length(ss110),1)*b_slabskin-130];
ss140 = [ss(:,1),ss(:,2),ones(length(ss110),1)*b_slabskin-140];
bott_mod = [ss(:,1),ss(:,2),ones(length(ss110),1)*500]; % bottom of model z = 500


known_coords = [ss110;ss120;ss130;ss140;bott_mod];  % Use the combined slab coordinates

% Fixed values for Vp, Vs, and Rho
vp_value = 2222;  % Example Vp value
vs_value = 2222;  % Example Vs value
rho_value = 2222; % Example Rho value

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

disp 'OCEANIC MANTLE = DONE'
disp(['* * * bottom of model at Z = ', num2str(bott_mod(1,3))]);



%% continental plate
% Known coordinates
cp0 = [ss(:,1),ss(:,2),ones(length(ss),1)*-24];   % top of continental plate at Z = -24km (below crust)
cp30 = [ss(:,1),ss(:,2),ones(length(ss),1)*-30]; 
cp40 = [ss(:,1),ss(:,2),ones(length(ss),1)*-40]; 
cp80 = [ss(:,1),ss(:,2),ones(length(ss),1)*-80]; 
cp100 = [ss(:,1),ss(:,2),ones(length(ss),1)*-100]; 
bott_cp = [ss(:,1),ss(:,2),ones(length(ss),1)*-120]; % bottom of continental plate at z = - 120km

known_coords = [cp0;cp30;cp40;cp80;cp100;bott_cp];  % Use the combined slab coordinates

% Fixed values for Vp, Vs, and Rho
vp_value = 3333;  % Example Vp value
vs_value = 3333;  % Example Vs value
rho_value = 3333; % Example Rho value

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


%% continental mantle
% Known coordinates
cm0 = [ss(:,1),ss(:,2),ones(length(ss),1)*-124];   % top of continental mantle at Z = -124km (below crust)
cm130 = [ss(:,1),ss(:,2),ones(length(ss),1)*-130]; 
bott_cm20 = [ss(:,1),ss(:,2),ss(:,3)+20]; % top of slab skin + 20km
bott_cm10 = [ss(:,1),ss(:,2),ss(:,3)+10]; % top of slab skin + 10km
bott_cm = [ss(:,1),ss(:,2),ss(:,3)];      % top of slab skin 

known_coords = [cm0;cm130;bott_cm20;bott_cm10;bott_cm];  % Use the combined slab coordinates

% Fixed values for Vp, Vs, and Rho
vp_value = 4444;  % Example Vp value
vs_value = 4444;  % Example Vs value
rho_value = 4444; % Example Rho value

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


disp 'CONTINENTAL MANTLE = DONE'
disp(['* * * top of continental mantle at Z = ', num2str(cm0(1,3))]);
disp(['* * * bottom of continental mantle at Z = ', num2str(bott_cm(1,3))]);

%%

% Create a mask for valid Vp values
valid_mask = ~isnan(Vp_grid);  % Create a mask for valid Vp values

% Initialize arrays for valid coordinates and values
valid_coords = [];  % Array for storing valid coordinates
valid_vp_values = [];  % Array for storing corresponding valid Vp values

% Extract valid coordinates and their corresponding Vp values
for ix = 1:size(Vp_grid, 1)
    for iy = 1:size(Vp_grid, 2)
        for iz = 1:size(Vp_grid, 3)
            if valid_mask(ix, iy, iz)  % If the Vp value is valid
                % Get the corresponding coordinate
                valid_coords = [valid_coords; X(ix, iy, iz), Y(ix, iy, iz), Z(ix, iy, iz)];
                valid_vp_values = [valid_vp_values; Vp_grid(ix, iy, iz)];
            end
        end
    end
end

% Visualization of 3D scatter plot of (x, y, z) and color according to Vp

f = figure(1); f.Visible = 'on';

% Create a scatter plot in 3D with valid points
scatter3(valid_coords(:, 1), valid_coords(:, 2), valid_coords(:, 3), ...
         50, valid_vp_values, 'filled'); % Use non-NaN Vp values for color
     
grid on;
xlabel('X Coordinate');
ylabel('Y Coordinate');
zlabel('Z Coordinate');
% Adjust view angle
print('check','-dpng','-r300');
savefig('check.fig');  % Save the current figure as 'check.fig'