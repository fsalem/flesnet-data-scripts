#!/usr/bin/gnuplot

set xlabel '# of Nodes' font 'Helvetica,300' offset 0,-60,0
set ylabel 'Agg. Bandwidth [MB/s]' font 'Helvetica,300' offset -120,0,0
set tics font 'Helvetica,290'
set key font 'Helvetica,250' left
set tmargin 10
set bmargin 80
set lmargin 145
set rmargin 53
set xtics offset 0,-15,0
set ytics offset -1,0,0
set grid ytics mytics
set grid xtics mytics
set xtics rotate
set yrange [0:140000]
#set ytics autofreq 5000
set ytics format '%0.s%c'

set style data histogram
set style histogram cluster gap 1
set style fill solid border -1
set boxwidth 0.9

set terminal pdf enhanced crop size 180cm,140cm
set output 'Libfabric_MPI_Agg_Bandwidth_comparison.pdf'

plot 'MPI_Libfabric_Agg_Bandwidth_comparison_32kB.data' u 2:xtic(1) t col lc 1 ,\
'' u 3 t col lc 2,\
'' u 4 t col lc 3


#pause -1


