clear all; clc;

strike = 346;
dip = 72;
rake = -11;
Mw = 4.19;

cmt_name = "CMT";

load CMT_coords.mat;
n_CMT = length(CMT_coords);
 n_CMT = 1;


M0 = 10^((1.5 * Mw) + 9.1);  % N.m
M0 = M0 * 1e7; % N.m --> dyn.cm


%% 

% Convert angles to radians
phi = deg2rad(strike);
delta = deg2rad(dip);
lambda = deg2rad(rake);


Mxx=-(sin(delta)*cos(lambda)*sin(2*phi)+sin(2*delta)*sin(lambda)*sin(phi)*sin(phi));
Myy=(sin(delta)*cos(lambda)*sin(2*phi)-sin(2*delta)*sin(lambda)*cos(phi)*cos(phi));
Mzz=(sin(2*delta)*sin(lambda));

Mxy=(sin(delta)*cos(lambda)*cos(2*phi)+0.5*sin(2*delta)*sin(lambda)*sin(2*phi));
Mxz=-(cos(delta)*cos(lambda)*cos(phi)+cos(2*delta)*sin(lambda)*sin(phi));
Myz=-(cos(delta)*cos(lambda)*sin(phi)-cos(2*delta)*sin(lambda)*cos(phi));



Mrr = Mzz;
Mtt = Mxx;
Mpp = Myy;
Mrt = Mxz;
Mrp = Myz;
Mtp = Mxy;

% % signs as per SpecefmX_freq/scr
    % Mrr =  Mzz; disp('* * * check signs changed or not * * *')
    % Mtt =  Myy;
    % Mpp =  Mxx;
    % Mrt = -Myz;
    % Mrp =  Mxz;
    % Mtp = -Mxy;

M0_CMT = (1/sqrt(2)) * sqrt((M0*Mrr)^2 + (M0*Mtt)^2 + (M0*Mpp)^2 + 2*((M0*Mrt)^2 + (Mrp*M0)^2 + (Mtp*M0)^2));
Mw_CMT = (2/3)*((log10(M0_CMT*1e-7) - 9.1));

disp(['* * * M0 from Mw = ', num2str(M0), ' dyn.cm']);
disp(['* * * M0 from CMT components = ', num2str(M0_CMT), ' dyn.cm']);
disp(['* * * Mw from CMT = ', num2str(Mw_CMT), ' & given Mw = ',num2str(Mw)]);

%% Seismic Moment
M0_sub = M0/n_CMT;

% Compute Mw of each subfault
Mw_sub = (2/3) * (log10(M0_sub*1e-7) - 9.1);  % Reverse of M0 formula

% Compute half duration using empirical relation:
HD_sub = 0.5 * 10.^(0.5 * (Mw_sub - 6));  % in seconds
fid = fopen(cmt_name, 'w');
disp '  '
disp(['* * * Divide Mw ', num2str(Mw), ' over ', num2str(n_CMT), ' CMTs by mo/',num2str(n_CMT),' ,not Mw/',num2str(n_CMT)]);
% Loop through each CMT_coordsinate

HD_sub = 0.3;

for ii = 1:n_CMT
    % Extract location
    lon = CMT_coords(ii,1);
    lat = CMT_coords(ii,2);
    depth = -CMT_coords(ii,3) / 1000;  % convert to km (assuming Z is in meters and negative)
    % 
    % lon = 350*1000;
    % lat = 3800*1000;
    % depth = 16.8;
    disp '   '; disp '* * * * * * * * * * *  W R O N G     lat lon depth * * * * * * * * * *'; disp '   ';

    % Write block for each point
    fprintf(fid,'PDE  2011 03 11 05 46 24.00  %8.2f %8.2f %6.2f CMT by Aki_Rich-%d\n', ...
        lat, lon, depth, ii);
    fprintf(fid,'event name:     S D R Mw %d %d %d %0.1f\n',strike,dip,rake,Mw);
    fprintf(fid,'time shift:     0.0\n');
    fprintf(fid,'half duration:  %f\n',HD_sub);
    fprintf(fid,'latitude:       %8.4f\n', lat);
    fprintf(fid,'longitude:      %8.4f\n', lon);
    fprintf(fid,'depth:          %6.2f\n', depth);
    fprintf(fid,'Mrr:      %13.6fe+23\n',Mrr * M0_sub/ 1e23);
    fprintf(fid,'Mtt:      %13.6fe+23\n',Mtt * M0_sub/ 1e23);
    fprintf(fid,'Mpp:      %13.6fe+23\n',Mpp * M0_sub/ 1e23);
    fprintf(fid,'Mrt:      %13.6fe+23\n',Mrt * M0_sub/ 1e23);
    fprintf(fid,'Mrp:      %13.6fe+23\n',Mrp * M0_sub/ 1e23);
    fprintf(fid,'Mtp:      %13.6fe+23\n',Mtp * M0_sub/ 1e23);
end
disp(['* * * Check Half Duration ', num2str(HD_sub),' sec * * * ']);

% Close the file
fclose(fid);

