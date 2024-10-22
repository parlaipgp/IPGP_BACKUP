clear;close all;clc
cd /media/rajesh/LaCie/SLABS/CUBIT/

load depths_rsGMT.dat;
DATA = depths_rsGMT;


llh=[DATA(:,1)';DATA(:,2)';DATA(:,3)'];

disp ' * * * Origin is taken at (144 37) for llh2xyz* * *'

xyz=llh2local(llh,[130,33]);



x = xyz(1,1:1:end);
y = xyz(2,1:1:end);
h = llh(3,1:1:end);


disp(['Number of vertex = ', num2str(length(x))]);


%%
% figure
% scatter3(DATA(:,1), DATA(:,2), DATA(:,3)); xlabel('long');ylabel('lat');
% 
% figure
% scatter3(x,y,h,"r");xlabel('x');ylabel('y');

%% write cubit commands
data_matrix = [x' y' h'];

fileID = fopen('slab_surf.jou', 'w');

fprintf(fileID,'journal off\n echo off\n info off\n');
for i = 1:size(data_matrix, 1)
    fprintf(fileID,'create vertex location %.7e %.7e %.7e\n', data_matrix(i, 1), data_matrix(i, 2), data_matrix(i, 3));
end

n_lon = (lon/grid_int) + 1;
n_lat = (lat/grid_int) + 1;


ii = 1; jj=n_lon;   % lon = 17°  17/0.1 + 1
for k = 1:n_lat  % lat = 14°  14/0.1 + 1   total curves 140
fprintf(fileID,'create curve spline location vertex %d to %d \n',ii,jj);
ii=ii+n_lon; jj=jj+n_lon;
end

fprintf(fileID,'\n\ndelete vertex all \n\n');
fprintf(fileID,'\n\ncreate surface skin curve 1 to %d \n\n',n_lat-1);
fprintf(fileID,'\n\ndelete curve all \n\n');
fprintf(fileID,'\n\nsave cub5 "JapanSlabSkin.cub5" \n\n');

fclose(fileID);

