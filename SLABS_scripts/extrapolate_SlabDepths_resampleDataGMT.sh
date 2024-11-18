#!/bin/bash


#min_lon=130.0
#max_lon=147.0
#min_lat=33.0
#max_lat=47.0


min_lon=127.0
max_lon=150.0
min_lat=30.0
max_lat=50.0




# Define the grid parameters
#lon=17
#lat=14

lon=23
lat=20

grid_int=0.1

# Set the minimum depth threshold (adjustable)
min_depth_threshold=-450
max_depth_threshold=0


# Step 1: Extract relevant data from depths.dat (assuming columns: lon, lat, ux, uy, uz, sxx)
# Adjust column numbers if needed. Example here assumes you want lon, lat, and ux for extrapolation.
awk '{print $1, $2, $3}' depths.dat > depths_1.dat

# Step 2: Generate the grid using GMT with specified bounds and grid spacing
gmt surface depths_1.dat -R${min_lon}/${max_lon}/${min_lat}/${max_lat} -I${grid_int} -Ggrid_depths.nc

# Step 2.5: Clip the grid to ensure all depth values are no less than the specified threshold
gmt grdclip grid_depths.nc -Sb${min_depth_threshold}/${min_depth_threshold} -Ggrid_depths_clipped.nc
gmt grdclip grid_depths_clipped.nc -Sa${max_depth_threshold}/${max_depth_threshold} -Ggrid_depths_clipped.nc


# Step 3: Convert the grids to text format (optional, if you want to see the extrapolated data as text)
rm depths_rsGMT.dat
gmt grd2xyz grid_depths_clipped.nc > depths_rsGMT.dat

# Optional: Clean up intermediary files if needed
rm depths_1.dat grid_depths.nc grid_depths_clipped.nc

# Notify the user that the process is complete
echo "Extrapolation complete. Output saved in depths_rsGMT.dat"

# Step 4: Run the MATLAB script createCubitSurface
echo "Running MATLAB script * *  createCubitSurface * *"
matlab -nodisplay -r "createCubitSurface(${lon}, ${lat}, ${grid_int}); exit"
