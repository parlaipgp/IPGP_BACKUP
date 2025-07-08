
clear all; clc;

strike = 252;
dip = 78;
rake = -162;
Mw = 4.19;

cmt_name = "CMT_DK_Hollywood";

load CMT_coords.mat;
n_CMT = length(CMT_coords);
n_CMT = 1;



M0 = 10^((1.5 * Mw) + 9.1);  % N.m
M0 = M0 * 1e7; % N.m --> dyn.cm
M0_sub = M0/n_CMT;

HD_sub = 0.3;
%%

% Converts strike, dip, rake to moment tensor in Aki & Richards and CMTSOLUTION formats
% Based on original C and Python implementations by Onur Tan and Dimitri Komatitsch

% Constants
d2r = 0.017453293; % degrees to radians

fprintf('Strike    = %9.5f degrees\n', strike);
fprintf('Dip       = %9.5f degrees\n', dip);
fprintf('Rake/Slip = %9.5f degrees\n\n', rake);

% Convert to radians
S = strike * d2r;
D = dip * d2r;
R = rake * d2r;

% Aki & Richards moment tensor components
Mxx = -1.0 * ( sin(D) * cos(R) * sin(2*S) + sin(2*D) * sin(R) * sin(S)^2 );
Myy =        ( sin(D) * cos(R) * sin(2*S) - sin(2*D) * sin(R) * cos(S)^2 );
Mzz = -1.0 * ( Mxx + Myy );
Mxy =        ( sin(D) * cos(R) * cos(2*S) + 0.5 * sin(2*D) * sin(R) * sin(2*S) );
Mxz = -1.0 * ( cos(D) * cos(R) * cos(S)   + cos(2*D) * sin(R) * sin(S) );
Myz = -1.0 * ( cos(D) * cos(R) * sin(S)   - cos(2*D) * sin(R) * cos(S) );

fprintf('Output Aki&Richards1980:  Mxx  Myy  Mzz  Mxy  Mxz  Myz\n');
fprintf('%9.5f %9.5f %9.5f %9.5f %9.5f %9.5f\n\n', Mxx, Myy, Mzz, Mxy, Mxz, Myz);

% Convert to Harvard CMTSOLUTION format
Mtt = Mxx;
Mpp = Myy;
Mrr = Mzz;
Mtp = -Mxy;
Mrt = Mxz;
Mrp = -Myz;

%%

fid = fopen(cmt_name, 'w');

for ii = 1:n_CMT
    % Extract location
    % lon = CMT_coords(ii,1);
    % lat = CMT_coords(ii,2);
    % depth = -CMT_coords(ii,3) / 1000;  % convert to km (assuming Z is in meters and negative)
    % % 
    lon = 350*1000;
    lat = 3800*1000;
    depth = 16.8;
    disp '   '; disp '* * * * * * * * * * *  C H E C K    lat lon depth * * * * * * * * * *'; disp '   ';


    % Write block for each point
    fprintf(fid,'PDE  2011 03 11 05 46 24.00  %8.2f %8.2f %6.2f CMT by Dimitri Komatitsch%d\n', ...
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

