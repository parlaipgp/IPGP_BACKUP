clear;close all;
cd /media/rajesh/LaCie/SPECFEM-X/Tohoku2011/RESULTS_PLOTS-pre-seis/

warning('off', 'all');
data1 = readtable("data-1.csv");
data2 = readtable("data-2.csv");
data3 = readtable("data-3.csv");
data4 = readtable("data-4.csv");
data5 = readtable("data-5.csv");
data6 = readtable("data-6.csv");
data7 = readtable("data-7.csv");
data8 = readtable("data-8.csv");
data9 = readtable("data-9.csv");
data10 = readtable("data-10.csv");
data11 = readtable("data-11.csv");
data12 = readtable("data-12.csv");

data_master = [data1;data2;data3;data4;data5;data6;data7;data8;data9;data10;data11;data12];

freesurf_rows = data_master.Points_2 == 0;
data_freesurf = data_master(freesurf_rows,:);
data = data_freesurf;


data_uniq = unique(data,'rows');
data_sort_1 = sortrows(data_uniq,1);
data_sort_2 = sortrows(data_sort_1,2);
DATA = data_sort_1(1:1:end,:);              %re-sampled data

clear data* freesurf_rows

x = DATA.Points_0./1000;
y = DATA.Points_1./1000;

xy=[x';y'];
disp ' * * * Origin is taken at (142 37) for local2llh* * *'
llh=local2llh(xy,[142,37]);

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

