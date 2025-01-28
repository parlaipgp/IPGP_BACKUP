#!/bin/csh


echo "code to read all .csv files ==> xyz2llh ==> resample to 0.2° using GMT ==> write coseis.dat with 0.2° uniform grid"

# Hard-coded bounds (adjust these values as needed)
set min_lon = 110
set max_lon = 170
set min_lat = 10
set max_lat = 70

echo "reading SPECFEMX .csv files at"
pwd

echo "running matlab script xyz2llh_writting_DatFile.m"
matlab -nodisplay -r "xyz2llh_writting_DatFile; exit"

echo "back to"
pwd

echo "resampling coseis.dat to 0.2° using GMT"

# Step 1: Extract Latitude, Longitude, Ux, Uy, Uz, and Sxx from coseis.dat
# Extract the required columns
awk '{print $2, $1, $3}' coseis.dat > coseis_ux.dat
awk '{print $2, $1, $4}' coseis.dat > coseis_uy.dat
awk '{print $2, $1, $5}' coseis.dat > coseis_uz.dat


awk '{print $2, $1, $15}' coseis.dat > coseis_gd.dat

# Step 2: Generate the grids with GMT
gmt surface coseis_ux.dat -R$min_lon/$max_lon/$min_lat/$max_lat -I0.2 -Ggrid_ux.nc
gmt surface coseis_uy.dat -R$min_lon/$max_lon/$min_lat/$max_lat -I0.2 -Ggrid_uy.nc
gmt surface coseis_uz.dat -R$min_lon/$max_lon/$min_lat/$max_lat -I0.2 -Ggrid_uz.nc

gmt surface coseis_gd.dat -R$min_lon/$max_lon/$min_lat/$max_lat -I0.2 -Ggrid_gd.nc

# Step 3: Convert the grids to text format
# Extract grids as xyz files
gmt grd2xyz grid_ux.nc > ux_rsGMT.dat
gmt grd2xyz grid_uy.nc > uy_rsGMT.dat
gmt grd2xyz grid_uz.nc > uz_rsGMT.dat

gmt grd2xyz grid_gd.nc > gd_rsGMT.dat

rm *.nc
rm coseis_ux.dat coseis_uy.dat coseis_uz.dat coseis_gd.dat

echo "running matlab script write_GMTresampledDATA.m"
matlab -nodisplay -r "write_GMTresampledDATA; exit"

rm ux_rsGMT.dat uy_rsGMT.dat uz_rsGMT.dat gd_rsGMT.dat

echo "the resampled coseis.dat is saved at"
pwd
