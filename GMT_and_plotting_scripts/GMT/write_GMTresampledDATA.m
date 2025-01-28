
clear;close all;

disp 'we are at'
pwd 

ux = readmatrix('ux_rsGMT.dat', 'NumHeaderLines', 1);
uy = readmatrix('uy_rsGMT.dat', 'NumHeaderLines', 1);
uz = readmatrix('uz_rsGMT.dat', 'NumHeaderLines', 1);
gd = readmatrix('gd_rsGMT.dat', 'NumHeaderLines', 1);


lon = ux(:,1); lat = ux(:,2); 
ux = ux(:,3);
uy = uy(:,3);
uz = uz(:,3);
gd = gd(:,3);



nn = zeros(length(ux), 1);  % Random vector with the same length as ux
data_matrix = [lat lon ux uy uz nn nn nn nn nn nn nn nn nn gd nn];

writeDataMatrixToFile(data_matrix);



