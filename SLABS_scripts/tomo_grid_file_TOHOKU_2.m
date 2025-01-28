clc; clear;
cd /media/rajesh/LaCie/SLABS/CUBIT/tomo/
disp 'Tomo file for model without trans_layer'

load xyz_smooth_3000X3000.mat;
ss = xyz_smooth;   %% slab skin

dist_threshold = 5;
ss_edge_dist = 5;

x = -1500:10:1500;
y = -1500:10:1500;

[X, Y] = meshgrid(x, y);
x = X(:);
y = Y(:);
z_ground = zeros(length(x),1);


disp(['top of slab at Z = ', num2str(max(ss(:,3)))]);
disp(['bottom of slab at Z = ', num2str(min(ss(:,3)))]);


%% slab
ss10 = [ss(:,1),ss(:,2),ss(:,3)-10];
ss20 = [ss(:,1),ss(:,2),ss(:,3)-20];
ss30 = [ss(:,1),ss(:,2),ss(:,3)-30];
ss40 = [ss(:,1),ss(:,2),ss(:,3)-40];
ss50 = [ss(:,1),ss(:,2),ss(:,3)-50];
ss60 = [ss(:,1),ss(:,2),ss(:,3)-60];
ss70 = [ss(:,1),ss(:,2),ss(:,3)-70];
ss80 = [ss(:,1),ss(:,2),ss(:,3)-80];
ss90 = [ss(:,1),ss(:,2),ss(:,3)-90];
ss100 = [ss(:,1),ss(:,2),ss(:,3)-100];

slab = [ss;ss10;ss20;ss30;ss40;ss50;ss60;ss70;ss80;ss90;ss100]; 

save ./tomo_layers_3000X3000/slab.mat slab;
%% crust
tic
cr0 = [x,y,z_ground];
cr10 = [x,y,z_ground-10];
cr20 = [x,y,z_ground-20];

M1 = [cr0;cr10;cr20];
M2 = slab;

% Initialize an empty logical array to mark points to keep in M1
keep_points = true(size(M1, 1), 1);

% Loop over each point in M1
parfor i = 1:size(M1, 1)
    % Calculate the distance from the current point in M1 to all points in M2
    distances = sqrt(sum((M2 - M1(i, :)).^2, 2));
    
    % If any point in M2 is within the threshold distance, mark the current point for removal
    if any(distances <= dist_threshold)
        keep_points(i) = false;
    end
  i
end

% Remove the points in M1 that are within the threshold distance of any point in M2
M1_unique = M1(keep_points, :);

ss_edge = ss(ss(:,3) >= -20 & ss(:,3) <= 0, :);                 %% * * * Need to adjust this * * * * 
ss_edge = [ss_edge(:,1), ss_edge(:,2), ss_edge(:,3)+ss_edge_dist];

crust = [M1_unique;ss_edge];
save ./tomo_layers_3000X3000/crust.mat crust;
toc
%% Lithospheric mantle
lm21 = [x,y,z_ground-21];
lm30 = [x,y,z_ground-30];
lm40 = [x,y,z_ground-40];
lm50 = [x,y,z_ground-50];
lm60 = [x,y,z_ground-60];
lm70 = [x,y,z_ground-70];
lm80 = [x,y,z_ground-80];
lm90 = [x,y,z_ground-90];
lm100 = [x,y,z_ground-100];

M1 = [lm21;lm30;lm40;lm50;lm60;lm70;lm80;lm90;lm100];
M2 = slab;


% Initialize an empty logical array to mark points to keep in M1
keep_points = true(size(M1, 1), 1);

% Loop over each point in M1
parfor i = 1:size(M1, 1)
    % Calculate the distance from the current point in M1 to all points in M2
    distances = sqrt(sum((M2 - M1(i, :)).^2, 2));
    
    % If any point in M2 is within the threshold distance, mark the current point for removal
    if any(distances <= dist_threshold)
        keep_points(i) = false;
    end
    i
end

% Remove the points in M1 that are within the threshold distance of any point in M2
M1_unique = M1(keep_points, :);

ss_edge = ss(ss(:,3) >= -100 & ss(:,3) <= -21, :);                 %% * * * Need to adjust this * * * * 
ss_edge1 = [ss_edge(:,1), ss_edge(:,2), ss_edge(:,3)+ss_edge_dist];


ss_edge = ss100(ss100(:,3) >= -100 & ss100(:,3) <= -21, :);                 %% * * * Need to adjust this * * * * 
ss_edge2 = [ss_edge(:,1), ss_edge(:,2), ss_edge(:,3)-ss_edge_dist];

lith_mant = [M1_unique; ss_edge1;ss_edge2];

save ./tomo_layers_3000X3000/lith_mant.mat lith_mant
toc
%% Asthenosphere (low viscosity)

as101 = [x,y,z_ground-101];
as110= [x,y,z_ground-110];
as120= [x,y,z_ground-120];
as130 = [x,y,z_ground-130];
as140 = [x,y,z_ground-140];
as150 = [x,y,z_ground-150];
as160 = [x,y,z_ground-160];
as170= [x,y,z_ground-170];
as180 = [x,y,z_ground-180];
as190 = [x,y,z_ground-190];
as200 = [x,y,z_ground-200];
as210 = [x,y,z_ground-210];
as220 = [x,y,z_ground-220];

M1 = [as101;as110;as120;as130;as140;as150;as160;as170;as180;as190;as200;as210;as220];
M2 = slab;


% Initialize an empty logical array to mark points to keep in M1
keep_points = true(size(M1, 1), 1);

% Loop over each point in M1
parfor i = 1:size(M1, 1)
    % Calculate the distance from the current point in M1 to all points in M2
    distances = sqrt(sum((M2 - M1(i, :)).^2, 2));
    
    % If any point in M2 is within the threshold distance, mark the current point for removal
    if any(distances <= dist_threshold)
        keep_points(i) = false;
    end
    i
end

% Remove the points in M1 that are within the threshold distance of any point in M2
M1_unique = M1(keep_points, :);

ss_edge = ss(ss(:,3) >= -220 & ss(:,3) <= -101, :);                 %% * * * Need to adjust this * * * * 
ss_edge1 = [ss_edge(:,1), ss_edge(:,2), ss_edge(:,3)+ss_edge_dist];


ss_edge = ss100(ss100(:,3) >= -220 & ss100(:,3) <= -101, :);                 %% * * * Need to adjust this * * * * 
ss_edge2 = [ss_edge(:,1), ss_edge(:,2), ss_edge(:,3)-ss_edge_dist];

astheno = [M1_unique; ss_edge1;ss_edge2];

save ./tomo_layers_3000X3000/astheno.mat astheno
toc
%% rest of upper mantle
um221 = [x,y,z_ground-221];
um230 = [x,y,z_ground-230];
um240 = [x,y,z_ground-240];
um250 = [x,y,z_ground-250];
um260 = [x,y,z_ground-260];
um270 = [x,y,z_ground-270];
um280 = [x,y,z_ground-280];
um290 = [x,y,z_ground-290];
um300 = [x,y,z_ground-300];
um310 = [x,y,z_ground-310];
um320 = [x,y,z_ground-320];
um330 = [x,y,z_ground-330];
um340 = [x,y,z_ground-340];
um350 = [x,y,z_ground-350];
um360 = [x,y,z_ground-360];
um370 = [x,y,z_ground-370];
um380 = [x,y,z_ground-380];
um390 = [x,y,z_ground-390];
um400 = [x,y,z_ground-400];
um410 = [x,y,z_ground-410];

M1 = [um221;um230;um240;um250;um260;um270;um280;um290;um300;um310;um320;um330;um340;um350;um360;um370;um380;um390;um400;um410];
M2 = slab;


% Initialize an empty logical array to mark points to keep in M1
keep_points = true(size(M1, 1), 1);

% Loop over each point in M1
parfor i = 1:size(M1, 1)
    % Calculate the distance from the current point in M1 to all points in M2
    distances = sqrt(sum((M2 - M1(i, :)).^2, 2));
    
    % If any point in M2 is within the threshold distance, mark the current point for removal
    if any(distances <= dist_threshold)
        keep_points(i) = false;
    end
    i
end

% Remove the points in M1 that are within the threshold distance of any point in M2
M1_unique = M1(keep_points, :);

ss_edge = ss(ss(:,3) >= -410 & ss(:,3) <= -221, :);                 %% * * * Need to adjust this * * * * 
ss_edge1 = [ss_edge(:,1), ss_edge(:,2), ss_edge(:,3)+ss_edge_dist];


ss_edge = ss100(ss100(:,3) >= -410 & ss100(:,3) <= -221, :);                 %% * * * Need to adjust this * * * * 
ss_edge2 = [ss_edge(:,1), ss_edge(:,2), ss_edge(:,3)-ss_edge_dist];


upper_mant = [M1_unique; ss_edge1;ss_edge2];

save ./tomo_layers_3000X3000/upper_mant.mat upper_mant
toc
%% Transition zone
tz411 = [x,y,z_ground-411];
tz420 = [x,y,z_ground-420];
tz430 = [x,y,z_ground-430];
tz440 = [x,y,z_ground-440];
tz450 = [x,y,z_ground-450];
tz460 = [x,y,z_ground-460];
tz470 = [x,y,z_ground-470];
tz480 = [x,y,z_ground-480];
tz490 = [x,y,z_ground-490];
tz500 = [x,y,z_ground-500];
tz510 = [x,y,z_ground-510];
tz520 = [x,y,z_ground-520];
tz660 = [x,y,z_ground-660];

M1 = [tz411;tz420;tz430;tz440;tz450;tz460;tz470;tz480;tz490;tz500;tz510;tz520;tz660];
M2 = slab;


% Initialize an empty logical array to mark points to keep in M1
keep_points = true(size(M1, 1), 1);

% Loop over each point in M1
parfor i = 1:size(M1, 1)
    % Calculate the distance from the current point in M1 to all points in M2
    distances = sqrt(sum((M2 - M1(i, :)).^2, 2));
    
    % If any point in M2 is within the threshold distance, mark the current point for removal
    if any(distances <= dist_threshold)
        keep_points(i) = false;
    end
    i
end

% Remove the points in M1 that are within the threshold distance of any point in M2
M1_unique = M1(keep_points, :);

ss_edge = ss(ss(:,3) >= -660 & ss(:,3) <= -411, :);                 %% * * * Need to adjust this * * * * 
ss_edge1 = [ss_edge(:,1), ss_edge(:,2), ss_edge(:,3)+ss_edge_dist];


ss_edge = ss100(ss100(:,3) >= -660 & ss100(:,3) <= -411, :);                 %% * * * Need to adjust this * * * * 
ss_edge2 = [ss_edge(:,1), ss_edge(:,2), ss_edge(:,3)-ss_edge_dist];


trans_zone = [M1_unique; ss_edge1;ss_edge2];

save ./tomo_layers_3000X3000/trans_zone.mat trans_zone
toc


%% Lower mantle
lm661 = [x,y,z_ground-661];
lm670 = [x,y,z_ground-670];
lm690 = [x,y,z_ground-690];
lm710 = [x,y,z_ground-710];
lm750 = [x,y,z_ground-750];
lm800 = [x,y,z_ground-800];
lm850 = [x,y,z_ground-850];
lm900 = [x,y,z_ground-900];
lm950 = [x,y,z_ground-950];
lm1020 = [x,y,z_ground-1020];



M1 = [lm661;lm670;lm690;lm750;lm850;lm900;lm1020];
M2 = slab;


% Initialize an empty logical array to mark points to keep in M1
keep_points = true(size(M1, 1), 1);

% Loop over each point in M1
parfor i = 1:size(M1, 1)
    % Calculate the distance from the current point in M1 to all points in M2
    distances = sqrt(sum((M2 - M1(i, :)).^2, 2));
    
    % If any point in M2 is within the threshold distance, mark the current point for removal
    if any(distances <= dist_threshold)
        keep_points(i) = false;
    end
    i
end

% Remove the points in M1 that are within the threshold distance of any point in M2
M1_unique = M1(keep_points, :);

ss_edge = ss(ss(:,3) >= -1020 & ss(:,3) <= -661, :);                 %% * * * Need to adjust this * * * * 
ss_edge1 = [ss_edge(:,1), ss_edge(:,2), ss_edge(:,3)+ss_edge_dist];


ss_edge = ss100(ss100(:,3) >= -1020 & ss100(:,3) <= -661, :);                 %% * * * Need to adjust this * * * * 
ss_edge2 = [ss_edge(:,1), ss_edge(:,2), ss_edge(:,3)-ss_edge_dist];


low_mant = [M1_unique; ss_edge1;ss_edge2];

save ./tomo_layers_3000X3000/low_mant.mat low_mant

