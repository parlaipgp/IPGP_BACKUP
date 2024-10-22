#!/bin/bash

# Set the hard-coded bounds (adjust as needed)
echo "Extrapolation between Longitude: 130-147, Latitude: 33-47"

min_lon=130.0
max_lon=147.0
min_lat=33.0
max_lat=47.0

# Define the grid parameters
lon=17
lat=14
grid_int=0.5

# Step 1: Extract relevant data from depths.dat (assuming columns: lon, lat, ux, uy, uz, sxx)
# Adjust column numbers if needed. Example here assumes you want lon, lat, and ux for extrapolation.
awk '{print $1, $2, $3}' depths.dat > depths_1.dat

# Step 2: Generate the grid using GMT with specified bounds and grid spacing (I0.2 is a grid spacing of 0.2 degrees)
gmt surface depths_1.dat -R${min_lon}/${max_lon}/${min_lat}/${max_lat} -I${grid_int} -Ggrid_depths.nc

# Step 3: Convert the grids to text format (optional, if you want to see the extrapolated data as text)
gmt grd2xyz grid_depths.nc > depths_rsGMT.dat

# Optional: Clean up intermediary files if needed
rm depths_1.dat grid_depths.nc

# Notify the user that the process is complete
echo "Extrapolation complete. Output saved in depths_rsGMT.dat"

# Step 4: Run the MATLAB script createCubitSurface
echo "Running MATLAB script * *  createCubitSurface * *"
matlab -nodisplay -r "createCubitSurface(${lon}, ${lat}, ${grid_int}); exit"


