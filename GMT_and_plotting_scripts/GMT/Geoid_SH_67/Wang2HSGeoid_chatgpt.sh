#!/bin/csh

# Set GMT defaults for plotting
gmtset FORMAT_FLOAT_OUT %10.6f
gmtset FORMAT_FLOAT_MAP %10.4f
gmtset FONT_ANNOT_PRIMARY 18p
gmtset FONT_LABEL 20p

# Convert units from meters to millimeters
awk '{print $1, $2, $3*1000.0}' Gd.coseis.dat > Gd.coseis.mm.dat

# Input data files
set wanggeoidfile = 'Gd.coseis.mm.dat'
set wangvdispfile = 'Uz.coseis.dat'
set wanggps_N = 'Ux.coseis.dat'
set wanggps_E = 'Uy.coseis.dat'

# Set various parameters
set landoc = 1
set lsmcalc = 0
set topoHSfile = 'coeffs.bathy.0.25_d0'
set topofile = 'topo_for_lsm'
set degmaxtopo = 720
set lsm_file = 'landseamask'

set rootname = 'Coslip'

# SH expansion parameters
set degmax = 200
set degmaxgrid = 67

# Output plot region parameters
set area = 'Tohoku'
set xmin = 110
set xmax = 160
set ymin = 15
set ymax = 60
set stepx = 0.2
set stepy = 0.2

set xminplot = 110
set xmaxplot = 160
set yminplot = 15
set ymaxplot = 60

# Increase the grid resolution for finer plots
set pas = 0.05
set pasplot = 0.025

# Execute the main computation script
echo '    '
echo ' COMPUTATION: SH EXPANSION OF WANG GEOID '
echo '    '

./Wang2SH_GraviTot <<EOF
$wanggeoidfile
$landoc
$rootname
$degmax
$ymin $ymax $xmin $xmax $stepy $stepx
$degmaxgrid
$wangvdispfile
$wanggps_N
$wanggps_E
$lsmcalc
$topofile
$lsm_file
EOF

echo '    '
echo ' TRACE GRAPHIQUE GEOID - millimeters '
echo '   '

foreach fileout ($rootname.map_geoid $rootname.mapgeo_ocean_vert $rootname.mapgeo_ocean_horiz $rootname.map_geoid_tot)

# Convert to finer resolution
awk '{print $1, $2, $3*1000.0}' $fileout > $fileout.2

# Use higher resolution for xyz2grd
xyz2grd $fileout.2 -G$fileout.grd -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -I$pasplot -V

\rm -f $fileout.local.ps
\rm -f $fileout.local.eps

grdinfo $fileout.grd >! toto
set zmin=`awk 'NR==8 {print $3}' toto`
set zmax=`awk 'NR==8 {print $5}' toto`
\rm toto
set tick=`echo $zmax $zmin | awk '{print ($1-$2)/5}'`
echo ' '
echo $zmin $zmax
set contour=`echo $zmin $zmax | awk '{print ($2-$1)/20}'`
echo $contour

makecpt -Chaxby -T$zmin/$zmax/$tick -Z -V >! $fileout.cpt

blockmean $fileout.2 -I$pas -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -V >! $fileout.mean
surface $fileout.mean -G$fileout.I2.grd -I$pasplot -R$xminplot/$xmaxplot/$yminplot/$ymaxplot >! $fileout.I2.grd
grdimage $fileout.I2.grd -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -C$fileout.cpt -X2.5 -Y6 -P -JM16 -B5g5/5g5 -V -K > $fileout.local.ps
pscoast -R -JM -B -Di -W3 -V -O -K >> $fileout.local.ps

psscale -C$fileout.cpt -D8/-1.5/18/0.3h -L -O -K -V >> $fileout.local.ps

pstext -R0/21/0/29.7 -Jx1 -V -N -O << fin >> $fileout.local.ps
8 -3.5 Geoid (mm) - $fileout
fin

ps2eps $fileout.local.ps
psconvert $fileout.local.eps

rm -f $fileout.local.eps
rm -f $fileout.grd
rm -f $fileout.I2.grd
rm -f $fileout.mean
rm -f $fileout.2

end

# gmtset FORMAT_FLOAT_MAP %10.0f

# Repeat similar steps for other plots as needed

echo '    '
echo ' TRACE GRAPHIQUE EWH - centimeters '
echo '   '

# Example for one of the additional plots
# Modify similarly for others as needed

#...

echo '    '
echo ' TRACE GRAPHIQUE GRAVITY - microGals '
echo '   '

foreach fileout ($rootname.map_gravity $rootname.map_gravity_tot)

awk '{print $1, $2, $3*1000.0}' $fileout > $fileout.2

xyz2grd $fileout.2 -G$fileout.grd -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -I$pasplot -V

\rm -f $fileout.local.ps
\rm -f $fileout.local.eps

grdinfo $fileout.grd >! toto
set zmin=`awk 'NR==8 {print $3}' toto`
set zmax=`awk 'NR==8 {print $5}' toto`
\rm toto
set tick=`echo $zmax $zmin | awk '{print ($1-$2)/5}'`
echo ' '
echo $zmin $zmax
set contour=`echo $zmin $zmax | awk '{print ($2-$1)/20}'`
echo $contour

makecpt -Chaxby -T$zmin/$zmax/$tick -Z -V >! $fileout.cpt

blockmean $fileout.2 -I$pas -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -V >! $fileout.mean
surface $fileout.mean -G$fileout.I2.grd -I$pasplot -R$xminplot/$xmaxplot/$yminplot/$ymaxplot >! $fileout.I2.grd
grdimage $fileout.I2.grd -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -C$fileout.cpt -X2.5 -Y6 -P -JM16 -B5g5/5g5 -V -K > $fileout.local.ps
pscoast -R -JM -B -Di -W3 -V -O -K >> $fileout.local.ps

psscale -C$fileout.cpt -D8/-1.5/18/0.3h -L -O -K -V >> $fileout.local.ps

pstext -R0/21/0/29.7 -Jx1 -V -N -O << fin >> $fileout.local.ps
8 -3.5 Gravity disturbance (microGals) - $fileout
fin

ps2eps $fileout.local.ps
psconvert $fileout.local.eps

rm -f $fileout.local.eps
rm -f $fileout.grd
rm -f $fileout.I2.grd
rm -f $fileout.mean
rm -f $fileout.2

end

# Continue similarly for other plots

