
clear all; clc;close all;
cd /media/rajesh/LaCie/SLABS/CUBIT/CMT

strike = 130;       
dip = 53;         
length = 20;     % in meters
width  = 30;       % in meters
center = [350 3800 -16.8]; % center of fault at depth km
gd = 0.5;           % grid spacing in meters

strike = 90-strike  ;       % 90 - strike
dip = dip-90;               % dip - 90

[X, Y, Z] = fault_grid_points(strike, dip, length, width, center, gd);
CMT_coords = [X(:), Y(:), Z(:)]*1000;

save CMT_coords.mat CMT_coords;

figure;
plot3(X(:), Y(:), Z(:), 'k.');
xlabel('X km'); ylabel('Y km'); zlabel('Z km');
title('Grid Points on Fault Surface'); axis equal; grid on;view(2);
%% write cubit commands
data_matrix = CMT_coords;

fileID = fopen('Fault_surf_CMT.jou', 'w');

fprintf(fileID,'journal off\n echo off\n info off\n');
for i = 1:size(data_matrix, 1)
    fprintf(fileID,'create vertex location %.7e %.7e %.7e\n', data_matrix(i, 1), data_matrix(i, 2), data_matrix(i, 3));
end

fclose(fileID);

%%
function [X, Y, Z] = fault_grid_points(strike, dip, length, width, center, gd)
    % Convert angles to radians
    strike = deg2rad(strike);
    dip = deg2rad(dip);

    % Direction vectors
    v_strike = [cos(strike), sin(strike), 0]; % unit vector along strike
    v_dip = [-sin(dip)*sin(strike), sin(dip)*cos(strike), -cos(dip)]; % down-dip direction

    % Number of points in each direction
    n_strike = floor(length / gd) + 1;
    n_dip = floor(width / gd) + 1;

    % Grid values from -half to +half length/width
    s_vals = linspace(-length/2, length/2, n_strike);
    d_vals = linspace(-width/2, width/2, n_dip);

    % Initialize arrays
    X = zeros(n_dip, n_strike);
    Y = zeros(n_dip, n_strike);
    Z = zeros(n_dip, n_strike);

    % Loop through grid
    for i = 1:n_dip
        for j = 1:n_strike
            vec = s_vals(j)*v_strike + d_vals(i)*v_dip;
            X(i,j) = center(1) + vec(1);
            Y(i,j) = center(2) + vec(2);
            Z(i,j) = center(3) + vec(3);
        end
    end
end
