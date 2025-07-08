
clear all; clc;

CMT = readtable('NORTHRIDGE_CMT_components.dat', 'Delimiter', '\t');

Mrr  = sum(CMT.Mrr);
Mtt  = sum(CMT.Mtt);
Mpp  = sum(CMT.Mpp);

Mrt  = sum(CMT.Mrt);
Mrp  = sum(CMT.Mrp);
Mtp  = sum(CMT.Mtp);


M0_CMT = (1/sqrt(2)) * sqrt((Mrr)^2 + (Mtt)^2 + (Mpp)^2 + 2*((Mrt)^2 + (Mrp)^2 + (Mtp)^2))
Mw_CMT = (2/3)*((log10(M0_CMT*1e-7) - 9.1))

%% CMT file write

cmt_name = "CMT_northridge_sum";


fid = fopen(cmt_name, 'w');


HD_sub = 0.3;


% Extract location
lon = 350*1000;
lat = 3800*1000;
depth = 16.8;

% Write block for each point
fprintf(fid,'PDE  2011 03 11 05 46 24.00  %8.2f %8.2f %6.2f Northridge CMT sum of all components \n', ...
    lat, lon, depth);
fprintf(fid,'event name:     S D R Mw\n ');
fprintf(fid,'time shift:     0.0\n');
fprintf(fid,'half duration:  %f\n',HD_sub);
fprintf(fid,'latitude:       %8.4f\n', lat);
fprintf(fid,'longitude:      %8.4f\n', lon);
fprintf(fid,'depth:          %6.2f\n', depth);
fprintf(fid,'Mrr:      %13.6e\n',Mrr);
fprintf(fid,'Mtt:      %13.6e\n',Mtt);
fprintf(fid,'Mpp:      %13.6e\n',Mpp);
fprintf(fid,'Mrt:      %13.6e\n',Mrt);
fprintf(fid,'Mrp:      %13.6e\n',Mrp);
fprintf(fid,'Mtp:      %13.6e\n',Mtp);


fclose(fid);

