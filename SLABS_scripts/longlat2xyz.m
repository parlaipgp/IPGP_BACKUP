clear;close all;clc
cd /media/rajesh/LaCie/SLABS/CUBIT/

load depths_rsGMT.dat;
DATA = depths_rsGMT;


llh=[DATA(:,1)';DATA(:,2)';DATA(:,3)'];

disp ' * * * Origin is taken at (144 37) for llh2xyz* * *'

xyz=llh2local(llh,[144,37]);

disp ' * * * Resampling * * *'


x = xyz(1,1:1:end);
y = xyz(2,1:1:end);
h = llh(3,1:1:end);

% interpolation
%[xq,yq] = meshgrid(-1500:1:1500,-1500:1:1500);
%hq = griddata(x,y,h,xq,yq);


%%
figure
scatter(DATA(:,1), DATA(:,2)); xlabel('long');ylabel('lat');hold on
rectangle('Position', [130, 33, 17, 14], 'EdgeColor', 'r', 'LineWidth', 1);


figure
scatter(x,y);xlabel('x');ylabel('y');


%% write cubit commands
data_matrix = [x' y' h'];
%data_matrix = DATA(1:20:end,:);

fileID = fopen('slab_surf.txt', 'w');

fprintf(fileID,'journal off\n echo off\n info off\n')
for i = 1:size(data_matrix, 1)
    fprintf(fileID,'create vertex location %.7e %.7e %.7e\n', data_matrix(i, 1), data_matrix(i, 2), data_matrix(i, 3));
end
fclose(fileID);

%save('xyz.dat', 'data_matrix', '-ascii');
i
