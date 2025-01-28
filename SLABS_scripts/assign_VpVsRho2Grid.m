
cd /media/rajesh/LaCie/SLABS/CUBIT/tomo/tomo_layers_3000X3000/

clear; clc; 
tic


load crust.mat;
load lith_mant.mat;
load astheno.mat;
load upper_mant.mat;
load trans_zone.mat;
load low_mant.mat;
load slab.mat;

% PREM. 6 layers with Slab contrast along depth

vpvsrho_crust       = [5230, 2770, 2800];
vpvsrho_lith_mant   = [7820, 4370, 3280];
vpvsrho_astheno     = [8020, 4470, 3370];
vpvsrho_upper_mant  = [8780, 4730, 3510];
vpvsrho_trans_zone  = [9830, 5330, 3890];
vpvsrho_low_mantle  = [11060, 6170, 4430];



vpvsrho_slab_1        = [7976.4, 4457.4, 3360];
vpvsrho_slab_2        = [8180.4, 4559.4, 3450];
vpvsrho_slab_3        = [8955.6, 4824.6, 3590];
vpvsrho_slab_4        = [10026.6, 5436.6, 3970];
vpvsrho_slab_5        = [11281.2, 6293.4, 4510];

%%
crust_mat = [crust, ones(length(crust),3).*vpvsrho_crust];
lith_mant_mat = [lith_mant, ones(length(lith_mant),3).*vpvsrho_lith_mant];
astheno_mat = [astheno, ones(length(astheno),3).*vpvsrho_astheno];
upper_mant_mat = [upper_mant, ones(length(upper_mant),3).*vpvsrho_upper_mant];
trans_zone_mat = [trans_zone, ones(length(trans_zone),3).*vpvsrho_trans_zone];
low_mant_mat = [low_mant, ones(length(low_mant),3).*vpvsrho_low_mantle];


slab_1 = slab(slab(:, 3) >= -100 & slab(:, 3) <= -20, :);
slab_2 = slab(slab(:, 3) >= -220 & slab(:, 3) <= -101, :);
slab_3 = slab(slab(:, 3) >= -410 & slab(:, 3) <= -221, :);
slab_4 = slab(slab(:, 3) >= -660 & slab(:, 3) <= -411, :);
slab_5 = slab(slab(:, 3) >= -1000 & slab(:, 3) <= -661, :);

slab_mat_1 = [slab_1, ones(length(slab_1),3).*vpvsrho_slab_1];
slab_mat_2 = [slab_2, ones(length(slab_2),3).*vpvsrho_slab_2];
slab_mat_3 = [slab_3, ones(length(slab_3),3).*vpvsrho_slab_3];
slab_mat_4 = [slab_4, ones(length(slab_4),3).*vpvsrho_slab_4];
slab_mat_5 = [slab_5, ones(length(slab_5),3).*vpvsrho_slab_5];


tomo_matrix = [crust_mat;lith_mant_mat;astheno_mat;...
    slab_mat_1;slab_mat_2;slab_mat_3;slab_mat_4;slab_mat_5;...
    upper_mant_mat;trans_zone_mat;low_mant_mat];

tomo_matrix = sortrows(tomo_matrix,3,'descend');
disp(['Bottom of model at Z = ', num2str(min(tomo_matrix(:,3)))]);

save ./tomo_matrix_10kmGrid.mat tomo_matrix


%%
