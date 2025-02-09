#!/bin/bash

# Set GMT parameters
gmt set FORMAT_FLOAT_OUT %10.6f
gmt set FORMAT_FLOAT_MAP %10.2f
gmt set FONT_ANNOT_PRIMARY 8p
gmt set FONT_LABEL 10p

#--------------------------------Define longitudes and arrays

# Define common name
common_name="long132"

# Define an array of tags and titles
tags=("Ux" "Uy" "Uz" "Gd")
titles=("Ux along Lon 132" "Uy along Lon 132" "Uz along Lon 132" "Gd along Lon 132")

#--------------------------------Loop through each tag

for i in "${!tags[@]}"; do
    # Define plot parameters based on the current tag
    tag=${tags[$i]}
    title=${titles[$i]}
    input_file1="${tag}_${common_name}_wang.dat"   # First file containing data along longitude
    input_file2="${tag}_${common_name}_specfemx.dat"  # Second file to overlay on the same plot
    resampled_file2="${tag}_${common_name}_other_resampled.dat"  # Resampled second file
    output_plot="${tag}_${common_name}_plot_resampled.ps"   # Output PostScript file
    xlabel="Latitude [deg]"
    ylabel="${tag} [mm]"

    # Define plot range based on both datasets
    lat_min=$(awk 'NR==1 {min=$1} NR>1 {if($1<min) min=$1} END {print min}' "$input_file1")
    lat_max=$(awk 'NR==1 {max=$1} NR>1 {if($1>max) max=$1} END {print max}' "$input_file1")
    data_min=$(awk 'NR==1 {min=$2} NR>1 {if($2<min) min=$2} END {print min}' "$input_file1" "$input_file2")
    data_max=$(awk 'NR==1 {max=$2} NR>1 {if($2>max) max=$2} END {print max}' "$input_file1" "$input_file2")

    # Calculate y-axis tick interval to have exactly 10 ticks
    y_range=$(echo "$data_max - $data_min" | bc)
    tick_interval=$(echo "scale=2; $y_range / 10" | bc)

    # Step 1: Resample the second dataset to match the latitude values of the first dataset
    gmt sample1d "$input_file2" -T"$input_file1" -Fa > "$resampled_file2"

    # Step 2: Create the base plot with the first dataset
    gmt psxy "$input_file1" -R$lat_min/$lat_max/$data_min/$data_max -JX15c/10c -Bxa5f1+l"$xlabel" -By$tick_interval+l"$ylabel" -BWSne \
        -W2p,blue -P -K > "$output_plot"

    # Step 3: Overlay the resampled second dataset onto the same plot
    gmt psxy "$resampled_file2" -R -J -W2p,red -O -K >> "$output_plot"

    # Add title
    gmt pstext -R0/1/0/1 -JX15c/10c -F+f10p,Helvetica-Bold,black+jCB -N -O << EOF >> "$output_plot"
0.5 1.05 $title
EOF

    # Convert to JPEG
    gmt psconvert "$output_plot" -A -P -Tj  # Convert to JPEG

    # Clean up
    rm -f "$output_plot" "$resampled_file2"
done
