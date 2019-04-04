#!/usr/bin/gnuplot

set xlabel 'Message Size' font 'Helvetica,300' offset 0,-130,0
set ylabel 'Latency [us]' font 'Helvetica,300' offset -160,0,0
set tics font 'Helvetica,290'
set key font 'Helvetica,250' left
set tmargin 10
set bmargin 160
set lmargin 170
set rmargin 53
set xtics offset 0,-15,0
set ytics offset -1,0,0
set grid ytics mytics
set grid xtics mytics
set xtics rotate
set yrange [0:60000]
set ytics autofreq 5000

set terminal pdf enhanced crop size 140cm,140cm
set output 'Libfabric_MPI_Latency_comparison.pdf'

plot 'MPI_Latency_comparison.data' u ($0):4:2:3:xtic(1) t "MPI-32n" lc 1 ps 10 w yerr,'MPI_Latency_comparison.data' u 4:xtic(1) t '' lc 1 ps 10 w linespoints,\
'MPI_Latency_comparison.data' u ($0):7:5:6:xtic(1) t "MPI-64n" lc 2 ps 10 w yerr, 'MPI_Latency_comparison.data' u 7:xtic(1) t '' lc 2 ps 10 w linespoints,\
'MPI_Latency_comparison.data' u ($0):10:8:9:xtic(1) t "MPI-80n" lc 3 ps 10 w yerr, 'MPI_Latency_comparison.data' u 10:xtic(1) t '' lc 3 ps 10 w linespoints,\
'Libfabric_Latency_comparison.data' u ($0):4:2:3:xtic(1) t "Libfabric-32n" lc 4 ps 10 w yerr,'Libfabric_Latency_comparison.data' u 4:xtic(1) t '' lc 4 ps 10 w linespoints,\
'Libfabric_Latency_comparison.data' u ($0):7:5:6:xtic(1) t "Libfabric-64n" lc 5 ps 10 w yerr, 'Libfabric_Latency_comparison.data' u 7:xtic(1) t '' lc 5 ps 10 w linespoints,\
'Libfabric_Latency_comparison.data' u ($0):10:8:9:xtic(1) t "Libfabric-80n" lc 6 ps 10 w yerr, 'Libfabric_Latency_comparison.data' u 10:xtic(1) t '' lc 6 ps 10 w linespoints

#pause -1


