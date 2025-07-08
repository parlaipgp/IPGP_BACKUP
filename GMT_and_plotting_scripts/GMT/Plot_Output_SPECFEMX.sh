#!/bin/csh
echo "                                                 "
echo "                                                 "
echo "  * * * need to run * * * resampleDataGMT.sh * * * first"
echo "                                                 "
echo "                                                 "
gmtset FORMAT_FLOAT_OUT %10.6f
gmtset FORMAT_FLOAT_MAP %5.2f
gmtset FONT_ANNOT_PRIMARY 6p
gmtset FONT_LABEL 6p

# Output plots - TOHOKU
set area = 'Tohoku'
set xmin = 110
set xmax = 170
set ymin = 10
set ymax = 70
set stepx = 0.2
set stepy = 0.2

set xminplot = 120
set xmaxplot = 160
set yminplot = 20
set ymaxplot = 60


# Define upper part (solid line)
echo "138.6312   35.6049" > fup.txt
echo "142.7204   44.0437" >> fup.txt

# Define lower part (dotted line)
echo "142.7204   44.0437" > fdown.txt
echo "141.5562   44.3733" >> fdown.txt
echo "137.5852   35.8967" >> fdown.txt
echo "138.6312   35.6049" >> fdown.txt 


set pas = 0.05
set pasplot = 0.025


foreach file (coseis.dat)

# x vers le Nord, y vers l'Est, z Up (donc -z du calcul qui est vers le bas)
echo "                                                 "
echo "                                                 "
echo "================================================="
echo "                                                 "
echo "                                                 "
echo "   No need to -1 * Uz for SPECFEMX Results       "
echo "   Ux = Uy       "
echo "   Gd = Gd * -1       "

echo "================================================="
echo "                                                 "
echo "                                                 "

awk 'NR > 1 {print $2, $1, $3}' $file > Uy.$file
awk 'NR > 1 {print $2, $1, $4}' $file > Ux.$file
awk 'NR > 1 {print $2, $1, $5}' $file > Uz.$file
awk 'NR > 1 {print $2, $1, $15*-1}' $file > Gd.$file
awk 'NR > 1 {print $2, $1, $16}' $file > Gr.$file

end

awk '{print $1, $2, $3*1000.0}' Gd.coseis.dat > Gd.coseis.mm.dat

echo '---------------------------------------START----------------------------------------------'
foreach file (coseis.dat)

foreach fileout (Ux.$file Uy.$file Uz.$file Gd.$file)  # Gr.$file)

awk '{print $1, $2, $3*1000.0}' $fileout > $fileout.2

xyz2grd $fileout.2 -G$fileout.grd -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -I$pasplot -V

\rm -f $fileout.local.ps
\rm -f $fileout.local.jpg
\rm -f $fileout.local.png

grdinfo $fileout.grd >! toto
set zmin=`awk 'NR==8 {print $3}' toto`
set zmax=`awk 'NR==8 {print $5}' toto`
\rm toto
set tick=`echo $zmax $zmin | awk '{print ($1-$2)/10}'`
echo ' '
echo $zmin $zmax
set contour=`echo $zmin $zmax | awk '{print ($2-$1)/20}'`
echo $contour

makecpt -Chaxby -T$zmin/$zmax/$tick -Z -V >! $fileout.cpt


blockmean $fileout.2 -I$pas -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -V >! $fileout.mean
surface $fileout.mean -G$fileout.I2.grd -I$pasplot -R$xminplot/$xmaxplot/$yminplot/$ymaxplot >! $fileout.I2.grd


grdimage $fileout.I2.grd -R$xminplot/$xmaxplot/$yminplot/$ymaxplot -C$fileout.cpt \
-Xc -Yc -P -JM4.4 -B10g5/10g5 --MAP_FRAME_TYPE=plain --MAP_FRAME_PEN=0.1p --MAP_TICK_PEN=0.5p \
--MAP_TICK_LENGTH_PRIMARY=0.1c --MAP_GRID_PEN_PRIMARY=0.1p,grey --MAP_ANNOT_OFFSET_PRIMARY=2p \
-V -K > $fileout.local.ps


# coast line
pscoast -JM -R -Di -W0.2p,87/87/87  -V -O -K -P --MAP_FRAME_PEN=0.1p --MAP_TICK_PEN=0.1  >> $fileout.local.ps

echo '---------------------------------------Fault----------------------------------------------'

# Fault plan
psxy fup.txt -R -JM -W0.3p,red -O -K >> $fileout.local.ps
psxy fdown.txt -R -JM -W0.1p,red,- -O -K >> $fileout.local.ps



echo '---------------------------------------Fault----------------------------------------------'



gmtset FONT_ANNOT_PRIMARY 5p

gmt set FORMAT_FLOAT_MAP %.2f

psscale -C$fileout.cpt -D2.2/-0.75/5.3/0.1h -L -O -K -V --MAP_FRAME_PEN=0.05p  --MAP_TICK_LENGTH_PRIMARY=0.05 >> $fileout.local.ps

gmtset FONT_ANNOT_PRIMARY 6p

pstext -R0/21/0/29.7 -Jx1 -V -N -O << fin >> $fileout.local.ps
2.2 -1.5 $fileout - mm
fin


ps2eps $fileout.local.ps
#psconvert $fileout.local.eps
psconvert $fileout.local.ps -Tg -A+m0.5c -E600

rm -f $fileout.local.eps
rm -f $fileout.grd
rm -f $fileout.I2.grd
rm -f $fileout.mean
rm -f $fileout.2
echo '---------------------------------------END----------------------------------------------'

end


end


