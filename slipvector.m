clear all; close all;
cd /media/rajesh/LaCie/SPECFEM-X/Tohoku2011/pre-seis/

strike = 180; % example strike angle in degrees
dip = 60;    % example dip angle in degrees
rake = 90;   % example rake angle in degrees
slip = 0.40  % meters

[slipX, slipY, slipZ] = calculateSlip(strike, dip, rake);

fprintf('Slip X: %.4f\n', slipX);
fprintf('Slip Y: %.4f\n', slipY);
fprintf('Slip Z: %.4f\n', slipZ);


slipXYZ_for_specfemx = [slipX*slip slipY*slip slipZ*slip]