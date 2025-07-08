clear all; clc;

% Input (in degrees)
strike = 90;
dip    = 90;
rake   = 180;


% function to compute the fault normal vector given the strike and dip (in degrees)
%
% the strike should lie between 0 and 360 (negative ok)
% the dip is restricted to lie between 0 and 90
%
% the dip should be measured in the direction such that
% when you look in the strike direction, the fault
% dips to your right.
%
%" C HARLES J. AMMON DEPARTMENT OF GEOSCIENCES PENN STATE UNIVERSITY "


nn = -sind(dip)*sind(strike);  % North
ne = sind(dip)*cosd(strike);   % East
nv = -cosd(dip);               % Verical

% Calculate slip components
sx = cosd(rake) * cosd(strike) + sind(rake) * sind(strike) * cosd(dip);  %slip X (East)
sy = cosd(rake) * sind(strike) - sind(rake) * cosd(strike) * cosd(dip);  %slip Y (North)
sz = -sind(rake) * sind(dip);                                            %slip Z (Up)

n = [ne; nn; nv];  % normal vector (NEV)
s = [sy;sx;sz];  % slip vector (NEU)

% Compute moment tensor in NED coordinates
mt = (n * s' + s * n');

% mt = [-0.5  -0.5  0;
%       -0.5   0.5  0;
%        0     0   -0.5];  % S90 D45 R90 (Pure thrust) U-S-E

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
