#!/usr/bin/gnuplot

set style fill solid noborder
set boxwidth 5
set xrange [-10:100]
#set yrange [-500:]
unset colorbox
set ylabel 'Waiting Duration(ms)' font 'Helvetica,60' offset -13,0,0
set tics font 'Helvetica,60'
set ytics format '%.s%c'
set key font 'Helvetica,60'
set tmargin 2
set bmargin 5
set lmargin 22
#set rmargin 7
set xtics offset 0,-2,0
#set ytics offset -1,0,0


#set terminal pdf enhanced size 50cm,30cm
#set output 'scheduler_comparison_stats.pdf'

#set terminal pngcairo size 1400,700 enhanced crop
#set output 'scheduler_comparison_stats.png'


plot 'scheduler_comparison_stats.data' using  7:($3/1000):($2/1000):($6/1000):($5/1000):xtic(1) with candlesticks title 'Min, Max (bar: 10th - 90th percentile)' whiskerbars


pause -1










