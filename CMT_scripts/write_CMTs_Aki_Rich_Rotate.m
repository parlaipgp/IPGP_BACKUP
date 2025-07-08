clear all; clc;



strike = 90;
dip = 45;
rake = 90;

Mw = 6.7;

cmt_name = "CMT_aki_northridge";


load CMT_coords.mat;
n_CMT = length(CMT_coords);
n_CMT = 1;

M0 = 10^((1.5 * Mw) + 16.1); % Directly in dyn·cm

M0 = 1

phi = deg2rad(strike);
delta = deg2rad(dip);
lambda = deg2rad(rake);



%% AKi_Rich


% Compute unrotated ENU moment tensor (geographic coordinates)
Mxx = -M0 * (sin(delta)*cos(lambda)*sin(2*phi) + sin(2*delta)*sin(lambda)*sin(phi)^2);
Myy =  M0 * (sin(delta)*cos(lambda)*sin(2*phi) - sin(2*delta)*sin(lambda)*cos(phi)^2);
Mzz = -Mxx - Myy;  % Enforce trace-free condition

Mxy =  M0 * (sin(delta)*cos(lambda)*cos(2*phi) + 0.5*sin(2*delta)*sin(lambda)*sin(2*phi));
Mxz = -M0 * (cos(delta)*cos(lambda)*cos(phi) + cos(2*delta)*sin(lambda)*sin(phi));
Myz = -M0 * (cos(delta)*cos(lambda)*sin(phi) - cos(2*delta)*sin(lambda)*cos(phi));


M_aki = [Mxx Mxy Mxz;
         Mxy Myy Myz;
         Mxz Myz Mzz];

Mrr = M_aki (1,1);
Mtt = M_aki (2,2);
Mpp = M_aki (3,3);

Mrt = M_aki (1,2);
Mrp = M_aki (1,3);
Mtp = M_aki (2,3);


%% rotate Aki & Rich to spherical coords T P R and to Code

% Output components

% M_code = [Mtt Mtp Mtr;
%           Mpt Mpp Mpr;
%           Mrt Mrp Mrr];  the TPR matrix




% T1 = [-1  0  0;
%        0  1  0;
%        0  0  -1];  % Aki to TPR
% 
% T2 = [ 0  1  0;
%       -1  0  0;
%        0  0  1];  % TPR to code
% 
% 
% M_tpr = T1 * M_aki * T1';
% M_code = T2 * M_tpr * T2';
% 
% Mtt = M_code(1,1);
% Mpp = M_code(2,2);
% Mrr = M_code(3,3);
% 
% Mtp = M_code(1,2);
% Mrt = M_code(1,3);
% Mrp = M_code(2,3);



%% rotate Aki & Rich to Code and to R T P

% Output components

% M_code = [Mtt Mtp Mtr;
%           Mpt Mpp Mpr;
%           Mrt Mrp Mrr];  the TPR matrix




% T1 = [ 0  1  0;
%        1  0  0;
%        0  0  -1];  % Aki to code
% 
% T2 = [ 0 -1  0;
%        1  0  0;
%        0  0  1];  % code to rtp
% 
% 
% M_code = T1 * M_aki * T1';
% M_rtp  = T2 * M_code * T2';
% 
% Mtt = M_rtp(1,1);
% Mpp = M_rtp(2,2);
% Mrr = M_rtp(3,3);
% 
% Mtp = M_rtp(1,2);
% Mrt = M_rtp(1,3);
% Mrp = M_rtp(2,3);


%% rotate Aki & Rich to spherical coords R T P (not TPR)


T1 = [ 0  0  -1;
      -1  0   0;
       0  1   0];

M_rtp = T1 * M_aki * T1';

Mrr = M_rtp (1,1);
Mtt = M_rtp (2,2);
Mpp = M_rtp (3,3);

Mrt = M_rtp (1,2);
Mrp = M_rtp (1,3);
Mtp = M_rtp (2,3);

%% CMT file write
Expo = 1e+0;

fid = fopen(cmt_name, 'w');

for ii = 1:n_CMT
    % Extract location
    lon = CMT_coords(ii,1);
    lat = CMT_coords(ii,2);
    depth = -CMT_coords(ii,3) / 1000;  % convert to km (assuming Z is in meters and negative)
    lon = 350 * 1000;
    lat = 3800 * 1000;
    depth = 16.8;
    disp '   '; disp '* * * * * * * * * * * C H E C K     lat lon depth * * * * * * * * * *'; disp '   ';
    disp '   '; disp '* * * * * * * * * * *  C H E C K     Expo * * * * * * * * * *'; disp '   ';

    % Write block for each point
    fprintf(fid,'PDE  2011 03 11 05 46 24.00 %8.2f %8.2f %6.2f mb Ms CMT-%d\n', ...
        lat, lon, depth, ii);
    fprintf(fid,'event name:     S D R  Mw %d %d %d %1.2f\n',strike,dip,rake,Mw);
    fprintf(fid,'time shift:     0.0\n');
    fprintf(fid,'half duration:  0.3\n');
    fprintf(fid,'latitude:       %8.4f\n', lat);
    fprintf(fid,'longitude:      %8.4f\n', lon);
    fprintf(fid,'depth:          %6.2f\n', depth);
    fprintf(fid,'Mrr:      %13.5fe+0\n', Mrr / Expo);
    fprintf(fid,'Mtt:      %13.5fe+0\n', Mtt / Expo);
    fprintf(fid,'Mpp:      %13.5fe+0\n', Mpp / Expo);
    fprintf(fid,'Mrt:      %13.5fe+0\n', Mrt / Expo);
    fprintf(fid,'Mrp:      %13.5fe+0\n', Mrp / Expo);
    fprintf(fid,'Mtp:      %13.5fe+0\n', Mtp / Expo);
    % fprintf(fid,'Mrr:      %13.4f\n', Mrr);
    % fprintf(fid,'Mtt:      %13.4f\n', Mtt);
    % fprintf(fid,'Mpp:      %13.4f\n', Mpp);
    % fprintf(fid,'Mrt:      %13.4f\n', Mrt);
    % fprintf(fid,'Mrp:      %13.4f\n', Mrp);
    % fprintf(fid,'Mtp:      %13.4f\n', Mtp);
end

% Close the file
fclose(fid);


