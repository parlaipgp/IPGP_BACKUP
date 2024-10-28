clc; clear;close all;
cd  '/media/rajesh/LaCie/SPECFEM-X/cubit_example/DrHNG/inclined_strike_slip'

% Create vectors for x, y, z
nn = 20;
x = -500:nn:500;
y = x;

z1 = -50:nn:0;
z2 = -220:nn:-60;
z3 = -470:nn:-230;
z4 = -600:nn:-480;

% VpVsRho_1 = [6700, 3870, 2900];  
% VpVsRho_2 = [8800, 4470, 3370];  
% VpVsRho_3 = [9400, 5000, 3700];  
% VpVsRho_4 = [11000, 6000, 4400];  

VpVsRho_1 = [11000, 6000, 4400];  
VpVsRho_2 = [11000, 6000, 4400];  
VpVsRho_3 = [11000, 6000, 4400];  
VpVsRho_4 = [11000, 6000, 4400]; 

% Generate the grid
[X, Y, Z] = ndgrid(x, y, z1);
xyz = [X(:), Y(:), Z(:)]*1000;
mat_prop= repmat(VpVsRho_1, length(xyz), 1);
layer1 = [xyz,mat_prop];

[X, Y, Z] = ndgrid(x, y, z2);
xyz = [X(:), Y(:), Z(:)]*1000;
mat_prop= repmat(VpVsRho_2, length(xyz), 1);
layer2 = [xyz,mat_prop];

[X, Y, Z] = ndgrid(x, y, z3);
xyz = [X(:), Y(:), Z(:)]*1000;
mat_prop= repmat(VpVsRho_3, length(xyz), 1);
layer3 = [xyz,mat_prop];

[X, Y, Z] = ndgrid(x, y, z4);
xyz = [X(:), Y(:), Z(:)]*1000;
mat_prop= repmat(VpVsRho_4, length(xyz), 1);
layer4 = [xyz,mat_prop];

mat = [layer1;layer2;layer3;layer4];

disp ("Total grid points ");
TotGP = length(mat);
% clear layer* Vp* z* x X y Y z Z xyz
%% write xyz file
% x 0 y 0 z 0 x end y end z end
% dx dy dz
% n x n y n z
% v p min v p max v s min v s max ρ min ρ max


% x 1 y 1 z 1 v p1 v s1 ρ 1
% x 2 y 2 z 2 v p2 v s2 ρ 2
% x 3 y 3 z 3 v p3 v s3 ρ 3
% ...
% ...
% x n y n z n v pn v sn ρ n
% where,
% n = n x × n y × n z is the total number of grid points.

filename = 'tomo.xyz';

fileID = fopen(filename, 'w');

% Loop through each row of the matrix and write to the file
fprintf(fileID, '%.0f %.0f %.0f %.0f %.0f %.0f\n', -500000, -500000, -600000, 500000, 500000, 0);
fprintf(fileID, '%.0f %.0f %.0f\n', nn*1000, nn*1000, nn*1000);
fprintf(fileID, '%.0f %.0f %.0f\n', length(x), length(y), length(z1)+length(z2)+length(z3)+length(z4));
fprintf(fileID, '%.0f %.0f %.0f %.0f %.0f %.0f %.0f %.0f %.0f %.0f\n', 11000, 11000, 6000, 6000, 4400, 4400, 9999, 9999, 9999, 9999);
for i = 1:size(mat, 1)
    fprintf(fileID, '%.0f %.0f %.0f %.0f %.0f %.0f\n', mat(i, 1), mat(i, 2), mat(i, 3), mat(i, 4), mat(i, 5), mat(i, 6));
end

fclose(fileID);

disp 'DONE'
pwd



