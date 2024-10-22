#!/bin/csh

gmtset FORMAT_FLOAT_OUT %10.6f
gmtset FORMAT_FLOAT_MAP %10.1f
gmtset FONT_ANNOT_PRIMARY 18p
gmtset FONT_LABEL 20p

./fomosto_pscmp2008a <<EOF
pscmp08-tohoku-slice1.inp
EOF


./fomosto_pscmp2008a <<EOF
pscmp08-tohoku-slice2.inp
EOF



foreach snapshot (coseis)
awk 'NR > 1 {print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16}' {$snapshot}-slice2.dat > {$snapshot}2.dat

cat {$snapshot}-slice1.dat {$snapshot}2.dat > {$snapshot}.dat

#mv {$snapshot}-slice1.dat {$snapshot}.dat
rm -f {$snapshot}-slice*.dat
rm -f {$snapshot}2.dat
end

foreach snapshot (relax_1_month)
awk 'NR > 1 {print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16}' {$snapshot}-slice2.dat > {$snapshot}2.dat

cat {$snapshot}-slice1.dat {$snapshot}2.dat > {$snapshot}.dat

#mv {$snapshot}-slice1.dat {$snapshot}.dat
rm -f {$snapshot}-slice*.dat
rm -f {$snapshot}2.dat
end


foreach snapshot (relax_3_month)
awk 'NR > 1 {print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16}' {$snapshot}-slice2.dat > {$snapshot}2.dat

cat {$snapshot}-slice1.dat {$snapshot}2.dat > {$snapshot}.dat

#mv {$snapshot}-slice1.dat {$snapshot}.dat
rm -f {$snapshot}-slice*.dat
rm -f {$snapshot}2.dat
end


foreach snapshot (relax_6_month)
awk 'NR > 1 {print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16}' {$snapshot}-slice2.dat > {$snapshot}2.dat

cat {$snapshot}-slice1.dat {$snapshot}2.dat > {$snapshot}.dat

#mv {$snapshot}-slice1.dat {$snapshot}.dat
rm -f {$snapshot}-slice*.dat
rm -f {$snapshot}2.dat
end


foreach snapshot (relax_1_year)
awk 'NR > 1 {print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16}' {$snapshot}-slice2.dat > {$snapshot}2.dat

cat {$snapshot}-slice1.dat {$snapshot}2.dat > {$snapshot}.dat

#mv {$snapshot}-slice1.dat {$snapshot}.dat
rm -f {$snapshot}-slice*.dat
rm -f {$snapshot}2.dat
end


foreach snapshot (relax_2_year)
awk 'NR > 1 {print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16}' {$snapshot}-slice2.dat > {$snapshot}2.dat

cat {$snapshot}-slice1.dat {$snapshot}2.dat > {$snapshot}.dat

#mv {$snapshot}-slice1.dat {$snapshot}.dat
rm -f {$snapshot}-slice*.dat
rm -f {$snapshot}2.dat
end


foreach snapshot (relax_5_year)
awk 'NR > 1 {print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16}' {$snapshot}-slice2.dat > {$snapshot}2.dat

cat {$snapshot}-slice1.dat {$snapshot}2.dat > {$snapshot}.dat

#mv {$snapshot}-slice1.dat {$snapshot}.dat
rm -f {$snapshot}-slice*.dat
rm -f {$snapshot}2.dat
end

