#!/bin/csh


foreach file (coseis.dat)

# x vers le Nord, y vers l'Est, z Up (donc -z du calcul qui est vers le bas)

awk 'NR > 1 {print $2, $1, $3}' $file > Ux.$file
awk 'NR > 1 {print $2, $1, $4}' $file > Uy.$file
awk 'NR > 1 {print $2, $1, -$5}' $file > Uz.$file
awk 'NR > 1 {print $2, $1, $15}' $file > Gd.$file
awk 'NR > 1 {print $2, $1, $16}' $file > Gr.$file

# Save Ux, Uy, Uz along Longitude 135
    set lon_filter = 132
    set title = "long132_wang"
    awk -v lon=$lon_filter '$1 == lon {print  $2, $3*1000}' Ux.$file > Ux_$title.dat
    awk -v lon=$lon_filter '$1 == lon {print  $2, $3*1000}' Uy.$file > Uy_$title.dat
    awk -v lon=$lon_filter '$1 == lon {print  $2, $3*1000}' Uz.$file > Uz_$title.dat
    awk -v lon=$lon_filter '$1 == lon {print  $2, $3*1000}' Gd.$file > Gd_$title.dat
end

rm *.coseis.dat
