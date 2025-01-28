clear; close all;

warning('off', 'all');

% Display the name of the file being read
filename = "Tohoku_freesurf_extrapolated.csv";
disp(['Reading file: * * * * ===> ',filename]);
disp('At:');
disp(pwd);




% Read the file into a table
data = readtable(filename);



data_uniq = unique(data,'rows');
data_sort_1 = sortrows(data_uniq,1);
data_sort_2 = sortrows(data_sort_1,2);
DATA = data_sort_1(1:1:end,:);              %re-sampled data

x = DATA.Points_0./1000;
y = DATA.Points_1./1000;

xy=[x';y'];
disp ' * * * Origin is taken at [138.5, 40] for local2llh* * *'
llh=local2llh(xy,[138.5,40]);

x=llh(1,:);
y=llh(2,:);

grav_pot = DATA.gravity_potential;
gd = grav_pot./9.8;
ux = DATA.displacement_0;
uy = DATA.displacement_1;
uz = DATA.displacement_2;

%% Lat[deg] Lon[deg] Ux Uy Uz Sxx Syy Szz Sxy Syz Szx Tx Ty Rot Gd Gr
nn = rand(length(x),1);
data_matrix = [y' x' ux uy uz nn nn nn nn nn nn nn nn nn gd nn];

save('coseis.dat', 'data_matrix', '-ascii');

