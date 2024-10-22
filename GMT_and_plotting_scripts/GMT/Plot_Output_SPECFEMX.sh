#!/bin/csh

gmtset FORMAT_FLOAT_OUT %10.6f
gmtset FORMAT_FLOAT_MAP %10.2f
gmtset FONT_ANNOT_PRIMARY 14p
gmtset FONT_LABEL 20p

# Output plots - TOHOKU
set area = 'Tohoku'
set xmin = 115
set xmax = 160
set ymin = 15
set ymax = 60
set stepx = 0.2
set stepy = 0.2

set xminplot = 115
set xmaxplot = 160
set yminplot = 15
set ymaxplot = 60

set pas = 0.05
set pasplot = 0.025


foreach file (coseis.dat)

# x vers le Nord, y vers l'Est, z Up (donc -z du calcul qui est vers le bas)
echo "================================================="
echo "                                                 "
echo "                                                 "
echo "No need to -1 * Uz for SPECFEMX Results"
echo "                                                 "
echo "                                                 "
echo "================================================="


awk 'NR > 1 {print $2, $1, $3}' $file > Ux.$file
awk 'NR > 1 {print $2, $1, $4}' $file > Uy.$file
awk 'NR > 1 {print $2, $1, $5}' $file > Uz.$file
awk 'NR > 1 {print $2, $1, $15}' $file > Gd.$file
awk 'NR > 1 {print $2, $1, $16}' $file > Gr.$file

end

awk '{print $1, $2, $3*1000.0}' Gd.coseis.dat > Gd.coseis.mm.dat


foreach file (coseis.dat)

foreach fileout (Ux.$file Uy.$file Uz.$file Gd.$file)  # Gr.$file)

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
8 -3.5 $fileout - mm (SPECFEMX)
fin


ps2eps $fileout.local.ps
psconvert $fileout.local.eps


rm -f $fileout.local.eps
rm -f $fileout.grd
rm -f $fileout.I2.grd
rm -f $fileout.mean
rm -f $fileout.2

end



foreach fileout (Gr.$file)

awk '{print $1, $2, $3*100000000.0}' $fileout > $fileout.2

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
8 -3.5 $fileout - microGals
fin


ps2eps $fileout.local.ps
psconvert $fileout.local.eps


rm -f $fileout.local.eps
rm -f $fileout.grd
rm -f $fileout.I2.grd
rm -f $fileout.mean
rm -f $fileout.2

end


end

