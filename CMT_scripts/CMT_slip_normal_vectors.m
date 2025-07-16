

                         % - - - Working Good for SPECFEMX. [nx ny nz] [sx sy sz] - - - %
clear all; clc;

% Input (in degrees)
strike = -45;
dip    = 90;
rake   = 0;

%" C HARLES J. AMMON DEPARTMENT OF GEOSCIENCES PENN STATE UNIVERSITY "
 
ne = sind(dip)*cosd(strike);   % East  (X)
nn = -sind(dip)*sind(strike);  % North (Y)
nv = cosd(dip);                % Up    (Z)


% Calculate slip components

sx = cosd(rake) * sind(strike) + sind(rake) * cosd(dip) * cosd(strike);
sy = cosd(rake) * cosd(strike) - sind(rake) * cosd(dip) * sind(strike);
sz = sind(rake) * sind(dip);


n = [ne; nn; nv];  % normal vector [nx ny nz]

s = [sx; sy; sz];  % slip vector   [sx sy sz]

% Compute moment tensor in NED coordinates
mt = (n * s' + s * n');


Mt = 1.135e+11*mt;

Mrr = Mt(3,3); %Mzz
Mtt = Mt(2,2); %Myy
Mpp = Mt(1,1); %Mxx

Mrt = Mt(3,2); %Mzy
Mrp = Mt(3,1); %Mzx
Mtp = Mt(2,1); %Myx

disp('Fault normal vector n:');
disp(n);

disp('Slip vector s:');
disp(s);
disp('Moment tensor:');
disp(mt);

fprintf('Mrr: %20.5e\n', Mrr);
fprintf('Mtt: %20.5e\n', Mtt);
fprintf('Mpp: %20.5e\n', Mpp);
fprintf('Mrt: %20.5e\n', Mrt);
fprintf('Mrp: %20.5e\n', Mrp);
fprintf('Mtp: %20.5e\n', Mtp);
