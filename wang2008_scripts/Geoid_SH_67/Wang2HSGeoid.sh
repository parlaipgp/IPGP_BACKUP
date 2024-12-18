#!/bin/csh

gmtset FORMAT_FLOAT_OUT %10.6f
gmtset FORMAT_FLOAT_MAP %10.1f
gmtset FONT_ANNOT_PRIMARY 18p
gmtset FONT_LABEL 20p

awk '{print $1, $2, $3*1000.0}' Gd.coseis.dat > Gd.coseis.mm.dat

# input mass file
set wanggeoidfile = 'Gd.coseis.mm.dat'
set wangvdispfile = 'Uz.coseis.dat'
set wanggps_N = 'Ux.coseis.dat'
set wanggps_E = 'Uy.coseis.dat'

set landoc = 1                          # 0 = ocean, 1 = continent
set lsmcalc = 0                         # 1 = calculer, 0 = charger depuis un fichier
set topoHSfile = 'coeffs.bathy.0.25_d0'
set topofile = 'topo_for_lsm'
set degmaxtopo = 720
set lsm_file = 'landseamask'

set rootname = 'Coslip'

# SH expansion
set degmax = 200
set degmaxgrid = 67

# Output plots - TOHOKU
set area = 'Tohoku'
set xmin = 110
set xmax = 160
set ymin = 10
set ymax = 60
set stepx = 0.4
set stepy = 0.4

set xminplot = 110
set xmaxplot = 160
set yminplot = 10
set ymaxplot = 60

set pas = 0.05
set pasplot = 0.025

echo '    '
echo ' COMPUTATION: SH EXPANSION OF WANG GEOID '
echo '    '

# si calcul lsm
# $lsmcalc
# $topoHSfile
# $degmaxtopo
# $lsm_file

#./Wang2SH_GraviTot_EWH <<EOF
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

awk '{print $1, $2, $3*1000.0}' $fileout > $fileout.2

xyz2grd $fileout.2 -G$fileout.grd -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -I$pasplot -V

\rm -f $fileout.local.ps
\rm -f $fileout.local.eps

grdinfo $fileout.grd >! toto
set zmin=`awk 'NR==8 {print $3}' toto`
set zmax=`awk 'NR==8 {print $5}' toto`
\rm toto
set tick=`echo $zmax $zmin | awk '{print ($1-$2)/10}'`
echo ' '
echo $zmin $zmax
set contour=`echo $zmin $zmax | awk '{print ($2-$1)/20}'`
echo $contour
#set tick=`echo $xmax $xmin | awk '{print int(($1-$2)/10)}'`

makecpt -Chaxby -T$zmin/$zmax/$tick -Z -V >! $fileout.cpt
#makecpt -Crainbow -T-1.2/2/0.32 -Z -V >! $fileout.cpt
#grd2cpt $fileout.grd -L$zmin/$zmax -Chaxby -Z >! $fileout.cpt

blockmean $fileout.2 -I$pas -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -V >! $fileout.mean
surface $fileout.mean -G$fileout.I2.grd -I$pasplot -R$xminplot/$xmaxplot/$yminplot/$ymaxplot >! $fileout.I2.grd
grdimage $fileout.I2.grd -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -C$fileout.cpt -X2.5 -Y6 -P -JM16 -B5g5/5g5 -V -K > $fileout.local.ps
#pscoast -R -JM -B -I1/255 -Di -W3/255 -V -O -K >> $fileout.local.ps
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

gmtset FORMAT_FLOAT_MAP %10.0f


echo '    '
echo ' TRACE GRAPHIQUE EWH - centimeters '
echo '   '

#foreach fileout ($rootname.map_ewh_tot)

#awk '{print $1, $2, $3/10.0}' $fileout > $fileout.2

#xyz2grd $fileout.2 -G$fileout.grd -R130/150/25/45 -I$pasplot -V

#\rm -f $fileout.local.ps
#\rm -f $fileout.local.eps

#grdinfo $fileout.grd >! toto
#set zmin=`awk 'NR==8 {print $3}' toto`
#set zmax=`awk 'NR==8 {print $5}' toto`
#\rm toto
#set tick=`echo $zmax $zmin | awk '{print ($1-$2)/10}'`
#echo ' '
#echo $zmin $zmax
#set contour=`echo $zmin $zmax | awk '{print ($2-$1)/20}'`
#echo $contour
##set tick=`echo $xmax $xmin | awk '{print int(($1-$2)/10)}'`

#makecpt -Chaxby -T$zmin/$zmax/$tick -Z -V >! $fileout.cpt
##makecpt -Crainbow -T-1.2/2/0.32 -Z -V >! $fileout.cpt
##grd2cpt $fileout.grd -L$zmin/$zmax -Chaxby -Z >! $fileout.cpt

#blockmean $fileout.2 -I$pas -R130/150/25/45 -V >! $fileout.mean
#surface $fileout.mean -G$fileout.I2.grd -I$pasplot -R130/150/25/45 >! $fileout.I2.grd
#grdimage $fileout.I2.grd -R130/150/25/45 -C$fileout.cpt -X2.5 -Y6 -P -JM16 -B2/2 -V -K > $fileout.local.ps
##pscoast -R -JM -B -I1/255 -Di -W3/255 -V -O -K >> $fileout.local.ps
#pscoast -R -JM -Di -W1.5 -V -O -K >> $fileout.local.ps

#gmtset FORMAT_FLOAT_MAP %10.1f
#psscale -C$fileout.cpt -D8/-1.5/18/0.3h -L -O -K -V >> $fileout.local.ps
#gmtset FORMAT_FLOAT_MAP %10.0f

#pstext -R0/21/0/29.7 -Jx1 -V -N -O << fin >> $fileout.local.ps
#8 -3.5 EWH (cm) - $fileout
#fin

#ps2eps $fileout.local.ps
#psconvert $fileout.local.eps

#rm -f $fileout.local.eps
#rm -f $fileout.grd
#rm -f $fileout.I2.grd
#rm -f $fileout.mean
#rm -f $fileout.2

#end

gmtset FORMAT_FLOAT_MAP %10.0f


echo '    '
echo ' TRACE GRAPHIQUE GRAVITY - microGals '
echo '   '

#set fileout = $rootname.map_gravity
foreach fileout ($rootname.map_gravity $rootname.map_gravity_tot)

awk '{print $1, $2, $3*1000.0}' $fileout > $fileout.2

xyz2grd $fileout.2 -G$fileout.grd -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -I$pasplot -V

\rm -f $fileout.local.ps
\rm -f $fileout.local.eps

grdinfo $fileout.grd >! toto
set zmin=`awk 'NR==8 {print $3}' toto`
set zmax=`awk 'NR==8 {print $5}' toto`
\rm toto
set tick=`echo $zmax $zmin | awk '{print ($1-$2)/10}'`
echo ' '
echo $zmin $zmax
set contour=`echo $zmin $zmax | awk '{print ($2-$1)/20}'`
echo $contour
#set tick=`echo $xmax $xmin | awk '{print int(($1-$2)/10)}'`

makecpt -Chaxby -T$zmin/$zmax/$tick -Z -V >! $fileout.cpt
#makecpt -Crainbow -T-1.2/2/0.32 -Z -V >! $fileout.cpt
#grd2cpt $fileout.grd -L$zmin/$zmax -Chaxby -Z >! $fileout.cpt

blockmean $fileout.2 -I$pas -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -V >! $fileout.mean
surface $fileout.mean -G$fileout.I2.grd -I$pasplot -R$xminplot/$xmaxplot/$yminplot/$ymaxplot >! $fileout.I2.grd
grdimage $fileout.I2.grd -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -C$fileout.cpt -X2.5 -Y6 -P -JM16 -B5g5/5g5 -V -K > $fileout.local.ps
#pscoast -R -JM -B -I1/255 -Di -W3/255 -V -O -K >> $fileout.local.ps
pscoast -R -JM -B -Di -W3 -V -O -K >> $fileout.local.ps

#pstext -R0/21/0/29.7 -Jx1 -V -N -O -K << fin >> $fileout.local.ps
#6 18 20 0 5 2 $file
#fin

psscale -C$fileout.cpt -D8/-1.5/18/0.3h -L -O -K -V >> $fileout.local.ps

pstext -R0/21/0/29.7 -Jx1 -V -N -O << fin >> $fileout.local.ps
8 -3.5  Gravity disturbance (microGals) - $fileout
fin

ps2eps $fileout.local.ps
psconvert $fileout.local.eps

rm -f $fileout.local.eps
rm -f $fileout.grd
rm -f $fileout.I2.grd
rm -f $fileout.mean
rm -f $fileout.2

end


echo '    '
echo ' TRACE GRAPHIQUE OCEAN LOAD - kg/m@+2@+ '
echo '   '

foreach fileout ($rootname.map_ocean_vert $rootname.map_ocean_horiz)

awk '{print $1, $2, $3}' $fileout > $fileout.2

xyz2grd $fileout.2 -G$fileout.grd -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -I$pasplot -V

\rm -f $fileout.local.ps
\rm -f $fileout.local.eps

grdinfo $fileout.grd >! toto
set zmin=`awk 'NR==8 {print $3}' toto`
set zmax=`awk 'NR==8 {print $5}' toto`
\rm toto
set tick=`echo $zmax $zmin | awk '{print ($1-$2)/10}'`
echo ' '
echo $zmin $zmax
set contour=`echo $zmin $zmax | awk '{print ($2-$1)/20}'`
echo $contour
#set tick=`echo $xmax $xmin | awk '{print int(($1-$2)/10)}'`

makecpt -Chaxby -T$zmin/$zmax/$tick -Z -V >! $fileout.cpt
#makecpt -Crainbow -T-1.2/2/0.32 -Z -V >! $fileout.cpt
#grd2cpt $fileout.grd -L$zmin/$zmax -Chaxby -Z >! $fileout.cpt

blockmean $fileout.2 -I$pas -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -V >! $fileout.mean
surface $fileout.mean -G$fileout.I2.grd -I$pasplot -R$xminplot/$xmaxplot/$yminplot/$ymaxplot >! $fileout.I2.grd
grdimage $fileout.I2.grd -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -C$fileout.cpt -X2.5 -Y6 -P -JM16 -B5g5/5g5 -V -K > $fileout.local.ps
#pscoast -R -JM -B -I1/255 -Di -W3/255 -V -O -K >> $fileout.local.ps
pscoast -R -JM -B -Di -W3 -V -O -K >> $fileout.local.ps

psscale -C$fileout.cpt -D8/-1.5/18/0.3h -L -O -K -V >> $fileout.local.ps

pstext -R0/21/0/29.7 -Jx1 -V -N -O << fin >> $fileout.local.ps
8 -3.5 Ocean load - kg/m@+2@+ - $fileout
fin


ps2eps $fileout.local.ps
psconvert $fileout.local.eps

rm -f $fileout.local.eps
rm -f $fileout.grd
rm -f $fileout.I2.grd
rm -f $fileout.mean
rm -f $fileout.2

end


echo '    '
echo ' TRACE GRAPHIQUE SURFACE DISPLACEMENTS - mm '
echo '   '

foreach fileout ($wangvdispfile $wanggps_N $wanggps_E)

awk '{print $1, $2, $3*1000.0}' $fileout > $fileout.2

xyz2grd $fileout.2 -G$fileout.grd -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -I$pasplot -V

\rm -f $fileout.local.ps
\rm -f $fileout.local.eps

grdinfo $fileout.grd >! toto
set zmin=`awk 'NR==8 {print $3}' toto`
set zmax=`awk 'NR==8 {print $5}' toto`
\rm toto
set tick=`echo $zmax $zmin | awk '{print ($1-$2)/10}'`
echo ' '
echo $zmin $zmax
set contour=`echo $zmin $zmax | awk '{print ($2-$1)/20}'`
echo $contour
#set tick=`echo $xmax $xmin | awk '{print int(($1-$2)/10)}'`

makecpt -Chaxby -T$zmin/$zmax/$tick -Z -V >! $fileout.cpt
#makecpt -Crainbow -T-1.2/2/0.32 -Z -V >! $fileout.cpt
#grd2cpt $fileout.grd -L$zmin/$zmax -Chaxby -Z >! $fileout.cpt

blockmean $fileout.2 -I$pas -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -V >! $fileout.mean
surface $fileout.mean -G$fileout.I2.grd -I$pasplot -R$xminplot/$xmaxplot/$yminplot/$ymaxplot >! $fileout.I2.grd
grdimage $fileout.I2.grd -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -C$fileout.cpt -X2.5 -Y6 -P -JM16 -B5g5/5g5 -V -K > $fileout.local.ps
#pscoast -R -JM -B -I1/255 -Di -W3/255 -V -O -K >> $fileout.local.ps
pscoast -R -JM -B -Di -W3 -V -O -K >> $fileout.local.ps

psscale -C$fileout.cpt -D8/-1.5/18/0.3h -L -O -K -V >> $fileout.local.ps

pstext -R0/21/0/29.7 -Jx1 -V -N -O << fin >> $fileout.local.ps
8 -3.5 Surface displacement - mm - $fileout
fin


ps2eps $fileout.local.ps
psconvert $fileout.local.eps

rm -f $fileout.local.eps
rm -f $fileout.grd
rm -f $fileout.I2.grd
rm -f $fileout.mean
rm -f $fileout.2

end


echo '    '
echo ' TRACE GRAPHIQUE GEOID INPUT - mm '
echo '   '

gmtset FORMAT_FLOAT_MAP %10.1f

foreach fileout ($wanggeoidfile)

awk '{print $1, $2, $3}' $fileout > $fileout.2

xyz2grd $fileout.2 -G$fileout.grd -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -I$pasplot -V

\rm -f $fileout.local.ps
\rm -f $fileout.local.eps

grdinfo $fileout.grd >! toto
set zmin=`awk 'NR==8 {print $3}' toto`
set zmax=`awk 'NR==8 {print $5}' toto`
\rm toto
set tick=`echo $zmax $zmin | awk '{print ($1-$2)/10}'`
echo ' '
echo $zmin $zmax
set contour=`echo $zmin $zmax | awk '{print ($2-$1)/20}'`
echo $contour
#set tick=`echo $xmax $xmin | awk '{print int(($1-$2)/10)}'`

makecpt -Chaxby -T$zmin/$zmax/$tick -Z -V >! $fileout.cpt
#makecpt -Crainbow -T-1.2/2/0.32 -Z -V >! $fileout.cpt
#grd2cpt $fileout.grd -L$zmin/$zmax -Chaxby -Z >! $fileout.cpt

blockmean $fileout.2 -I$pas -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -V >! $fileout.mean
surface $fileout.mean -G$fileout.I2.grd -I$pasplot -R$xminplot/$xmaxplot/$yminplot/$ymaxplot >! $fileout.I2.grd
grdimage $fileout.I2.grd -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -C$fileout.cpt -X2.5 -Y6 -P -JM16 -B5g5/5g5 -V -K > $fileout.local.ps
#pscoast -R -JM -B -I1/255 -Di -W3/255 -V -O -K >> $fileout.local.ps
pscoast -R -JM -B -Di -W3 -V -O -K >> $fileout.local.ps

psscale -C$fileout.cpt -D8/-1.5/18/0.3h -L -O -K -V >> $fileout.local.ps

pstext -R0/21/0/29.7 -Jx1 -V -N -O << fin >> $fileout.local.ps
8 -3.5 Geoid - mm - $fileout
fin


ps2eps $fileout.local.ps
psconvert $fileout.local.eps

rm -f $fileout.local.eps
rm -f $fileout.grd
rm -f $fileout.I2.grd
rm -f $fileout.mean
rm -f $fileout.2

end



rm *.rmsHS
